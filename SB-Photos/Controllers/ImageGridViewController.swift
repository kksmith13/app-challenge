//
//  ViewController.swift
//  SB-Trial
//
//  Created by Kyle Smith on 7/20/18.
//  Copyright © 2018 smithcoding. All rights reserved.
//

import UIKit

class ImageGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    lazy var mainView: ImageGridView = {
        let v = ImageGridView()
        v.collectionView.delegate = self
        v.collectionView.dataSource = self
        v.collectionView.backgroundColor = .white
        return v
    }()
    
    enum EnabledView {
        case grid
        case detail
    }
    
    let api = APIClient.shared
    let cellId = "cellId"
    
    var page = 0
    var itemsPerPage = 50
    var canLoadMoreImages = true
    var currentView: EnabledView = .grid
    
    // alert stuff
    var isShowingAlert = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SB Challenge"
        view = mainView
        
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        mainView.collectionView.addGestureRecognizer(gestureRecognizer)
        mainView.collectionView.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
        loadMoreImages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMoreImages() {

    // Handle senario where we are about to run out of images to load in
        if (itemsPerPage * page) > api.imagesInSearch {
            itemsPerPage = api.imagesInSearch - (itemsPerPage * page) - 1
            canLoadMoreImages = false
        }
        
        api.fetchImages(count: itemsPerPage, page: page, completion: { (data) in
            self.page += 1
            guard let dataPresent = data else {
                return
            }
            
            self.api.imagesInSearch = dataPresent.totalEstimatedMatches
            
            for item in dataPresent.value {
                self.api.thumbnailImageUrl.append(item.thumbnailUrl.absoluteString)
                self.api.detailedImageUrl.append(item.contentUrl.absoluteString)
            }
            self.reloadCollectionViewData()
        })
    }
    
    func reloadCollectionViewData() {
        DispatchQueue.main.async {
            self.mainView.collectionView.performBatchUpdates({
                self.mainView.collectionView.reloadSections(IndexSet(integer: 0))
            }, completion: nil)
        }
    }
    
    func displayClipboardAlert() {
        if !isShowingAlert {
            isShowingAlert = true
            let alert = AlertView()
            alert.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 50)
            
            view.addSubview(alert)
            _ = alert.anchor(nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                UIView.animate(withDuration: 0.5, animations: {
                    alert.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 50)
                    self.view.layoutIfNeeded()
                }, completion: { (_) in
                    self.isShowingAlert = false
                    alert.removeFromSuperview()
                })
            }
        }
    }
    
    // MARK: - UIGesture Methods
    @objc fileprivate func handleLongPress(recognizer: UIGestureRecognizer) {
        let tap = recognizer.location(in: self.mainView.collectionView)
        if let indexPath = mainView.collectionView.indexPathForItem(at: tap) {
            let cell = mainView.collectionView.cellForItem(at: indexPath) as! ImageCell
            let image = cell.imageView.image
            UIPasteboard.general.image = image
            displayClipboardAlert()
        }
    }
    
    // MARK: - CV Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return api.thumbnailImageUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        
        // clean up image
        cell.imageView.image = nil
        cell.imageView.contentMode = .scaleAspectFit
        if self.currentView == .grid {
            let imageUrl = api.thumbnailImageUrl[indexPath.row]
            APIClient.shared.downloadImageFromUrl(urlString: imageUrl) { (success, image) in
                if success && image != nil {
                    cell.imageView.image = image
                }
            }
        } else {
            let imageUrl = api.detailedImageUrl[indexPath.row]
            APIClient.shared.downloadImageFromUrl(urlString: imageUrl) { (success, image) in
                if success && image != nil {
                    cell.imageView.image = image
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if currentView == .grid {
            let numberOfItemsPerRow = 4
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
            return CGSize(width: size, height: size)
        } else {
            return CGSize(width: view.frame.width, height: view.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRowIndex = collectionView.numberOfItems(inSection: 0) - 3
        if indexPath.row == lastRowIndex && canLoadMoreImages {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                self.loadMoreImages()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // If currently in grid mode, switch everything to prepare for detail view
        if currentView == .grid {
            collectionView.isPagingEnabled = true
            currentView = .detail
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
        } else {
            // else switch back to grid mode properties
            collectionView.isPagingEnabled = false
            currentView = .grid
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
            }
        }
        
        // Handle scrolling to correct index when detail view has fully loaded
        if currentView == .detail {
            collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
            view.layoutIfNeeded()
        }
    }
}


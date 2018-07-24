//
//  ImageGridCollectionView.swift
//  SB-Photos
//
//  Created by Kyle Smith on 7/21/18.
//  Copyright © 2018 smithcoding. All rights reserved.
//

import UIKit

class ImageGridView: BaseView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    var imageGridViewController: ImageGridViewController?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        return cv
    }()
    
    enum EnabledView {
        case grid
        case detail
    }
    
    let api = APIClient.shared
    let cellId = "cellId"
    var page = 0
    var initalLoadCount = 50
    var canLoadMoreImages = true
    var currentView: EnabledView = .grid
    
    override func setupViews() {
        super.setupViews()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(gestureRecognizer)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        
        
        _ = collectionView.anchor(safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        loadMoreImages(count: initalLoadCount)
    }
    
    func loadMoreImages(count: Int = 15) {
        
        // Handle senario where we are about to run out of images to load in
//        if (count * page) > ImageDownloadManager.shared.imagesInSearch {
//            count = ImageDownloadManager.shared.imagesInSearch - (count * page) - 1
//            canLoadMoreImages = false
//        }
        
        api.fetchImages(count: count, page: page, completion: { (data) in
            self.page += 1
            guard let dataPresent = data else {
                return
            }

            for item in dataPresent.value {
                self.api.thumbnailImageUrl.append(item.thumbnailUrl.absoluteString)
                self.api.detailedImageUrl.append(item.contentUrl.absoluteString)
            }
            self.reloadCollectionViewData()
        })
    }
    
    func reloadCollectionViewData() {
        DispatchQueue.main.async {
            self.collectionView.performBatchUpdates({
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }, completion: nil)
        }
    }
    
    //MARK: - CV Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return api.thumbnailImageUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        
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
            return CGSize(width: frame.width, height: frame.height)
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
        // else switch back to grid mode properties
        } else {
            collectionView.isPagingEnabled = false
            currentView = .grid
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
            }
        }
        
        reloadCollectionViewData()
        
        // Handle scrolling to correct index when detail view has fully loaded
        if currentView == .detail {
            collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
            layoutIfNeeded()
        }
    }
    
    @objc fileprivate func handleLongPress(recognizer: UIGestureRecognizer) {
        let tap = recognizer.location(in: self.collectionView)
        if let indexPath = collectionView.indexPathForItem(at: tap) {
            let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
            let image = cell.imageView.image
            UIPasteboard.general.image = image
            
            let alert = AlertView()
            addSubview(alert)
            _ = alert.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        }
    }
}

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
        case GridView
        case DetailView
    }
    
    let cellId = "cellId"
    var page = 0
    var count = 15
    var canLoadMoreImages = true
    var currentView: EnabledView = .GridView
    

    
    override func setupViews() {
        super.setupViews()
        
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        
        _ = collectionView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 44, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        loadMoreImages()
    }
    
    func loadMoreImages() {
        APIClient.shared.fetchImages(count: count, page: page, completion: { (data) in
//            if (count * page) > (ImageDownloadManager.shared.imagesInSearch - count) { }
            self.page += 1
            guard let dataPresent = data else {
                return
            }
            
            for item in dataPresent.value {
                let url = item.thumbnailUrl
                let data = try? Data(contentsOf: url)
                if let imageData = data {
                    ImageDownloadManager.shared.images.append(UIImage(data: imageData)!)
                }
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
        return ImageDownloadManager.shared.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        DispatchQueue.main.async {
            if ImageDownloadManager.shared.images.count < indexPath.row {
                cell.imageView.image = ImageDownloadManager.shared.images[indexPath.row]
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if currentView == .GridView {
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
        
        DispatchQueue.main.async {
            (cell as! ImageCell).imageView.image = ImageDownloadManager.shared.images[indexPath.row]
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentView == .GridView {
            collectionView.isPagingEnabled = true
            currentView = .DetailView
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
        } else {
            collectionView.isPagingEnabled = false
            currentView = .GridView
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
            }
        }
        
        reloadCollectionViewData()
    }
}

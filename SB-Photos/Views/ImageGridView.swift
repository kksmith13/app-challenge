//
//  ImageGridCollectionView.swift
//  SB-Photos
//
//  Created by Kyle Smith on 7/21/18.
//  Copyright © 2018 smithcoding. All rights reserved.
//

import UIKit

class ImageGridView: BaseView {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        // set background for safe area
        backgroundColor = UIColor.smashingBoxesPink()
        addSubview(collectionView)
        
        
        _ = collectionView.anchor(safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}

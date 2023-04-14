//
//  UnsplashImagePickerCollectionVC.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 14/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import UIKit

protocol UnsplashImagePickerVCDelegate : AnyObject {
    func didSelectImageWithURL(_ url : String)
}

final class UnsplashImagePickerVC: UICollectionViewController {

    weak var delegate : UnsplashImagePickerVCDelegate?
    var data : [Tag] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let horizontalPadding : CGFloat = 6
        let numberOfItemsPerRow : CGFloat = 3
        let width = (collectionView.frame.width - horizontalPadding) / numberOfItemsPerRow
        let cellHeight : CGFloat = 30
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: width + cellHeight)
        collectionView.collectionViewLayout = layout
    }
}

extension UnsplashImagePickerVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tag = data[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstagramImagePickerCustomCell", for: indexPath) as! InstagramImagePickerCustomCell
        cell.foodImage.sd_setImage(with: URL(string: tag.URL.thumbnailResolution))
        return cell
    }
}

extension UnsplashImagePickerVC {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 0.3
        
        let selectedImage = data[indexPath.row]
        
        self.delegate?.didSelectImageWithURL(selectedImage.URL.standardResolution)
        navigationController?.popViewController(animated: true)
    }
}

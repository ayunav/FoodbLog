//
//  FoodLogCollectionViewVC.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 05/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import UIKit
import Parse

final class FoodLogCollectionViewVC: UICollectionViewController {
    
    var allFoodbLogObjects : [FoodLog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pullDataFromParse()
    }
}

extension FoodLogCollectionViewVC {
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return allFoodbLogObjects.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let log = allFoodbLogObjects[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodbLogCustomCell", for: indexPath) as! FoodbLogCustomCell
        cell.foodbLogImage.file = log.image
        cell.foodbLogImage.loadInBackground()
        cell.layer.masksToBounds = true
        
        return cell
    }
}

extension FoodLogCollectionViewVC {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let log = allFoodbLogObjects[indexPath.row]
        
        let foodDetailVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FoodLogDetailVC") as! FoodLogDetailVC
        foodDetailVC.foodLogObject = log
        
        navigationController?.pushViewController(foodDetailVC, animated: true)
    }
}

extension FoodLogCollectionViewVC {
    func pullDataFromParse() {
        let query = PFQuery(className: "\(FoodLog.self)")
        query.findObjectsInBackground { objects, error in
            if let error = error {
                print("Error find objects from PFQuery : \(error.localizedDescription)")
            }
            
            guard let pfObjects = objects, let foodObject = pfObjects as? [FoodLog] else {return}
            self.allFoodbLogObjects.append(contentsOf: foodObject)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}


private extension FoodLogCollectionViewVC {
    func setupUI() {
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "FoodbLog_White_Logo.png"))
        
        let horizontalPadding : CGFloat = 6.0
        let numberOfItemPerRow : CGFloat = 3.0
        let heightAdjustment : CGFloat = 30.0
        let width = (collectionView.frame.width - horizontalPadding) / numberOfItemPerRow
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
        
        collectionView.collectionViewLayout = layout
    }
}

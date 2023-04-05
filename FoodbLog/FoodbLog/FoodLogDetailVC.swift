//
//  FoodLogDetailVC.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 05/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import UIKit

final class FoodLogDetailVC: UIViewController {

    @IBOutlet weak var foodLogImageView : UIImageView!
    @IBOutlet weak var recipeButton : UIButton!
    @IBOutlet weak var restaurantNameLabel : UILabel!
    @IBOutlet weak var dishNameLabel : UILabel!
    @IBOutlet weak var foodLogDescription : UITextView!
    
    var foodLogObject : FoodLog?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestFoodLogImage()
    }
    
    func setupUI() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "FoodbLog_White_Logo.png"))
  
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        foodLogImageView.clipsToBounds = true
        
        recipeButton.setTitleColor(.flatBlue(), for: .normal)
        recipeButton.contentHorizontalAlignment = .left
        
        restaurantNameLabel.textColor = .flatGray()
        restaurantNameLabel.text = foodLogObject?.restaurantName
        
        dishNameLabel.textColor = .flatOrange()
        dishNameLabel.text = foodLogObject?.name
        
        foodLogDescription.font = .systemFont(ofSize: 24)
        foodLogDescription.text = foodLogObject?.notes
    }
    
    func requestFoodLogImage() {
        let imageFile = self.foodLogObject?.image
        imageFile?.getDataInBackground { data, error in
            guard let data = data else {return}
            
            DispatchQueue.main.async {
                self.foodLogImageView.image = UIImage(data: data)
            }
        }
    }
}

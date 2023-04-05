//
//  RootTabBarVC.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 05/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import UIKit

final class RootTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCs()
    }
    
    func setupVCs() {
        viewControllers = [
            firstTabBar(),
            secondTabBar()
        ]
    }
}

private extension RootTabBarVC {
    func firstTabBar() -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "\(FoodbLogCollectionViewController.self)") as! FoodbLogCollectionViewController

        
       return createNavigationController(for: vc, title: "Food bLog", image: UIImage(named: "Literature Filled-25"))
    }
    
    func secondTabBar() -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "\(FoodFeedViewController.self)")
        as! FoodFeedViewController
        
        return createNavigationController(for: vc, title: "Food Feed", image: UIImage(named: "Food Filled-25"))
    }
}

private extension RootTabBarVC {
    
    /// Generate UINavigationController for the VC in the tab bar
    /// - Parameters:
    ///   - rootViewController: view controller of the tab bar
    ///   - title: title of navigation bar & tab bar
    ///   - image: image icon for tab bar
    /// - Returns: View Controller that has UINavigationController
    func createNavigationController(
        for rootViewController : UIViewController,
        title : String,
        image : UIImage?, preferLargeTitles : Bool = false) -> UIViewController {
            let navController = UINavigationController(rootViewController: rootViewController)
            navController.tabBarItem.title = title
            navController.tabBarItem.image = image
            if #available(iOS 11.0, *) {
                navController.navigationBar.prefersLargeTitles = preferLargeTitles
            }
            
            rootViewController.navigationItem.title = title
            return navController
        }
}

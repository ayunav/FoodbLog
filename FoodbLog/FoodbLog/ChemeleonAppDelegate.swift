//
//  ChemeleonAppDelegate.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 05/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import UIKit
import ChameleonFramework

final class ChameleonAppDelegate : NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Chameleon.setGlobalThemeUsingPrimaryColor(.flatOrange(), with: .light)
        return true
    }
}

//
//  ParseDBAppDelegate.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 05/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import UIKit
import Parse

final class ParseDBAppDelegate : NSObject, UIApplicationDelegate {
    private let parseApplicationId = "rjpud8TLiUXDlfbMapE2epIj6lwTPafkhWQInPs3"
    private let parseClientKey = "je9HpthLghFr4MRHSvWTLlBBxJVb3udoZ8XmTisz"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// [Optional] Power your app with Local Datastore. For more info, go to
        /// https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        /// Initialize Parse.
        Parse.setApplicationId(parseApplicationId, clientKey: parseClientKey)
        
        // [Optional] Track statistics around application opens.
        // This method should be inside the didFinishLaunchingWithOptions method.
        //[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        
        FoodLog.registerSubclass()
        return true
    }
}

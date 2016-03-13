//
//  FoodFeedDetailViewController.h
//  FoodbLog
//
//  Created by Ayuna Vogel on 10/18/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodFeedDetailViewController : UIViewController

// from top to bottom as on the screen
@property (nonatomic) NSString *imageUrlString;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *recipeName;
@property (nonatomic) NSString *textViewCaption;

@end

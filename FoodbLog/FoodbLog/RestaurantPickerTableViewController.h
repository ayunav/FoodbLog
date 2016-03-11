//
//  RestaurantPickerTableViewController.h
//  FoodbLog
//
//  Created by Jovanny Espinal on 10/15/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RestaurantPickerTableViewDelegate <NSObject>

- (void) didSelectRestaurant:(NSString *)restaurant;

@end

@interface RestaurantPickerTableViewController : UITableViewController

@property (nonatomic) NSArray<NSDictionary*>* restaurantData;

@property (nonatomic, weak) id <RestaurantPickerTableViewDelegate> delegate;

@end

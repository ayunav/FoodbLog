//
//  RestaurantPickerTableViewController.m
//  FoodbLog
//
//  Created by Jovanny Espinal on 10/15/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import "RestaurantPickerTableViewController.h"

@interface RestaurantPickerTableViewController ()

@end


@implementation RestaurantPickerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.restaurantData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantNameCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.restaurantData[indexPath.row][@"restaurantName"];
    cell.detailTextLabel.text = self.restaurantData[indexPath.row][@"restaurantAddress"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *restaurant = self.restaurantData[indexPath.row][@"restaurantName"];
    [self.delegate didSelectRestaurant:restaurant];
    
}

@end

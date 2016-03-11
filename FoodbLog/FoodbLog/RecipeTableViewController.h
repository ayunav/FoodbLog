//
//  RecipeTableViewController.h
//  FoodbLog
//
//  Created by Jovanny Espinal on 10/20/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodFeedObject.h"

@protocol RecipeTableViewDelegate <NSObject>

- (void) didSelectRecipe:(NSString *)recipe withIngredients:(NSString*)ingredients;


@end

@interface RecipeTableViewController : UITableViewController

@property (nonatomic) NSArray<FoodFeedObject*> *recipeResultsArray;
@property (nonatomic) id<RecipeTableViewDelegate> delegate;

@end

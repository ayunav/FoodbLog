//
//  RecipeTableViewController.m
//  FoodbLog
//
//  Created by Jovanny Espinal on 10/20/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import "RecipeTableViewController.h"
#import "RecipeTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>


@interface RecipeTableViewController ()

@end

@implementation RecipeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipeResultsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeCell" forIndexPath:indexPath];
    
    cell.recipeName.text = self.recipeResultsArray[indexPath.row].recipeTitle;
    
    [cell.recipeImage sd_setImageWithURL:[NSURL URLWithString:self.recipeResultsArray[indexPath.row].imageURLString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.recipeImage.image = image;

    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self getIngredientsOfRecipe:self.recipeResultsArray[indexPath.row]];
    
    [self.delegate didSelectRecipe:self.recipeResultsArray[indexPath.row].recipeTitle withIngredients:self.recipeResultsArray[indexPath.row].caption];
    
    
}
-(void)getIngredientsOfRecipe:(FoodFeedObject*)recipe{
    
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    
    
    NSString* recipeString = [NSString stringWithFormat:@"http://food2fork.com/api/get?key=1c8230d5345097e5019e288eb8203983&rId=%@", recipe.recipeID];
    
    [manager GET:recipeString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        
        NSArray* ingredientsArray = responseObject[@"recipe"][@"ingredients"];
        NSString* ingredientsString = [ingredientsArray componentsJoinedByString:@"\n \n"];
        recipe.caption = ingredientsString;
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"banana");
        
    }];
    
    
}

@end

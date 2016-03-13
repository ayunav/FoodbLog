//
//  FoodFeedViewController.m
//  FoodbLog
//
//  Created by Jovanny Espinal on 10/12/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>

#import "FoodFeedObject.h"
#import "FoodFeedDetailViewController.h"
#import "FoodFeedViewController.h"
#import "FoodFeedCustomCVC.h"

@interface FoodFeedViewController ()  <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) IBOutlet UISegmentedControl* segmentedControl;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic) NSString *instagramSearchString;
@property (nonatomic) NSString *recipeSearchString;

@property (nonatomic) NSMutableArray<FoodFeedObject *> *instagramResultsArray;
@property (nonatomic) NSMutableArray<FoodFeedObject*> *recipeResultsArray;

@end

@implementation FoodFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.segmentedControl setSelectedSegmentIndex:0];
    self.instagramSearchString = @"whatsonyourplate";
    self.recipeSearchString = @"pizza";
    
    NSLog(@"%@", self.instagramResultsArray);
    
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self instagramRequestForString:self.instagramSearchString];
}

#pragma mark - Navigation

- (IBAction)controlEventForSegmentedControlChange:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        [self instagramRequestForString:self.instagramSearchString];
    } else {
        [self recipeRequestForString:self.recipeSearchString];
    }
    
}

#pragma mark - Collection View methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.instagramResultsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FoodFeedCustomCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FoodFeedCustomCVC" forIndexPath:indexPath];
    
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
    
        FoodFeedObject *objectForCell = self.instagramResultsArray[indexPath.row];
        
        [cell.foodImage sd_setImageWithURL:[NSURL URLWithString:objectForCell.imageURLString]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            cell.foodImage.image = image;
            cell.foodNameLabel.text = [NSString stringWithFormat:@"#%@ by %@", self.instagramSearchString, objectForCell.instagramUserName];
            
        }];
    } else {
        
        FoodFeedObject *objectForCell = self.recipeResultsArray[indexPath.row];
        
        [cell.foodImage sd_setImageWithURL:[NSURL URLWithString:objectForCell.imageURLString]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            cell.foodImage.image = image;
            cell.foodNameLabel.text = objectForCell.recipeTitle;
            
        }];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FoodFeedDetailViewController *foodFeedDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodFeedDetailViewController"];
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
    
        foodFeedDetailVC.imageUrlString = self.instagramResultsArray[indexPath.row].imageURLString;
        foodFeedDetailVC.textViewCaption = self.instagramResultsArray[indexPath.row].caption;
        foodFeedDetailVC.userName = self.instagramResultsArray[indexPath.row].instagramUserName;
        
    } else {
        
        foodFeedDetailVC.imageUrlString = self.recipeResultsArray[indexPath.row].imageURLString;
        foodFeedDetailVC.textViewCaption = self.recipeResultsArray[indexPath.row].caption;
        foodFeedDetailVC.recipeName = self.recipeResultsArray[indexPath.row].recipeTitle;
        
    }
    
    [self.navigationController pushViewController:foodFeedDetailVC animated:YES];
    
}

#pragma mark - Search Tags on Instagram via the Search Bar

- (void)instagramRequestForString:(NSString *)string {

    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=ac0ee52ebb154199bfabfb15b498c067", string];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray *results = responseObject[@"data"];
        
        self.instagramResultsArray = [[NSMutableArray alloc]init];
        
        for (NSDictionary *result in results) {
            
            FoodFeedObject *resultObject = [[FoodFeedObject alloc]init];
            
            resultObject.imageURLString = result[@"images"][@"standard_resolution"][@"url"];
            resultObject.caption = result[@"caption"][@"text"];
            resultObject.instagramUserName = result[@"user"][@"username"];
            
            [self.instagramResultsArray addObject:resultObject];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"FAIL");
        
    }];
    
}

#pragma mark - Search Recipe via the Search Bar

- (void)recipeRequestForString:(NSString *)string {
    
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *URLString = [NSString stringWithFormat:@"http://food2fork.com/api/search?key=54f7d87124b73e5b6ea3a30f7ec3eb54&q=%@", string];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
  
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
   
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray *recipes = responseObject[@"recipes"];
        
        self.recipeResultsArray = [[NSMutableArray alloc]init];
        for (NSDictionary *recipe in recipes) {
            
            FoodFeedObject *recipeResultObject = [[FoodFeedObject alloc]init];
            recipeResultObject.imageURLString = recipe[@"image_url"];
            recipeResultObject.recipeID = recipe[@"recipe_id"];
            
            [self getIngredientsOfRecipe:recipeResultObject];
            
            [self.recipeResultsArray addObject:recipeResultObject];
            
            //NSLog(@"%@", recipeResultObject);
        }
        
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@", operation.response);
        NSLog(@"%@", operation.responseData);
        NSLog(@"%ld", operation.response.statusCode);
    }];
}

- (void)getIngredientsOfRecipe:(FoodFeedObject *)recipe {
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *recipeString = [NSString stringWithFormat:@"http://food2fork.com/api/get?key=54f7d87124b73e5b6ea3a30f7ec3eb54&rId=%@", recipe.recipeID];
    
    [manager GET:recipeString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray *ingredientsArray = responseObject[@"recipe"][@"ingredients"];
        NSString *ingredientsString = [ingredientsArray componentsJoinedByString:@"\n \n"];
        recipe.caption = ingredientsString;
        recipe.recipeTitle = responseObject[@"recipe"][@"title"];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@", operation.response);
        NSLog(@"%@", operation.responseString);
        NSLog(@"%ld", operation.response.statusCode);
        
    }];
}

#pragma mark - Text Field Return method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField endEditing:YES];
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        self.instagramSearchString = textField.text;
        [self instagramRequestForString:self.instagramSearchString];
        
    } else {
        
        self.recipeSearchString = textField.text;
        [self recipeRequestForString:self.recipeSearchString];
        
    }
    
    return YES;
}

@end

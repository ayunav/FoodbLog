//
//  FoodbLog.m
//  FoodbLog
//
//  Created by Jovanny Espinal on 10/12/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <ChameleonFramework/Chameleon.h>

#import "FoodbLogCollectionVC.h"
#import "FoodbLogCustomHeader.h"
#import "FoodbLogCustomCell.h"
#import "FoodLog.h"
#import "FoodLogDetailViewController.h"

@interface FoodbLogCollectionVC () <UICollectionViewDataSource, UICollectionViewDelegate>


@end

@implementation FoodbLogCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat leftAndRightPaddings = 6.0;
    CGFloat numberOfItemsPerRow = 3.0;
    CGFloat heightAdjustment = 30.0;

    CGFloat width = (CGRectGetWidth(self.collectionView.frame) - leftAndRightPaddings)/numberOfItemsPerRow;

    UICollectionViewFlowLayout *layout = self.collectionViewLayout;
    layout.itemSize = CGSizeMake(width, width +heightAdjustment);

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FoodbLog_White_Logo.png"]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self pullDataFromParse];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.allFoodLogObjects.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    FoodbLogCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foodbLogCell" forIndexPath:indexPath];

    FoodLog *log = self.allFoodLogObjects[indexPath.row];
    cell.foodbLogImageInTheFoodbLogCell.file = log.image;
    [cell.foodbLogImageInTheFoodbLogCell loadInBackground];

    cell.layer.masksToBounds = YES;

    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    FoodbLogCustomHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"foodbLogHeaderView" forIndexPath:indexPath];
    
    headerView.foodbLogHeaderLabel.textColor = [UIColor flatOrangeColor];
    headerView.foodbLogHeaderLabel.text = @"Food";

    return headerView;
}


#pragma mark - Parse methods

- (void)pullDataFromParse {

    PFQuery *query = [PFQuery queryWithClassName:[FoodLog parseClassName]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.allFoodLogObjects = objects;
        [self.collectionView reloadData];
    }];

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"FoodLogDetailVCSegueIdentifier" sender:nil];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    if ([segue.identifier isEqualToString:@"FoodLogDetailVCSegueIdentifier"]) {
    FoodLogDetailViewController *foodLogDetailVC = segue.destinationViewController;

    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    
    FoodLog *passedFoodLogObject = [self.allFoodLogObjects objectAtIndex:indexPath.row];
    
    // Pass the selected object to the new view controller.
    foodLogDetailVC.foodLogObject = passedFoodLogObject;
    }
    
}

@end

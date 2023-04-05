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

#import "FoodLog.h"
#import "FoodbLogCollectionViewController.h"
#import "FoodbLogCustomCell.h"
#import "FoodLogDetailViewController.h"

@interface FoodbLogCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end


@implementation FoodbLogCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FoodbLog_White_Logo.png"]];
    
    CGFloat leftAndRightPaddings = 6.0;
    CGFloat numberOfItemsPerRow = 3.0;
    
    CGFloat heightAdjustment = 30.0;
    CGFloat width = (CGRectGetWidth(self.collectionView.frame) - leftAndRightPaddings)/numberOfItemsPerRow;
    
    UICollectionViewFlowLayout *layout = self.collectionViewLayout;
    layout.itemSize = CGSizeMake(width, width + heightAdjustment);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self pullDataFromParse];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allFoodbLogObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    FoodbLogCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FoodbLogCustomCell" forIndexPath:indexPath];

    FoodLog *log = self.allFoodbLogObjects[indexPath.row];
    
    cell.foodbLogImage.file = log.image;
    [cell.foodbLogImage loadInBackground];

    cell.layer.masksToBounds = YES;

    return cell;
}


#pragma mark - Parse methods

- (void)pullDataFromParse {

    PFQuery *query = [PFQuery queryWithClassName:[FoodLog parseClassName]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.allFoodbLogObjects = objects;
        [self.collectionView reloadData];
    }];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"FoodLogDetailVCSegueIdentifier"]) {
        
        FoodLogDetailViewController *foodLogDetailVC = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        
        FoodLog *passedFoodbLogObject = [self.allFoodbLogObjects objectAtIndex:indexPath.row];
        
        // Pass the selected object to the new view controller.
        foodLogDetailVC.foodbLogObject = passedFoodbLogObject;
    }
    
}

@end

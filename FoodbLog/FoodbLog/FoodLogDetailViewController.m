//
//  FoodLogDetailViewController.m
//  FoodbLog
//
//  Created by Ayuna Vogel on 10/18/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import <ChameleonFramework/Chameleon.h>

#import "FoodLogDetailViewController.h"

@interface FoodLogDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *foodLogImageView; // food image
@property (weak, nonatomic) IBOutlet UIButton *recipeButton;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel; // dish title
@property (weak, nonatomic) IBOutlet UITextView *foodLogDescription; // notes

@end


@implementation FoodLogDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchDataAndSetupUI];
}

- (void)fetchDataAndSetupUI {
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FoodbLog_White_Logo.png"]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // image (top of the screen)
    
    self.foodLogImageView.clipsToBounds = YES;
    
    PFFile *imageFile = self.foodbLogObject.image;
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        self.foodLogImageView.image = [UIImage imageWithData:data];
    }];
    
    // recipe
    
    [self.recipeButton setTitleColor:[UIColor flatBlueColor] forState:UIControlStateNormal];
    self.recipeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    // restaurant
    
    self.restaurantNameLabel.textColor =[UIColor flatGrayColorDark];
    self.restaurantNameLabel.text = self.foodbLogObject.restaurantName;
    
    // dish name
    
    self.dishNameLabel.textColor = [UIColor flatOrangeColor];
    self.dishNameLabel.text = self.foodbLogObject.name;
    
    
    // description/notes
    
    self.foodLogDescription.text = self.foodbLogObject.notes;
    [self.foodLogDescription setFont:[UIFont systemFontOfSize:24.0f]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

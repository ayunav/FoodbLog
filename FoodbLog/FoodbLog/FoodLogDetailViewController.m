//
//  FoodLogDetailViewController.m
//  FoodbLog
//
//  Created by Ayuna Vogel on 10/18/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import "FoodLogDetailViewController.h"
#import <ChameleonFramework/Chameleon.h>

@interface FoodLogDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *foodLogImageView; // food image
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *foodLogDescription; // notes
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel; // dish title
@property (weak, nonatomic) IBOutlet UIButton *recipeButton;

@end

@implementation FoodLogDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.foodLogImageView.clipsToBounds = YES;
    self.dishNameLabel.textColor = [UIColor flatOrangeColor];
    self.restaurantNameLabel.textColor =[UIColor flatGrayColorDark];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.recipeButton setTitleColor:[UIColor flatBlueColor] forState:UIControlStateNormal];
    self.recipeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
    self.dishNameLabel.text = self.foodLogObject.name;
    self.restaurantNameLabel.text = self.foodLogObject.restaurantName; 

    self.foodLogDescription.text = self.foodLogObject.notes;
    // Note: if the object has a recipe saved, it should display the recipe text in the self.foodLogDescription.text
    [self.foodLogDescription setFont:[UIFont systemFontOfSize:24.0f]];
    
    PFFile *imageFile = self.foodLogObject.image;
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }

        self.foodLogImageView.image = [UIImage imageWithData:data];
    
    }];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FoodbLog_White_Logo.png"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)recipeButtonTapped:(UIButton *)sender {
    
   
    
   
    
    
}

@end

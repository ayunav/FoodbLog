//
//  FoodFeedDetailViewController.m
//  FoodbLog
//
//  Created by Ayuna Vogel on 10/18/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import "FoodFeedDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <ChameleonFramework/Chameleon.h>

@interface FoodFeedDetailViewController ()

@property (nonatomic) IBOutlet UIImageView* imageView;
@property (nonatomic) IBOutlet UITextView* textView;
@property (nonatomic) IBOutlet UILabel* titleLabel;

@end

@implementation FoodFeedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleLabel.textColor = [UIColor flatOrangeColor];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    if(self.userName){
        
        self.titleLabel.text = [NSString stringWithFormat:@"Instagram user %@ said:", self.userName];
        
    } else {
        
        self.titleLabel.text = self.recipeName;
        
    }
    self.textView.text = self.textViewCaption;
    self.imageView.clipsToBounds = YES;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.imageView.image = image;
        
        
    }];
    
    
}


@end

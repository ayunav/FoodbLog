//
//  InstagramImagePicker.m
//  FoodbLog
//
//  Created by Jovanny Espinal on 10/11/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "InstagramImagePicker.h"
#import "InstagramImagePickerCustomCell.h"

@implementation InstagramImagePicker

- (void)viewDidLoad {

    CGFloat leftAndRightPaddings = 6.0;
    CGFloat numberOfItemsPerRow = 3.0;
    
    CGFloat heightAdjustment = 30.0;
    CGFloat width = (CGRectGetWidth(self.collectionView.frame) - leftAndRightPaddings)/numberOfItemsPerRow;
    
    UICollectionViewFlowLayout *layout = self.collectionViewLayout;
    layout.itemSize = CGSizeMake(width, width + heightAdjustment);
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageURLArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    InstagramImagePickerCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InstagramImagePickerCustomCell" forIndexPath:indexPath];
    
    [cell.foodImage sd_setImageWithURL:[NSURL URLWithString:self.imageURLArray[indexPath.row]]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 
        cell.foodImage.image = image;
                                 
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate imagePickerDidSelectImageWithURL:self.imageURLArray[indexPath.row]];
    
    InstagramImagePickerCustomCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.alpha = 0.3;
    
}

@end

//
//  InstagramImagePicker.h
//  FoodbLog
//
//  Created by Jovanny Espinal on 10/11/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InstagramImagePickerDelegate <NSObject>

- (void)imagePickerDidSelectImageWithURL:(NSString*)url;

@end


@interface InstagramImagePicker : UICollectionViewController

@property (nonatomic, weak) id <InstagramImagePickerDelegate> delegate;
@property (nonatomic) NSArray *imageURLArray;

@end

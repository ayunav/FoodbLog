//
//  FDBLogData.h
//  FoodbLog
//
//  Created by Ayuna Vogel on 10/15/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface FoodLog : PFObject<PFSubclassing>
+ (NSString *)parseClassName; 

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PFFile *image;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *restaurantName;
@property (nonatomic, strong) NSString *recipeName;


@end

//
//  FDBLogData.m
//  FoodbLog
//
//  Created by Ayuna Vogel on 10/15/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>

#import "FoodbLogObject.h"

// setting up Parse database for FoodLog object

@implementation FoodLog

@dynamic name;
@dynamic image;
@dynamic notes;
@dynamic restaurantName;
@dynamic recipeName;

+ (NSString *)parseClassName {
    return @"FoodLog";
}

@end

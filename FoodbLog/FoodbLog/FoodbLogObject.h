//
//  FDBLogData.h
//  FoodbLog
//
//  Created by Ayuna Vogel on 10/15/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

// setting up Parse database for FoodLog object

@interface FoodLog : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *restaurantName;
@property (nonatomic, strong) NSString *recipeName;
@property (nonatomic, strong) PFFile *image;

@end

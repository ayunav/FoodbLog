//
//  FDBLogData.h
//  FoodbLog
//
//  Created by Ayuna Vogel on 10/15/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface FDBLogData : PFObject<PFSubclassing>
+ (NSString *)parseClassName; 

// the names of the properties for now
@property (nonatomic, strong) NSString *foodLogDishTitle;
@property (nonatomic, strong) PFFile *foodLogImageFile; 
@property (nonatomic, strong) NSString *foodLogImageTitle;
@property (nonatomic, strong) NSString *foodLogRestaurantTitle;
@property (nonatomic, strong) NSString *foodLogRecipeTitle;
@property (nonatomic, strong) NSString *foodLogNotesText;

//- (id)initWithFoodLogObject:(PFObject *)aFoodLog;


@end

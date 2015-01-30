//
//  PullFromParseCloudCode.h
//  Lingo
//
//  Created by William Gu on 1/29/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PullFromParse;
@protocol PullFromParseDelegate

-(void)matchFound;
-(void)matchNotFound;

@end

@interface PullFromParseCloudCode : NSObject

@property (nonatomic, assign) id delegate;
-(void)clientOneFunction;
-(void)deleteMatchFromParse;

//@property (nonatomic, strong) NSString *diningHallOtherIntAsString;
//@property (nonatomic, strong) NSString *usernameOther;
//@property (nonatomic, strong) NSString *deviceTokenOther;

@end

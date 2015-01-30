//
//  PushToParseCloudCode.h
//  Lingo
//
//  Created by William Gu on 1/29/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PushToParse;
@protocol PushToParseDelegate

-(void)callbackFromCloudCodeReceived;

@end


@interface PushToParseCloudCode : NSObject

@property (nonatomic, assign) id delegate;
@property (nonatomic) int diningHall;
-(void)pushToParseCloudCode;

@end

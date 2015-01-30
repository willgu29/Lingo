//
//  UserData.h
//  Lingo
//
//  Created by William Gu on 1/30/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property (nonatomic, strong) NSString *deviceTokenOther;
@property (nonatomic, strong) NSString *diningHallOtherAsStringInt;
@property (nonatomic, strong) NSString *usernameOther;
@property (nonatomic, strong) NSString *conversationID;

@property (nonatomic) int clientType; //first or second? (0 = undecided)

@end

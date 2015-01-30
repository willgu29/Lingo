//
//  CreateConversation.h
//  Lingo
//
//  Created by William Gu on 1/29/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LayerKit/LayerKit.h>

@interface CreateConversation : NSObject

@property (strong, nonatomic) LYRConversation *conversation;
//-(void)createConversationWith:(NSString *)deviceToken;
-(void)sendMessage:(NSString *)textString;
-(void)createDefaultConversationWith:(NSString *)deviceTokenOther;



@end

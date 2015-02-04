//
//  CreateConversation.m
//  Lingo
//
//  Created by William Gu on 1/29/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "CreateConversation.h"
#import <LayerKit/LayerKit.h>
#import "AppDelegate.h"

@implementation CreateConversation




//CLIENT TWO CALL
-(void)createDefaultConversationWith:(NSString *)deviceTokenOther andConvoID:(NSString *)convoID
{
    NSString *deviceTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSError *error = nil;
    self.conversation = [delegate.layerClient newConversationWithParticipants:[NSSet setWithArray:@[deviceTokenString, deviceTokenOther, @"Simulator", @ "Dashboard", convoID]] options:nil error:&error];
    
    
//    send a "dummy" message with the MIME type "text/invite". This would be an empty message that you never display to the users
//    [LYRMessagePart messagePartWithMIMEType:@"text/invite" data:<#(NSData *)#>]
    // Creates a message part with text/plain MIME Type
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithText:@"Welcome to Lingo!"];
    
    // Creates and returns a new message object with the given conversation and array of message parts
    LYRMessage *message = [delegate.layerClient newMessageWithParts:@[messagePart] options:@{LYRMessageOptionsPushNotificationAlertKey: @"LingoUCLA"} error:nil];
    
    // Sends the specified message
    BOOL success = [self.conversation sendMessage:message error:&error];
    if (success) {
        NSLog(@"Message queued to be sent: %@", message);
    } else {
        NSLog(@"Message send failed: %@", error);
    }
    
    [self sendIceBreaker];
   
}

-(void)sendIceBreaker
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithText:@"Say hi!"];
    
    // Creates and returns a new message object with the given conversation and array of message parts
    LYRMessage *message = [delegate.layerClient newMessageWithParts:@[messagePart] options:@{LYRMessageOptionsPushNotificationAlertKey: @"LingoUCLA"} error:nil];
    
    NSError *error;
    // Sends the specified message
    BOOL success = [self.conversation sendMessage:message error:&error];
    if (success) {
        NSLog(@"Message queued to be sent: %@", message);
    } else {
        NSLog(@"Message send failed: %@", error);
    }
}


-(void)sendMessage:(NSString *)textString
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    // Creates a message part with text/plain MIME Type
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithText:textString];
    
    // Creates and returns a new message object with the given conversation and array of message parts
    LYRMessage *message = [delegate.layerClient newMessageWithParts:@[messagePart] options:@{LYRMessageOptionsPushNotificationAlertKey: textString} error:nil];

    // Sends the specified message
    NSError *error;
    BOOL success = [self.conversation sendMessage:message error:&error];
    if (success) {
        NSLog(@"Message queued to be sent: %@", textString);
    } else {
        NSLog(@"Message send failed: %@", error);
    }
}



@end

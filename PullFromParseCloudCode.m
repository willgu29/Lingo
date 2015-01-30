//
//  PullFromParseCloudCode.m
//  Lingo
//
//  Created by William Gu on 1/29/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "PullFromParseCloudCode.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@implementation PullFromParseCloudCode

-(void)clientOneFunction
{
    NSLog(@"client one function");
    
    NSString *stringDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    //Query parse database every 5 seconds for 2 minutes then cancel request
    PFQuery *query = [PFQuery queryWithClassName:@"Match"];
    [query whereKey:@"deviceToken" equalTo:stringDeviceToken];
    PFObject *visitPF = [query getFirstObject];
    
    NSString *status = visitPF[@"status"];
    
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    if (status.integerValue == 1)
    {
        //Start over query in 5 seconds
        [_delegate matchNotFound];
    }
    else if (status.integerValue == 2)
    {
        NSLog(@"Status at 2: messaging in progress!");
        delegate.dataObject.deviceTokenOther = visitPF[@"deviceTokenOther"];
        delegate.dataObject.diningHallOtherAsStringInt = visitPF[@"diningHallOther"];
        delegate.dataObject.usernameOther = visitPF[@"usernameOther"];
        delegate.dataObject.conversationID =  [NSString stringWithFormat:@"%@%@", delegate.dataObject.usernameOther,[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]];

        //Going to delete in deleteMatchFromParse instead
//        [visitPF deleteInBackground];

        //present message screen!
        //Someone found a match and is waiting for you!
        //Switch to messaging
        //Switch match to value 3 or something
        [_delegate matchFound];

    }
    else
    {
        //Ignore
    }
    
}


-(void)deleteMatchFromParse
{
    NSString *stringDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    PFQuery *query = [PFQuery queryWithClassName:@"Match"];
    [query whereKey:@"deviceToken" equalTo:stringDeviceToken];
    PFObject *matchObject = [query getFirstObject];
    [matchObject deleteInBackground];
    
}

@end

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

-(void)queryParseForMatchStatusTwo
{
    
    NSString *stringDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
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
        [_delegate matchFound];

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

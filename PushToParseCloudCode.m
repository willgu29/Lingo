//
//  PushToParseCloudCode.m
//  Lingo
//
//  Created by William Gu on 1/29/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "PushToParseCloudCode.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@implementation PushToParseCloudCode

-(void)pushToParseCloudCode
{
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    NSString *diningHallString = [NSString stringWithFormat:@"%d", _diningHall];
    [PFCloud callFunctionInBackground:@"hello"
                       withParameters:@{@"deviceToken": deviceToken, @"username": username, @"diningHall": diningHallString}
                                block:^(NSArray *results, NSError *error) {
                                    if (!error) {
                                        // this is where you handle the results and change the UI.
                                        NSLog(@"BLOCK CALLED");
                                        NSLog(@"RESULTS: %@", results);
                                        if (results.count == 0)
                                        {
                                            NSLog(@"NO MATCHES ERROR SHOULD BE AN ERROR");
                                        }
                                        else
                                        {
                                            //CLIENT 2
                                            [self matchUser:results];

                                        }
                                    }
                                    else
                                    {
                                        //CLIENT 1
                                        NSLog(@"ERROR: %@", error);
                                        [self addUserToMatchQueue];
                                    }
                                    
                                }];
 
}

-(void)matchUser:(NSArray *)array
{
    id object = [array lastObject];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    delegate.dataObject.clientType = 2;
    delegate.dataObject.usernameOther = object[@"username"];
    delegate.dataObject.diningHallOtherAsStringInt = object[@"diningHall"];
    delegate.dataObject.deviceTokenOther = object[@"deviceToken"];
    
}

-(void)addUserToMatchQueue
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.dataObject.clientType = 1;
    
    PFObject *matchPF = [PFObject objectWithClassName:@"Match"];
    matchPF[@"username"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    matchPF[@"deviceToken"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    matchPF[@"diningHall"] = [NSString stringWithFormat:@"%d",_diningHall];
    matchPF[@"status"] = [NSString stringWithFormat:@"%d", 1];
    matchPF[@"deviceTokenOther"] = nil;
    matchPF[@"diningHallOther"] = nil;
    matchPF[@"usernameOther"] = nil;
    [matchPF saveInBackground];
}

@end

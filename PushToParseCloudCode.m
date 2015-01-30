//
//  PushToParseCloudCode.m
//  Lingo
//
//  Created by William Gu on 1/29/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "PushToParseCloudCode.h"
#import <Parse/Parse.h>

@implementation PushToParseCloudCode

-(void)pushToParseCloudCode
{
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    
    [PFCloud callFunctionInBackground:@"hello"
                       withParameters:@{@"deviceToken": deviceToken}
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
                                            [self matchUser];

                                        }
                                    }
                                    else
                                    {
                                        NSLog(@"ERROR: %@", error);
                                        [self addUserToMatchQueue];
                                    }
                                }];
 
}

-(void)matchUser
{
    
}

-(void)addUserToMatchQueue
{
    PFObject *matchPF = [PFObject objectWithClassName:@"Match"];
    matchPF[@"deviceToken"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    matchPF[@"diningHall"] = [NSString stringWithFormat:@"%d",_diningHall];
    [matchPF saveInBackground];
}

@end

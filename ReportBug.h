//
//  ReportBug.h
//  Lingo
//
//  Created by William Gu on 1/31/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


@class FeedbackViewController;

@interface ReportBug : NSObject <MFMailComposeViewControllerDelegate>

-(void)reportBugWithVC:(UIViewController *)viewController;


@end

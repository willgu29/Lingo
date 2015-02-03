//
//  ReportBug.m
//  Lingo
//
//  Created by William Gu on 1/31/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "ReportBug.h"

@interface ReportBug()

@property (nonatomic, strong) UIViewController *presentingVC;

@end

@implementation ReportBug


-(void)reportBugWithVC:(UIViewController *)viewController
{
    _presentingVC = viewController;
    if ([MFMailComposeViewController canSendMail])
    {
        NSString *emailTitle = @"Feedback";
        // Email Content
        NSString *messageBody = @"Thanks for using Lingo! Please let us know if you have any comments or suggestions; your feedback is highly valued.";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:@"support@trendsetting.me"];
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [viewController presentViewController:mc animated:YES completion:NULL];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Mail is not configured on this account. Please email lingoucla@gmail.com. Your feedback is highly valued."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [_presentingVC dismissViewControllerAnimated:YES completion:NULL];
}


@end

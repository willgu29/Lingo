//
//  MessageViewController.m
//  Lingo
//
//  Created by William Gu on 1/26/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "MessageViewController.h"
#import "Lingo-Swift.h"
#import "CreateConversation.h"
#import "AppDelegate.h"
#import "ConvertDiningHallNumberToString.h"

const int MAX_CONVERSATION_MESSAGES_FROM_QUERY = 7; //Default 20?

@interface MessageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *typingIndicator;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) SendMessages *sendMessageObject;
@property (strong, nonatomic) CreateConversation *createConversationObject;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *diningHallLabel;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //TODO: Add dynamic cell height for ios 7 currently this handles ios 8
    
    //Was crashing on iOS 7 still
//    _tableView.estimatedRowHeight = 44.0;
//    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 ){
//        _tableView.rowHeight = UITableViewAutomaticDimension;
//    }
    
    //*******

    _typingIndicator.hidden = YES;
    _createConversationObject = [[CreateConversation alloc] init];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.dataObject.clientType == 1)
    {
        //LET Client 1 query for chatroom just created by client 2 (if none existed)
        [self queryForConversationWith:delegate.dataObject.deviceTokenOther andConvoID:delegate.dataObject.conversationID];
    }
    else if (delegate.dataObject.clientType == 2)
    {
        //LET CLIENT 2 MAKE CHATROOM SINCE THEY WILL GET RESULT QUICKER.
        [self queryForConversationWith:delegate.dataObject.deviceTokenOther andConvoID:delegate.dataObject.conversationID];

    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveTypingIndicator:)
                                                 name:LYRConversationDidReceiveTypingIndicatorNotification
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
//    if (_tableView.contentSize.height > _tableView.frame.size.height)
//    {
//        CGPoint offset = CGPointMake(0, _tableView.contentSize.height -     _tableView.frame.size.height);
//        [self.tableView setContentOffset:offset animated:YES];
//    }
//
    
    //Crashes on new conversation because there are no messages! (FIX THIS)d
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.queryController numberOfObjectsInSection:0]-1 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}

-(void)moveVC
{
    [self.view setFrame:CGRectMake(0, -166, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)revertVC
{
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
}


#pragma mark - UITextfield Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveVC];
    textField.text = @"";
    [_createConversationObject.conversation sendTypingIndicator:LYRTypingDidBegin];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self revertVC];
    [_createConversationObject.conversation sendTypingIndicator:LYRTypingDidFinish];

}

-(void)didReceiveTypingIndicator:(NSNotification *)notification
{
    NSString *participantID = notification.userInfo[LYRTypingIndicatorParticipantUserInfoKey];
    LYRTypingIndicator typingIndicator = [notification.userInfo[LYRTypingIndicatorValueUserInfoKey] unsignedIntegerValue];
    
    if (typingIndicator == LYRTypingDidBegin) {
        NSLog(@"%@ is typing", [self convertDeviceIDToName:participantID]);
        _typingIndicator.alpha = 0;
        _typingIndicator.hidden = NO;
        [UIView animateWithDuration:1.5 animations:^{
            _typingIndicator.alpha = 1;
        }];
        _typingIndicator.text = [NSString stringWithFormat:@"%@ is typing...", [self convertDeviceIDToName:participantID]];
    }
    else {
        NSLog(@"Typing Stopped");
        _typingIndicator.alpha = 1;
        [UIView animateWithDuration:1 animations:^{
            _typingIndicator.alpha = 0;
        }];
    }
}


#pragma mark - Client Type 1 Methods

-(void)queryForConversationWith:(NSString *)deviceTokenOther andConvoID:(NSString *)convoID
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSString *deviceTokenSelf = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    LYRQuery *query = [LYRQuery queryWithClass:[LYRConversation class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"participants" operator:LYRPredicateOperatorIsEqualTo value:@[deviceTokenSelf,deviceTokenOther, @"Simulator", @"Dashboard" ,convoID]];
    
//    query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    query.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO] ];//YES Feb 3rd
    
    NSError *error;
    NSOrderedSet *conversations = [delegate.layerClient executeQuery:query error:&error];
    if (!error) {
        NSLog(@"%tu conversations with participants %@", conversations.count, @[ @"<PARTICIPANT>" ]);
    } else {
        NSLog(@"Query failed with error %@", error);
    }
    
    
    // Retrieve the last conversation
    if (conversations.count) {
        _createConversationObject.conversation = [conversations lastObject];
        [self setupLabelValues];
        NSLog(@"Get last conversation object: %@",_createConversationObject.conversation.identifier);
        // setup query controller with messages from last conversation
        [self setupQueryController];
    }
    else
    {
        if (delegate.dataObject.clientType == 1)
        {
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(retryMessageConvo) userInfo:nil repeats:NO];

        }
        else if (delegate.dataObject.clientType == 2)
        {
            [_createConversationObject createDefaultConversationWith:delegate.dataObject.deviceTokenOther andConvoID:delegate.dataObject.conversationID];
            [self setupLabelValues];
            [self setupQueryController];
        }
    }
}
                          
-(void)retryMessageConvo
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [self queryForConversationWith:delegate.dataObject.deviceTokenOther andConvoID:delegate.dataObject.conversationID];

}

-(void)setupLabelValues
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    _nameLabel.text = [NSString stringWithFormat:@"%@ would like to eat at: ", delegate.dataObject.usernameOther];
    _diningHallLabel.text = [ConvertDiningHallNumberToString returnDiningHallStringFromInt:delegate.dataObject.diningHallOtherAsStringInt.intValue];
    
}


#pragma mark - IBAction

-(IBAction)doneButton:(UIButton *)sender
{
    // Deletes a conversation
    
    
    [_createConversationObject sendMessage:@"has left the conversation"];
    
//    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(deleteConvo) userInfo:nil repeats:NO];
    
    
    FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] initWithNibName:@"FeedbackViewController" bundle:nil];
    [self.navigationController pushViewController:feedbackVC animated:true];
    
}

-(void)deleteConvo
{
    NSError *error = nil;
    BOOL success = [_createConversationObject.conversation delete:LYRDeletionModeAllParticipants error:&error];

}

-(IBAction)sendButton:(UIButton *)sender
{
    if ([_textField.text isEqualToString:@""])
    {
        return;
    }
    [_createConversationObject sendMessage:_textField.text];
    _textField.text = @"";

}

#pragma mark - UITextField




-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignKeyboard];
}

-(void)resignKeyboard
{
    NSLog(@"Resign keyboard");
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark -Layer methods and calls

-(void)setupQueryController
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    // Query for all the messages in conversation sorted by index
    LYRQuery *query = [LYRQuery queryWithClass:[LYRMessage class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"conversation" operator:LYRPredicateOperatorIsEqualTo value:_createConversationObject.conversation];
    query.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
//    query.limit = MAX_CONVERSATION_MESSAGES_FROM_QUERY;
//    query.offset = 0;
    // Set up query controller
    self.queryController = [delegate.layerClient queryControllerWithQuery:query];
    self.queryController.delegate = self;
    
    NSError *error;
    BOOL success = [self.queryController execute:&error];
    if (success) {
        NSLog(@"Query fetched %tu message objects", [self.queryController numberOfObjectsInSection:0]);
    } else {
        NSLog(@"Query failed with error: %@", error);
    }
    
    [_tableView reloadData];
}

- (void)queryControllerWillChangeContent:(LYRQueryController *)queryController
{
    [self.tableView beginUpdates];
}

- (void)queryController:(LYRQueryController *)controller
        didChangeObject:(id)object
            atIndexPath:(NSIndexPath *)indexPath
          forChangeType:(LYRQueryControllerChangeType)type
           newIndexPath:(NSIndexPath *)newIndexPath
{
    // Automatically update tableview when there are change events
    switch (type) {
        case LYRQueryControllerChangeTypeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case LYRQueryControllerChangeTypeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case LYRQueryControllerChangeTypeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case LYRQueryControllerChangeTypeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
   
}

- (void)queryControllerDidChangeContent:(LYRQueryController *)queryController
{
    [self.tableView endUpdates];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    // Return number of objects in queryController
    return [self.queryController numberOfObjectsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get Message Object from queryController
    LYRMessage *message = [self.queryController objectAtIndexPath:indexPath];
    
    // Set cell text to "<Sender>: <Message Contents>"
    LYRMessagePart *messagePart = message.parts[0];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",[message sentByUserID], [[NSString alloc] initWithData:messagePart.data encoding:NSUTF8StringEncoding]];
    
    NSString *messageString = [[NSString alloc] initWithData:messagePart.data encoding:NSUTF8StringEncoding];

    if ([messageString isEqualToString:@"Welcome to Lingo!"] || [messageString isEqualToString:@"Say hi!"])
    {
        cell.textLabel.text = [NSString stringWithFormat:@"Lingo@UCLA: %@", messageString];
        return;
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",[self convertDeviceIDToName:[message sentByUserID]], messageString];
    }

//    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",[self convertDeviceIDToName:[message sentByUserID]], [[NSString alloc] initWithData:messagePart.data encoding:NSUTF8StringEncoding]];


}

-(NSString *)convertDeviceIDToName:(NSString *)deviceID
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSString *deviceString = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    if ([deviceID isEqualToString:deviceString])
    {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    }
    else
    {
        return delegate.dataObject.usernameOther;
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

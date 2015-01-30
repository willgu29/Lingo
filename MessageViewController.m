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
@interface MessageViewController ()

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

    _createConversationObject = [[CreateConversation alloc] init];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.dataObject.clientType == 1)
    {
        [self queryForConversationWith:delegate.dataObject.deviceTokenOther andConvoID:delegate.dataObject.conversationID];
    }
    else if (delegate.dataObject.clientType == 2)
    {
        [_createConversationObject createDefaultConversationWith:delegate.dataObject.deviceTokenOther andConvoID:delegate.dataObject.conversationID];
        [self setupLabelValues];
        [self setupQueryController];
    }
    else
    {
        //FATAL ERROR
    }
    
    

    
    
    // Fetches all conversations between the authenticated user and the supplied participant
    [self fetchLayerConversation];
}

#pragma mark - Client Type 1 Methods

-(void)queryForConversationWith:(NSString *)deviceTokenOther andConvoID:(NSString *)convoID
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSString *deviceTokenSelf = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    LYRQuery *query = [LYRQuery queryWithClass:[LYRConversation class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"participants" operator:LYRPredicateOperatorIsEqualTo value:@[deviceTokenOther, @"Simulator", @"Dashboard" ,convoID]];
    
    query.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES] ];
    
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
        [_createConversationObject.conversation addParticipants:[NSSet setWithArray:@[deviceTokenSelf]] error:&error];
        [self setupLabelValues];
        NSLog(@"Get last conversation object: %@",_createConversationObject.conversation.identifier);
        // setup query controller with messages from last conversation
        [self setupQueryController];
    }
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
    NSError *error = nil;
    BOOL success = [_createConversationObject.conversation delete:LYRDeletionModeAllParticipants error:&error];
    
    
    FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] initWithNibName:@"FeedbackViewController" bundle:nil];
    [self.navigationController pushViewController:feedbackVC animated:true];
    
}

-(IBAction)sendButton:(UIButton *)sender
{
    [_createConversationObject sendMessage:_textField.text];
//    [_createConversationObject testMessage];
}

#pragma mark - UITextField




-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    return YES;
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self resignKeyboard];
//}
//
//-(void)resignKeyboard
//{
//    NSLog(@"Resign keyboard");
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
//    
//}

#pragma mark -Layer methods and calls

- (void)fetchLayerConversation
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    LYRQuery *query = [LYRQuery queryWithClass:[LYRConversation class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"participants" operator:LYRPredicateOperatorIsEqualTo value:@[@"TestUser", @"Simulator", @"Dashboard" ]];
    
    query.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO] ];
    
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
        NSLog(@"Get last conversation object: %@",_createConversationObject.conversation.identifier);
        // setup query controller with messages from last conversation
        [self setupQueryController];
    }
}

-(void)setupQueryController
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    // Query for all the messages in conversation sorted by index
    LYRQuery *query = [LYRQuery queryWithClass:[LYRMessage class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"conversation" operator:LYRPredicateOperatorIsEqualTo value:_createConversationObject.conversation];
    query.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:NO]];
    
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",[self convertDeviceIDToName:[message sentByUserID]], [[NSString alloc] initWithData:messagePart.data encoding:NSUTF8StringEncoding]];

}

-(NSString *)convertDeviceIDToName:(NSString *)deviceID
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (deviceID == [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"])
    {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    }
    else
    {
        return delegate.dataObject.usernameOther;
    }

}

//- (void)fetchLayerConversation
//{
//    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
////    NSString *
//    LYRQuery *query = [LYRQuery queryWithClass:[LYRConversation class]];
//    query.predicate = [LYRPredicate predicateWithProperty:@"participants" operator:LYRPredicateOperatorIsEqualTo value:self.createConversationObject.conversation];// @[ @"TestUser" ]];
//    query.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES] ];
//    
//    NSError *error;
//    NSOrderedSet *conversations = [delegate.layerClient executeQuery:query error:&error];
//    if (!error) {
//        NSLog(@"%tu conversations with participants %@", conversations.count, conversations.array);
//    } else {
//        NSLog(@"Query failed with error %@", error);
//    }
//    
//    // Retrieve the last conversation
//    if (conversations.count) {
//        _createConversationObject.conversation = [conversations lastObject];
//        NSLog(@"Get last conversation object: %@",_createConversationObject.conversation.identifier);
//        // setup query controller with messages from last conversation
//        [self setupQueryController];
//    }
//}
//
//-(void)setupQueryController
//{
//    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    // Query for all the messages in conversation sorted by index
//    LYRQuery *query = [LYRQuery queryWithClass:[LYRMessage class]];
//    query.predicate = [LYRPredicate predicateWithProperty:@"conversation" operator:LYRPredicateOperatorIsEqualTo value:_createConversationObject.conversation];
//    query.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:NO]];
//    
//    // Set up query controller
//    self.queryController = [delegate.layerClient queryControllerWithQuery:query];
//    self.queryController.delegate = self;
//    
//    NSError *error;
//    BOOL success = [self.queryController execute:&error];
//    if (success) {
//        NSLog(@"Query fetched %tu message objects", [self.queryController numberOfObjectsInSection:0]);
//    } else {
//        NSLog(@"Query failed with error: %@", error);
//    }
//}
//
//- (void)queryControllerWillChangeContent:(LYRQueryController *)queryController
//{
//    [self.tableView beginUpdates];
//}
//
//- (void)queryController:(LYRQueryController *)controller
//        didChangeObject:(id)object
//            atIndexPath:(NSIndexPath *)indexPath
//          forChangeType:(LYRQueryControllerChangeType)type
//           newIndexPath:(NSIndexPath *)newIndexPath
//{
//    // Automatically update tableview when there are change events
//    switch (type) {
//        case LYRQueryControllerChangeTypeInsert:
//            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
//                                  withRowAnimation:UITableViewRowAnimationAutomatic];
//            break;
//        case LYRQueryControllerChangeTypeUpdate:
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
//                                  withRowAnimation:UITableViewRowAnimationAutomatic];
//            break;
//        case LYRQueryControllerChangeTypeMove:
//            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
//                                  withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
//                                  withRowAnimation:UITableViewRowAnimationAutomatic];
//            break;
//        case LYRQueryControllerChangeTypeDelete:
//            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
//                                  withRowAnimation:UITableViewRowAnimationAutomatic];
//            break;
//        default:
//            break;
//    }
//}
//
//- (void)queryControllerDidChangeContent:(LYRQueryController *)queryController
//{
//    [self.tableView endUpdates];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return number of objects in queryController
//    return [self.queryController numberOfObjectsInSection:section];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *simpleTableIdentifier = @"SimpleTableCell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Get Message Object from queryController
//    LYRMessage *message = [self.queryController objectAtIndexPath:indexPath];
//    
//    // Set cell text to "<Sender>: <Message Contents>"
//    LYRMessagePart *messagePart = message.parts[0];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",[message sentByUserID], [[NSString alloc] initWithData:messagePart.data encoding:NSUTF8StringEncoding]];
//}
//

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

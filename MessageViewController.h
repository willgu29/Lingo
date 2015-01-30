//
//  MessageViewController.h
//  Lingo
//
//  Created by William Gu on 1/26/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>

@interface MessageViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,LYRQueryControllerDelegate>

//These properties are used within the example.

//@property (nonatomic) LYRClient *layerClient;
@property (nonatomic, retain) LYRQueryController *queryController;
//
//@property (nonatomic, strong) NSString *diningHallOtherIntAsString;
//@property (nonatomic, strong) NSString *usernameOther;
//@property (nonatomic, strong) NSString *deviceTokenOther;
//@property (nonatomic) int clientType;

@end

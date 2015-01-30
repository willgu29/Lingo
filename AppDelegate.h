//
//  AppDelegate.h
//  Lingo
//
//  Created by William Gu on 1/26/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@class LYRClient;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LYRClient *layerClient;
@property (strong, nonatomic) UserData *dataObject;

@end

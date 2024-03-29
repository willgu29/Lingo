//
//  AppDelegate.m
//  Lingo
//
//  Created by William Gu on 1/26/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "AppDelegate.h"
#import "Lingo-Swift.h"
#import <LayerKit/LayerKit.h>
#import <Parse/Parse.h>
#import "NSDataConvert.h"

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //PARSE KIT
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"JxRcxaBlRovUP8BpmdUCRDvifa6IM9kHh9y5kVG2"
                  clientKey:@"C4DQQQotZzVIKaPM1SxuQUMTtYG3CBrGRBag4ZRM"];
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    //**************
    
    //PUSH NOTIFICATIONS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        // Register device for iOS8
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
        
    } else {
        // Register device for iOS7
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    }
    //***************
    
    
    //"Login Authentication" -> currently if a username is stored go to main, else create username
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    if (username)
    {
        WhereWhenViewController *whereVC = [[WhereWhenViewController alloc] initWithNibName:@"WhereWhenViewController" bundle:nil];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:whereVC];
        self.window.rootViewController = navVC;
    }
    else
    {
        IntroViewController *introVC = [[IntroViewController alloc] initWithNibName:@"IntroViewController" bundle:nil];
        self.window.rootViewController = introVC;
    }
    
    _dataObject = [[UserData alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
    
}



-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register remote Notifcations: FATAL ERROR: %@", error);
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    NSLog(@"Device token: %@", deviceToken);
    NSString *hexadecimalString = [deviceToken hexadecimalString];
    [[NSUserDefaults standardUserDefaults] setObject:hexadecimalString forKey:@"deviceToken"];
    [self activiateLayer];
}
//-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    //fetch proper completion handle for notification.
//    
//    
//}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //If user is in matching mode, send push notification on match found
    
    //else if user is in messaging, send them message notifications
    
    //
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self deleteMatchFromParse]; //Jan 31.. might not be working
    
}



-(void)deleteMatchFromParse
{
    NSString *stringDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    PFQuery *query = [PFQuery queryWithClassName:@"Match"];
    [query whereKey:@"deviceToken" equalTo:stringDeviceToken];
    PFObject *matchObject = [query getFirstObject];
    [matchObject deleteInBackground];
    
}

#pragma mark -LAYER KIT


-(NSString *)generateUserIDString
{
    NSLog(@"Generating Unique ID");
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
}

-(void)activiateLayer
{
    //LAYER KIT
    NSUUID *appID = [[NSUUID alloc] initWithUUIDString:@"806c1028-a013-11e4-a3db-285a000000f4"];
    self.layerClient = [LYRClient clientWithAppID:appID];
    [self.layerClient connectWithCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"Failed to connect to Layer: %@", error);
        } else {
            //            NSString *userIDString = @"TestUser";
            NSString *userIDString = [self generateUserIDString];
            // Once connected, authenticate user.
            // Check Authenticate step for authenticateLayerWithUserID source
            [self authenticateLayerWithUserID:userIDString completion:^(BOOL success, NSError *error) {
                if (!success) {
                    NSLog(@"Failed Authenticating Layer Client with error:%@", error);
                }
            }];
        }
    }];
    
    
    
    //**************
    
}

- (void)authenticateLayerWithUserID:(NSString *)userID completion:(void (^)(BOOL success, NSError * error))completion
{
    // If the user is authenticated you don't need to re-authenticate.
    if (self.layerClient.authenticatedUserID) {
        NSLog(@"Layer Authenticated as User %@", self.layerClient.authenticatedUserID);
        if (completion) completion(YES, nil);
        return;
    }
    
    /*
     * 1. Request an authentication Nonce from Layer
     */
    [self.layerClient requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
        if (!nonce) {
            if (completion) {
                completion(NO, error);
            }
            return;
        }
        
        /*
         * 2. Acquire identity Token from Layer Identity Service
         */
        [self requestIdentityTokenForUserID:userID appID:[self.layerClient.appID UUIDString] nonce:nonce completion:^(NSString *identityToken, NSError *error) {
            if (!identityToken) {
                if (completion) {
                    completion(NO, error);
                }
                return;
            }
            
            /*
             * 3. Submit identity token to Layer for validation
             */
            [self.layerClient authenticateWithIdentityToken:identityToken completion:^(NSString *authenticatedUserID, NSError *error) {
                if (authenticatedUserID) {
                    if (completion) {
                        completion(YES, nil);
                    }
                    NSLog(@"Layer Authenticated as User: %@", authenticatedUserID);
                } else {
                    completion(NO, error);
                }
            }];
        }];
    }];
}

- (void)requestIdentityTokenForUserID:(NSString *)userID appID:(NSString *)appID nonce:(NSString *)nonce completion:(void(^)(NSString *identityToken, NSError *error))completion
{
    NSParameterAssert(userID);
    NSParameterAssert(appID);
    NSParameterAssert(nonce);
    NSParameterAssert(completion);
    
    NSURL *identityTokenURL = [NSURL URLWithString:@"https://layer-identity-provider.herokuapp.com/identity_tokens"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:identityTokenURL];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary *parameters = @{ @"app_id": appID, @"user_id": userID, @"nonce": nonce };
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    request.HTTPBody = requestBody;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        // Deserialize the response
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(![responseObject valueForKey:@"error"])
        {
            NSString *identityToken = responseObject[@"identity_token"];
            completion(identityToken, nil);
        }
        else
        {
            NSString *domain = @"layer-identity-provider.herokuapp.com";
            NSInteger code = [responseObject[@"status"] integerValue];
            NSDictionary *userInfo =
            @{
              NSLocalizedDescriptionKey: @"Layer Identity Provider Returned an Error.",
              NSLocalizedRecoverySuggestionErrorKey: @"There may be a problem with your APPID."
              };
            
            NSError *error = [[NSError alloc] initWithDomain:domain code:code userInfo:userInfo];
            completion(nil, error);
        }
        
    }] resume];
}

@end

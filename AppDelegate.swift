//
//  AppDelegate.swift
//  Lingo
//
//  Created by William Gu on 1/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var layerClient: LYRClient!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
    
        var appID: NSUUID? = NSUUID(UUIDString: "806c1028-a013-11e4-a3db-285a000000f4");
        
        self.layerClient = LYRClient(appID: appID);
        self.layerClient.connectWithCompletion { (var success: Bool, var error: NSError!) -> Void in
            //Code block 1
            if (!success)
            {
                NSLog("Test failure");
            }
            else
            {
                NSLog("Test success");
                var userIDString = "TestUser";
                //Once connected, authenticate user
                //Check authenticate step for authenticateLayerWithUserID source
                self.authenticateLayerWithUserID(userIDString, completion: { (var success: Bool, var error: NSError!) -> Void in
                    if (!success)
                    {
                        NSLog("Failed authenticating layer with error %@", error);
                    }
                })
            }
        }

    
            


        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds);
        var introVC = IntroViewController(nibName: "IntroViewController", bundle:nil);
        self.window?.rootViewController = introVC;
    
    
        self.window?.backgroundColor = UIColor.whiteColor();
    
    
    
        self.window?.makeKeyAndVisible();
    
    
        return true
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //pragma mark - Swift Layer ******************
    //********************************************
    
    func authenticateLayerWithUserID(userID: NSString, completion:((Bool, NSError!) -> Void))
    {
        //User already authenticated
        if (self.layerClient.authenticatedUserID != nil)
        {
            NSLog("Layer authenticated as User %@", self.layerClient.authenticatedUserID);
            if ((completion) != nil)
            {
                completion(true, nil);
                return;
            }
        }
        //1. Request authentication from nonce from layer
        self.layerClient.requestAuthenticationNonceWithCompletion { (var nonce: String!, var error: NSError!) -> Void in
            if (nonce != nil)
            {
                if (completion != nil)
                {
                    completion(false, error);
                }
                return;
            }
            //2. Acquire identity token from layer identity service
            self.requestIdentityTokenForUserID(userID, appID: self.layerClient.appID.UUIDString, nonce: nonce) { (var identityToken: NSString!, var error: NSError!) -> Void in
                //Hi code!
                if (identityToken == nil)
                {
                    if (completion != nil)
                    {
                        completion(false, error);
                    }
                    return;
                }
                
                //3. submit identity token to layer for validation
                self.layerClient.authenticateWithIdentityToken(identityToken, completion: { (var authenticatedUserID: String!, var error: NSError!) -> Void in
                    if (authenticatedUserID != nil)
                    {
                        if(completion != nil)
                        {
                            completion(true, nil);
                        }
                        NSLog("Layer has authenticated as user: %@", authenticatedUserID);
                    }
                    else
                    {
                        completion(false, error);
                        
                    }
                })
            }
            
            
        }
        
        
            
    }
    
    func requestIdentityTokenForUserID(userID: NSString, appID: NSString, nonce: NSString, completion:((NSString!, NSError!) -> Void)! )
    {
        var identityTokenURL = NSURL(string: "https://layer-identity-provider.herokuapp.com/identity_tokens");
        var request = NSMutableURLRequest(URL: identityTokenURL!);
        request.HTTPMethod = "POST";
        request.valueForHTTPHeaderField("Content-Type");
        request.valueForHTTPHeaderField("Accept");
        var parameters = ["app_id": appID, "user_id": userID, "nonce": nonce];
        let option = 0;
        
        var requestBody = NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions(), error: nil);
        request.HTTPBody = requestBody;
        
        var sessionConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration();
        var session = NSURLSession(configuration: sessionConfig);
        session.dataTaskWithRequest(request, completionHandler: { (var data:NSData!, var response: NSURLResponse!, var error:NSError!) -> Void in
            if (error != nil)
            {
                completion(nil, error);
                return;
            }
            //deserialize response
            var responseObject = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(), error: nil);
            if (responseObject?.valueForKey("error") == nil)
            {
                var identityToken: NSString = (responseObject?.valueForKey("identity_token") as NSString);
                completion(identityToken, nil);
            }
            else
            {
                var domain = "layer-identity-provider.herokuapp.com";
                var code = responseObject?.valueForKey("status")?.integerValue;
                var userInfo = [NSLocalizedDescriptionKey: "Layer Identity Provider Returned an Error",
                    NSLocalizedRecoverySuggestionErrorKey: "There may be a problem with your APPID"];
                
                var error = NSError(domain: domain, code: code!, userInfo: userInfo);
                completion(nil, error);
            }
    
        }).resume();
        
    }
    
}





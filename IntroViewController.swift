//
//  IntroViewController.swift
//  Lingo
//
//  Created by William Gu on 1/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goButton() {
        var whereWhenVC = WhereWhenViewController(nibName:"WhereWhenViewController", bundle:nil);
        var navigationController = UINavigationController(rootViewController: whereWhenVC);
//        var userinfoVC = UserInfoViewController(nibName:"UserInfoViewController", bundle:nil);
//        var tabBarVC = UITabBarController();
//        tabBarVC.viewControllers = [navigationController, userinfoVC];
        self.presentViewController(navigationController, animated: true, completion: nil);
    }

    
    func textFieldDidEndEditing(textField: UITextField) {
        //Save name
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

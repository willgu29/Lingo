//
//  MatchViewController.swift
//  Lingo
//
//  Created by William Gu on 1/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testButton() {

        var pushParse = PushToParseCloudCode();
        pushParse.pushToParseCloudCode();
    }
    
    @IBAction func messageButton() {
        //Layer SDK or Parse SDK or Personal Implementation?
        var messageVC = MessageViewController(nibName:"MessageViewController", bundle:nil);
//        var messagingVC = MessagingViewController(nibName:"MessagingViewController", bundle:nil);
        self.navigationController?.pushViewController(messageVC, animated: true);
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

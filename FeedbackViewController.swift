//
//  FeedbackViewController.swift
//  Lingo
//
//  Created by William Gu on 1/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    var reportBug = ReportBug();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func feedbackButton() {
        //Present mail option
        reportBug.reportBugWithVC(self);
    }
    
    @IBAction func roundTwoButton() {
        //Go back to start
        self.navigationController?.popToRootViewControllerAnimated(true);
    }
  

}

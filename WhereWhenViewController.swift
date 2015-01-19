//
//  WhereWhenViewController.swift
//  Lingo
//
//  Created by William Gu on 1/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class WhereWhenViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker?
    @IBOutlet weak var diningHallPicker: UIPickerView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yayButton() {
        //Puts user in queue based on decided location and time
        var matchVC = MatchViewController(nibName:"MatchViewController", bundle:nil);
//        self.navigationController?.pushViewController(matchVC, animated: true);
        self.presentViewController(matchVC, animated: true, completion: nil);
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

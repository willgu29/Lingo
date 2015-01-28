//
//  WhereWhenViewController.swift
//  Lingo
//
//  Created by William Gu on 1/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class WhereWhenViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var datePicker: UIDatePicker?
    @IBOutlet weak var diningHallPicker: UIPickerView?
    var dataSourcePicker: NSArray = ["De Neve", "B Plate", "Feast", "Covel", "Rende", "Cafe 1919", "B Cafe"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        datePicker?.datePickerMode = UIDatePickerMode.CountDownTimer;
        self.navigationController?.navigationBarHidden = true;
        
    }
    
    func setupValuesOfPickers() {
        datePicker?.minimumDate = NSDate() //current date and time
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yayButton() {
        //Puts user in queue based on decided location and time
        //Send to server
        
        var matchVC = MatchViewController(nibName:"MatchViewController", bundle:nil);
        self.navigationController?.pushViewController(matchVC, animated: true);
    }
    
    
    //Dining Hall Picker
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Save dining hall
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let dataString = dataSourcePicker.objectAtIndex(row) as String;
        return NSAttributedString(string: dataString, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
//        return dataSourcePicker.objectAtIndex(row) as String;
//    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSourcePicker.count;
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    //*********************
    
    //Date Picker
    
    
}

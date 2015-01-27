//
//  MessagingViewController.swift
//  Lingo
//
//  Created by William Gu on 1/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

//USE MESSAGE VIEW CONTROLLER INSTEAD ********

class MessagingViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var textField: UITextField!
    @IBOutlet var tableView: UITableView!
    var queryController: LYRQueryController?
    var sendMessageObject: SendMessages = SendMessages()
//    var conversation: LYRConversation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
//    
//    func fetchLayerConversation()
//    {
//        var query: LYRQuery = LYRQuery().queryableClass
//        query.predicate = LYRPredicate.p
//    }
    
    
    //IBACTIONS
    
    @IBAction func sendButton(){
        //Send message
        sendMessageObject.sendMessage(textField.text)
        
    }
    
    @IBAction func doneButton(){
        var feedbackVC = FeedbackViewController(nibName:"FeedbackViewController", bundle:nil);
        self.navigationController?.pushViewController(feedbackVC, animated: true);

    }

    
    //RESIGN KEYBOARD METHODS
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        NSLog("Touch Began");
        resignKeyboard()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func resignKeyboard()
    {
        textField.resignFirstResponder()
       
    }
    
    //TABLEVIEW DELEGATE METHODS
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Default");
        cell.textLabel?.text = "SUP";
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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

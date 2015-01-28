//
//  IntroViewController.swift
//  Lingo
//
//  Created by William Gu on 1/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goButton() {
        
        
        if (textField.text.isEmpty)
        {
            //Alert: Please enter a name!
        }
        else
        {
            //Save name
        }
        
    }

    @IBAction func takeASelf() {
        
    }
    
    func saveName()
    {
        NSUserDefaults.standardUserDefaults().setValue(textField.text, forKey: "name");
        
    }
    
    
    func presentNextViewController()
    {
        var whereWhenVC = WhereWhenViewController(nibName:"WhereWhenViewController", bundle:nil);
        var navigationController = UINavigationController(rootViewController: whereWhenVC);
        self.presentViewController(navigationController, animated: true, completion: nil);
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        //Save name
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignFirstResponder()
        return true;
    }
 
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        resignFirstResponder()
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

//
//  SignUpSecond.swift
//  RunnerApp
//
//  Created by Steven Prescott on 9/26/15.
//  Copyright (c) 2015 Steven Prescott. All rights reserved.
//

import UIKit

class SignUpSecond: UIViewController,JsonDelegete {
    
    @IBOutlet var emailTF : UITextField!
    @IBOutlet var passWdTF : UITextField!
    @IBOutlet var confirmPassWdTF : UITextField!
    var _MoveUp: Bool = true
    @IBOutlet var msgLblShow : UILabel!
    var timer : NSTimer = NSTimer()
    @IBOutlet var signUpBtn : UIButton!
    var receivedData:NSMutableArray = NSMutableArray()
    var dataToSend = NSString()
    let jsonParsing = JsonParsing(nibName:"JsonParsing.swift", bundle: nil)
    var dataFetchingCase : Int = -1
    
    
    lazy private var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "loading")!
        return CustomActivityIndicatorView(image: image)
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(receivedData)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.addBottomLayer(emailTF)
        self.addBottomLayer(passWdTF)
        self.addBottomLayer(confirmPassWdTF)
        
        msgLblShow.layer.masksToBounds = true
        msgLblShow.layer.cornerRadius = 4.0
        signUpBtn.layer.cornerRadius = 4.0
        
        // Do any additional setup after loading the view.
    }
    func addLoadingIndicator (tempView : UIView)
    {
        tempView.addSubview(activityIndicator)
        activityIndicator.center = self.msgLblShow.center
        
    }
    func errorLblShow()
    {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.msgLblShow.alpha = 1.0
            self.view.userInteractionEnabled = false
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector:"update", userInfo:nil, repeats: false)
            }, completion: nil)
        
        
    }
    func update()
    {
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.msgLblShow.alpha = 0.0
            self.timer.invalidate()
            self.view.userInteractionEnabled = true
            }, completion: nil)
    }
    
    func addBottomLayer(textField: UITextField)
    {
        let bottomBorder = CALayer()
         bottomBorder.frame = CGRectMake(0.0, textField.frame.size.height - 1, textField.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0).CGColor
        textField.layer.addSublayer(bottomBorder)
    }
    
    @IBAction func signUpBtnClicked(sender : AnyObject)
    {
        
        if emailTF.text == ""
        {
            msgLblShow.text = "Please enter email ID."
            self.errorLblShow()
            
        }
        else if (isValidEmail(emailTF.text!) == false)
        {
            msgLblShow.text = "Please enter a valid email-Id."
            self.errorLblShow()
            
        }
        else if passWdTF.text == ""
        {
            msgLblShow.text = "Please enter your password"
            self.errorLblShow()
            
        }
        else if confirmPassWdTF.text == ""
        {
            msgLblShow.text = "Please enter confirm password"
            self.errorLblShow()
        }
        else if passWdTF.text != confirmPassWdTF.text
        {
            msgLblShow.text = "Password and confirm password must be same"
            self.errorLblShow()
        }
        else
        {
            NSUserDefaults.standardUserDefaults().setValue(emailTF.text, forKey: "username")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            NSUserDefaults.standardUserDefaults().setValue(passWdTF.text, forKey: "password")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            
            var data = NSMutableDictionary()
            if (receivedData.count > 0) {
                data.setValue("not available", forKey: "coach_id")
                data.setValue("not available", forKey: "userid")
                data.setValue(receivedData.objectAtIndex(0).valueForKey("userName") , forKey: "username")
                data.setValue(passWdTF.text, forKey: "password")
                data.setValue(emailTF.text, forKey: "email")
                data.setValue("not available", forKey: "first_name")
                data.setValue("not available", forKey: "last_name")
                data.setValue("not available", forKey: "weight")
                data.setValue("not available", forKey: "height")
                data.setValue("not available", forKey: "age")
                data.setValue("not available", forKey: "dob")
                data.setValue(receivedData.objectAtIndex(0).valueForKey("schoolName"), forKey: "school")
                data.setValue(receivedData.objectAtIndex(0).valueForKey("teamName"), forKey: "team")
                data.setValue(receivedData.objectAtIndex(0).valueForKey("coachName"), forKey: "coach_name")
                data.setValue("1", forKey: "role")
                data.setValue("not available", forKey: "intials")
                
                
                dataToSend  = data.JSONRepresentation()
            }
            jsonParsing.loadData("POST", url: SignUpApi, isHeader: true,throughAccessToken : false,dataToSend : dataToSend as String,sendData : true)
            jsonParsing.jpdelegate = self
            dataFetchingCase = ApiResponseValue.SignUpApiCalled.rawValue
            activityIndicator.startAnimating()
        }
        
    }
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest : NSPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }

    
    func textFieldDidBeginEditing(textField: UITextField)
    {
         self.viewMoveUp(60.0)
    }
    func textFieldDidEndEditing(textField: UITextField)
    {
        if textField == emailTF
        {
            emailTF.resignFirstResponder()
            passWdTF.becomeFirstResponder()
            
        }
        else if textField == passWdTF
        {
            passWdTF.resignFirstResponder()
            confirmPassWdTF.becomeFirstResponder()
            
        }
        else
        {
            self.viewMoveDown(60.0)
            confirmPassWdTF.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
        
    }
    
    func viewMoveUp(value:CGFloat){
        if (_MoveUp){
            UIView.animateWithDuration( 0.3 , animations:
                {   //Perform animation to lift view upside
                    var f : CGRect  = self.view.bounds
                    f.origin.y += value
                    self.view.bounds = f
            })
            _MoveUp = false
        }
    }
    func viewMoveDown(value:CGFloat){
        if (!_MoveUp){
            UIView.animateWithDuration( 0.3 , animations:
                {   //Perform animation to lift view upside
                    var f : CGRect  = self.view.bounds
                    f.origin.y -= value
                    self.view.bounds = f
            })
            
            _MoveUp = true
        }
    }
    
    
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        
//    }

    
    func dataFound(){
       
        var isSuccess : Int = 1
        activityIndicator.stopAnimating()
        if (dataFetchingCase == ApiResponseValue.SignUpApiCalled.rawValue){
            if ((jsonParsing.fetchedJsonResult["success"] as! Int)  == isSuccess )
            {
                var access_token: NSString? = jsonParsing.fetchedDataArray.objectAtIndex(0)["access_token"] as? String
                var coach_id: Int? = jsonParsing.fetchedDataArray.objectAtIndex(0)["id"] as? Int
                
                NSUserDefaults.standardUserDefaults().setValue(String(format: "%d", coach_id!), forKey: "coach_id")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                NSUserDefaults.standardUserDefaults().setValue(access_token, forKey: "access_token")
                NSUserDefaults.standardUserDefaults().synchronize()
                NSUserDefaults.standardUserDefaults().setValue("false", forKey: "logout")
                NSUserDefaults.standardUserDefaults().synchronize()
                var user_email: NSString? = jsonParsing.fetchedDataArray.objectAtIndex(0)["email_id"] as? String
                NSUserDefaults.standardUserDefaults().setValue(user_email, forKey: "email_id")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                let homeVC:UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeScreen") as UIViewController!
                
                self.navigationController?.pushViewController(homeVC, animated: true)
            }
            else{
                msgLblShow.text = "Your email or password is incorrect"
                self.errorLblShow()
            }
            
        }
    }
    func connectionInterruption(){
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

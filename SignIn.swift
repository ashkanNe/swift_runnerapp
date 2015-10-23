//
//  SignIn.swift
//  RunnerApp
//
//  Created by Tarun Sachdeva on 9/26/15.
//  Copyright (c) 2015 Tarun Sachdeva. All rights reserved.
//

import UIKit

class SignIn: UIViewController,UITextFieldDelegate,JsonDelegete {
    
     @IBOutlet var userNameTF : UITextField!
     @IBOutlet var passwordTF : UITextField!
     @IBOutlet var loginBtn : UIButton!
     @IBOutlet var signUpBtn : UIButton!
     @IBOutlet var loadingIndicator : UIActivityIndicatorView!
     @IBOutlet var loadingView : UIView!
     @IBOutlet var msgLblShow : UILabel!
     var dataToSend = NSString()
     let jsonParsing = JsonParsing(nibName:"JsonParsing.swift", bundle: nil)
     var dataFetchingCase : Int = -1
     var timer : NSTimer = NSTimer()
     var _MoveUp: Bool = true
    
    
    lazy private var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "loading")!
        return CustomActivityIndicatorView(image: image)
        }()


    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
       self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "Runner App"
        addLoadingIndicator(self.view)
        self.addBottomLayer(userNameTF)
        self.addBottomLayer(passwordTF)
        msgLblShow.layer.masksToBounds = true
        msgLblShow.layer.cornerRadius = 4.0
        loginBtn.layer.cornerRadius = 4.0
        signUpBtn.layer.cornerRadius = 4.0
        
        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addLoadingIndicator (tempView : UIView)
    {
        tempView.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        
    }
    
    func addBottomLayer(textField: UITextField)
    {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, textField.frame.size.height - 1, textField.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0).CGColor
        textField.layer.addSublayer(bottomBorder)
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
    
    
    @IBAction func signInBtnClicked(sender : AnyObject)
    {
        
        if userNameTF.text == ""
        {
            msgLblShow.text = "Please enter your Email-id"
            self.errorLblShow()
            
        }
        else if (isValidEmail(userNameTF.text!) == false)
        {
            msgLblShow.text = "Please enter a valid Email-id"
            self.errorLblShow()
            
        }
        else if passwordTF.text == ""
        {
            msgLblShow.text = "Please enter your password"
            self.errorLblShow()
            
        }
        else
        {
        
        NSUserDefaults.standardUserDefaults().setValue(userNameTF.text, forKey: "username")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        NSUserDefaults.standardUserDefaults().setValue(passwordTF.text, forKey: "password")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        jsonParsing.loadData("POST", url: LoginApi, isHeader: true,throughAccessToken : false,dataToSend : dataToSend as String,sendData : true)
        jsonParsing.jpdelegate = self
        dataFetchingCase = ApiResponseValue.LoginApiCalled.rawValue
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
        if (textField == userNameTF || textField == passwordTF ){
            self.viewMoveUp(60.0)
        }
    }

    func textFieldDidEndEditing(textField: UITextField)
    {
        if textField == userNameTF {
            userNameTF.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        }
        else if textField == passwordTF {
            self.viewMoveDown(60.0)
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
    
    func dataFound(){
        var isSuccess : Int = 1
        activityIndicator.stopAnimating()
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
    func connectionInterruption(){
        
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

//
//  EditRunnerVC.swift
//  RunnerApp
//
//  Created by Steven Prescott on 10/2/15.
//  Copyright (c) 2015 Steven Prescott. All rights reserved.
//

import UIKit

class EditRunnerVC: UIViewController,JsonDelegete {
    
    @IBOutlet var firstNameTF : UITextField!
    @IBOutlet var LastNameTF : UITextField!
    @IBOutlet var heightTF : UITextField!
    @IBOutlet var weightTF : UITextField!
    @IBOutlet var ageTF : UITextField!
    var dataToSend = NSString()
    let jsonParsing = JsonParsing(nibName:"JsonParsing.swift", bundle: nil)
    var dataFetchingCase : Int = -1
    var _MoveUp: Bool = true
    @IBOutlet var msgLblShow : UILabel!
    var timer : NSTimer = NSTimer()
    
    
    @IBOutlet var saveChangesBtn : UIButton!
    var dataReceived:NSMutableDictionary = NSMutableDictionary()

    lazy private var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "loading")!
        return CustomActivityIndicatorView(image: image)
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Edit Runner"
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        firstNameTF.text = String(format: "%@", dataReceived.objectForKey("first_name") as! String)
        LastNameTF.text = String(format: "%@", dataReceived.objectForKey("last_name") as! String)
        heightTF.text = String(format: "%@", dataReceived.objectForKey("height") as! String)
        weightTF.text = String(format: "%@", dataReceived.objectForKey("weight") as! String)
        ageTF.text = String(format: "%d", dataReceived.objectForKey("age") as! Int)
        self.addLoadingIndicator(view)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveChangesBtnClicked(sender : AnyObject)
    {
        if firstNameTF.text == ""
        {
            msgLblShow.text = "Please enter first Name."
            self.errorLblShow()
            
        }
        else if LastNameTF.text == ""
        {
            msgLblShow.text = "Please enter last name"
            self.errorLblShow()
            
        }
        else if heightTF.text == ""
        {
            msgLblShow.text = "Please enter your height"
            self.errorLblShow()
        }
        else if weightTF.text == ""
        {
            msgLblShow.text = "Please enter your weight"
            self.errorLblShow()
        }
        else if ageTF.text == ""
        {
            msgLblShow.text = "Please enter your age"
            self.errorLblShow()
        }
        else{
            let data = NSMutableDictionary()
            data.setValue("not available", forKey: "userid")
            data.setValue("not available", forKey: "username")
            data.setValue("not available", forKey: "password")
            data.setValue("not available", forKey: "email")
            data.setValue(firstNameTF.text, forKey: "first_name")
            data.setValue(LastNameTF.text, forKey: "last_name")
            data.setValue(weightTF.text, forKey: "weight")
            data.setValue(heightTF.text, forKey: "height")
            data.setValue(ageTF.text, forKey: "age")
            data.setValue("not available", forKey: "dob")
            data.setValue("not available", forKey: "school")
            data.setValue("not available", forKey: "team")
            data.setValue("2", forKey: "role")
            data.setValue("not available", forKey: "coach_id")
            data.setValue("not available", forKey: "coach_name")
            
            dataToSend  = data.JSONRepresentation()
            print(dataReceived)
            let tempData : String = String(format:"id=%d?", dataReceived.objectForKey("id") as! Int)
            jsonParsing.loadData("POST", url: EditRunnerApi + tempData , isHeader: true,throughAccessToken : false,dataToSend : dataToSend as String,sendData : true)
            jsonParsing.jpdelegate = self
            dataFetchingCase = ApiResponseValue.EditRunnerApiCalled.rawValue
            activityIndicator.startAnimating()
            
        }
    }
    
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            
        }
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
    @IBAction func doneNumberPad(sender : AnyObject)
    {
        heightTF.resignFirstResponder()
        weightTF.resignFirstResponder()
        ageTF.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
      //  self.viewMoveUp(60.0)
        let toolbar:UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        toolbar.barStyle = UIBarStyle.BlackTranslucent
        let doneItem: UIBarButtonItem = UIBarButtonItem(title:"Done", style:UIBarButtonItemStyle.Plain, target: self, action: "doneNumberPad:")
        let array:NSArray = [doneItem]
        toolbar.items = array as! [UIBarButtonItem]
        toolbar.sizeToFit()
        if textField == weightTF || textField == heightTF || textField == ageTF {
            textField.inputAccessoryView = toolbar
        }
    }
    func textFieldDidEndEditing(textField: UITextField)
    {
        if textField == firstNameTF
        {
            firstNameTF.resignFirstResponder()
            LastNameTF.becomeFirstResponder()
            
        }
        else if textField == LastNameTF
        {
            LastNameTF.resignFirstResponder()
            heightTF.becomeFirstResponder()
            
        }
        else if textField == heightTF
        {
            heightTF.resignFirstResponder()
            weightTF.becomeFirstResponder()
            
        }
        else if textField == weightTF
        {
            weightTF.resignFirstResponder()
            ageTF.becomeFirstResponder()
            
        }
        else
        {
           // self.viewMoveDown(60.0)
            ageTF.resignFirstResponder()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataFound(){
        
        let isSuccess : Int = 1
        activityIndicator.stopAnimating()
        if (dataFetchingCase == ApiResponseValue.EditRunnerApiCalled.rawValue){
            if ((jsonParsing.fetchedJsonResult["success"] as! Int)  == isSuccess )
            {
                print("Save changes Done.")
            }
            else{
//                msgLblShow.text = "Your email or password is incorrect"
//                self.errorLblShow()
            }
            
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

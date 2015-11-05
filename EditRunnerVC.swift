/**
￼@class EditRunnerVC.swift
This file is used to Make change in the existing information of particular Runner.
Prescott | Neshagaran
@Copyright (c) 2015 Prescott | Neshagaran. All rights reserved.
*/

import UIKit

class EditRunnerVC: UIViewController,JsonDelegete {
    
    /** This is the UITextField Object which holds the information of the runner */
    @IBOutlet var firstNameTF : UITextField!
    @IBOutlet var LastNameTF : UITextField!
    @IBOutlet var heightTF : UITextField!
    @IBOutlet var weightTF : UITextField!
    @IBOutlet var ageTF : UITextField!
    @IBOutlet var schoolyearTF : UITextField!
    
    /** This is the UILabel Object which is used to show an alert message */
    @IBOutlet var msgLblShow : UILabel!

    
    @IBOutlet var saveChangesBtn : UIButton!
    var dataToSend = NSString()
    
     /** This is the Object of JsonParsing Class which is used to Call API. */
    let jsonParsing = JsonParsing(nibName:"JsonParsing.swift", bundle: nil)
    var dataFetchingCase : Int = -1
    
    var timer : NSTimer = NSTimer()
    
    /** This is Boolean flag to hold information that View in currently Up or Down.*/
    var _MoveUp: Bool = true
 
    /** This will hold the existing information of the runner.*/
    var dataReceived:NSMutableDictionary = NSMutableDictionary()

    /** This is the Object of "CustomActivityIndicatorView" Class to show custom Indicator View */
    lazy private var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "loading")!
        return CustomActivityIndicatorView(image: image)
        }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
            
        self.navigationItem.title = "Edit Runner"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        //Set Up the existing infromation of Runner on View.
        firstNameTF.text = String(format: "%@", dataReceived.objectForKey("first_name") as! String)
        LastNameTF.text = String(format: "%@", dataReceived.objectForKey("last_name") as! String)
        heightTF.text = String(format: "%@", dataReceived.objectForKey("height") as! String)
        weightTF.text = String(format: "%@", dataReceived.objectForKey("weight") as! String)
        ageTF.text = String(format: "%d", dataReceived.objectForKey("age") as! Int)
        schoolyearTF.text = String(format: "%d", dataReceived.objectForKey("age") as! Int)
        
        //Add Custom Indicator on View.
        self.addLoadingIndicator(view)
        
    }
    
    /** 
        @brief This method is used to send updated information to the server.
    */
    @IBAction func saveChangesBtnClicked(sender : AnyObject)
    {
            
        //Adding Constraint so that no field should be empty.
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
        else if schoolyearTF.text == ""
        {
            msgLblShow.text = "Please enter your school year"
            self.errorLblShow()
        }
        else{
            let data = NSMutableDictionary()      //Data to send along with API
            data.setValue("not available", forKey: "userid")
            data.setValue("not available", forKey: "username")
            data.setValue("not available", forKey: "password")
            data.setValue("not available", forKey: "email")
            data.setValue(firstNameTF.text, forKey: "first_name")
            data.setValue(LastNameTF.text, forKey: "last_name")
            data.setValue(weightTF.text, forKey: "weight")
            data.setValue(heightTF.text, forKey: "height")
            data.setValue(ageTF.text, forKey: "age")
            data.setValue(schoolyearTF.text, forKey: "schoolyear")
            data.setValue("0000-00-00 00:00:00", forKey: "dob")
            data.setValue("not available", forKey: "school")
            data.setValue("not available", forKey: "team")
            data.setValue("2", forKey: "role")
            data.setValue("not available", forKey: "coach_id")
            data.setValue("not available", forKey: "coach_name")
            
            dataToSend  = data.JSONRepresentation()  //Change data in Json Format
        
        //Call API to send updated information on the server.
            let tempData : String = String(format:"id=%d", dataReceived.objectForKey("id") as! Int)
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
    func addLoadingIndicator (tempView : UIView)   //To Add Custom Indicator on this View
    {
        tempView.addSubview(activityIndicator)
        activityIndicator.center = self.msgLblShow.center
        
    }
    
   /** This method is used to show any error alert on the screen */
    func errorLblShow()
    {
       
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {                         //Show message Label.
    
            self.msgLblShow.alpha = 1.0
            self.view.userInteractionEnabled = false
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector:"update", userInfo:nil, repeats: false)     //Start Timer to show alert for a specific time.
            }, completion: nil)
        
        
    }
    
  /** This method is called when timer completes and to hide the error label  */
    func update()
    {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {                       //Hides the message Label
            self.msgLblShow.alpha = 0.0
            self.timer.invalidate()
            self.view.userInteractionEnabled = true
            }, completion: nil)
    }
   /** This method is to hide the keyboard from View. */
    @IBAction func doneNumberPad(sender : AnyObject)
    {
        heightTF.resignFirstResponder()
        weightTF.resignFirstResponder()
        ageTF.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- UIView Animation Methods
    /** This method is used to Up the View when user press on any UITextField */
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
    /** This method is used to Down the View when user press on any UITextField */
    func viewMoveDown(value:CGFloat){
        if (!_MoveUp){
            UIView.animateWithDuration( 0.3 , animations:
                {   //Perform animation to lift view downSide
                    var f : CGRect  = self.view.bounds
                    f.origin.y -= value
                    self.view.bounds = f
            })
            
            _MoveUp = true
        }
    }
    
    
   //MARK:- UITextField Delegete Methods
    func textFieldDidBeginEditing(textField: UITextField)
    {
      //To add a Toolbar on NumberPad keyboard.
        let toolbar:UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        toolbar.barStyle = UIBarStyle.BlackTranslucent
        let doneItem: UIBarButtonItem = UIBarButtonItem(title:"Done", style:UIBarButtonItemStyle.Plain, target: self, action: "doneNumberPad:")
        let array:NSArray = [doneItem]
        toolbar.items = array as? [UIBarButtonItem]
        toolbar.sizeToFit()
        if textField == weightTF || textField == heightTF || textField == ageTF {
            textField.inputAccessoryView = toolbar
        }
    }
    
   /** This method is used to make the next UITextfield active when user press next on any UITextField. */
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
            ageTF.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
        
    }
 
    
     //MARK:- NSURLConnection Delegete Methods
    /** This is the Delegete Method of NSURLConnection Class,and gets called when we receive response of API */
    func dataFound(){
        
        let isSuccess : Int = 1
        activityIndicator.stopAnimating()
        if (dataFetchingCase == ApiResponseValue.EditRunnerApiCalled.rawValue){
            if ((jsonParsing.fetchedJsonResult["success"] as! Int)  == isSuccess ) //test if we get response successfully.
            {
                print("Save changes Done.")
            }
            else{
            
            }
            
        }
    }
    
   /** This is the Delegete Method of NSURLConnection Class,and get called when there is some problem in data receiving */
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

/**
￼@class SignUpFirst.swift
￼@brief This file is used to accept the information of the Coach.
@discussion User add Coach Name,User Name,Team Name,School Name of the Coach.
@author Prescott | Neshagaran
@Copyright (c) 2015 Prescott | Neshagaran. All rights reserved.
*/

import UIKit

class SignUpFirst: UIViewController {

    /* This is the UITextField Object which holds Email,Password and Confirm Password of Coach */
    @IBOutlet var coachNameTF : UITextField!
    @IBOutlet var UserNameTF : UITextField!
    @IBOutlet var teamTF : UITextField!
    @IBOutlet var schoolTF : UITextField!
    
    /** This is Boolean flag to hold information that View in currently Up or Down.*/
    var _MoveUp: Bool = true
    
    @IBOutlet var msgLblShow : UILabel!
    @IBOutlet var nextBtn : UIButton!
    var timer : NSTimer = NSTimer()
 
    /** This is NSMutableArray Object which hold information of Runner.*/
    var dataArray:NSMutableArray = NSMutableArray()
    
    lazy private var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "loading")!
        return CustomActivityIndicatorView(image: image)
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        //Add a Bottom Layer to UITextField
        self.addBottomLayer(coachNameTF)
        self.addBottomLayer(UserNameTF)
        self.addBottomLayer(teamTF)
        self.addBottomLayer(schoolTF)
        
        self.navigationItem.title = "Sign Up"
        
        msgLblShow.layer.masksToBounds = true
        msgLblShow.layer.cornerRadius = 4.0
        nextBtn.layer.cornerRadius = 4.0

    }
    func addLoadingIndicator (tempView : UIView)
    {
        tempView.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        
    }
    
    //MARK:- Add a bottom layer Method
    func addBottomLayer(textField: UITextField)
    {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, textField.frame.size.height - 1, textField.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0).CGColor
        textField.layer.addSublayer(bottomBorder)
    }
    
    //MARK:- Show Error Message Method
    /**
    @brief This method is used to show error message for some predefine time only.
    */
    func errorLblShow()
    {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.msgLblShow.alpha = 1.0
            self.view.userInteractionEnabled = false
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector:"update", userInfo:nil, repeats: false)
            }, completion: nil)
    }
    /**
    @brief This method is called when time of error message show completes .
    */
    func update()
    {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.msgLblShow.alpha = 0.0
            self.timer.invalidate()
            self.view.userInteractionEnabled = true
            }, completion: nil)
    }
    /**
    @brief This method is called to Pass Control to Next ViewController.
    */
    @IBAction func nextBtnClicked(sender : AnyObject)
    {
        //validate that no field should be empty
        if coachNameTF.text == ""
        {
            msgLblShow.text = "Please enter coach name."
            self.errorLblShow()
        }
        else if UserNameTF.text == ""
        {
            msgLblShow.text = "Please enter user name."
            self.errorLblShow()
        }
        else if teamTF.text == ""
        {
            msgLblShow.text = "Please enter team name"
            self.errorLblShow()
        }
        else if schoolTF.text == ""
        {
            msgLblShow.text = "Please enter school name"
            self.errorLblShow()
        }
        else
        {
            dataArray.removeAllObjects()
            let tempDict:NSMutableDictionary = NSMutableDictionary()  //Data to send along with API
            tempDict .setObject(coachNameTF.text!, forKey: "coachName")
            tempDict .setObject(UserNameTF.text!, forKey: "userName")
            tempDict .setObject(teamTF.text!, forKey: "teamName")
            tempDict .setObject(schoolTF.text!, forKey: "schoolName")
            
            dataArray .addObject(tempDict)
            
            let secondVC = self.storyboard?.instantiateViewControllerWithIdentifier("signUpSecond") as! SignUpSecond
            secondVC.receivedData = dataArray    //Send Data to Next View Controller
            self.navigationController?.pushViewController(secondVC, animated: true)
            
        }
    }
    
    //MARK:- UITextField Delegete Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField)
    {
        self.viewMoveUp(60.0)   //Move View to Up
    }
    func textFieldDidEndEditing(textField: UITextField)
    {
        if textField == coachNameTF
        {
            coachNameTF.resignFirstResponder()
            UserNameTF.becomeFirstResponder()
        }
        else if textField == UserNameTF
        {
            UserNameTF.resignFirstResponder()
            teamTF.becomeFirstResponder()
        }
        else if textField == teamTF
        {
            teamTF.resignFirstResponder()
            schoolTF.becomeFirstResponder()
        }
        else
        {
            self.viewMoveDown(60.0)  //Move View to Down
            schoolTF.resignFirstResponder()
        }
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
    //MARK:- Prepare For Segue Method
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "FirstToSecond") {
            let secondVC = segue.destinationViewController as! SignUpSecond
            secondVC.receivedData = dataArray
            print(secondVC.receivedData)
            self.navigationController?.pushViewController(secondVC, animated: true)
        }
       
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

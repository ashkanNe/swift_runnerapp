//
//  StartRun.swift
//  RunnerApp
//
//  Created by Steven Prescott on 9/26/15.
//  Copyright (c) 2015 Steven Prescott. All rights reserved.
//

import UIKit

class StartRun: UIViewController,JsonDelegete {

    @IBOutlet var milesTF : UITextField!
    @IBOutlet var feetTF : UITextField!
    @IBOutlet var runNameTF : UITextField!
    @IBOutlet var selectRunnerBtn : UIButton!
    @IBOutlet var weatherConditionBtn : UIButton!
    @IBOutlet var sunnyConditionBtn : UIButton!
    @IBOutlet var cloudyConditionBtn : UIButton!
    @IBOutlet var foggyConditionBtn : UIButton!
    @IBOutlet var msgLblShow : UILabel!
    var currentWeatherCondition:NSMutableString = "sunny"
    var allRunnerArray:NSMutableArray = NSMutableArray()
    var runDetailDict:NSMutableDictionary = NSMutableDictionary()
    

    var timer : NSTimer = NSTimer()
    let jsonParsing = JsonParsing(nibName:"JsonParsing.swift", bundle: nil)
    var dataToSend = NSString()
    var dataFetchingCase : Int = -1
    
    lazy private var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "loading")!
        return CustomActivityIndicatorView(image: image)
        }()


    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationItem.setHidesBackButton(false, animated: false)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.navigationItem.title = "Start Run"
        self.addBottomLayer(milesTF)
        self.addBottomLayer(feetTF)
        self.addBottomLayer(runNameTF)
        addLoadingIndicator(self.view)
        sunnyConditionBtn.layer.cornerRadius = 4.0
        cloudyConditionBtn.layer.cornerRadius = 4.0
        foggyConditionBtn.layer.cornerRadius = 4.0
        selectRunnerBtn.layer.cornerRadius = 4.0
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
    }
    func addBottomLayer(textField: UITextField)
    {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, textField.frame.size.height - 1, textField.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor.blackColor().CGColor
        textField.layer.addSublayer(bottomBorder)
    }
    func addLoadingIndicator (tempView : UIView)
    {
        tempView.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        
    }

    
    
    @IBAction func selectWeatherConditionBtnClicked(sender : AnyObject)
    {
        
        if (sender.tag == 1){
            sunnyConditionBtn.backgroundColor = UIColor(red: 33.0/255.0, green: 87.0/255.0, blue: 161.0/255.0, alpha: 1.0)
            foggyConditionBtn.backgroundColor = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
            cloudyConditionBtn.backgroundColor = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
            currentWeatherCondition.setString("sunny")
        }
        else if(sender.tag == 2){
            cloudyConditionBtn.backgroundColor = UIColor(red: 33.0/255.0, green: 87.0/255.0, blue: 161.0/255.0, alpha: 1.0)
            foggyConditionBtn.backgroundColor = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
            sunnyConditionBtn.backgroundColor = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
            currentWeatherCondition.setString("cloudy")
        }
        else{
            foggyConditionBtn.backgroundColor = UIColor(red: 33.0/255.0, green: 87.0/255.0, blue: 161.0/255.0, alpha: 1.0)
            cloudyConditionBtn.backgroundColor = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
            sunnyConditionBtn.backgroundColor = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
           currentWeatherCondition.setString("foggy")
        }
    }
    
    @IBAction func selectRunnerBtnClicked(sender : AnyObject)
    {
        if(runNameTF.text == "" )
        {
            msgLblShow.text = "Please enter run name."
            self.errorLblShow()
        }
        else if(milesTF.text == "")
        {
            msgLblShow.text = "Please enter run miles."
            self.errorLblShow()
            
        }
        else if(feetTF.text == "")
        {
            msgLblShow.text = "Please enter run feet."
            self.errorLblShow()
        }
        else{
            
            var runLength:NSMutableString = NSMutableString()
            runLength.setString(milesTF.text!)
            runLength.appendString("miles")
            runLength.appendString(feetTF.text!)
            runLength.appendString("feet")
            
            runDetailDict.setObject(runNameTF.text!, forKey: "runName")
            runDetailDict.setObject(runLength, forKey: "runLength")
            runDetailDict.setObject(currentWeatherCondition, forKey: "weatherCondition")
            
            jsonParsing.loadData("GET", url: RunnerListApi, isHeader: true,throughAccessToken : false,dataToSend : dataToSend as String,sendData : true)
            jsonParsing.jpdelegate = self
            dataFetchingCase = ApiResponseValue.RunnerListApiCalled.rawValue
            activityIndicator.startAnimating()
           
        }
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
    
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        let toolbar:UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        toolbar.barStyle = UIBarStyle.BlackTranslucent
        
        let doneItem: UIBarButtonItem = UIBarButtonItem(title:"Done", style:UIBarButtonItemStyle.Plain, target: self, action: "doneNumberPad:")
        
        let array:NSArray = [doneItem]
        toolbar.items = array as! [UIBarButtonItem]
        
        toolbar.sizeToFit()
        
        if textField == milesTF{
            milesTF.inputAccessoryView = toolbar
            
        }
        else
        {
            feetTF.inputAccessoryView = toolbar
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
        
    }
    
    @IBAction func doneNumberPad(sender : AnyObject)
    {
        milesTF.resignFirstResponder()
        feetTF.resignFirstResponder()
    }
    
    func dataFound(){
        var isSuccess : Int = 1
        activityIndicator.stopAnimating()
        if ((jsonParsing.fetchedJsonResult["success"] as! Int)  == isSuccess )
        {
            
            
          //  var allRunnerArray:NSMutableArray = NSMutableArray()
            var tempArray:NSArray = NSArray()
            tempArray = (jsonParsing.fetchedDataArray.objectAtIndex(0) as! NSArray)
            
            
            let predicate =  NSPredicate(format: "role == %@", "2" )
            
            let allRunnerArray = tempArray.filteredArrayUsingPredicate(predicate)
            print(allRunnerArray)
            var selectRunnerVC = self.storyboard?.instantiateViewControllerWithIdentifier("SelectRunner") as! SelectRunnerVC
            
            selectRunnerVC.tempRunDetail = runDetailDict
            
            
            selectRunnerVC.runnerListArray.addObjectsFromArray(allRunnerArray)
            self.navigationController?.pushViewController(selectRunnerVC, animated: true)
        }
        else{
            msgLblShow.text = "Your email or password is incorrect"
            self.errorLblShow()
        }
        
    }
    
    
    func connectionInterruption(){
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        
//        if(segue.identifier == "StartRun") {
//            
//            var startRun = (segue.destinationViewController as SelectRunnerVC)
//            startRun.runnerListArray = allRunnerArray
//    }
//}
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}

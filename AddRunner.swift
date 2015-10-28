//
//  AddRunner.swift
//  RunnerApp
//
//  Created by Steven Prescott on 9/27/15.
//  Copyright (c) 2015 Steven Prescott. All rights reserved.
//

import UIKit

class AddRunner: UIViewController,JsonDelegete,UIAlertViewDelegate {
    
    @IBOutlet var firstNameTF : UITextField!
    @IBOutlet var LastNameTF : UITextField!
    @IBOutlet var heightTF : UITextField!
    @IBOutlet var weightTF : UITextField!
    @IBOutlet var ageTF : UITextField!
    
    @IBOutlet var alertMsgLbl : UILabel!
    @IBOutlet var doneBtn : UIButton!
    
    @IBOutlet var addRemoveSegmant : UISegmentedControl!
    @IBOutlet var addRunnerView : UIView!
    @IBOutlet var removeRunnerView : UIView!
    
    @IBOutlet var allRunnerTblView : UITableView!
    var runnerListArray:NSMutableArray = NSMutableArray()
    var selectedRunnerDict:NSMutableDictionary = NSMutableDictionary()
    var selectedRunnerSet:NSMutableSet = NSMutableSet()
    var selectedSegmentOptn:Int = -1
    var dataToPass:NSMutableDictionary = NSMutableDictionary()
    var _MoveUp: Bool = true
    
    @IBOutlet var msgLblShow : UILabel!
    var timer : NSTimer = NSTimer()
    var dataToSend = NSString()
    let jsonParsing = JsonParsing(nibName:"JsonParsing.swift", bundle: nil)
    var dataFetchingCase : Int = -1
    
    
    lazy private var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "loading")!
        return CustomActivityIndicatorView(image: image)
        }()

    override func viewDidLoad() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.title = "Enrolled Runner"
        self.automaticallyAdjustsScrollViewInsets = false
        self.addBottomLayer(firstNameTF)
        self.addBottomLayer(LastNameTF)
        self.addBottomLayer(heightTF)
        self.addBottomLayer(weightTF)
        self.addBottomLayer(ageTF)
        doneBtn.layer.cornerRadius = 4.0
        self.addLoadingIndicator(view)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func addLoadingIndicator (tempView : UIView)
    {
        tempView.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        
    }
    override func viewWillAppear(animated: Bool) {
        
        jsonParsing.loadData("GET", url: RunnerListApi, isHeader: true,throughAccessToken : false,dataToSend : dataToSend as String,sendData : true)
        jsonParsing.jpdelegate = self
        dataFetchingCase = ApiResponseValue.InitializeRunnerScreen.rawValue
        activityIndicator.startAnimating()
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func segmentedBtnClicked(sender : AnyObject)
    {
        alertMsgLbl.hidden = false
        if sender.selectedSegmentIndex == 0
        {
            alertMsgLbl.text = "Fill information to add a Runner."
            addRunnerView.hidden = false
            removeRunnerView.hidden = true
            doneBtn.hidden = false
        }
        else if sender.selectedSegmentIndex == 1 {
            
            jsonParsing.loadData("GET", url: RunnerListApi, isHeader: true,throughAccessToken : false,dataToSend : dataToSend as String,sendData : true)
            jsonParsing.jpdelegate = self
            dataFetchingCase = ApiResponseValue.RunnerListApiCalled.rawValue
            activityIndicator.startAnimating()
            alertMsgLbl.text = "Select Runner to remove."
            addRunnerView.hidden = true
            removeRunnerView.hidden = true
            doneBtn.hidden = true
            selectedSegmentOptn = 0
            
        }
        else{
            
            jsonParsing.loadData("GET", url: RunnerListApi, isHeader: true,throughAccessToken : false,dataToSend : dataToSend as String,sendData : true)
            jsonParsing.jpdelegate = self
            dataFetchingCase = ApiResponseValue.RunnerListApiCalled.rawValue
            activityIndicator.startAnimating()
            alertMsgLbl.text = "Select Any Runner to Edit."
            addRunnerView.hidden = true
            removeRunnerView.hidden = true
            doneBtn.hidden = true
            selectedSegmentOptn = 1
        }
        
    }
    func addBottomLayer(textField: UITextField)
    {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, textField.frame.size.height - 1, textField.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor.blackColor().CGColor
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
    
    
    @IBAction func doneBtnClicked(sender : AnyObject)
    {
        if firstNameTF.text == ""
        {
            msgLblShow.text = "Please enter first name."
            self.errorLblShow()
            
        }
        else if LastNameTF.text == ""
        {
            msgLblShow.text = "Please enter last name."
            self.errorLblShow()
            
        }
        else if heightTF.text == ""
        {
            msgLblShow.text = "Please enter height"
            self.errorLblShow()
            
        }
        else if weightTF.text == ""
        {
            msgLblShow.text = "Please enter weight"
            self.errorLblShow()
        }
        else if weightTF.text == ""
        {
            msgLblShow.text = "Please enter age"
            self.errorLblShow()
        }
        else
        {
            let firstIndex = firstNameTF.text!.startIndex
          //  let firstChar =   firstNameTF.text[firstIndex]
          //  let secondChar = LastNameTF.text[firstIndex]
            var data = NSMutableDictionary()
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
           // data.setValue(firstChar + secondChar, forKey: "intials")
            data.setValue("N.A", forKey: "intials")
            
            
            dataToSend  = data.JSONRepresentation()
            
            jsonParsing.loadData("POST", url: SignUpApi, isHeader: true,throughAccessToken : false,dataToSend : dataToSend as String,sendData : true)
            jsonParsing.jpdelegate = self
            dataFetchingCase = ApiResponseValue.AddRunnerApiCalled.rawValue
            activityIndicator.startAnimating()
            
           // let seconVC:UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("signUpSecond")! as UIViewController
            
          //  self.navigationController?.pushViewController(seconVC, animated: true)
            
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)  -> Int
    {
        return runnerListArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
         let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.frame = CGRectMake(0.0, 100.0, tableView.frame.size.width, 44.0);
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, cell.frame.size.height - 1, cell.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0).CGColor
        cell.layer.addSublayer(bottomBorder)
        cell.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        cell.textLabel?.textColor = UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0)
        
        if (runnerListArray.count > 0){
           cell.textLabel?.text = String(format: "%@", runnerListArray.objectAtIndex(indexPath.row).valueForKey("first_name") as! String )
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    func  tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        selectedRunnerDict.removeAllObjects()
        selectedRunnerDict.addEntriesFromDictionary(runnerListArray.objectAtIndex(indexPath.row) as! NSDictionary as [NSObject : AnyObject])
        
        if(selectedSegmentOptn == 0){
        let cell:UITableViewCell = tableView .cellForRowAtIndexPath(indexPath)!
            
            var removeRunnerAlert: UIAlertView = UIAlertView()
            
            removeRunnerAlert.delegate = self
            
            removeRunnerAlert.title = "Alert"
            removeRunnerAlert.message = "Do you want to remove runner!"
            removeRunnerAlert.addButtonWithTitle("Ok")
            removeRunnerAlert.addButtonWithTitle("Cancel")
            
            removeRunnerAlert.show()
            
//        if selectedRunnerSet .containsObject(indexPath.row){
//            selectedRunnerSet.removeObject(indexPath.row)
//             cell.accessoryType = UITableViewCellAccessoryType.None
//        }
//        else{
//           selectedRunnerSet.addObject(indexPath.row)
//             cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//        }
            
            
            
       
        }
        else if(selectedSegmentOptn == 1){
            //Edit
           
            var editVC = self.storyboard?.instantiateViewControllerWithIdentifier("EditVC") as! EditRunnerVC
            editVC.dataReceived = selectedRunnerDict
            self.navigationController?.pushViewController(editVC, animated: true)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let destinationVC = segue.destinationViewController as! EditRunnerVC
        destinationVC.dataReceived = dataToPass
    }
    func alertView(View: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
       switch buttonIndex{
        case 1:
            break;
        case 0:
            let data : String = String(format:"id=%d?", selectedRunnerDict.objectForKey("id") as! Int)
            jsonParsing.loadData("POST", url: RemoveRunnerApi + data, isHeader: true,throughAccessToken : false,dataToSend : dataToSend as String,sendData : true)
            jsonParsing.jpdelegate = self
            dataFetchingCase = ApiResponseValue.RemoveRunnerApiCalled.rawValue
            activityIndicator.startAnimating()
            break;
        default:
            NSLog("Default");
            break;
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        self.viewMoveUp(90.0)
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
    @IBAction func doneNumberPad(sender : AnyObject)
    {
        heightTF.resignFirstResponder()
        weightTF.resignFirstResponder()
        ageTF.resignFirstResponder()
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
        else{
            ageTF.resignFirstResponder()
            self.viewMoveDown(90.0)
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
        let isSuccess : Int = 1
        activityIndicator.stopAnimating()
        
        if(dataFetchingCase == ApiResponseValue.RunnerListApiCalled.rawValue)
        {
            if ((jsonParsing.fetchedJsonResult["success"] as! Int)  == isSuccess )
            {
                runnerListArray.removeAllObjects()
                var tempArray:NSArray = NSArray()
                tempArray = (jsonParsing.fetchedDataArray.objectAtIndex(0) as! NSArray)
                let predicate =  NSPredicate(format: "role == %@", "2" )
                runnerListArray.addObjectsFromArray(tempArray.filteredArrayUsingPredicate(predicate))
                removeRunnerView.hidden = false
                allRunnerTblView.reloadData()
            }
        }
        else if(dataFetchingCase == ApiResponseValue.AddRunnerApiCalled.rawValue)
        {
            if ((jsonParsing.fetchedJsonResult["success"] as! Int)  == isSuccess )
            {
                firstNameTF.text = ""
                LastNameTF.text = ""
                heightTF.text = ""
                weightTF.text = ""
                ageTF.text = ""
                msgLblShow.text = "Runner Added Successfully."
                self.errorLblShow()
            }
            else{
                msgLblShow.text = "Your email or password is incorrect"
                self.errorLblShow()
            }
        }
        else if(dataFetchingCase == ApiResponseValue.RemoveRunnerApiCalled.rawValue)
        {
            if ((jsonParsing.fetchedJsonResult["success"] as! Int)  == isSuccess )
            {
                jsonParsing.loadData("GET", url: RunnerListApi, isHeader: true,throughAccessToken : false,dataToSend : dataToSend as String,sendData : true)
                jsonParsing.jpdelegate = self
                dataFetchingCase = ApiResponseValue.RunnerListApiCalled.rawValue
                activityIndicator.startAnimating()
            }
        }
       else if(dataFetchingCase == ApiResponseValue.InitializeRunnerScreen.rawValue)
        {
            if ((jsonParsing.fetchedJsonResult["success"] as! Int)  == isSuccess )
            {
                runnerListArray.removeAllObjects()
                var tempArray:NSArray = NSArray()
                tempArray = (jsonParsing.fetchedDataArray.objectAtIndex(0) as! NSArray)
                let predicate =  NSPredicate(format: "role == %@", "2" )
                runnerListArray.addObjectsFromArray(tempArray.filteredArrayUsingPredicate(predicate))
               // removeRunnerView.hidden = false
                allRunnerTblView.reloadData()
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

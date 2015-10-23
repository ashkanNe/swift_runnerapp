//
//  RunLapVC.swift
//  RunnerApp
//
//  Created by Tarun Sachdeva on 9/27/15.
//  Copyright (c) 2015 Tarun Sachdeva. All rights reserved.
//

import UIKit

class RunLapVC: UIViewController,JsonDelegete {
    
    
    var runnerListArray: NSMutableArray = NSMutableArray()
    var runDetailDict: NSMutableDictionary = NSMutableDictionary()
    @IBOutlet var runStartTblView : UITableView!
    @IBOutlet var hoursLbl : UILabel!
    @IBOutlet var minuteLbl : UILabel!
    @IBOutlet var secondsLbl : UILabel!
    @IBOutlet var tapToRun : UIButton!
    @IBOutlet var saveRecordBtn : UIButton!
    
    let jsonParsing = JsonParsing(nibName:"JsonParsing.swift", bundle: nil)
    var dataToSend = NSString()
    var dataFetchingCase : Int = -1
    
    var runClearedCount : Int = 0
    
    var runnersArray:NSMutableArray = NSMutableArray()
    
    var runTimer : NSTimer = NSTimer()
    var count:Int = 1
    var seconds:Int = 1
    var minutes:Int = 0
    var hours:Int = 0
    
    
    var timer:CADisplayLink = CADisplayLink()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        runStartTblView.userInteractionEnabled = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "Start Run"
        
        tapToRun.layer.cornerRadius = 4.0
        saveRecordBtn.layer.cornerRadius = 4.0
        self.addLoadingIndicator(view)
        // Do any additional setup after loading the view.
    }
    
    lazy private var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "loading")!
        return CustomActivityIndicatorView(image: image)
        }()
    func addLoadingIndicator (tempView : UIView)
    {
        tempView.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        
    }
    
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)  -> Int
    {
        return runnerListArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:RunLapCell = tableView.dequeueReusableCellWithIdentifier("RunCell") as! RunLapCell
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, cell.frame.size.height - 1, cell.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0).CGColor
        cell.layer.addSublayer(bottomBorder)
        cell.backgroundColor = UIColor(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        cell.textLabel?.textColor = UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.runnerId.setString(String(format: "%d", runnerListArray.objectAtIndex(indexPath.row).valueForKey("id") as! Int))
        
        cell.nameLbl.text = String(format: "%@", runnerListArray.objectAtIndex(indexPath.row).valueForKey("first_name") as! String )
      //  cell.runnerId = runnerListArray.objectAtIndex(indexPath.row) as? String
        return cell
    }
    @IBAction func startRunClicked(sender : AnyObject)
    {
       runStartTblView.userInteractionEnabled = true
       secondsLbl.text = String(format: "%@", "01")
       runTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:"update", userInfo:nil, repeats: true)
       NSRunLoop.currentRunLoop().addTimer(runTimer, forMode: NSRunLoopCommonModes)
        
    }
    @IBAction func saveRecordClicked(sender : AnyObject)
    {
        let data = NSMutableDictionary()
        let runDetail = NSMutableDictionary()
        var runnersDetail = NSMutableDictionary()
        let tempRunnersArray:NSMutableArray = NSMutableArray()
        
//            data.setValue("not available", forKey: "coach_id")
//            data.setValue("not available", forKey: "userid")
//            data.setValue(receivedData.objectAtIndex(0).valueForKey("userName") , forKey: "username")
//            data.setValue(passWdTF.text, forKey: "password")
//            data.setValue(emailTF.text, forKey: "email")
//            data.setValue("not available", forKey: "first_name")
//            data.setValue("not available", forKey: "last_name")
//            data.setValue("not available", forKey: "weight")
//            data.setValue("not available", forKey: "height")
//            data.setValue("not available", forKey: "age")
//            data.setValue("not available", forKey: "dob")
//            data.setValue(receivedData.objectAtIndex(0).valueForKey("schoolName"), forKey: "school")
//            data.setValue(receivedData.objectAtIndex(0).valueForKey("teamName"), forKey: "team")
//            data.setValue(receivedData.objectAtIndex(0).valueForKey("coachName"), forKey: "coach_name")
//            data.setValue("1", forKey: "role")
//            dataToSend  = data.JSONRepresentation()
        
        
//            {
//                
//                "run":{
//                    "run_id":11,
//                    "name":"first",
//                    "length":"2 meter",
//                    "weather":"cool",
//                    "coach_id":"1"
//                },
//                "runners": [
//                {
//                "run_id":"1",
//                "runner_id":"1",
//                "time":"30sec"
//                },
//                {
//                "run_id":"1",
//                "runner_id":"12",
//                "time":"30sec"
//                }
//                ]
//                
//        }
        
        let coach_id: String! = NSUserDefaults.standardUserDefaults().valueForKey("coach_id") as! String
        runDetail.setValue("not available", forKey: "run_id")
        runDetail.setValue(runDetailDict.valueForKey("runName"), forKey: "name")
        runDetail.setValue(runDetailDict.valueForKey("runLength"), forKey: "length")
        runDetail.setValue(runDetailDict.valueForKey("weatherCondition"), forKey: "weather")
        runDetail.setValue(coach_id, forKey: "coach_id")
        
        for (var i = 0 ; i < runnerListArray.count ; i++ )
        {
            let cell = tableView(runStartTblView, cellForRowAtIndexPath: NSIndexPath(forRow: i, inSection: 0)) as! RunLapCell
            let runnnerDetail = NSMutableDictionary()
            runnnerDetail.setValue("not available", forKey: "run_id")
            runnnerDetail.setValue(cell.runnerId, forKey: "runner_id")
            runnnerDetail.setValue(cell.timeLbl.text, forKey: "time")
            tempRunnersArray.addObject(runnnerDetail)
        }
        data.setValue(tempRunnersArray, forKey: "run")
        data.setValue(runDetail, forKey: "runners")
        dataToSend  = data.JSONRepresentation()
        jsonParsing.loadData("POST", url:AddRunApi , isHeader: true,throughAccessToken : false,dataToSend : dataToSend as String,sendData : true)
        jsonParsing.jpdelegate = self
        dataFetchingCase = ApiResponseValue.AddRunApiCalled.rawValue
        activityIndicator.startAnimating()
        
    }
    
    func update()
    {
        count++
        seconds++
        if seconds < 60{
            if (seconds <= 9) {
                secondsLbl.text = String(format: "%@%d", "0",seconds)
            }
            else{
               secondsLbl.text = String(format: "%d", seconds)
            }
        }
        else {
            seconds = 0
            secondsLbl.text = String(format: "%@", "00")
        }
        
        minutes = count / 60
        hours = count / 3600
        
        if (minutes <= 9) {
            minuteLbl.text = String(format: "%@%d", "0",minutes)
        }
        else{
            minuteLbl.text = String(format: "%d", minutes)
        }
        
        if (hours <= 9) {
            hoursLbl.text = String(format: "%@%d", "0",hours)
        }
        else{
            hoursLbl.text = String(format: "%d", hours)
        }
    }
    
    func  tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        runClearedCount++
        let cell:RunLapCell = tableView.cellForRowAtIndexPath(indexPath)! as! RunLapCell
        let timeString:NSMutableString = NSMutableString()
        timeString.setString(hoursLbl.text!)
        timeString.appendString(":")
        timeString.appendString(minuteLbl.text!)
        timeString.appendString(":")
        timeString.appendString(secondsLbl.text!)
        
        cell.timeLbl.text = timeString as String
        cell.timeLbl.hidden = false
        
        cell.userInteractionEnabled = false
        
        if runClearedCount == runnerListArray.count {
           saveRecordBtn.userInteractionEnabled = true
            runTimer.invalidate()
        }
        
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationTransition(UIViewAnimationTransition.CurlUp, forView: cell as UITableViewCell, cache: true)
       
//        UIView.setAnimationDuration(0.7)
//        UIView.commitAnimations()
    }
    
    func dataFound(){
        
        var isSuccess : Int = 1
        activityIndicator.stopAnimating()
        if (dataFetchingCase == ApiResponseValue.AddRunApiCalled.rawValue){
            if ((jsonParsing.fetchedJsonResult["success"] as! Int)  == isSuccess )
            {
                var access_token: NSString? = jsonParsing.fetchedDataArray.objectAtIndex(0)["access_token"] as? String
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
              //  msgLblShow.text = "Your email or password is incorrect"
              //  self.errorLblShow()
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

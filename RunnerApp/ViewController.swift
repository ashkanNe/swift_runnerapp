//
//  ViewController.swift
//  RunnerApp
//
//  Created by Tarun Sachdeva on 9/17/15.
//  Copyright (c) 2015 Tarun Sachdeva. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,JsonDelegete {
    
    @IBOutlet var sideView : UIView!
    @IBOutlet var mainView : UIView!
    @IBOutlet var sideTblView : UITableView!
    @IBOutlet var startSessionBtn : UIButton!
    @IBOutlet var enrolledRunnerBtn : UIButton!
    @IBOutlet var runnerStatsBtn : UIButton!
    var dataToSend = NSString()
    let jsonParsing = JsonParsing(nibName:"JsonParsing.swift", bundle: nil)
    var dataFetchingCase : Int = -1
    @IBOutlet var msgLblShow : UILabel!
    var timer : NSTimer = NSTimer()
    var allRunnerArray:NSMutableArray = NSMutableArray()
    var runStatArray:NSMutableArray = NSMutableArray()
   
    var sideTblArray:NSMutableArray = NSMutableArray()
    
    lazy private var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "loading")!
        return CustomActivityIndicatorView(image: image)
        }()
    
    
    override func viewDidLoad() {
        
        sideTblArray .addObject("Sign In")
        sideTblArray.addObject("Sign Out")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.addLoadingIndicator(view)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //self.navigationItem.leftBarButtonItem = nil
        
        super.viewWillAppear(animated);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func addLoadingIndicator (tempView : UIView)
    {
         tempView.addSubview(activityIndicator)
         activityIndicator.center = self.view.center
    }
    
// MARK
// MARK: SideViewMethod
    @IBAction func sideBtnClicked(sender : AnyObject)
    {
        
        if(sideView.frame.origin.x == -200){
            sideTblView .reloadData()
            mainView.alpha = 5.0
            UIView.animateWithDuration( 0.3 , animations:
                {   //Perform animation to lift view upside
                    self.sideView.frame.origin.x = 0
                })
        }
        else{
            mainView.alpha = 1.0
            UIView.animateWithDuration( 0.3 , animations:
                {   //Perform animation to lift view upside
                    
                    self.sideView.frame.origin.x = -200
                    
            })
        }
       
    }
    // MARK
    // MARK: SideViewMethod
    @IBAction func startSessionBtnClicked(sender : AnyObject)
    {
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        let startSessionVC:UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StartRun") as UIViewController!
        
        self.navigationController?.pushViewController(startSessionVC, animated: true)
        
        
        
    }
    @IBAction func logoutBtnClicked(sender : AnyObject)
    {
        NSUserDefaults.standardUserDefaults().setValue("true", forKey: "logout")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        
        self.navigationController?.popToRootViewControllerAnimated(true)
//        let homeVC:UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeScreen")! as UIViewController
//        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    @IBAction func enrolledRunnerBtnClicked(sender : AnyObject)
    {
        jsonParsing.loadData("GET", url: RunnerListApi, isHeader: true,throughAccessToken : false,dataToSend : dataToSend as String,sendData : true)
        jsonParsing.jpdelegate = self
        dataFetchingCase = ApiResponseValue.RunnerListApiCalled.rawValue
        activityIndicator.startAnimating()
    }
    @IBAction func statBtnClicked(sender : AnyObject)
    {
        jsonParsing.loadData("GET", url: RunStatApi, isHeader: true,throughAccessToken : false,dataToSend : dataToSend as String,sendData : false)
        jsonParsing.jpdelegate = self
        dataFetchingCase = ApiResponseValue.RunnerStatApiCalled.rawValue
        activityIndicator.startAnimating()
        
        
        
       
    }
    
// MARK
// MARK: UITableViewDelegateMethods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)  -> Int
   {
    if (tableView == sideTblView) {
            return sideTblArray.count
        }
        return 0
    
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        if tableView == sideTblView
        {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        //cell.textLabel!.textColor = UIColor(red: 31.0/255.0, green: 147.0/255.0, blue: 202.0/255.0, alpha: 1.0)
        cell.textLabel!.textColor = UIColor.blackColor()
        cell.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
            
        cell.textLabel!.minimumScaleFactor = 0.01
        cell.textLabel!.adjustsFontSizeToFitWidth = true
        print(sideTblArray, terminator: "")
        cell.textLabel!.text = sideTblArray.objectAtIndex(indexPath.row) as? String
        return cell
        }

      return cell
    }
    func dataFound(){
        var isSuccess : Int = 1
        activityIndicator.stopAnimating()
        
        if(dataFetchingCase == ApiResponseValue.RunnerListApiCalled.rawValue)
        {
            if ((jsonParsing.fetchedJsonResult["success"] as! Int)  == isSuccess )
            {
               self.navigationItem.setHidesBackButton(false, animated: false) 
                var tempArray:NSArray = NSArray()
                tempArray = (jsonParsing.fetchedDataArray.objectAtIndex(0) as! NSArray)
                let predicate =  NSPredicate(format: "role == %@", "2" )
                
                let allRunnerArray = tempArray.filteredArrayUsingPredicate(predicate)
            
                var detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailVC") as! DetailViewController
                detailVC.memberDetailArray.addObjectsFromArray(allRunnerArray)
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            else{
               // msgLblShow.text = ""
               // self.errorLblShow()
            }
        }
        else  if(dataFetchingCase == ApiResponseValue.RunnerStatApiCalled.rawValue)
        {
            if ((jsonParsing.fetchedJsonResult["success"] as! Int)  == isSuccess )
            {
                var runStatVC = self.storyboard?.instantiateViewControllerWithIdentifier("RunnerStats") as! RunnerStatsVC
                runStatVC.runnnerStatArray.addObjectsFromArray(jsonParsing.fetchedDataArray.objectAtIndex(0) as! NSArray as [AnyObject])
                self.navigationController?.pushViewController(runStatVC, animated: true)
            }
        }
    }
    func connectionInterruption(){
        
    }

}


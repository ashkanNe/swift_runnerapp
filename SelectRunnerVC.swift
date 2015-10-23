//
//  SelectRunnerVC.swift
//  RunnerApp
//
//  Created by Tarun Sachdeva on 9/26/15.
//  Copyright (c) 2015 Tarun Sachdeva. All rights reserved.
//

import UIKit



class SelectRunnerVC: UIViewController,UITableViewDelegate,UITableViewDataSource,JsonDelegete {

    @IBOutlet var runnerListTblView: UITableView!
    var runnerListArray:NSMutableArray = NSMutableArray()
    var selectedRunnerSet:NSMutableSet = NSMutableSet()
    @IBOutlet var msgLblShow : UILabel!
    var timer : NSTimer = NSTimer()
    let jsonParsing = JsonParsing(nibName:"JsonParsing.swift", bundle: nil)
    var dataToSend = NSString()
    var dataFetchingCase : Int = -1
    var selectedRunnersArray:NSMutableArray = NSMutableArray()
    var tempRunDetail:NSMutableDictionary = NSMutableDictionary()
    
  
    
    lazy private var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "loading")!
        return CustomActivityIndicatorView(image: image)
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.title = "Select Runner"
        self.automaticallyAdjustsScrollViewInsets = false
        msgLblShow.layer.masksToBounds = true
        msgLblShow.layer.cornerRadius = 4.0
        
        var heightTV:  Int = 44 * (runnerListArray.count)
//        runnerListTblView.frame.size.height = CGFloat(heightTV) as CGFloat
        // Do any additional setup after loading the view.
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
    @IBAction func startSessionBtnClicked(sender : AnyObject)
    {
        if (selectedRunnerSet.count <= 0)
        {
            msgLblShow.text = "Please select any runner first."
            self.errorLblShow()
        }
        else{
            
//            let startRunVC:UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TimeLapStart")! as UIViewController
//            
//            
//            
//            self.navigationController?.pushViewController(startRunVC, animated: true)
            
            var runVC = self.storyboard?.instantiateViewControllerWithIdentifier("TimeLapStart") as! RunLapVC
            runVC.runnerListArray = selectedRunnersArray
            runVC.runDetailDict = tempRunDetail
            self.navigationController?.pushViewController(runVC, animated: true)
            
            
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
        bottomBorder.backgroundColor = UIColor(red: 97.0/255.0, green: 97.0/255.0, blue: 97.0/255.0, alpha: 1.0).CGColor
        cell.layer.addSublayer(bottomBorder)
        cell.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        cell.textLabel?.textColor = UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.text = String(format: "%@", runnerListArray.objectAtIndex(indexPath.row).valueForKey("first_name") as! String )

        return cell
    }
    func  tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell:UITableViewCell = tableView .cellForRowAtIndexPath(indexPath)!
        
        if selectedRunnerSet .containsObject(indexPath.row){
            selectedRunnerSet.removeObject(indexPath.row)
            cell.accessoryType = UITableViewCellAccessoryType.None
             selectedRunnersArray.removeObject(runnerListArray.objectAtIndex(indexPath.row))
        
        }
        else{
            selectedRunnerSet.addObject(indexPath.row)
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedRunnersArray.addObject(runnerListArray.objectAtIndex(indexPath.row))
        }
        print(selectedRunnersArray)
    }
    
    
    func dataFound(){
        var isSuccess : Int = 1
        activityIndicator.stopAnimating()
        if ((jsonParsing.fetchedJsonResult["success"] as! Int)  == isSuccess )
        {
            
           // runnerListArray.addObjectsFromArray()
            
            let startRunVC:UIViewController? = (self.storyboard?.instantiateViewControllerWithIdentifier("TimeLapStart") as UIViewController!)
            self.navigationController?.pushViewController(startRunVC!, animated: true)
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

//
//  DetailViewController.swift
//  RunnerApp
//
//  Created by Vikas on 22/09/15.
//  Copyright (c) 2015 Steven Prescott. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,JsonDelegete {
    
     @IBOutlet var memberDetailTblView : UITableView!
     @IBOutlet var addRunnerBtn : UIButton!
     var memberDetailArray:NSMutableArray = NSMutableArray()
    var dataToSend = NSString()
    let jsonParsing = JsonParsing(nibName:"JsonParsing.swift", bundle: nil)
    var dataFetchingCase : Int = -1
    
    
    lazy private var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "loading")!
        return CustomActivityIndicatorView(image: image)
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Team Members"
        self.addLoadingIndicator(view)
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.automaticallyAdjustsScrollViewInsets = false
        memberDetailTblView.reloadData()
    }

    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            var memberDetailArray:NSMutableArray = NSMutableArray()
        }
    }
    override func viewWillAppear(animated: Bool) {
        
        jsonParsing.loadData("GET", url: RunnerListApi, isHeader: true,throughAccessToken : false,dataToSend : dataToSend as String,sendData : true)
        jsonParsing.jpdelegate = self
        dataFetchingCase = ApiResponseValue.RunnerListApiCalled.rawValue
        activityIndicator.startAnimating()
        super.viewWillAppear(animated)
    }
    func addLoadingIndicator (tempView : UIView)
    {
        tempView.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addRunnerBtnClicked(sender : AnyObject)
    {
        let addRunnerVC:UIViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("AddRunner") as UIViewController!)
        self.navigationController?.pushViewController(addRunnerVC, animated: true)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)  -> Int
    {
         return memberDetailArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:MemberDetailCell = tableView.dequeueReusableCellWithIdentifier("MemberDetailCell") as! MemberDetailCell
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, cell.frame.size.height - 1, cell.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0).CGColor
        cell.layer.addSublayer(bottomBorder)
        cell.backgroundColor = UIColor(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        cell.textLabel?.textColor = UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.nameLbl?.text = memberDetailArray.objectAtIndex(indexPath.row).valueForKey("first_name") as? String
        cell.aliasLbl?.text = memberDetailArray.objectAtIndex(indexPath.row).valueForKey("intials") as? String
        return cell
    }
    func dataFound()
    {
        let isSuccess : Int = 1
        activityIndicator.stopAnimating()
        
        if(dataFetchingCase == ApiResponseValue.RunnerListApiCalled.rawValue)
        {
            if ((jsonParsing.fetchedJsonResult["success"] as! Int)  == isSuccess )
            {
                memberDetailArray.removeAllObjects()
                var tempArray:NSArray = NSArray()
                tempArray = (jsonParsing.fetchedDataArray.objectAtIndex(0) as! NSArray)
                let predicate =  NSPredicate(format: "role == %@", "2" )
                memberDetailArray.addObjectsFromArray(tempArray.filteredArrayUsingPredicate(predicate))
                
                memberDetailTblView.reloadData()
            }
        }
        
    }
    func connectionInterruption(){
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

/**
￼@class RunnerStatsVC.swift
￼@brief This file is used to show statstics of the Runners.
@discussion We get all the data from API and then show the data on UICollectionView.
@author Prescott | Neshagaran
@Copyright (c) 2015 Prescott | Neshagaran. All rights reserved.
*/

import UIKit

class RunnerStatsVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    /** This is the UICollectionView Object which used to display information of Run */
    @IBOutlet var runnerStatCV : UICollectionView!
    
    /** This is the NSMutableArray Object which holds the information of different Run */
    var runnnerStatArray:NSMutableArray = NSMutableArray()
    var tempRunnnerArray:NSMutableArray = NSMutableArray()
    
    /** This is the UILabel Object which used to display TotalTime and AverageTime */
    @IBOutlet var totalTimeLbl : UILabel!
    @IBOutlet var averageTimeLbl : UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Run Stats"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        
        if runnnerStatArray.count > 0 { //Get the actual details of Runner after Parse from Receiving Array.
        tempRunnnerArray.addObjectsFromArray(runnnerStatArray.objectAtIndex(0).objectForKey("runners") as! NSArray as [AnyObject])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- UICollectionView Delegete Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempRunnnerArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StatCell", forIndexPath: indexPath) as! RunnerStatsCell
       //Show Data on UILabes of UICollectionView Cell Object
        cell.timeRunLbl.text = String(format: "Time:%@",tempRunnnerArray.objectAtIndex(indexPath.row).valueForKey("lap_time") as! String)
        cell.lapLbl.text = String(format: "Lap:%@",tempRunnnerArray.objectAtIndex(indexPath.row).valueForKey("laps") as! String)
        cell.nameLbl.text = String(format: "%@",tempRunnnerArray.objectAtIndex(indexPath.row).valueForKey("first_name") as! String)
        
        return cell
    }
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let kWhateverHeightYouWant:CGFloat = 150.0
            return CGSizeMake(collectionView.bounds.size.width/3, kWhateverHeightYouWant)
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

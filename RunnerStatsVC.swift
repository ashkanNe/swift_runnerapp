//
//  RunnerStatsVC.swift
//  RunnerApp
//
//  Created by Tarun Sachdeva on 10/2/15.
//  Copyright (c) 2015 Tarun Sachdeva. All rights reserved.
//

import UIKit

class RunnerStatsVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet var runnerStatCV : UICollectionView!
    var runnnerStatArray:NSMutableArray = NSMutableArray()
    var tempRunnnerArray:NSMutableArray = NSMutableArray()
    @IBOutlet var totalTimeLbl : UILabel!
    @IBOutlet var averageTimeLbl : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Run Stats"
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        print(runnnerStatArray)
        if runnnerStatArray.count > 0 {
        tempRunnnerArray.addObjectsFromArray(runnnerStatArray.objectAtIndex(0).objectForKey("runners") as! NSArray as [AnyObject])
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempRunnnerArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StatCell", forIndexPath: indexPath) as! RunnerStatsCell
       
cell.timeLbl.text = String(format: "Time:%@",tempRunnnerArray.objectAtIndex(indexPath.row).valueForKey("lap_time") as! String)
cell.lapLbl.text = String(format: "Lap:%@",tempRunnnerArray.objectAtIndex(indexPath.row).valueForKey("laps") as! String)
cell.nameLbl.text = String(format: "%@",tempRunnnerArray.objectAtIndex(indexPath.row).valueForKey("first_name") as! String)
        
       // cell.backgroundColor = UIColor.orangeColor()
        return cell
    }
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let kWhateverHeightYouWant:CGFloat = 195.0
            return CGSizeMake(collectionView.bounds.size.width/2, kWhateverHeightYouWant)
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

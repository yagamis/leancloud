//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by xiaobo on 15/12/15.
//  Copyright © 2015年 xiaobo. All rights reserved.
//

import UIKit

class DiscoverTableViewController: UITableViewController {
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var restaurants:[AVObject] = []
    var imgCache = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        getRecordFromCloud()
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        refreshControl?.tintColor = UIColor.grayColor()
        refreshControl?.addTarget(self, action: "getNewData", forControlEvents: .ValueChanged)
        
    }
    
    func getNewData() {
        getRecordFromCloud(true)
    }

    
    func getRecordFromCloud(needNew :Bool = false) {
        let query = AVQuery(className: "Restaurant")
        
        if needNew {
            query.cachePolicy = .IgnoreCache
        } else {
            query.cachePolicy = .CacheElseNetwork
            query.maxCacheAge = 60 * 2
            query.orderByDescending("createdAt")
        }
        
        if query.hasCachedResult() {
            print("从缓存中获取结果！")
        }
        
        query.findObjectsInBackgroundWithBlock { (objects, e) -> Void in
            if let e = e {
                print(e.localizedDescription)
            } else if let objects = objects as? [AVObject] {
                self.restaurants = objects
                NSOperationQueue.mainQueue().addOperationWithBlock{
                    self.tableView.reloadData()
                    self.spinner.stopAnimating()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return restaurants.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let restaurant = restaurants[indexPath.row]
        let name = restaurant["name"] as! String
        cell.textLabel?.text = name
        
        //图像占位
        cell.imageView?.image = UIImage(named: "photoalbum")
        
        //后台下载图像
        if let img = restaurant["image"] as? AVFile {

                img.getDataInBackgroundWithBlock({ (data, e) -> Void in
                    
                    if let e = e {
                        print(e.localizedDescription)
                        return
                    }
                    //主线程更新图像
                    NSOperationQueue.mainQueue().addOperationWithBlock{
                        cell.imageView?.image = UIImage(data: data)
                    }
                })
            
        }

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

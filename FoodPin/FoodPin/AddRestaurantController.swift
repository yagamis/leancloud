//
//  AddRestaurantController.swift
//  FoodPin
//
//  Created by xiaobo on 15/10/31.
//  Copyright © 2015年 xiaobo. All rights reserved.
//

import UIKit
import CoreData

class AddRestaurantController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var restaurant: Restaurant!
    var isVisited = false

    @IBOutlet weak var labelVisited: UILabel!
    @IBAction func isVisitedTapped(sender: UIButton) {
        
        if sender.tag == 8001 {
            isVisited = true
            labelVisited.text = "我来过了"
        } else {
            isVisited = false
            labelVisited.text = "没来过"
        }
        
    }
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBAction func saveBtnTapped(sender: UIBarButtonItem) {
        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        
         let restaurant = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: buffer!) as! Restaurant
        
        restaurant.name = name.text!
        restaurant.type = type.text!
        restaurant.location = location.text!
        
        if let image = imageView.image {
            restaurant.image = UIImagePNGRepresentation(image)
        }
        
        restaurant.isVisited = isVisited
        
        
        do {
            try  buffer?.save()
        } catch {
            print(error)
        }
        
        saveRecordToCloud(restaurant)
        
        performSegueWithIdentifier("unwindToHomeList", sender: sender)
        
    }
    
    func saveRecordToCloud(restaurant: Restaurant!) {
        //准备一条需保存的数据记录
        let record = AVObject(className: "Restaurant")
        record["name"] = restaurant.name
        record["type"] = restaurant.type
        record["location"] = restaurant.location
        
        //图像尺寸重新调整
        let originImg = UIImage(data: restaurant.image!)!
        let scalingFac = (originImg.size.width > 1024) ? 1024 / originImg.size.width : 1.0
        let scaledImg = UIImage(data: restaurant.image!, scale: scalingFac)!
        
        //把图像文件转换为jpg格式，并用LeanCloud的File类型保存
        let imgFile = AVFile(name: "\(restaurant.name).jpg", data: UIImageJPEGRepresentation(scaledImg, 0.8))
        imgFile.saveInBackground()
        
        //关联图像文件
        record["image"] = imgFile
        
        record.saveInBackgroundWithBlock { (_, e) -> Void in
            if let e = e {
                print(e.localizedDescription)
            } else {
                print("保存成功！")
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .PhotoLibrary
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        let leftCons = NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: imageView.superview, attribute: .Leading, multiplier: 1, constant: 0)
        
        let rightCons = NSLayoutConstraint(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: imageView.superview, attribute: .Trailing, multiplier: 1, constant: 0)
        
        let topCons = NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: imageView.superview, attribute: .Top, multiplier: 1, constant: 0)
        
        let bottomCons = NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: imageView.superview, attribute: .Bottom, multiplier: 1, constant: 0)
        
        leftCons.active = true
        rightCons.active = true
        topCons.active = true
        bottomCons.active = true

        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

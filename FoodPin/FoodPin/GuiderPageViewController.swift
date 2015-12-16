//
//  GuiderPageViewController.swift
//  FoodPin
//
//  Created by xiaobo on 15/11/12.
//  Copyright © 2015年 xiaobo. All rights reserved.
//

import UIKit

class GuiderPageViewController: UIPageViewController,UIPageViewControllerDataSource {
    
    var headings = ["私人定制", "饕馆定位", "美食发现"]
    var images = ["foodpin-intro-1", "foodpin-intro-2", "foodpin-intro-3"]
    var footers = ["好店随时加，打造自己的美食向导", "马上找到饕餮大餐之馆的位置", "发现其他吃货的珍藏"]
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! GuiderContentViewController).index
        
        index++
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! GuiderContentViewController).index
        index--
        
        return viewControllerAtIndex(index)
    }
    
    
    func viewControllerAtIndex(index: Int) -> GuiderContentViewController? {
        if case 0 ..< headings.count = index {
            //创建一个新视图控制器并传递数据
            if let contentVC = storyboard?.instantiateViewControllerWithIdentifier("GuiderContentController") as? GuiderContentViewController {
                contentVC.imageName = images[index]
                contentVC.heading = headings[index]
                contentVC.footer = footers[index]
                contentVC.index = index
                
                return contentVC
            }
        } else {
            return nil
        }
        
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置数据源为自身
        dataSource = self
        
        //创建第一个页面
        if let startingVC = viewControllerAtIndex(0) {
            setViewControllers([startingVC], direction: .Forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return headings.count
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        
//        return 0
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

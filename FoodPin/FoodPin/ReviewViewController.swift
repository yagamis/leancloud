//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by xiaobo on 15/10/20.
//  Copyright © 2015年 xiaobo. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    var rating :String?
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBAction func ratingBtnTapped(sender: UIButton) {
        switch sender.tag {
        case 100: rating = "dislike"
        case 200: rating = "good"
        case 300: rating = "great"
        default: break
        }
        
        performSegueWithIdentifier("unwindToDetailView", sender: sender)
    }
   
    

    @IBOutlet weak var ratingStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        blurEffectView.frame = view.frame
        bgImageView.addSubview(blurEffectView)
        
        let scale = CGAffineTransformMakeScale(0, 0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
        
        ratingStackView.transform = CGAffineTransformConcat(scale, translate)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.3, animations: {
            self.ratingStackView.transform = CGAffineTransformIdentity
            }, completion: nil)
        
//        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
//            self.ratingStackView.transform = CGAffineTransformIdentity
//            }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

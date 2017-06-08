//
//  Extensions.swift
//  Medical Evaluation
//
//  Created by Veena on 07/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Used Colors
extension UIColor{
    
    class func MEAlertColor() -> UIColor
    {
        return UIColor.colorFromHEX(0xA90000)
    }
 
    class func colorFromHEX(hexValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
  
    
}
//MARK:- Used Fonts
extension UIFont{
    
    class func meBoldFont() -> UIFont{
        return helveticaNueueBold(15)
    }
    class func helveticaNueueBold(size: CGFloat) -> UIFont{
        return UIFont(name: "HelveticaNeue-Bold", size: size)!
    }
    
}

//MARK:- UIViewcontroller

extension UIViewController{
    
    func startLoadingAnimation(isLogin:Bool = false){
        
        let activityView = UIView()
        let screenRect = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height + 60)//UIScreen.mainScreen().bounds
        activityView.backgroundColor = UIColor.grayColor()
        activityView.tag = 101010
        self.view.addSubview(activityView)
        if isLogin{
        activityView.frame = CGRectMake(0, 0, screenRect.width, screenRect.height)
        }
        else{
              activityView.frame = CGRectMake(0, 65, screenRect.width, screenRect.height)
        }
        
        print("activity indiactor frame \(NSStringFromCGRect(activityView.frame))")

        let activityIndicator = HZActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.steps = 8;
        activityIndicator.backgroundColor = UIColor.clearColor()
        activityIndicator.opaque = true;
        activityIndicator.steps = 16;
        activityIndicator.finSize = CGSizeMake(3, 15);
        activityIndicator.indicatorRadius = 10;
        activityIndicator.stepDuration = 0.100;
        activityIndicator.roundedCoreners = UIRectCorner.TopRight;
        activityIndicator.cornerRadii = CGSizeMake(10, 10);
        activityIndicator.color = UIColor.MEAlertColor()         // animation direction
        activityIndicator.direction = HZActivityIndicatorDirectionClockwise;
        activityIndicator.tag = 101011
        self.view.addSubview(activityIndicator)
        activityIndicator.center = view.center//activityView.center
        activityIndicator.startAnimating()
    }
    
 
    
    func addNoDataFoundLabel(type:String?,isPlan : Bool = false,isInternalFilter:Bool = false)  {
        
        dispatch_async(dispatch_get_main_queue(), {
            func getString()->String{
                var str = ""
                if let _ = type{
                    
                    str = "No items available"
                    if isPlan{
                        str = type!
                    }
                }
                return str
            }
            
            if let label = self.view.viewWithTag(8001) as? UILabel{
                label.text = getString()
            }
            else{
                
                let frame = CGRectMake(0, 0, self.view.bounds.size.width, 50)
                let label = UILabel(frame: frame)
                label.text = getString()
                if isInternalFilter{
                    label.frame = CGRectMake(110, self.view.center.y, self.view.bounds.size.width - 110, 50)
                }else{
                    label.center = self.view.center
                }
                
                label.tag = 8001
                label.textColor = UIColor.lightGrayColor()
                label.font = UIFont(name: "Helvetica Neue-Light", size: 11)
                label.textAlignment = .Center
                self.view.addSubview(label)
            }
        })
    }
    
    
    func removeNoDataLabel()  {
        if let label = self.view.viewWithTag(8001) as? UILabel{
            label.removeFromSuperview()
        }
    }
    
    
    func stopLoadingAnimation(){
        
        if let activity = self.view.viewWithTag(101011) as? HZActivityIndicatorView{
            activity.stopAnimating()
        }
        
        if let activityIndicatorView = self.view.viewWithTag(101010){
            activityIndicatorView.removeFromSuperview()
        }
        
        if let activity = self.view.viewWithTag(101011) as? HZActivityIndicatorView{
            activity.removeFromSuperview()
            
        }
    }
    
    
    
}
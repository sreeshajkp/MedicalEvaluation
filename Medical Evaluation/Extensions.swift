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
    class func METextFieldColor() -> UIColor
    {
        return UIColor.colorFromHEX(0xC30D2B)
    }
    
    class func MELightGrey() -> UIColor{
        return UIColor.colorFromHEX(0xf5f5f5)
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


class Colors {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor(red:  169.0 / 255.0, green: 2.0 / 255.0, blue: 0, alpha: 0.8).CGColor//UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 1, green:1 , blue: 1, alpha: 0.8).CGColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}

//MARK:- UITextField
extension UITextField {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        self.layer.addAnimation(animation, forKey: "shake")//add(animation, forKey: "shake")
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
              activityView.frame = CGRectMake(0, 0, screenRect.width, screenRect.height)
        }
        
          let colors = Colors()
        activityView.backgroundColor = UIColor.clearColor()
        let backgroundLayer = colors.gl
        backgroundLayer.frame = activityView.frame
        activityView.layer.insertSublayer(backgroundLayer, atIndex: 0)
                
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
        activityIndicator.color = UIColor.whiteColor()       // animation direction
        activityIndicator.direction = HZActivityIndicatorDirectionClockwise;
        activityIndicator.tag = 101011
        self.view.addSubview(activityIndicator)
        activityIndicator.center = CGPointMake(view.center.x, view.center.y )//view.center//activityView.center
        activityIndicator.startAnimating()
    }
    
 
    
    func addNoDataFoundLabel(type:String?,isPlan : Bool = false,isInternalFilter:Bool = false)  {
        
        dispatch_async(dispatch_get_main_queue(), {
            func getString()->String{
                var str = meNilString
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
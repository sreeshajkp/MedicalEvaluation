//
//  ViewController.swift
//  Medical Evaluation
//
//  Created by Sreeshaj Kp on 03/01/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,MEDelegate{
    
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    @IBOutlet weak var matricField: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.text = "12345678"
        matricField.text = "12312d345678waq9"
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func accountTypeButtonAction(sender: AnyObject) {
        
         let touchedBtn  = sender as! UIButton
        let resultTag = touchedBtn.tag + 200
        
        if resultTag == 201{
            if let selectedBtn = self.view.viewWithTag(201) as? UIButton{
                selectedBtn.selected = true
            }
            
            if let selectedBtn = self.view.viewWithTag(202) as? UIButton{
                selectedBtn.selected = false
            }
            
            if let selectedBtn = self.view.viewWithTag(203) as? UIButton{
                selectedBtn.selected = false
            }
            
        }else if resultTag == 202{
            
            if let selectedBtn = self.view.viewWithTag(201) as? UIButton{
                 selectedBtn.selected = false
            }
            
            if let selectedBtn = self.view.viewWithTag(202) as? UIButton{
               
                selectedBtn.selected = true
            }
            
            if let selectedBtn = self.view.viewWithTag(203) as? UIButton{
                selectedBtn.selected = false
            }

            
        }else if resultTag == 203{
            if let selectedBtn = self.view.viewWithTag(201) as? UIButton{
                selectedBtn.selected = false
            }
            
            if let selectedBtn = self.view.viewWithTag(202) as? UIButton{
                
                selectedBtn.selected = false
            }
            
            if let selectedBtn = self.view.viewWithTag(203) as? UIButton{
                
                selectedBtn.selected = true
            }

        }
        
    }
  
    @IBAction func logInAction(sender: AnyObject) {
        startLoadingAnimation(true)
       let validateResult = checkValidationFields()
        if validateResult.0{
            NetworkManager.sharedManager.delegate = self
             NetworkManager.sharedManager.apiCallHandler(fetchDetailsForLoginAccess(), methodName: MEmethodNames().meMethodNames.MELoginMethod, appendUrl: MEApiUrls().MELogin.loginUrl)
        }else{
            stopLoadingAnimation()
            showAlertController(MEAppName, message: validateResult.1, cancelButton: MEAlertOK, otherButtons: [], handler: nil)
        }
    }
    
    //MEDelegate delegate methods
    
    func networkAPIResultFetched(result: AnyObject, message: String, methodName: String) {
        if methodName == MEmethodNames().meMethodNames.MELoginMethod{
        if let datObj  = result as? NSDictionary{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.stopLoadingAnimation()
                if let accessToken = datObj[JaccessToken] as? String{
                DBManager.sharedManager.insertValue(accessToken, forKey: MEAccessToken)
                }
                let userDetails = ModelClassManager.sharedManager.createModelArray([datObj], modelType: ModelType.MELoginModel) as? [MELoginModel]
                self.performSegueWithIdentifier(MEseguesNames().seguesToLogin.loginSegue, sender: self)
            })
        }
    }
    }
    func networkAPIResultFetchedWithError(error: AnyObject, methodName: String) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
             self.stopLoadingAnimation()
            self.showAlertController(MEAppName, message: error as! String, cancelButton: MEAlertOK, otherButtons: [], handler: nil)
        })
    }
 
    func fetchDetailsForLoginAccess() -> NSMutableDictionary{
        let dict = NSMutableDictionary()
        let mainDict = NSMutableDictionary()
        dict.setObject("1", forKey: jDeviceType)
        dict.setObject("1234", forKey: jDeviceID)
        dict.setObject("123", forKey: jRegistrationID)
        mainDict.setValue(matricField.text, forKey: jUsername)
        mainDict.setValue(passwordField.text, forKey: jPassword)
        mainDict.setValue(dict, forKey: jDevice)
        return mainDict
    }

    
    func checkValidationFields() ->(Bool,String){
        
        var isSuccess = false
        if matricField.text == ""{
            emptyFields = String(format:emptyFields,vUsername)
            isSuccess = false
        }else if passwordField.text == ""{
            emptyFields = String(format:emptyFields,vPassword)
            isSuccess = false
        }
        else{
              isSuccess = true
            emptyFields = ""
        }
        return (isSuccess,emptyFields)
        }
}


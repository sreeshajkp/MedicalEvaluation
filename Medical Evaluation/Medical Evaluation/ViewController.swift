//
//  ViewController.swift
//  Medical Evaluation
//
//  Created by Sreeshaj Kp on 03/01/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit
import JLToast

var isLogedOut = false

class ViewController: UIViewController ,MEDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var studentButton: UIButton!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    @IBOutlet weak var matricField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     // passwordField.text = "12345678" //Need to comment
      //  matricField.text = "123456"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        setInitialButtonAsSelected()
        if isLogedOut{
            showSuccessLogOut()
        }
    }
    
     //MARK :- Button Actions)
    @IBAction func accountTypeButtonAction(sender: AnyObject) {
        
         let touchedBtn  = sender as! UIButton
        let resultTag = touchedBtn.tag + 200
        
        if resultTag == 201{
            if let selectedBtn = self.view.viewWithTag(201) as? UIButton{
                setUIwithRespectToRole(201)
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
                setUIwithRespectToRole(202)
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
                setUIwithRespectToRole(203)
                selectedBtn.selected = true
            }

        }
        
    }
    
    func showSuccessLogOut(){
        let toast = JLToast.makeText(logOutMsg)
        toast.show()
        isLogedOut = false
    }

  
    @IBAction func logInAction(sender: AnyObject) {
        startLoadingAnimation(true)
       let validateResult = checkValidationFields()
        if validateResult.0{
            NetworkManager.sharedManager.delegate = self
             NetworkManager.sharedManager.apiCallHandler(fetchDetailsForLoginAccess(), methodName: MEmethodNames().meMethodNames.MELoginMethod, appendUrl: MEApiUrls().MELogin.loginUrl)
        }else{
            stopLoadingAnimation()
            self.showEmptyTextField(validateResult.1)
           self.view.endEditing(true)
        }
    }
    
    func showEmptyTextField(message:String){
        let toast = JLToast.makeText(message)
        toast.show()
    }
    
    //MARK:- MEDelegate delegate methods
    func networkAPIResultFetched(result: AnyObject, message: String, methodName: String) {
        if methodName == MEmethodNames().meMethodNames.MELoginMethod{
        if let datObj  = result as? NSDictionary{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.stopLoadingAnimation()
                if let accessToken = datObj[JaccessToken] as? String{
                    if let userName = datObj[JUserName] as? String{
                 DBManager.sharedManager.insertValue(userName, forKey: myUser)
                DBManager.sharedManager.insertValue(datObj, forKey: myUserDetails)
                DBManager.sharedManager.insertValue(accessToken, forKey: MEAccessToken)
                    }
                }
                if let userId = datObj[jUserId] as? String{
                    DBManager.sharedManager.insertValue(userId, forKey: myId)
                }
               _   = ModelClassManager.sharedManager.createModelArray([datObj], modelType: ModelType.MELoginModel) as? [MELoginModel]
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
    
 
    //MARK:- Fetching the dictionary for login api call
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

    
    //MARK:- Validation in username and password field
    func checkValidationFields() ->(Bool,String){
        var emptyFields = "Please fill the %@"
        var isSuccess = false
        if matricField.text == meNilString{
            emptyFields = String(format:emptyFields,vUsername)
            isSuccess = false
            matricField.shake()
            matricField.becomeFirstResponder()
        }
        else if passwordField.text == meNilString{
            emptyFields = String(format:emptyFields,vPassword)
            isSuccess = false
             passwordField.shake()
            passwordField.becomeFirstResponder()
        }
        else{
              isSuccess = true
            emptyFields = meNilString
        }
        return (isSuccess,emptyFields)
        }
    
    
    //MARK:- Initially student radio button should selected
    func setInitialButtonAsSelected(){
        studentButton.selected = true
        matricField.placeholder = meMatricNo
        passwordField.placeholder = mePassword
    }
    
    //MARK:- Changing the ui wrt the radio button selection
    func setUIwithRespectToRole(buttonTag : Int){
        if buttonTag == 202 || buttonTag == 203{
        matricField.placeholder = meStaffNo
        matricField.selectedTitle = meStaffNo
        }
        else{
            matricField.placeholder = meMatricNo
            matricField.selectedTitle = meMatricNo
        }
    }
}


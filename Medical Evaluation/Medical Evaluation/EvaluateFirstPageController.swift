//
//  EvaluateFirstPageController.swift
//  Medical Evaluation
//
//  Created by Sreeshaj Kp on 07/01/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit
import JLToast
var isBorder = false
var isCompletelySubmited = false
var evaluationId = Int()
class EvaluateFirstPageController: UIViewController ,MEDelegate{
    @IBOutlet weak var overlayView: UIView!

    var goToEvaluationPage = mainStoryboard.instantiateViewControllerWithIdentifier(MEStoryBoardIds().meStoryBoardIds.meNavBarToSectionEvaluate)
    var memberList : [MEMemberListModel]?

    @IBOutlet weak var studentPicker: Picker!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNotification()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        isBorder = true
        startActions()

         }
    override func viewWillDisappear(animated: Bool) {
        isBorder = false
    }
    
    func startActions(){
        callApiForEvaluatePage(MEmethodNames().meMethodNames.MEGetMyEvaluationMethod) // call evaluation api details for getting the sectionlist count
        callApiForEvaluatePage(MEmethodNames().meMethodNames.MEGetMemberListMethod)
        
        if isCompletelySubmited{
            self.showSuccessAlert()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-  Notification Observer
    func setNotification(){
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector:#selector(EvaluateFirstPageController.dismissView),
            name: meNotification,
            object: nil)
    }
    
    //MARK:- Success Alert
    func showSuccessAlert(){
        let toast = JLToast.makeText(evaluationSuccessMsg)
        toast.show()
        isCompletelySubmited = false
    }
 
    //MARK :- Api call handler
    func callApiForEvaluatePage(methodName : String){
        var url = meNilString
        startLoadingAnimation(false)
        NetworkManager.sharedManager.delegate = self
        if let accessToken = DBManager.sharedManager.fetchValueForKey(MEAccessToken) as? String{
            if accessToken != meNilString{
                var dict = meEmptyDics
                if methodName == MEmethodNames().meMethodNames.MEGetMyEvaluationMethod{
                    if let details = DBManager.sharedManager.fetchValueForKey(meUserDetails) {
                    url = String(format: MEApiUrls().MEGetMyEvaluationList.getMyEvaluationList, accessToken,getIdDetailsFromUserDetails(details).1)
                    }
                }
                    
                else if methodName == MEmethodNames().meMethodNames.MEGetMemberListMethod{
                      url = String(format: MEApiUrls().MEGetMemberList.getMemberList, accessToken,15,0)
                }
                    
                else if methodName == MEmethodNames().meMethodNames.MEGetStartMethod{
                     dict = meEmptyDic
                        if groupIdArray.count != 0 && evaluationIdArray.count != 0{
                            if studentPicker.pickerTextField.text != ""{
                            evaluationId =   (memberList?[0].group?.evaluation?.eEvaluationId)!
                        url = String(format: MEApiUrls().MEGetStartList.getStartList, accessToken,groupIdVal,(memberList?[0].group?.evaluation?.eEvaluationId)!,getCorrespondingValueUsingKeyFromDict(studentPicker.pickerTextField.text!)) //key
                            }
                        }

                }
             
                NetworkManager.sharedManager.apiCallHandler(dict, methodName: methodName, appendUrl: url)
            }
        }
    }
    
    //MARK:- Delegates methods
    func networkAPIResultFetched(result: AnyObject, message: String, methodName: String) {
        if methodName == MEmethodNames().meMethodNames.MEGetMyEvaluationMethod {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let profileDetails = ModelClassManager.sharedManager.createModelArray([result], modelType: ModelType.MEEvaluations) as? [MEEvaluations]
                _ = profileDetails![0]
                self.stopLoadingAnimation()
            })
        }
        else if methodName ==  MEmethodNames().meMethodNames.MEGetMemberListMethod{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
          self.memberList = ModelClassManager.sharedManager.createModelArray([result], modelType: ModelType.MEMemberListModel) as? [MEMemberListModel]
                self.setPicker()
                self.stopLoadingAnimation()
            })
        }
         else if methodName == MEmethodNames().meMethodNames.MEGetStartMethod{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                startList = ModelClassManager.sharedManager.createModelArray([result] , modelType: ModelType.MEStartEvaluationModel) as? [MEStartEvaluationModel]
                self.stopLoadingAnimation()
                self.presentViewController(self.goToEvaluationPage, animated: true, completion: nil)
            })
            
        }
}
    
func networkAPIResultFetchedWithError(error: AnyObject, methodName: String) {
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.stopLoadingAnimation()
        self.showAlertController(MEAppName, message: error as! String, cancelButton: MEAlertOK, otherButtons: [], handler: nil)
    })
}
    

    
    //MARK:- Button Actions
    @IBAction func startEvaluationButtonAction(sender: UIButton) {
      
        if pickerDict.count > 0{
        if countSection != 0{
       isFirst = true
       fromback = false
        mySectionCount = 1
        choiceDict = [:]
       callApiForEvaluatePage(MEmethodNames().meMethodNames.MEGetStartMethod)
        }
        }else{
            self.showAlertController(MEAppName, message: noStudentsEvaluateMsg, cancelButton: MEAlertOK, otherButtons: [], handler: nil)
        }
        
        
    }
   
    //MARK:- Notification
    func dismissView(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
          //  self.goToEvaluationPage.dismissViewControllerAnimated(true, completion: nil)
            self.goToEvaluationPage.dismissViewControllerAnimated(true, completion: {
              //  self.startActions()
            })
        }
    }

    //MARK :- GetIdDetailsFromUserDetails
    func getIdDetailsFromUserDetails(details : AnyObject) -> (Int,Int,String){
        let userName = details[meUserName] as? String
        var userGroupId  = Int()
        var evalId = Int()
        if let groupValue = details[meGroup] {
            userGroupId = (groupValue![meGroupId] as? Int)!
            
            if let evaluationValue = groupValue![meEvaluation] as? NSDictionary{
                evalId = (evaluationValue[meEvaluationId] as? Int)!
            }
        }
        return (userGroupId,evalId,userName!)
    }
    
    //MARK:- Set the student picker and set its initial value
    func setPicker(){
        if pickerDict.count != 0{
        studentPicker.pickerInputItems(pickerDict.allKeys)
        studentPicker.pickerTextField.text = pickerDict.allKeys[0] as? String
            overlayView.hidden = true

        }
        else{
            overlayView.hidden = false
            studentPicker.pickerTextField.placeholder = noStudentsPlaceHolder
        }
    }
    
    
    //MARK:- Get Corresponding Value Using Key From dict
    func getCorrespondingValueUsingKeyFromDict(key : String) -> String{
        var value = meNilString
        if pickerDict.count != 0{
            for each in pickerDict{
                if each.key as! String == key{
                    value = each.value as! String
                }
            }
            return value
        }
        else{
            return meNilString
        }
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

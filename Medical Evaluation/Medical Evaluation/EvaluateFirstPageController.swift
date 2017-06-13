//
//  EvaluateFirstPageController.swift
//  Medical Evaluation
//
//  Created by Sreeshaj Kp on 07/01/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit

class EvaluateFirstPageController: UIViewController ,MEDelegate{

    var goToEvaluationPage = mainStoryboard.instantiateViewControllerWithIdentifier(MEStoryBoardIds().meStoryBoardIds.meNavBarToSectionEvaluate)
    

    @IBOutlet weak var studentPicker: Picker!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNotification()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
     callApiForEvaluatePage(MEmethodNames().meMethodNames.MEGetMyEvaluationMethod) // call evaluation api details for getting the sectionlist count
      callApiForEvaluatePage(MEmethodNames().meMethodNames.MEGetStudentMethod)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNotification(){
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector:#selector(EvaluateFirstPageController.dismissView),
            name: meNotification,
            object: nil)
    }
    
 
    
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
                    
                else if methodName == MEmethodNames().meMethodNames.MEGetStudentMethod{
                      url = String(format: MEApiUrls().MEGetStudentList.getStudentList, accessToken,15,0,2)
                }
                    
                else if methodName == MEmethodNames().meMethodNames.MEGetStartMethod{
                     dict = meEmptyDic
                    if let details = DBManager.sharedManager.fetchValueForKey(meUserDetails) {
                        url = String(format: MEApiUrls().MEGetStartList.getStartList, accessToken, getIdDetailsFromUserDetails(details).0,getIdDetailsFromUserDetails(details).1,getIdDetailsFromUserDetails(details).2)
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
                print(sectionNames)
                self.stopLoadingAnimation()
            })
        }
        else if methodName ==  MEmethodNames().meMethodNames.MEGetStudentMethod{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
          _ = ModelClassManager.sharedManager.createModelArray(result as! NSArray, modelType: ModelType.MEProfileModel) as? [MEProfileModel]
                self.fetchAllFullNamesFromJson(result as! NSArray)
                self.stopLoadingAnimation()
            })
        }
         else if methodName == MEmethodNames().meMethodNames.MEGetStartMethod{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                startList = ModelClassManager.sharedManager.createModelArray([result] , modelType: ModelType.MEStartEvaluationModel) as? [MEStartEvaluationModel]
                self.stopLoadingAnimation()
                self.navigationController?.presentViewController(self.goToEvaluationPage, animated: true, completion: nil)

            })
            
        }
}

    func getIdDetailsFromUserDetails(details : AnyObject) -> (Int,Int,String){
        print(details)
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
    
    func fetchAllFullNamesFromJson(result : NSArray) {
          if result.count != 0{
           var fullNameArray = [String]()
            for each in result{
            if  let name = each[jfullName]  as? String{
                fullNameArray.append(name)
            }else{
                 fullNameArray.append("null")
            }
            }
            studentPicker.pickerTextField.text = fullNameArray[0]
            studentPicker.pickerInputItems(fullNameArray)
        }
        }
    
func networkAPIResultFetchedWithError(error: AnyObject, methodName: String) {
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.stopLoadingAnimation()
        self.showAlertController(MEAppName, message: error as! String, cancelButton: MEAlertOK, otherButtons: [], handler: nil)
    })
}
    @IBAction func startEvaluationButtonAction(sender: UIButton) {
        if countSection != 0{
        mySectionCount = 1
       callApiForEvaluatePage(MEmethodNames().meMethodNames.MEGetStartMethod)
        }
    }
   
    
    func dismissView(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.goToEvaluationPage.dismissViewControllerAnimated(true, completion: nil)
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

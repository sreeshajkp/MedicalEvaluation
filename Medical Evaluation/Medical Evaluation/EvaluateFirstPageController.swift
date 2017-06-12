//
//  EvaluateFirstPageController.swift
//  Medical Evaluation
//
//  Created by Sreeshaj Kp on 07/01/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit

class EvaluateFirstPageController: UIViewController ,MEDelegate{

    var goToEvaluationPage = mainStoryboard.instantiateViewControllerWithIdentifier("navBarToSectionEvaluate")
    

    @IBOutlet weak var studentPicker: Picker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentPicker.pickerTextField.text = "Ali"
        studentPicker.pickerInputItems(["Ali","Timmy","Lim","Hong"])
        setNotification()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
      callApiCallForProfile() // call profile details for getting the sectionlist count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNotification(){
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector:#selector(EvaluateFirstPageController.dismissView),
            name: "dismissView",
            object: nil)
    }
    
    func callApiCallForProfile(){
        var url = ""
        startLoadingAnimation(false)
        NetworkManager.sharedManager.delegate = self
        if let accessToken = DBManager.sharedManager.fetchValueForKey(MEAccessToken) as? String{
            if accessToken != ""{
                    url = String(format: MEApiUrls().MEGetProfile.getProfileUrl, accessToken)
                NetworkManager.sharedManager.apiCallHandler(meEmptyDics, methodName: MEmethodNames().meMethodNames.MEGetProfileMethod, appendUrl: url)
            }
        }
    }
    
    //MARK:- Delegates methods
    func networkAPIResultFetched(result: AnyObject, message: String, methodName: String) {
        if methodName == MEmethodNames().meMethodNames.MEGetProfileMethod{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let profileDetails = ModelClassManager.sharedManager.createModelArray([result], modelType: ModelType.MEProfileModel) as? [MEProfileModel]
                let details = profileDetails![0]
                self.stopLoadingAnimation()
            })
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
       // goToEvaluationPage.delegate = self
        navigationController?.presentViewController(goToEvaluationPage, animated: true, completion: nil)
        }
    }
    func dismissViewControllersWithNavigation(){
    
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

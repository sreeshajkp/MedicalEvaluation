//
//  SectionEvaluateViewController.swift
//  Medical Evaluation
//
//  Created by Veena on 12/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit

class SectionEvaluateViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,MEDelegate{
    var questionNum = Int()
    var delegate : MEDelegate?
    var questionList = [MEQuestionModel]()
    @IBOutlet weak var questionTable: UITableView!
    @IBOutlet weak var headerTextLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        print(mySectionCount)
        registerTheNib()
        setButtonTitlesForPageReload()
        getApiCall(MEmethodNames().meMethodNames.MEGetQuestionListMethod, sectionId: mySectionCount)
        print(sectionNames)
        setHeaderText()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func nextButtonAction(sender: UIButton) {
        if nextButton.titleLabel?.text != submit{
        mySectionCount = mySectionCount + 1
        if countSection! >= mySectionCount{
       let goToNextPage = mainStoryboard.instantiateViewControllerWithIdentifier(MEStoryBoardIds().meStoryBoardIds.meSectionEvaluateViewController) as? SectionEvaluateViewController
            self.navigationController?.pushViewController(goToNextPage!, animated: true)
        }
        }
        else{
            getApiCall(MEmethodNames().meMethodNames.MEGetQuestionSubmitMethod, sectionId: 0)
            NSNotificationCenter.defaultCenter().postNotificationName("dismissView", object: nil)
        }
        
        
    }
    
    @IBAction func backButtonAction(sender: UIButton) {
        print(mySectionCount)
        if mySectionCount > 0 && mySectionCount != 1{
        mySectionCount = mySectionCount - 1
       // self.navigationController?.popViewControllerAnimated(true)
            NSNotificationCenter.defaultCenter().postNotificationName("dismissView", object: nil)
        }
       else{
            //self.dismissViewControllerAnimated(true, completion: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("dismissView", object: nil)
        }
    }
    

    
    func registerTheNib(){
        self.navigationController?.navigationBarHidden = true
        questionTable.tableFooterView = UIView()
        questionTable.registerNib(UINib(nibName: METableViewCells().meTableViewCells.meSectionEvaluationTableViewCell, bundle: nil), forCellReuseIdentifier: METableViewCells().meTableViewCells.meSectionEvaluationTableViewCell)
    }
    
    func setHeaderText(){
        if sectionNames.count != 0{
            if mySectionCount > 0{
            headerTextLabel.text = sectionNames[mySectionCount - 1]
            }
        }
    }
    func setButtonTitlesForPageReload(){
        if countSection! == mySectionCount{
            nextButton.setTitle(submit, forState: .Normal)
        }
        else{
            nextButton.setTitle( next, forState: .Normal)
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier(METableViewCells().meTableViewCells.meSectionEvaluationTableViewCell, forIndexPath: indexPath) as? SectionEvaluationTableViewCell
        cell?.selectionStyle = .None
        if questionList.count != 0{
             questionNum = questionNum + 1
        if let questionList = questionList[indexPath.row] as? MEQuestionModel{
            cell?.questionLabel.text = "\(questionNum)" + ".  " + questionList.text!
        }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
    
 
    
    func getApiCall(methodName: String,sectionId: Int){
   //     startLoadingAnimation(false)
        NetworkManager.sharedManager.delegate = self
        if let accessToken  = DBManager.sharedManager.fetchValueForKey(MEAccessToken) as? String{
            var url = ""
            if methodName == MEmethodNames().meMethodNames.MEGetQuestionSubmitMethod{
             url = String(format: MEApiUrls().MESubmitQuestionList.getQuestionSubmit, accessToken)
                NetworkManager.sharedManager.apiCallHandler(meEmptyDic, methodName:  methodName, appendUrl: url)
            }
            else if methodName == MEmethodNames().meMethodNames.MEGetQuestionListMethod{
                 url = String(format: MEApiUrls().MEGetQuestionList.getQuestionList, accessToken,sectionId,15,0)
                NetworkManager.sharedManager.apiCallHandler(meEmptyDics, methodName:  methodName, appendUrl: url)
            }
            
        }
    }
    
    
//MARK:- Delegate functions
    func networkAPIResultFetched(result: AnyObject, message: String, methodName: String) {
        if methodName == MEmethodNames().meMethodNames.MEGetQuestionListMethod{
             if let datObj  = result as? NSDictionary{
                print(datObj)
            }
            questionList = (ModelClassManager.sharedManager.createModelArray(result as! NSArray, modelType: ModelType.MEQuestionModel) as? [MEQuestionModel])!
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.questionNum = 0
                self.questionTable.reloadData()
                self.stopLoadingAnimation()
            })
            
        }
        else if methodName == MEmethodNames().meMethodNames.MEGetQuestionSubmitMethod{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let success = result[jResult] as? Bool{
                    if success  {
                        self.stopLoadingAnimation()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else{
                        self.stopLoadingAnimation()
                    }
                }
            })
        }
    }
    
    func networkAPIResultFetchedWithError(error: AnyObject, methodName: String) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.stopLoadingAnimation()
        })
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */}


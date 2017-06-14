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
    var cellArray = [SectionEvaluationTableViewCell]()
    var delegate : MEDelegate?
    var questionList = [MEQuestionModel]()
    var isBack = false
    
    @IBOutlet weak var questionTable: UITableView!
    @IBOutlet weak var headerTextLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        cellArray = []
        registerTheNib()
        setButtonTitlesForPageReload()
        getApiCall(MEmethodNames().meMethodNames.MEGetQuestionListMethod, sectionId: mySectionCount)
        setHeaderText()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- ButtonActions
    @IBAction func nextButtonAction(sender: UIButton) {
        isFirst = false
        if nextButton.titleLabel?.text != submit{
            nextButtonAction()
        }
        else{
            getApiCall(MEmethodNames().meMethodNames.MEGetQuestionSubmitMethod, sectionId: 0)
        }
    }
    
    @IBAction func backButtonAction(sender: UIButton) {
        isFirst = false
        print(mySectionCount)
        if mySectionCount > 0 && mySectionCount != 1{
            setMySectionCountAndRefreshingTheQuestionList()
        }
       else{
            questionResponseArray = []
            cellArray = []
            NSNotificationCenter.defaultCenter().postNotificationName(meNotification, object: nil)
        }
    }
    
    
    //MARK :- Navigation to next page on next button click
    func nextButtonAction(){
        mySectionCount = mySectionCount + 1
        if countSection! >= mySectionCount{
            setQuestionsForSubmit(questionList)
            let goToNextPage = mainStoryboard.instantiateViewControllerWithIdentifier(MEStoryBoardIds().meStoryBoardIds.meSectionEvaluateViewController) as? SectionEvaluateViewController
            self.navigationController?.pushViewController(goToNextPage!, animated: true)
        }
    }
    
    
    //MARK:- SetMySectionCountAndRefreshingTheQuestionList
    func setMySectionCountAndRefreshingTheQuestionList(){
    mySectionCount = mySectionCount - 1
    isBack = true
    getApiCall(MEmethodNames().meMethodNames.MEGetQuestionListMethod, sectionId: mySectionCount)
    }
    
    
    //MARK:- RemoveResponseFromGlobalArray
    func removeResponseFromGlobalArray(){
        var newArray = NSMutableArray()
        print(questionResponseArray.count)
        print(questionList.count)
        if questionResponseArray.count != 0 {
             var newCount = 0
            if questionList.count != 0{
             newCount = questionResponseArray.count - questionList.count
            }
            else{
              newCount = questionResponseArray.count
            }
            for i in 0 ..< newCount{
                newArray.addObject(questionResponseArray[i])
            }
           questionResponseArray = newArray
            print(questionResponseArray)
        }
    }
    
    //MARK:- TableViewSetUps
    func registerTheNib(){
        questionTable.estimatedRowHeight = 130
        questionTable.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBarHidden = true
        questionTable.tableFooterView = UIView()
        questionTable.registerNib(UINib(nibName: METableViewCells().meTableViewCells.meSectionEvaluationTableViewCell, bundle: nil), forCellReuseIdentifier: METableViewCells().meTableViewCells.meSectionEvaluationTableViewCell)
    }
    
    
    //MARK:- Set each page with  the section names
    func setHeaderText(){
        if sectionNames.count != 0{
            if mySectionCount > 0{
            headerTextLabel.text = sectionNames[mySectionCount - 1]
            }
        }
    }
    
    //MARK :- Setup the button text
    func setButtonTitlesForPageReload(){
        print(countSection)
        if countSection == mySectionCount{
            nextButton.setTitle(submit, forState: .Normal)
        }
        else{
            nextButton.setTitle( next, forState: .Normal)
        }
    }
    
    //MARK:- TableView Delegates method
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableViewHeightConstraint.constant = tableView.contentSize.height
       let cell = (tableView.dequeueReusableCellWithIdentifier(METableViewCells().meTableViewCells.meSectionEvaluationTableViewCell, forIndexPath: indexPath) as? SectionEvaluationTableViewCell)!
        if isFirst {
        cell.typingTextField.text = ""
        }
        cell.selectionStyle = .None
        if questionList.count != 0{
             questionNum = questionNum + 1
        if let questionList = questionList[indexPath.row] as? MEQuestionModel{
            cell.questionLabel.text = "\(questionNum)" + ".  " + questionList.text!
        }
          cellArray.append(cell)
        }
        return cell
    }
    

    //MARK:- Api Methods
    func getApiCall(methodName: String,sectionId: Int){
      startLoadingAnimation(false)
        NetworkManager.sharedManager.delegate = self
        if let accessToken  = DBManager.sharedManager.fetchValueForKey(MEAccessToken) as? String{
            var url = meNilString
            
            if methodName == MEmethodNames().meMethodNames.MEGetQuestionSubmitMethod{
             url = String(format: MEApiUrls().MESubmitQuestionList.getQuestionSubmit, accessToken)
                print(questionResponseArray)
                 print(questionResponseArray.count)
                NetworkManager.sharedManager.apiCallHandler(questionResponseArray, methodName:  methodName, appendUrl: url)
            }
                
            else if methodName == MEmethodNames().meMethodNames.MEGetQuestionListMethod{
                 url = String(format: MEApiUrls().MEGetQuestionList.getQuestionList, accessToken,sectionId,15,0)
                NetworkManager.sharedManager.apiCallHandler(meEmptyDics, methodName:  methodName, appendUrl: url)
            }
                
            else if methodName == MEmethodNames().meMethodNames.MEGetEvaluationStopMethod{
                url = String(format: MEApiUrls().MEGetStopEvaluation.getStopEvaluation, accessToken,Int(startList![0].responseId!))
                NetworkManager.sharedManager.apiCallHandler(meEmptyDic, methodName:  methodName, appendUrl: url)
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
            print(questionList.count)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
              
                self.questionNum = 0
                self.questionTable.reloadData()
                self.stopLoadingAnimation()
                if self.isBack{
                    self.isBack = false
                    self.removeResponseFromGlobalArray()
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
        }
            
        else if methodName == MEmethodNames().meMethodNames.MEGetQuestionSubmitMethod{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let success = result[jResult] as? Bool{
                    if success  {
                        self.stopLoadingAnimation()
                        questionResponseArray = []
                        self.cellArray = []
                        self.getApiCall(MEmethodNames().meMethodNames.MEGetEvaluationStopMethod, sectionId: 0)
                    }
                    else{
                        self.stopLoadingAnimation()
                    }
                }
            })
        }
            
        else  if methodName == MEmethodNames().meMethodNames.MEGetEvaluationStopMethod{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let success = result[jResult] as? Bool{
                    if success  {
                        self.stopLoadingAnimation()
                        isCompletelySubmited = true
                        //Alert
                        NSNotificationCenter.defaultCenter().postNotificationName(meNotification, object: nil)
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
    
    
    //MARK:- setQuestionsResponseForSubmit
    func setQuestionsForSubmit(model : [MEQuestionModel]){
        print(cellArray.count)
        for each in cellArray{
            let index = cellArray.indexOf(each)
            let eachValue = model[index!]
            let responseDict = NSMutableDictionary()
            responseDict.setObject([meResponseId : Int(startList![0].responseId!)], forKey: meResponse)
            responseDict.setObject([meQuestionId : eachValue.questionId!], forKey: meQuestion)
            if each.yesOrNoPicker.text == MEAlertYes{
            responseDict.setObject([meResponseChoiceId : 1], forKey: meResponseChoice)
           }
          else if each.yesOrNoPicker.text == MEAlertNo{
                responseDict.setObject([meResponseChoiceId : 2], forKey: meResponseChoice) //dont know the values to give
            }
            else if each.yesOrNoPicker.text == ""{
                responseDict.setObject([meResponseChoiceId : 3], forKey: meResponseChoice) //dont know the values to give
            }
            if each.typingTextField.text  != meNilString{
            responseDict.setObject(each.typingTextField.text!, forKey: meComment)
            }
            else{
                responseDict.setObject(meNilString, forKey: meComment)
            }
            questionResponseArray.addObject(responseDict)
            print(questionResponseArray)
        }
           let user = ModelClassManager.sharedManager.createModelArray(questionResponseArray, modelType: ModelType.MESubmitResponseModel) as? [MESubmitResponseModel]
            print(user?.count)
    }
    }


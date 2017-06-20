//
//  SectionEvaluateViewController.swift
//  Medical Evaluation
//
//  Created by Veena on 12/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit
var fromback = false
//enum ChoiceId : Int{
//    case Yes =  1
//    case No = 2
//}
class SectionEvaluateViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,MEDelegate{
    
    var questionNum = Int()
    var cellArray = [SectionEvaluationTableViewCell]()
    var delegate : MEDelegate?
    var questionList = [MEQuestionModel]()
    var isBack = false
    var choiceIdDict : Dictionary<String,AnyObject>?
    var sectionCount : Int?
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
        setHeaderText()
        getApiCall(MEmethodNames().meMethodNames.MEGetQuestionListMethod, sectionId: sectionCount!)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- ButtonActions
    @IBAction func nextButtonAction(sender: UIButton) {
        isFirst = false
        fromback = false
        print(nextButton.titleLabel?.text)
        print(submit)
        if nextButton.titleLabel?.text != submit{
            nextButtonAction()
        }
        else{
            
            self.showAlertController(MEAppName, message: submitMsg, cancelButton: MEAlertNo, otherButtons: [MEAlertYes], handler: { (index) in
                if index == 1{
                    self.submitAction()
                }
            })
            
        }
    }
    
    func submitAction(){
        setQuestionsForSubmit(questionList)
        getApiCall(MEmethodNames().meMethodNames.MEGetQuestionSubmitMethod, sectionId: 0)

    }
    
    @IBAction func backButtonAction(sender: UIButton) {
        isFirst = false
        print(mySectionCount)
        if mySectionCount > 0 && mySectionCount != 1{
            fromback = true
            setMySectionCountAndRefreshingTheQuestionList()
        }
       else{
            questionResponseArray = []
            cellArray = []
            pickerResponseSetValues = []
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
    sectionCount = sectionCountArray[mySectionCount - 1]
   getApiCall(MEmethodNames().meMethodNames.MEGetQuestionListMethod, sectionId: sectionCount!)
     
    }
    
    
    //MARK:- RemoveResponseFromGlobalArray
    func removeResponseFromGlobalArray(){
        let newArray = NSMutableArray()
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
            print(questionResponseArray.count)
        }
    }
    
    //MARK:- removeResponseChoiceFromGlobalArray
    func removeResponseChoiceFromGlobalArray(){
        var pickerCount = pickerResponseSetValues.count
        var newCount = 0
        print(questionList.count)
        if pickerResponseSetValues.count != 0 {
            if questionList.count != 0{
                newCount = pickerResponseSetValues.count - questionList.count
                pickerSelectedValues = []
                for i in newCount ..< pickerCount{
                    pickerSelectedValues.addObject(pickerResponseSetValues[i])
                    
                }
            }
            else{
               pickerSelectedValues = []
            }
            print(pickerSelectedValues)
            var countVal = pickerResponseSetValues.count - pickerSelectedValues.count
            var arrays = NSMutableArray()
            for i in 0 ..< countVal{
                arrays.addObject(pickerResponseSetValues[i])
            }
            pickerResponseSetValues = arrays
            print(pickerResponseSetValues)
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
                var names = [String]()
                headerTextLabel.text = sectionNames[mySectionCount - 1]
                sectionCount = sectionCountArray[mySectionCount - 1]
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
        if let question = questionList[indexPath.row] as? MEQuestionModel{
            cell.questionLabel.text = "\(questionNum)" + ".  " + question.text!
            if fromback {
                cell.yesOrNoPicker.text =  pickerSelectedValues[indexPath.row] as! String
            }
            else{
                if choiceDict.count != 0{
                    cell.choiceIds = (choiceDict.allKeys as? [String])!
                }
                
            }
//            if let questionId = question.questionId{
//                cell.choiceIds = self.getPickerArrayForTheQuestion(questionId)
//            }
            
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
            
            else if methodName == MEmethodNames().meMethodNames.MEGetChoiceIDMethod{
                if evaluationId != 0{
                url = String(format:MEApiUrls().MEGetChoiceId.getChoiceId,accessToken,evaluationId,15,0)
                NetworkManager.sharedManager.apiCallHandler(meEmptyDics, methodName:  methodName, appendUrl: url)
            }
            }
        }
    }
    
    func getPickerArrayForTheQuestion(questionId:Int) -> [String]{
        
        
        var pickerValues = [String]()
        
        for key in (self.choiceIdDict?.keys)!{
            
            if key == "1"{
                
                if let array =  self.choiceIdDict![key] as? [Int]{
                    
                    if array.contains(questionId){
                        pickerValues.append("Yes")
                    }
                }
            }else if key == "2"{
                
                if let array =  self.choiceIdDict![key] as? [Int]{
                    
                    if array.contains(questionId){
                        pickerValues.append("No")
                    }
                }
            }
        }
        
        return pickerValues
        
    }
    
    
//MARK:- Delegate functions
    func networkAPIResultFetched(result: AnyObject, message: String, methodName: String) {
        if methodName == MEmethodNames().meMethodNames.MEGetQuestionListMethod{
         
            questionList = (ModelClassManager.sharedManager.createModelArray(result as! NSArray, modelType: ModelType.MEQuestionModel) as? [MEQuestionModel])!
            print(questionList.count)
           dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.stopLoadingAnimation()
                self.getApiCall(MEmethodNames().meMethodNames.MEGetChoiceIDMethod, sectionId: self.sectionCount!)
            })
        }
            
        else if methodName == MEmethodNames().meMethodNames.MEGetQuestionSubmitMethod{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let success = result[jResult] as? Bool{
                    if success  {
                        self.stopLoadingAnimation()
                        questionResponseArray = []
                        pickerSelectedValues = []
                        pickerResponseSetValues = []
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
        
        else if methodName == MEmethodNames().meMethodNames.MEGetChoiceIDMethod{
            if  let resultArry = result as? NSArray{
                let choices = ModelClassManager.sharedManager.createModelArray(resultArry, modelType: ModelType.MEchoiceModel) as? [MEResponseChoiceModel]
            // self.choiceIdDict = DBManager.sharedManager.setChoiceIds(choices!)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.questionNum = 0
                self.questionTable.reloadData()
                self.stopLoadingAnimation()
                if self.isBack{
                    self.isBack = false
                      if fromback{
                    self.removeResponseChoiceFromGlobalArray()
                    }
                    self.removeResponseFromGlobalArray()
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
            }
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
            //guard let _ = startList else {return }
            if let responseVal = responseValue{
            responseDict.setObject([meResponseId : responseVal], forKey: meResponse) //last minute change
            }
            responseDict.setObject([meQuestionId : eachValue.questionId!], forKey: meQuestion)
            pickerResponseSetValues.addObject(each.yesOrNoPicker.text!)
            if each.yesOrNoPicker.text != ""{
                responseDict.setObject([meResponseChoiceId :   getChoiceId(each.yesOrNoPicker.text!)], forKey: meResponseChoice) //dont know the values to give
            }
            if each.typingTextField.text  != meNilString{
            responseDict.setObject(each.typingTextField.text!, forKey: meComment)
            }
            else{
                responseDict.setObject(meNilString, forKey: meComment)
            }
            questionResponseArray.addObject(responseDict)
            print(questionResponseArray)
            print(pickerResponseSetValues)
        }
           let user = ModelClassManager.sharedManager.createModelArray(questionResponseArray, modelType: ModelType.MESubmitResponseModel) as? [MESubmitResponseModel]
            print(user?.count)
    }
    
    func getChoiceId(text: String) -> Int{
        var id = Int()
        for each in choiceDict{
            if text == each.key as! String{
                id = (each.value as? Int)!
            }
        }
        return id
    }
    }


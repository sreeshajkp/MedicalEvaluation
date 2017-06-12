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
        registerTheNib()
        setButtonTitlesForPageReload()
        getQuestionList(mySectionCount)
        print(sectionNames)
        setHeaderText()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func nextButtonAction(sender: UIButton) {
        if nextButton.titleLabel?.text != "SUBMIT"{
        mySectionCount = mySectionCount + 1
        if countSection! >= mySectionCount{
       var goToNextPage = mainStoryboard.instantiateViewControllerWithIdentifier("SectionEvaluateViewController") as? SectionEvaluateViewController
            self.navigationController?.pushViewController(goToNextPage!, animated: true)
        }
        }
    }
    
    @IBAction func backButtonAction(sender: UIButton) {
        if mySectionCount > 0{
            if mySectionCount == 1{
                mySectionCount = mySectionCount + 1
            }
        mySectionCount = mySectionCount - 1
        self.navigationController?.popViewControllerAnimated(true)
        }else{
            delegate!.dismissViewControllersWithNavigation!()
        }
    }
    
 
    func registerTheNib(){
        self.navigationController?.navigationBarHidden = true
        questionTable.tableFooterView = UIView()
        questionTable.registerNib(UINib(nibName: "SectionEvaluationTableViewCell", bundle: nil), forCellReuseIdentifier: "SectionEvaluationTableViewCell")
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
            nextButton.setTitle("SUBMIT", forState: .Normal)
        }
        else{
            nextButton.setTitle("NEXT", forState: .Normal)
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("SectionEvaluationTableViewCell", forIndexPath: indexPath) as? SectionEvaluationTableViewCell
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
    
    func getQuestionList(sectionId : Int){
        startLoadingAnimation(false)
        NetworkManager.sharedManager.delegate = self
        if let accessToken  = DBManager.sharedManager.fetchValueForKey(MEAccessToken) as? String{
            let url = String(format: MEApiUrls().MEGetQuestionList.getQuestionList, accessToken,sectionId,15,0)
            print(url)
            NetworkManager.sharedManager.apiCallHandler(meEmptyDics, methodName:  MEmethodNames().meMethodNames.MEGetQuestionListMethod, appendUrl: url)
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


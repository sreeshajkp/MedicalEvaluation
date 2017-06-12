//
//  SectionEvaluateViewController.swift
//  Medical Evaluation
//
//  Created by Veena on 12/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit

class SectionEvaluateViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,MEDelegate{
    
    var questionList = [MEQuestionModel]()
    @IBOutlet weak var questionTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        getQuestionList()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SectionEvaluationTableViewCell", forIndexPath: indexPath) as? SectionEvaluationTableViewCell
        if let questionList = questionList[indexPath.row] as? MEQuestionModel{
            cell?.questionLabel.text = questionList.text
        }
        return cell!
    }
    
    func getQuestionList(){
        startLoadingAnimation(false)
        NetworkManager.sharedManager.delegate = self
        if let accessToken  = DBManager.sharedManager.fetchValueForKey(MEAccessToken) as? String{
            let url = String(format: MEApiUrls().MEGetQuestionList.getQuestionList, accessToken,1,15,0)
            NetworkManager.sharedManager.apiCallHandler(meEmptyDic, methodName:  MEmethodNames().meMethodNames.MEGetQuestionListMethod, appendUrl: url)
        }
    }
    
    func networkAPIResultFetched(result: AnyObject, message: String, methodName: String) {
        if methodName == MEmethodNames().meMethodNames.MEGetQuestionListMethod{
            questionList = (ModelClassManager.sharedManager.createModelArray(result as! NSArray, modelType: ModelType.MEQuestionListModel) as? [MEQuestionModel])!
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
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


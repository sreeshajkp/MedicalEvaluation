//
//  Global.swift
//  Medical Evaluation
//
//  Created by Veena on 08/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation
import UIKit

//MARK :- StoryBoard
 let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
var countSection = DBManager.sharedManager.fetchValueForKey(sectionCount) as? Int
var mySectionCount = Int()
var isFirst = false
var startList : [MEStartEvaluationModel]?
var questionResponseArray = NSMutableArray()
var pickerResponseSetValues = NSMutableArray()
var pickerSelectedValues = NSMutableArray()
var groupIdArray =  [Int]()
var groupIdVal = Int()
var evaluationIdArray =  [Int]()
var sectionNames = [String]()
var sectionCountArray = [Int]()
var pickerDict = NSMutableDictionary()

//MARK:- Segues Names
class MEseguesNames{
    let seguesToLogin = SeguesToLoginPage()
}
struct  SeguesToLoginPage{
    let loginSegue = "LoginSegue"
}

//MARK:- Method Names

class MEmethodNames{
    let meMethodNames = MeMethods()
}
struct  MeMethods{
    let MELoginMethod = "MELoginMethod"
    let MEGetUsersMethod = "MEGetUsersMethod"
    let MEGetProfileMethod = "MEGetProfileMethod"
    let MELogoutMethod = "MELogoutMethod"
    let MEGetGroupListMethod = "MEGetGroupListMethod"
    let MEGetQuestionListMethod = "MEGetQuestionListMethod"
    let MEGetQuestionSubmitMethod = "MEGetQuestionSubmitMethod"
    let MEGetStudentMethod = "MEGetStudentMethod"
    let MEGetStartMethod = "MEGetStartMethod"
     let MEGetMyEvaluationMethod = "MEGetMyEvaluationMethod"
    let MEGetMemberListMethod = "MEGetMemberListMethod"
     let MEGetEvaluationStopMethod = "MEGetEvaluationStopMethod"
    let MEGetChoiceIDMethod = "MEGetChoiceIDMethod"
    
}

//MARK:- StoryBoard Names
class MEStoryBoardIds{
    let meStoryBoardIds = MEStoryBoards()
}
struct MEStoryBoards {
    let meStartNav = "startNav"
    let meTabBarViewController = "TabBarViewController"
    let meEvaluateFirstPageController = "EvaluateFirstPageController"
    let meEvaluateSecondPageController = "EvaluateSecondPageController"
    let meSectionEvaluateViewController = "SectionEvaluateViewController"
    let meNavBarToSectionEvaluate = "navBarToSectionEvaluate"
}

//MARK:- TableViewCell Names
class METableViewCells{
    let meTableViewCells = METableCells()
}
struct METableCells {
    let meDetailTableViewCell = "DetailTableViewCell"
    let meListTableViewCell = "ListTableViewCell"
    let meSectionEvaluationTableViewCell = "SectionEvaluationTableViewCell"
}

func setAttributedText(fontToBold : UIFont,fontToLight : UIFont,text : String,constantTex :String,label : UILabel){
    let boldAttribute = [NSFontAttributeName: fontToBold]
    let regularAttribute = [NSFontAttributeName: fontToLight]
    let beginningAttributedString = NSAttributedString(string: hi, attributes: regularAttribute )
    let boldAttributedString = NSAttributedString(string: text, attributes: boldAttribute)
    let endAttributedString = NSAttributedString(string: constantTex, attributes: regularAttribute )
    let fullString =  NSMutableAttributedString()
    
    fullString.appendAttributedString(beginningAttributedString)
    fullString.appendAttributedString(boldAttributedString)
    fullString.appendAttributedString(endAttributedString)
    label.attributedText = fullString
}

//MARK:- REMOVE FROM DB
func removeAllValuesFromUserDefaults(){
     DBManager.sharedManager.removeValueForKey(myUserDetails)
    DBManager.sharedManager.removeValueForKey(MEAccessToken)
    DBManager.sharedManager.removeValueForKey(myId)
    DBManager.sharedManager.removeValueForKey(meUserDetails)
    choiceDict = [:]
    questionResponseArray = []
    pickerResponseSetValues = []
     pickerSelectedValues = []
     groupIdArray =  []
     evaluationIdArray =  []
     sectionNames = []
     sectionCountArray = []
    pickerDict = [:]
}
func getUserNameFromProfile() -> String{
    var user = meNilString
    if let details = DBManager.sharedManager.fetchValueForKey(myUserDetails){
        print(details)
        if let userName = details["UserName"] as? String{
          user = userName
        }
    }
    print(user)
    return user
}
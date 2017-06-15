//
//  MEResponseChoiceModel.swift
//  Medical Evaluation
//
//  Created by Veena on 14/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation
var choiceDict = NSMutableDictionary()
class MEResponseChoiceModel {

    var section : MESection?
    var responseChoiceId : Int?
    var text : String?
    var comment : String?
    var createdDate : String?
    
    init(values: NSDictionary){
        if let evaluationDict = values["Section"] as? NSDictionary{
            self.section = MESection(values: evaluationDict)
        }
        self.responseChoiceId = values["ResponseChoiceId"] as? Int
        self.text = values["Text"] as? String
        getResponseChoiceIdAndTextFromModel()
        self.comment = values["Comment"] as? String
        self.createdDate = values["CreatedDate"] as? String
    }
    
    func getResponseChoiceIdAndTextFromModel(){
        choiceDict.setObject(self.responseChoiceId!, forKey: self.text!)
    }
}

class MESection{
    var mSectionId : Int?
    var mName : String?
    var mDescription : String?
    var mCreatedDate : Bool?
    var mLastUpdatedDate : Int?
    var questionList = [MEQuestionModel]()
     var evaluationList : MEEvaluations?
    var mIsDelete : Bool?
    
    init(values: NSDictionary){
        self.mSectionId = values["SectionId"] as? Int
        self.mName = values["Name"] as? String
        self.mDescription = values["Description"] as? String
        self.mCreatedDate = values["CreatedDate"] as? Bool
        self.mLastUpdatedDate = values["LastUpdatedDate"] as? Int
        self.mIsDelete = values["IsDelete"] as? Bool
        if let questionListDict = values["QuestionList"] as? NSArray{
            questionList = fetchingMemberList(questionListDict)
        }
        if let evaluationDict = values["Evaluation"] as? NSDictionary{
            self.evaluationList = MEEvaluations(values: evaluationDict)
        }
    }
    
    func fetchingMemberList(memberArray: NSArray) -> [MEQuestionModel]{
        if memberArray.count != 0{
            for each in memberArray as! [NSDictionary]{
                let memberList = MEQuestionModel(values: each)
                let _ = self.questionList
                self.questionList.append(memberList)
            }
        }
        print(questionList)
        return questionList
    }
}



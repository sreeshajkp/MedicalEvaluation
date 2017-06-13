//
//  SubmitResponseModel.swift
//  Medical Evaluation
//
//  Created by Veena on 13/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation

class MESubmitResponseModel {
    var response : ResponseModel?
    
    init(values: NSDictionary){
        self.response = ResponseModel(values: values)
    }
}

class ResponseModel {
    var response : MEResponseId?
    var question : MEQuestionId?
    var responseChoice : MEResponseChoiceId?
    var comment : String?
    
    init(values: NSDictionary){
        if let responseDict = values["Response"] as? NSDictionary{
       self.response = MEResponseId(values: responseDict )
        }
        if let questionDict = values["Question"] as? NSDictionary{
            self.question = MEQuestionId(values: questionDict)
        }
        if let responseChoiceDict = values["ResponseChoice"] as? NSDictionary{
          self.responseChoice = MEResponseChoiceId(values: responseChoiceDict)
        }
          self.comment = values["Comment"] as? String
    }
}

class MEResponseId {
    var responseId : Int?
    init(values: NSDictionary){
        self.responseId = values["ResponseId"] as? Int
    }
}

class MEQuestionId {
    var questionId : Int?
    init(values: NSDictionary){
        self.questionId = values["QuestionId"] as? Int
    }
}

class MEResponseChoiceId {
    var responseChoiceId : Int?
    init(values: NSDictionary){
        self.responseChoiceId = values["ResponseChoiceId"] as? Int
    }
}




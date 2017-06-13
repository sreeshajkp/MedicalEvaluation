//
//  MEStartEvaluationModel.swift
//  Medical Evaluation
//
//  Created by Veena on 12/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation

class MEStartEvaluationModel{
   var evaluator : MEEvaluator?
    var evalutee : MEEvaluatee?
    var responseId : Int?
    var startDate : String?
    var startTime : String?
   var group : MEGroup?
    
    init(values: NSDictionary){
        if let evalObj = values["Evaluator"] as? NSDictionary{
        self.evaluator = MEEvaluator(values: evalObj)
        }
        if let evaluObj = values["Evaluatee"] as? NSDictionary{
            self.evaluator = MEEvaluator(values: evaluObj)
        }
        self.responseId = values["ResponseId"] as? Int
        self.startDate = values["StartDate"] as? String
        self.startTime = values["StartTime"] as? String
        if let groupValues = values["Group"] as? NSDictionary{
            self.group = MEGroup(values: groupValues)
        }
    }
}

class MEEvaluator{
    var userId : String?
    var userName : String?
    var fullName : String?
    var contactNumber : String?
    var createdDate : String?
    var role : Int?
    var isEvaluated : Bool?
    init(values: NSDictionary){
    self.contactNumber = values["ContactNumber"] as? String
    self.createdDate = values["CreatedDate"] as? String
    self.fullName = values["FullName"] as? String
    self.isEvaluated = (values["IsEvaluated"] as? Bool)!
    self.role = values["Role"] as? Int
    self.userId = values["UserId"] as? String
    self.userName = values["UserName"] as? String
    }
}
class MEEvaluatee{
    var userId : String?
    var userName : String?
    var fullName : String?
    var contactNumber : String?
    var createdDate : String?
    var role : Int?
    var isEvaluated : Bool?
    init(values: NSDictionary){
        self.contactNumber = values["ContactNumber"] as? String
        self.createdDate = values["CreatedDate"] as? String
        self.fullName = values["FullName"] as? String
        self.isEvaluated = (values["IsEvaluated"] as? Bool)!
        self.role = values["Role"] as? Int
        self.userId = values["UserId"] as? String
        self.userName = values["UserName"] as? String
    }
}






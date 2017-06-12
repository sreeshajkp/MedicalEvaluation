//
//  MEStartEvaluationModel.swift
//  Medical Evaluation
//
//  Created by Veena on 12/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation

class MEStartEvaluationModel{
   // var evaluator :
   // var evalutee :
    var responseId : Int?
    var startDate : String?
    var startTime : String?
  //  var group :
    
    init(values: NSDictionary){
        self.responseId = values["ResponseId"] as? Int
        self.startDate = values["StartDate"] as? String
        self.startTime = values["StartTime"] as? String
    }
}

class Evaluator{
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
class Evaluatee{
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
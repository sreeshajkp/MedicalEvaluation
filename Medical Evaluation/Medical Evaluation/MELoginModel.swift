//
//  MELoginModel.swift
//  Medical Evaluation
//
//  Created by Veena on 07/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//
import Foundation

class MELoginModel{
    var  accessToken : String?
    var contactNumber : String?
    var createdDate : String?
    var fullName : String?
    var isEvaluated : Bool
    var role : Int?
    var userId : String?
    var userName : String?
    
    
    init(values: NSDictionary){
        self.accessToken = values["AccessToken"] as? String
        self.contactNumber = values["ContactNumber"] as? String
        self.createdDate = values["CreatedDate"] as? String
        self.fullName = values["FullName"] as? String
        self.isEvaluated = (values["IsEvaluated"] as? Bool)!
        self.role = values["Role"] as? Int
        self.userId = values["UserId"] as? String
        self.userName = values["UserName"] as? String
    }
    
}
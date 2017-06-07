//
//  MEProfileModel.swift
//  Medical Evaluation
//
//  Created by Veena on 07/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation

class MEProfileModel{
    var contactNumber : String?
    var createdDate : String?
    var fullName : String?
    var isEvaluated : Int?
    var role : Int?
    var userId : String?
    var userName : String?
    
    init(values: NSDictionary){
        contactNumber = values["ContactNumber"] as? String
        createdDate = values["CreatedDate"] as? String
        fullName = values["FullName"] as? String
        isEvaluated = values["IsEvaluated"] as? Int
        role = values["Role"] as? Int
        userId = values["UserId"] as? String
        userName = values["UserName"] as? String
    }
}
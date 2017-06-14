//
//  MEGroupListModel.swift
//  Medical Evaluation
//
//  Created by Veena on 08/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation

class MEGroupListModel{
    
var createdDate : String?
var evaluation : MEEvaluation?
var memberList  = [MEMemberList]()
var groupId : Int?
var lastUpdatedDate : String?
var name : String?
var wardName : String?

init(values : NSDictionary){
    self.createdDate = values["CreatedDate"] as? String
    if let evaluationDict = values["Evaluation"] as? NSDictionary{
     self.evaluation = MEEvaluation(values: evaluationDict)
    }
     self.groupId = values["GroupId"] as? Int
     self.lastUpdatedDate = values["LastUpdatedDate"] as? String
    if let memberListArray = values["MemberList"] as? NSArray{
        memberList = fetchingMemberList(memberListArray)
    }
     self.name = values["Name"] as? String
     self.wardName = values["Name"] as? String
}
    
    func fetchingMemberList(memberArray: NSArray) -> [MEMemberList]{
        if memberArray.count != 0{
            for each in memberArray as! [NSDictionary]{
                let memberList = MEMemberList(values: each)
                 let _ = self.memberList
                    self.memberList.append(memberList)
            }
        }
        print(memberList)
        return memberList
    }
}

class MEEvaluation{
    var eCreatedDate : String?
    var eDescription : String?
    var eEvaluationId : Int?
    var eLastUpdatedDate : String?
    var eName : String?

    init(values: NSDictionary){
        self.eCreatedDate = values["CreatedDate"] as? String
        self.eDescription = values["Description"] as? String
        self.eEvaluationId = values["EvaluationId"] as? Int
        self.eLastUpdatedDate = values["LastUpdatedDate"] as? String
        self.eName = values["Name"] as? String
    }
}


class MEMemberList{
    var mContactNumber : String?
    var mCreatedDate : String?
    var mFullName : String?
    var misEvaluated : Bool?
    var mRole : Int?
    var mUserId : String?
    var mUserName : String?
    
    init(values: NSDictionary){
        self.mContactNumber = values["ContactNumber"] as? String
        self.mCreatedDate = values["CreatedDate"] as? String
        self.mFullName = values["FullName"] as? String
        self.misEvaluated = values["IsEvaluated"] as? Bool
        self.mRole = values["Role"] as? Int
        self.mUserId = values["UserId"] as? String
        self.mUserName = values["UserName"] as? String
        
    }
    
}


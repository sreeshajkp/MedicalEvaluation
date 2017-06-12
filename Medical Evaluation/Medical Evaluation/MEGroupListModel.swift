//
//  MEGroupListModel.swift
//  Medical Evaluation
//
//  Created by Veena on 08/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation

class MEGroupListModel{

var userId : String?
var userName : String?
var fullName : String?
var contactNumber : String?
var createdDate : String?
var role : Int?
var isEvaluation : Bool?
var group : MEGroup?
    

    

var memberList : [MEMemberList]?




init(values : NSDictionary){
     self.userId = values["UserId"] as? String
    self.contactNumber = values["ContactNumber"] as? String
    self.role = values["Role"] as? Int
    self.isEvaluation = values["IsEvaluated"] as? Bool
     self.userName = values["UserName"] as? String
   self.fullName = values["FullName"] as? String
    self.createdDate = values["CreatedDate"] as? String
//    if let groupValues = values["Group"] as! NSArray{
//        
//    }
    if let memberListArray = values["MemberList"] as? NSArray{
        memberList = fetchingMemberList(memberListArray)
    }

}
    
    func fetchingMemberList(memberArray: NSArray) -> [MEMemberList]{
        if memberArray.count != 0{
            for each in memberArray as! [NSDictionary]{
                let memberList = MEMemberList(values: each)
                 let _ = self.memberList
                    self.memberList = [memberList]
            }
        }
        print(memberList)
        return memberList!
    }
}

class MEEvaluation{
     var eEvaluationId : Int?
     var eName : String?
     var eDescription : String?
    var eCreatedDate : String?
    var eLastUpdatedDate : String?
//    var sectionList : []

    init(values: NSDictionary){
        self.eCreatedDate = values["CreatedDate"] as? String
        self.eDescription = values["Description"] as? String
        self.eEvaluationId = values["EvaluationId"] as? Int
        self.eLastUpdatedDate = values["LastUpdatedDate"] as? String
        self.eName = values["Name"] as? String
      //  if let
    }
}

class MEGroup{
    var groupId : Int?
    var name : String?
    var wardName : String?
    var lastUpdatedDate : String?
    var createdDate : String?
    var evaluation : MEEvaluation?
    init(values: NSDictionary){
        self.groupId = values["GroupId"] as? Int
        self.name = values["Name"] as? String
        self.wardName = values["WardName"] as? String
        self.lastUpdatedDate = values["LastUpdatedDate"] as? String
        self.createdDate = values["CreatedDate"] as? String
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


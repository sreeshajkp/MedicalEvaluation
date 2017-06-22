//
//  MEProfileModel.swift
//  Medical Evaluation
//
//  Created by Veena on 07/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

//
//  MEGroupListModel.swift
//  Medical Evaluation
//
//  Created by Veena on 08/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation

class MEProfileModel{
    
    var userId : String?
    var userName : String?
    var fullName : String?
    var contactNumber : String?
    var createdDate : String?
    var role : Int?
    var isEvaluation : Bool?
    var group : MEGroup?
    
    init(values : NSDictionary){
        self.userId = values["UserId"] as? String
        self.contactNumber = values["ContactNumber"] as? String
        self.role = values["Role"] as? Int
        self.isEvaluation = values["IsEvaluated"] as? Bool
        self.userName = values["UserName"] as? String
        self.fullName = values["FullName"] as? String
        self.createdDate = values["CreatedDate"] as? String
        if let groupValues = values["Group"] as? NSDictionary{
              self.group = MEGroup(values: groupValues)
        }
     }
    }


class MEEvaluations{
    var eEvaluationId : Int?
    var eName : String?
    var eDescription : String?
    var eCreatedDate : String?
    var eLastUpdatedDate : String?
    var eSectionList = [MESectionList]()
    
    init(values: NSDictionary){
        self.eCreatedDate = values["CreatedDate"] as? String
        self.eDescription = values["Description"] as? String
        self.eEvaluationId = values["EvaluationId"] as? Int
        self.eLastUpdatedDate = values["LastUpdatedDate"] as? String
        self.eName = values["Name"] as? String
        if let sectionList = values["SectionList"] as? NSArray{
            DBManager.sharedManager.insertValue(sectionList.count, forKey: sectionCount)
          eSectionList =  fetchingSectionListList(sectionList)
        }
    }
    func fetchingSectionListList(memberArray: NSArray) -> [MESectionList]{
        sectionNames = []
        sectionCountArray = []
        for each in memberArray{
            if  let name = each["Name"] {
                sectionNames.append(name as! String)
            }
            if  let name = each["SectionId"] {
                sectionCountArray.append(name as! Int)
            }
        }
        if memberArray.count != 0{
            for each in memberArray as! [NSDictionary]{
            
                let memberList = MESectionList(values: each)
                let _ = eSectionList
                self.eSectionList.append(memberList)
            }
        }
        return eSectionList
    }
}


class MEGroup{
    var groupId : Int?
    var name : String?
    var wardName : String?
    var lastUpdatedDate : String?
    var createdDate : String?
    var evaluation : MEEvaluations?
    init(values: NSDictionary){
        self.groupId = values["GroupId"] as? Int
        groupIdVal = (values["GroupId"] as? Int)!
        self.name = values["Name"] as? String
        self.wardName = values["WardName"] as? String
        self.lastUpdatedDate = values["LastUpdatedDate"] as? String
        self.createdDate = values["CreatedDate"] as? String
        if let evaluationDict = values["Evaluation"] as? NSDictionary{
            evaluation = MEEvaluations(values: evaluationDict)
        }
    }
}


class MESectionList{
    var mSectionId : Int?
    var mName : String?
    var mDescription : String?
    var mCreatedDate : Bool?
    var mLastUpdatedDate : Int?
    var mIsDelete : Bool?
    
    init(values: NSDictionary){
        self.mSectionId = values["SectionId"] as? Int
        self.mName = values["Name"] as? String
        self.mDescription = values["Description"] as? String
        self.mCreatedDate = values["CreatedDate"] as? Bool
        self.mLastUpdatedDate = values["LastUpdatedDate"] as? Int
        self.mIsDelete = values["IsDelete"] as? Bool
        
    }
    
   
}




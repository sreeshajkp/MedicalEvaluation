//
//  MEMemberListModel.swift
//  Medical Evaluation
//
//  Created by Veena on 14/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation

class MEMemberListModel{
    var group : MEGroup?
    var member = [MEMemberList]()
    
    init(values : NSDictionary){
        if let group = values["Group"] as? NSDictionary{
            self.group = MEGroup(values: group)
        }
        if let members = values["Member"] as? NSArray {
          member =  fetchingMemberList(members)
        }
    }
    func fetchingMemberList(memberArray: NSArray) -> [MEMemberList]{
        pickerDict = [:]
        for each in memberArray{
              let role = each["Role"] as? Int
                let eval = each["IsEvaluated"] as? Bool
                let userName = each["UserName"] as? String
                    if role == 5 && eval == false && userName != getUserNameFromProfile() {
                        if let name = each["FullName"] as? String{
                            let nameUser = each["UserName"] as? String
                            pickerDict.setObject(nameUser!, forKey: name)
                        }
                        else{
                            let nameUser = each["UserName"] as? String
                            pickerDict.setObject(nameUser!, forKey: "null")
                }
                print(pickerDict)
            }
        }
        if memberArray.count != 0{
            for each in memberArray as! [NSDictionary]{
                let memberList = MEMemberList(values: each)
                self.member.append(memberList)
            }
        }
        print(member)
        return member
    }
}

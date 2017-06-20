//
//  ModelManager.swift
//  MepLinks
//
//  Created by Sreeshaj  on 20/07/16.
//  Copyright © 2016 InApp. All rights reserved.
//

import Foundation
import UIKit

enum ModelType:String {
    case MELoginModel            = "MELoginModel"
    case MEProfileModel           = "MEProfileModel"
    case MEGroupListModel       = "MEGroupListModel"
    case MEQuestionModel   = "MEQuestionModel"
    case MESubmitResponseModel   = "MESubmitResponseModel"
    case MEStartEvaluationModel   = "MEStartEvaluationModel"
    case MEEvaluations = "MEEvaluations"
    case MEMemberListModel = "MEMemberListModel"
    case MEchoiceModel = "MEchoiceModel"
}

class ModelClassManager{
    class var sharedManager: ModelClassManager {
        struct Static {
            static var instance: ModelClassManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = ModelClassManager()
        }
        return Static.instance!
    }
    
    func createModelArray(data:NSArray,modelType:ModelType) -> NSArray {
        var results = [AnyObject]()
        if data.count != 0{
            for eachData in data as! [NSDictionary]{
                var object:AnyObject?
                switch modelType {
                case .MELoginModel:  object              = MELoginModel(values: eachData)
                case .MEProfileModel: object              = MEProfileModel(values: eachData)
                case .MEGroupListModel: object          = MEGroupListModel(values: eachData)
                case .MEQuestionModel : object   = MEQuestionModel(values: eachData)
                case .MESubmitResponseModel : object = MESubmitResponseModel(values: eachData)
                case .MEStartEvaluationModel : object = MEStartEvaluationModel(values: eachData)
                case .MEEvaluations : object = MEEvaluations(values: eachData)
                case .MEMemberListModel : object = MEMemberListModel(values: eachData)
                case .MEchoiceModel : object = MEResponseChoiceModel(values: eachData)
              
                }
                results.append(object!)
                print(results)
            }
        }
        return results
    }
}




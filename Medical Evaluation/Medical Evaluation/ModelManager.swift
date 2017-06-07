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
                           default:
                    break
                }
                results.append(object!)
                print(results)
            }
        }
        return results
    }
}


//MAR:-  calling format

// ModelClassManager.sharedManager.createModelArray(userArray, modelType: .MEPUser) as! [MEPUser]
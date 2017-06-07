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
    case MEPUser            = "MEPUser"
    case MEPShortage        = "MEPShortage"
    case MEPMainCategory    = "MEPMainCategory"
    case MEPCategory        = "MEPCategory"
    case MEPCountry         = "MEPCountry"
    case MEPAddShortageAttribute = "MEPAddShortageAttribute"
    case MEPAttributes      = "MEPAttributes"
    case MEPSurplus        = "MEPSurplus"
    case MEPDashBoardSurplus = "Surplus"
    case MEPDashBoardShortage = "Shortage"
    case MEPDashBoardLaunches = "Launches"
    case MEPDashBoardTraders = "Traders"
    case SUBrandDetail = "SUBrandDetail"
    case MEPManufacture = "MEPManufacture"
    case MEPServiceProvider = "MEPServiceProvider"
    case MEPServiceProviderDetails = "MEPServiceProviderDetails"
    case MEPReview = "MEPReview"
    case CurrespondService = "CurrespondService"
    case MEPTraders = "TradersList"
    case MEPMyServiceProvider = "MEPMyServiceProvider"
    case MEPTraderDetails = "MEPTraderDetails"
    //case MEPChat           = "MEPChat"
    case MEPGeneralProduct          = "MEPGeneralProduct"
    case MEPPlan = "MEPPlan"
    case MEPChat           = "MEPChat"
    case MEPChatMessages   = "MEPChatMessages"
    //SearchResults
    case MEPGeneralAttributeCategory          = "MEPGeneralAttributeCat"
    case MEPGeneralAttributeBrand          = "MEPGeneralAttributeBrand"
    case MEPGeneralAttribute = "MEPgenAttri"
    case chatRoom = "chatRoom"
    case MEPManufactureDetail = "MEPManufactureDetail"
    case MEPOffer = "MEPOffer"
    case MEPSubcontractor = "MEPSubcontractor"
    case MEPCompany = "MEPCompany"
    case MEPFooterAd = "MEPFooterAd"
    case MEPAlert = "MEPAlert"
    case MEPWallet = "MEPWallet"
    case MEPContact = "MEPContact"
   case MEPCarrier = "MEPCarrier"
    case MEPPlanPager =  "MEPPlanPager"
    case MEPPlanSlot = "MEPPlanSlot"
    
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
                case .MEPUser:  object              = MEPUser(values: eachData)
                case .MEPShortage:  object          = MEPShortage(values: eachData)
                case .MEPMainCategory:  object      = MEPMainCategory(values: eachData)
                case .MEPCategory:  object          = MEPCategory(values: eachData)
                case .MEPCountry:  object           = MEPCountry(values: eachData)
                case .MEPAddShortageAttribute:object  = MEPAddShortageAttribute(values: eachData)
                case .MEPAttributes:object      = MEPAttributes(values: eachData)
                case .MEPSurplus:object         = MEPSurplus(values: eachData)
                case .MEPDashBoardSurplus:object = MEPDashBoard(values:eachData , Withtype: .Surplus)
                case .MEPDashBoardShortage:object = MEPDashBoard(values:eachData , Withtype: .Shortage)
                case .MEPDashBoardLaunches:object = MEPDashBoard(values:eachData , Withtype: .Launches)
                case .MEPDashBoardTraders:object = MEPDashBoard(values:eachData , Withtype: .Traders)
                case .MEPChat:object               = MEPchatData(values: eachData)
                case .MEPGeneralProduct:object = MEPGeneralProduct(values:eachData )
                case .MEPChatMessages:object       = MEPMessageModel(values: eachData)
                case .MEPPlan:object               = MEPPlan(values: eachData)
                case .MEPGeneralAttribute:object =  MEPGeneralAttribute(values: eachData, AndType: "")
                case .SUBrandDetail:object          = SUBrandDetail(values: eachData)
                case .MEPManufacture:object               = MEPManufacture(values: eachData)
                case .MEPServiceProvider:object               = MEPServiceProvider(values: eachData)
                case .MEPServiceProviderDetails:object     = MEPServiceProviderDetails(values: eachData)
                case .MEPReview:object = MEPReview(values:eachData)
                case .CurrespondService:object = CurrespondService(values:eachData)
                case .MEPTraders:object = MEPTrader(values: eachData)
                case .MEPMyServiceProvider:object = MEPMyServiceProvider(values: eachData)
                //MEPTraderDetails
                case .MEPTraderDetails:object = MEPTraderDetails(values: eachData)
                case .chatRoom:object = chatRoom(values: eachData)
                case .MEPManufactureDetail:object = MEPManufactureDetail(values:eachData)
                case .MEPOffer:object = MEPOffer(values:eachData)//MEPCompany
                case .MEPSubcontractor:object = MEPSubcontractor(values:eachData)
                case .MEPCompany:object = MEPCompany(values:eachData)
                case . MEPFooterAd:object = MEPFooterAd(values:eachData)
                case . MEPAlert:object = MEPAlert(values:eachData)
                case . MEPWallet:object = MEPWallet(values:eachData)
                case . MEPContact:object = MEPContact(values:eachData)
                case . MEPCarrier:object = MEPCareer(values:eachData)
                case .MEPPlanPager: object = MEPPlanPager(values: eachData)
                case .MEPPlanSlot: object = MEPPlanSlot(values: eachData)

                default:
                    break
                }
                results.append(object!)
            }
        }
        return results
    }
    
    func createModelArrayMEPAtributes(data:NSArray,modelType:ModelType) -> [MEPGeneralAttribute] {
        var results = [MEPGeneralAttribute]()
        if data.count != 0{
            for eachData in data as! [NSDictionary]{
                var object:AnyObject?
                results.append( MEPGeneralAttribute(values: eachData, AndType: ""))
            }
        }
        return results
    }
    
    
    func createModelArrayMEPAtributesOfManufacturer(data:NSDictionary,modelTypeString:String) -> MEPGeneralAttribute {
        print("ysss\(data)")
        let filterAttribute =  MEPGeneralAttribute(values: data, AndType: modelTypeString)
        return filterAttribute
    }
    
    
    func createModelForAttributeMapping(data:NSDictionary,modelType:ModelType) -> MEPGeneralAttribute {
        let dic = NSDictionary()
        let returnObj = MEPGeneralAttribute(values:dic, AndType: "")
        if data.count != 0{
            
            switch modelType {
            case .MEPGeneralAttributeCategory:
                return MEPGeneralAttribute(values: data, AndType: CategoryTypeResults)
            case .MEPGeneralAttributeBrand:
                return MEPGeneralAttribute(values: data, AndType:BrandTypeResults)
            default:
                break
            }
            
            
        }
        return returnObj
    }
    
    
    func createMyPlanModel(data:NSDictionary)->MyPlanModel
    {
        var myPlanModel = MyPlanModel()
        if let totalSlots = data["slots_available"] as?     Int
        {
            myPlanModel.totalSlots = totalSlots
        }
        if let usedSlots = data["slots_used"] as?     Int
        {
            myPlanModel.usedSlots = usedSlots
        }
        if let myPlansArray = data["occupied_plans"] as? NSArray
        {
            let myPlans = ModelClassManager.sharedManager.createModelArray(myPlansArray, modelType: .MEPPlan) as! [MEPPlan]
            myPlanModel.myPlansArray =  myPlans
        }
        if let myPlansArray = data["free_plans"] as? NSArray
        {
            let myPlans = ModelClassManager.sharedManager.createModelArray(myPlansArray, modelType: .MEPPlan) as! [MEPPlan]
            if let data = myPlanModel.myPlansArray
            {
                myPlanModel.myPlansArray! += myPlans
            }
        }
        return myPlanModel
    }
    
    
}



//MAR:-  calling format

// ModelClassManager.sharedManager.createModelArray(userArray, modelType: .MEPUser) as! [MEPUser]
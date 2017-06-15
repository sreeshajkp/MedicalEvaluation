//
//  DBManager.swift
//  MepLinks
//
//  Created by Sreeshaj  on 18/07/16.
//  Copyright © 2016 InApp. All rights reserved.
//

import Foundation


class DBManager {
    
    let userDefaults  = NSUserDefaults.standardUserDefaults()
    
    class var sharedManager: DBManager {
        struct Static {
            static var instance: DBManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = DBManager()
        }
        return Static.instance!
    }
    
    func insertValue(data:AnyObject?, forKey key:String){
        guard let details = data else{
            return
        }
            userDefaults.setObject(details, forKey: key)
          userDefaults.synchronize()
        }
        
        
    func fetchValueForKey(key:String) -> AnyObject?{
        guard let details = userDefaults.valueForKey(key) else{
            return nil
        }
        return details
    }
    
    func removeValueForKey(Key:String){
        if let _ = fetchValueForKey(Key)
        {
            userDefaults.removeObjectForKey(Key)
            userDefaults.synchronize()
        }
    }
    
    func setChoiceIds(choices:[MEResponseChoiceModel]) -> Dictionary<String,AnyObject>{
        
        
        var choiceIdsDict = Dictionary<String,AnyObject>()
        
        for choice in choices{
            
            if let choiceId = choice.responseChoiceId{
                
                var questionIds = [Int]()
                
                for question in (choice.section?.questionList)!{
                    if let questionObj = question as? MEQuestionModel{
                        questionIds.append(questionObj.questionId!)
                    }
                }
                
                choiceIdsDict["\(choiceId)"] = questionIds
            }
        }
        
        print("section question choiceIds :",choiceIdsDict)
        
        return choiceIdsDict
        
    }
    //MARK:- GetTextwrtChoiceId
    func getPickerForResponseChoiceId() -> [String]{
        var choiceValues = [String]()
        var allValues = choiceDict.allValues
        for each in allValues {
            switch each as! Int{
            case ChoiceId.Yes.rawValue:
                choiceValues.append(MEAlertYes)
            case ChoiceId.No.rawValue:
                choiceValues.append(MEAlertNo)
            default:
                break;
            }
        }
        return choiceValues
    }

func moveToTabBarView(){
    let appDeligate = UIApplication.sharedApplication().delegate as! AppDelegate
    let loginVC = mainStoryboard.instantiateViewControllerWithIdentifier(MEStoryBoardIds().meStoryBoardIds.meTabBarViewController)
    appDeligate.window?.rootViewController = loginVC
    appDeligate.window?.makeKeyAndVisible()
    }
}




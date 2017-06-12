//
//  MEQuestionListModel.swift
//  Medical Evaluation
//
//  Created by Veena on 12/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation
class MEQuestionListModel {
    var questionId : Int?
    var text : String?
    var textBoxFlag : Bool?
    var createdDate : String?
    
    init(values: NSDictionary){
        self.questionId = values["QuestionId"] as? Int
        self.text = values["Text"] as? String
        self.textBoxFlag = values["TextBoxFlag"] as? Bool
        self.createdDate = values["CreatedDate"] as? String
    }
}

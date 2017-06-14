//
//  APIUrls.swift
//  Medical Evaluation
//
//  Created by Veena on 07/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation


class MEApiUrls{
    let MELogin  = Login()
    let MELogout  = LogOut()
    let MEGetProfile  = GetProfile()
    let MEGetUsersProfile = GetUsersProfile()
    let MEGetGroupList = GetGroupList()
    let MEGetQuestionList =  GetQuestionList()
     let MESubmitQuestionList =  GetQuestionSubmit()
    let MEGetStudentList =  GetStudentList()
     let MEGetStartList =  GetStartList()
     let MEGetMyEvaluationList =  GetMyEvaluationList()
    let MEGetMemberList =  GetMemberList()
    let MEGetStopEvaluation =  GetStopEvaluation()
    
}

struct Login {
    let loginUrl = "Api/Account/Login"
}
struct LogOut{
    let logOutUrl = "Api/Account/Logout?accessToken=%@"
}
struct GetProfile{
    let getProfileUrl = "Api/Account/Get?accessToken=%@"
}
struct GetUsersProfile{
    let getUsersProfile = "Api/Account/GetUserList?accessToken=%@&take=%d&skip=%d&filterType=%d"
}
struct GetGroupList {
    let  getGroupList = "Api/Group/GetList?accessToken=%@&take=%d&skip=%d"
}
struct GetQuestionList {
    let  getQuestionList = "Api/Question/GetList?accessToken=%@&sectionId=%d&take=%d&skip=%d"
}
struct GetQuestionSubmit {
    let  getQuestionSubmit = "Api/Response/Submit?accessToken=%@"
}
struct GetStudentList{
     let  getStudentList = "Api/Account/GetStudentList?accessToken=%@&take=%d&skip=%d&filterType=%d"
}
struct GetStartList{
    let  getStartList = "Api/Response/Start?accessToken=%@&groupdId=%d&evaluationId=%d&userName=%@"
}
struct GetMyEvaluationList{
    let  getMyEvaluationList = "Api/Evaluation/Get?accessToken=%@&evaluationId=%d"
}
struct GetMemberList{
    let  getMemberList = "Api/Account/GetMemberList?accessToken=%@&take=%d&skip=%d"
}
struct GetStopEvaluation{
    let  getStopEvaluation = "/Api/Response/End?accessToken=%@&responseId=%d"
}


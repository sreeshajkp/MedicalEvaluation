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
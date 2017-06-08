//
//  Constants.swift
//  Medical Evaluation
//
//  Created by Veena on 07/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation

let MEBASE_URLS = "http://medeval.azurewebsites.net/"

//MARK:- App Name
let MEAppName = "Medical Evaluation"

//MARK:- Alert Buttons
let MEAlertCancel = "Cancel"
let MEAlertOK = "OK"
let MEAlertYes = "Yes"
let MEAlertNo = "No" //

//MARK:- Alert Constants
let MEusername = "username"

//MARK:- Constants
let MEAccessToken = "AccessToken"
var emptyFields = "Please fill the %@ field"
var hi = "Hi"

//MARK:- Response Constants
let MEResponseStatus = "status"
let MEResponseMessage = "message"
let MEResponseContent = "content"

//MARK:- Alert Messages
let noNetworkMsg = "Please check your internet connectivity!"
let serverErrorMsg = "Server Error.Try again later!"
let kEnterEmailOrUsername = "Please enter the Username"
let logOutMsg = "Logout successfully!"


//MARK:- JSON Keys
let JaccessToken = "AccessToken"
let jSuccess = "Success"
let jContentType = "Content-Type"
let jApplicationJSON = "application/json"
let jError = "Error"
let jDeviceType = "DeviceType"
let jDeviceID = "DeviceID"
let jRegistrationID = "RegistrationID"
let jUsername = "UserName"
let jPassword = "Password"
let jDevice = "Device"

//MARK:- Segues Names
class MEseguesNames{
    let seguesToLogin = SeguesToLoginPage()
}
struct  SeguesToLoginPage{
    let loginSegue = "LoginSegue"
}

//MARK:- Method Names

class MEmethodNames{
    let meMethodNames = MeMethods()
}
struct  MeMethods{
    let MELoginMethod = "MELoginMethod"
    let MEGetUsersMethod = "MEGetUsersMethod"
    let MEGetProfileMethod = "MEGetProfileMethod"
    let MELogoutMethod = "MELogoutMethod"
    let MEGetGroupListMethod = "MEGetGroupListMethod"
}

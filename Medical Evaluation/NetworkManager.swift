
//
//  NetworkManager.swift
//  SMART MI
//
//  Created by Sibi on 03/02/16.
//  Copyright Â© 2016 InApp. All rights reserved.
//

import Foundation

class NetworkManager {
    
    var delegate:MEDelegate?
    
    class var sharedManager: NetworkManager {
        struct Static {
            static var instance: NetworkManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = NetworkManager()
        }
        return Static.instance!
    }
    
 
    
    //MARK:-  POST Method
    
    func postDetails(detailDictionary : NSDictionary, methodName : String, appendUrl : String){
        
        if !isInternetAvailable(){
            self.delegate?.networkAPIResultFetchedWithError!(noNetworkMsg, methodName: methodName,status: 0)
            return
        }
        
        let url = MEBASE_URLS.stringByAppendingString(appendUrl)
        
        print("final url is :",url)
        let completeUrlPath = NSURL(string: url)
        
        let registerRequest = NSMutableURLRequest(URL: completeUrlPath!)
        let session = NSURLSession.sharedSession()
        
        if NSJSONSerialization.isValidJSONObject(detailDictionary){
            
            registerRequest.HTTPMethod = "POST"
            registerRequest.setValue(jApplicationJSON, forHTTPHeaderField: jContentType)
            registerRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(detailDictionary, options: [])
            
            let task = session.dataTaskWithRequest(registerRequest) { (data, response, error) -> Void in
                
                var isSuccess = false
                var errorMessage = ""
                if error != nil {
                    print(error!.description)
                    errorMessage = serverErrorMsg
                }
                else {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        if httpResponse.statusCode == 200{
                            if data!.length != 0 {
                                do {
                                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                                    if jsonResult is NSDictionary{
                                        if httpResponse.statusCode as! Int == 200{
                                                isSuccess = true
                                             
                                                    print(self.delegate)
                                                    self.delegate?.networkAPIResultFetched!(jsonResult, message: jSuccess, methodName: methodName)
                                                
                                        }
                                      else  {
                                                
                                                if let message = jsonResult[MEResponseMessage] as? String{
                                                    errorMessage = message
                                                    isSuccess = true
                                                    let status = jsonResult[MEResponseStatus] as! Int
                                                    
                                                    self.delegate?.networkAPIResultFetchedWithError!(errorMessage, methodName: methodName,status: status)
                                                
                                            }
                                        }
                                        
                                    }
                                    
                                    // use anyObj here
                                } catch
                                {
                                    print("json error: \(error)")
                                    errorMessage = serverErrorMsg
                                }
                            }
                        }
                        else{
                            errorMessage = serverErrorMsg
                        }
                    } else {
                        print("Can't cast response to NSHTTPURLResponse")
                    }
                }
                
                if !isSuccess{
                        self.delegate?.networkAPIResultFetchedWithError!(errorMessage, methodName: methodName,status: 0)
                }
            }
            task.resume()
            
        }
    }
     //MARK:-  GET Method
    
    func getDetails(methodName : String, appendUrl : String)  {
        if !isInternetAvailable(){
            self.delegate?.networkAPIResultFetchedWithError!(noNetworkMsg, methodName: methodName, status: 0)
            return
        }
        let request : NSMutableURLRequest = NSMutableURLRequest()
        var completeUrlPath : NSURL?
        let url = MEBASE_URLS.stringByAppendingString(appendUrl)
        print(url)
        completeUrlPath = NSURL(string: url)
        request.URL = completeUrlPath
        request.HTTPMethod = "GET"
        request.setValue(jApplicationJSON, forHTTPHeaderField: jContentType)

        print(request)
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        
        session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            var isSuccess = false
            var jsonResult : AnyObject?
            if error == nil{
                do {
                    print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                    jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: [.MutableContainers,.AllowFragments,.MutableLeaves])
                    
                    if jsonResult is NSDictionary || jsonResult is NSArray {
                        if let httpResponse = response as? NSHTTPURLResponse{
                       if httpResponse.statusCode == 200{
                                isSuccess = true
                                    print(self.delegate)
                                    self.delegate?.networkAPIResultFetched!(jsonResult!, message: jSuccess, methodName: methodName)
                        }
                        else   {
                            
                                print(self.delegate)
                                self.delegate?.networkAPIResultFetchedWithError!(jError, methodName: methodName, status: 0)
                        }
                        }
                    }
                }
                catch  let error as NSError{
                    // TODO: handle
                    print(error.localizedDescription)
                }
            }
            else{
                // TODO: handle
            }
            if !isSuccess{
                var errorMessage : String = ""
                if let _ = jsonResult{
                    if jsonResult is NSDictionary{
                        if jsonResult?[MEResponseStatus] as! Int == 0{
                            if  let errMsg = jsonResult![MEResponseMessage] as? String {
                                errorMessage = errMsg
                            }
                        }
                    }
                }
                else if let _ = error{
                    errorMessage = serverErrorMsg
                }
                
                    if error?.code !=  NSURLErrorTimedOut {
                        self.delegate?.networkAPIResultFetchedWithError!(errorMessage, methodName: methodName, status: 0)
                    }
            }
            }.resume()
    }
    
    
}

    
    
    

    


//
//  NetworkManager.swift
//  SMART MI
//
//  Created by Sibi on 03/02/16.
//  Copyright Â© 2016 InApp. All rights reserved.
//

import Foundation

enum HttpMethod : String{
    case POST = "POST"
    case GET = "GET"
}

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
    

    func apiCallHandler(detailDictionary : AnyObject, methodName : String, appendUrl : String){
        if !isInternetAvailable(){
            self.delegate?.networkAPIResultFetchedWithError!(noNetworkMsg, methodName: methodName)
            return
        }
        print(delegate)
        let url = MEBASE_URLS.stringByAppendingString(appendUrl)
        print("final url is :",url)
        let completeUrlPath = NSURL(string: url)
        let registerRequest = NSMutableURLRequest(URL: completeUrlPath!)
        registerRequest.setValue(jApplicationJSON, forHTTPHeaderField: jContentType)
        if detailDictionary.count > 0{
            registerRequest.HTTPMethod = HttpMethod.POST.rawValue
            do{
                let jsonData = try NSJSONSerialization.dataWithJSONObject(detailDictionary, options: [])
                registerRequest.HTTPBody = jsonData
            }
            catch  let error as NSError{
                print(error.localizedDescription)
                self.delegate?.networkAPIResultFetchedWithError!(serverErrorMsg, methodName: methodName)
            }
        }
        else{
          registerRequest.HTTPMethod = HttpMethod.GET.rawValue
        }
        let session = NSURLSession.sharedSession()
        _ = session.dataTaskWithRequest(registerRequest) { (data, response, error) in
          _ = meNilString
            var jsonResult : AnyObject?

            if error == nil{
                do {
                    print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                    jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: [.MutableContainers,.AllowFragments,.MutableLeaves])
                    
                    if jsonResult is NSDictionary || jsonResult is NSArray {
                        if let httpResponse = response as? NSHTTPURLResponse{
                            if httpResponse.statusCode == 200{
                                print(self.delegate)
                                if jsonResult != nil{
                                self.delegate?.networkAPIResultFetched!(jsonResult!, message: jSuccess, methodName: methodName)
                                }
                            }
                            else   {
                                
                                print(self.delegate)
                                self.delegate?.networkAPIResultFetchedWithError!(serverErrorMsg, methodName: methodName)
                            }
                        }
                    }
                    else{
                         self.delegate?.networkAPIResultFetchedWithError!(serverErrorMsg, methodName: methodName)
                    }
                }
                catch  let error as NSError{
                    // TODO: handle
                    print(error.localizedDescription)
                    self.delegate?.networkAPIResultFetchedWithError!(serverErrorMsg, methodName: methodName)

                }
            }
        }.resume()
    }
    
}

    
    
    

    

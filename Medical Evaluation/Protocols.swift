//
//  Protocols.swift
//  Medical Evaluation
//
//  Created by Veena on 07/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation

@objc protocol MEDelegate
{
    optional func networkAPIResultFetched(result:AnyObject,message:String,methodName:String)
    optional func networkAPIResultFetchedWithError(error:AnyObject,methodName:String)
}
//
//  FileClient.swift
//  BaseProject
//
//  Created by wangyong on 15/2/3.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

import UIKit

class FileClient: RequestConfig {
   
    var _networking_state : Int = 0;
    
    class var shareInstance: FileClient {
        get {
            struct Static {
                static var instance: FileClient? = nil
                static var token: dispatch_once_t = 0
            }
            dispatch_once(&Static.token, {
                Static.instance = FileClient()
            })
            return Static.instance!
        }
    }
    
    
    override init() {
        super.init()
        
        let reachability = Reachability.reachabilityForInternetConnection()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: reachability)
        
        reachability.startNotifier()
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                _networking_state = 0
                println("Reachable via WiFi")
            } else {
                _networking_state = 1
                println("Reachable via Cellular")
            }
        } else {
            _networking_state = 2
            println("Not reachable")
        }
    }
}

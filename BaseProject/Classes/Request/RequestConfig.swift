//
//  RequestConfig.swift
//  BaseProject
//
//  Created by wangyong on 15/2/3.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

import UIKit

class RequestConfig: NSObject {
    
    private func getServerURL()-> NSString{
        return ""
    }
    
    private func getApiVersion()-> NSString{
        return "1"
    }
    
    public func getRequestURL(api: NSString)-> NSString{
        return [NSString stringWithFormat:"https://api.71ao.cn/%@/%@",getApiVersion(),api];
    }
   
}

//
//  RequestSend.swift
//  BaseProject
//
//  Created by wangyong on 15/2/3.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

import UIKit


//uploadtype
enum UploadType{
    case UploadTypePicture
    case UploadTypeVoice
} ;

enum APIResponceCode: Int
{
    case CODE_SUCCESS = 0
    case CODE_ERROR = 1
    case CODE_NEED_AUTH = 2
};

class RequestSend: AFHTTPRequestOperationManager {
    
    let TIME_OUT_INTERVAL: NSTimeInterval = 30.0
    var _request_url: NSString?
    var _param: NSMutableDictionary?
    
    
    var _dele: AnyObject?
    var _complete_selector: Selector = ""
    var _error_selector: Selector = ""
    var _use_post: Bool = true
    var _cholicy: NSURLRequestCachePolicy?
//    
//    
//  
    class func requestSenderWithURL(url: NSString,post: Bool, param: NSMutableDictionary, cholicy: NSURLRequestCachePolicy, dele: AnyObject, completeSelector: Selector, errorSelector: Selector, selectorArgument: Selector)-> RequestSend{
      
        var request_send: RequestSend = RequestSend()
        request_send._request_url = url;
        request_send._use_post = post;
        request_send._param = param;
        request_send._dele = dele;
        request_send._complete_selector = completeSelector;
        request_send._error_selector = errorSelector;
        request_send._complete_selector = selectorArgument;
        request_send._cholicy = cholicy

        return request_send;
        
    }
    
    func send(){
        
        var temp_url: NSMutableString = ""

        for (key, value) in self._param! {
            
            if value is NSString {
                
                var encodedValue = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,value as CFString,"[].","!*'();:@&=+$,/?%#[]",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))

                
                temp_url.appendFormat("&%@=%@", key as NSString, encodedValue as NSString)
                
            }
            else
            {
                temp_url.appendFormat("&%@=%@", key as String, value as NSString)
            }
        }
        
        
        if(!self._use_post)
        {
            self._request_url = NSString(format: "%@?%@", self._request_url!, temp_url)
        }
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string:self._request_url as String)!, cachePolicy: self._cholicy!, timeoutInterval: TIME_OUT_INTERVAL)
        
        request.HTTPMethod = "POST"
        if !self._use_post{
            request.HTTPMethod = "GET"
        } else{
            request.HTTPBody = temp_url.dataUsingEncoding(NSUTF8StringEncoding)
        }

        var operation: AFHTTPRequestOperation = AFHTTPRequestOperation(request: request)
        operation.securityPolicy.allowInvalidCertificates = true;
        
        
        operation.setCompletionBlockWithSuccess({ (AFHTTPRequestOperation operation, AnyObject object) -> Void in
            if self._dele != nil && self._complete_selector != nil
            {
                if self._dele!.respondsToSelector(self._complete_selector)
                {
//            
//                    //去皮
                    var obj: AnyObject? = self.transitionData(object, cache: false)
//
                    if obj != nil {
                        if obj is NSError {
                            var control:UIControl = UIControl()
                            control.sendAction(self._error_selector, to: self._dele, forEvent: obj as? UIEvent)
                        }else{
                            var control:UIControl = UIControl()
                            control.sendAction(self._complete_selector, to: self._dele, forEvent: obj as? UIEvent)
                        }
                    }
                }
                
            }
        
        }, failure: { (AFHTTPRequestOperation, NSError) -> Void in
            
        })
        
//        
//        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            if(self.delegate && self.completeSelector)
//            {
//            if([self.delegate respondsToSelector:self.completeSelector])
//            {
//            #pragma clang diagnostic push
//            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//            
//            //去皮
//            id object = [self transitionData:responseObject cache:NO];
//            
//            if (object) {
//            if ([object isKindOfClass:[NSError class]]) {
//            [self.delegate performSelector:self.errorSelector withObject:(NSError *)object];
//            }else{
//            [self.delegate performSelector:self.completeSelector withObject:object];
//            }
//            }
//            #pragma clang diagnostic pop
//            }
//            }
//            
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            if(self.delegate && self.errorSelector)
//            {
//            if([self.delegate respondsToSelector:self.errorSelector])
//            {
//            #pragma clang diagnostic push
//            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//            if(self.timesp)
//            {
//            NSMutableDictionary *reasonDict = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
//            [reasonDict setObject:self.timesp forKey:@"timesp"];
//            
//            NSError *errorr = [NSError errorWithDomain:ERROR_DOMAIN code:error.code userInfo:[NSDictionary dictionaryWithObject:reasonDict forKey:@"reason"]];
//            [self.delegate performSelector:self.errorSelector withObject:errorr];
//            
//            }
//            else
//            {
//            [self.delegate performSelector:self.errorSelector withObject:error];
//            
//            if(error.localizedDescription){
//            NSString *str = [NSString stringWithFormat:@"code: %ld  error_info_request[%@]",(long)error.code,error.localizedDescription];
//            [[FMLogger sharedLogger] writeImageDoloadErrorInfoToLogFile:str];
//            }
//            
//            }
//            #pragma clang diagnostic pop
//            
//            }
//            }
//
//            }];
//        
            operation.start()
    }
    
    func uploadData(type: UploadType){
    }
    
    
    ///////////////
    func transitionData(data: AnyObject, cache:Bool)-> AnyObject?
    {
        var json_string: NSString = NSString(data: data as NSData, encoding: NSUTF8StringEncoding)!
    
        if json_string.length > 0
        {
            
    
            var dict: NSDictionary = json_string.JSONValue() as NSDictionary
    
            var code: Int = dict.objectForKey("code") as Int
            
            switch code{
                
            case 0:
                println("")
                return data
            default:
                println("")

            }
        }
        
        return nil
    }
    

}

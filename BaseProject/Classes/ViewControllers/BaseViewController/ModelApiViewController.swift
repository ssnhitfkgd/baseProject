//
//  ModelApiViewController.swift
//  BaseProject
//
//  Created by wangyong on 15/2/2.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

import UIKit



let MODEL_PAGE_SIZE = 20


/********************************添加api 以追加得方式 向下拓展 否则缓存数据会错乱**********************************/
enum API_GET_TYPE
{
    case API_HOME_LISR          //搜索图片
    case DEFAULT          //搜索图片

};
/********************************添加api 以追加得方式 向下拓展 否则缓存数据会错乱**********************************/


enum API_GET_CODE
{
    case ERROR_CODE_SUCCESS
    case ERROR_CODE_NORMAL
    case ERROR_CODE_NEED_AUTH
}


class ModelApiViewController: UIViewController {

    var _model: AnyObject?
    
    var _loading: Bool = false
    var _offset: String? = ""
    var _load_more: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    func modelApi()-> API_GET_TYPE
    {
        return API_GET_TYPE.API_HOME_LISR;
    }
    
    func isLoading()-> Bool
    {
        return _loading;
    }
    
    func reloadData()
    {
        loadData(false)
    }
    
    func loadData(more: Bool)
    {
        var api_type = modelApi()
        _loading = true
        
//        WPFileClient *client = [WPFileClient sharedInstance];
        var pageSize =  getPageSize()
        var offsetId = ""
        if more {
            offsetId = self._offset!
        }
        _load_more = more;
        
        
        switch api_type {
        case .API_HOME_LISR:
            println("API_HOME_LISR")

        case .DEFAULT:
            println("DEFAULT")

        }
        
    }
    
    func didFinishLoad(result: NSArray)
    {
        
        if self._model != nil && self._model!.isEqualToArray(result)
        {
            return;
        }
                        
        if  self._model != nil  && self._model!.count > 0 {
            self._model!.addObjectsFromArray(result)
        } else {
            self._model!.removeAllObjects()
            self._model!.addObjectsFromArray(result)
        
        }
    }
    
    func didFailWithError(error: NSError)
    {
    }
    
    func requestDidFinishLoad(data: AnyObject)
    {
        if(data.count > 0 && data is NSDictionary)
        {
            var obj: NSArray? = data.objectForKey("list") as? NSArray
            if obj != nil
            {
                var offset_id: AnyObject? = data.objectForKey("offset_id") as? String
                if (offset_id != nil && (offset_id! is String))
                {
                    self._offset = offset_id as? String;
                }
                
                
                var cache: Bool? = data.objectForKey("cache") as? Bool
                
                if cache != nil && !self._load_more {
                    self._model = nil;
                }
                
                didFinishLoad(obj!)
                _loading = false
            }
        }

    }
    
    func requestError(error: NSError)
    {
        _loading = false
        didFailWithError(error)
    }
    
    func getPageSize()-> Int
    {
        return MODEL_PAGE_SIZE;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


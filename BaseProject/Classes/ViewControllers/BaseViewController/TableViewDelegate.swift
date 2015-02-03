//
//  TableViewDelegate.swift
//  BaseProject
//
//  Created by wangyong on 15/2/2.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

import UIKit

@objc protocol TableViewDelegate: NSObjectProtocol{
    class optional func rowHeightForObject(item: AnyObject?) ->CGFloat
    optional func setObject(item: AnyObject?)
}


//
//  UIAlertView+Addition.h
//  Youku
//
//  Created by quan dong on 7/7/12.
//  Copyright (c) 2012 Lebo.com inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^VoidBlock)();

typedef void (^SDismissBlock)(int buttonIndex);
typedef void (^CancelBlock)();

@interface UIAlertView (Block) <UIAlertViewDelegate> 
+ (UIAlertView*) alertViewWithTitle:(NSString*) title                    
                            message:(NSString*) message 
                  cancelButtonTitle:(NSString*) cancelButtonTitle
                  otherButtonTitles:(NSArray*) otherButtons
                          onDismiss:(SDismissBlock) dismissed
                           onCancel:(CancelBlock) cancelled;

@property (nonatomic, copy) SDismissBlock dismissBlock;
@property (nonatomic, copy) CancelBlock cancelBlock;

@end


//
//  UIButton+XW.h
//  ClickCountOfButton
//
//  Created by key on 15/10/22.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XW)

@property (nonatomic, assign) NSInteger  btnClickedCount;

@property (nonatomic, copy) void (^currentActionBlock)() ;

@end

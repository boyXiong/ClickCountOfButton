//
//  UIButton+XW.m
//  ClickCountOfButton
//
//  Created by key on 15/10/22.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//

#import "UIButton+XW.h"
#import <objc/runtime.h>
#import <objc/message.h>


NSString * const xw_btnClickedCountKey = nil;
NSString * const xw_btnCurrentActionBlockKey = nil;



@implementation UIButton (XW)

/** 拦截了UIButton 所有的
 - (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
 方法*/
- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    
    
    __weak typeof(target) weakTarget = target;
    
    __weak typeof(self) weakSelf = self;
    
    //利用 关联对象 给UIButton 增加了一个 block
    [self  setCurrentActionBlock:^{
        //运行时 发送 消息 执行方法
        ((void (*)(void *, SEL, UIButton *))objc_msgSend)((__bridge void *)(weakTarget), action , weakSelf);
    
    }];
    
    
    //拦截了本身要执行的action 先执行，写下来的 xw_clicked:方法
    [super addTarget:self action:@selector(xw_clicked:) forControlEvents:controlEvents];
}

//拦截了按钮点击后要执行的代码
- (void)xw_clicked:(UIButton *)sender{
    //统计 在这个方法中执行想要操作的
    
    self.btnClickedCount++;
    
    NSLog(@"%@ 点击 %ld次 ",[sender titleForState:UIControlStateNormal], self.btnClickedCount);
    
    
    
    //执行原来要执行的方法
    sender.currentActionBlock();
}

//在分类中增加了 btnClickedCount的 (setter 和 getter）方法，使用关联对象增加了相关的成员空间
- (NSInteger)btnClickedCount{
    id tmp = objc_getAssociatedObject(self, &xw_btnClickedCountKey);
    NSNumber *number = tmp;
    return number.integerValue;
}


- (void)setBtnClickedCount:(NSInteger)btnClickedCount{
    objc_setAssociatedObject(self, &xw_btnClickedCountKey, @(btnClickedCount), OBJC_ASSOCIATION_ASSIGN);
}


//增加一个 block 关联UIButton
- (void)setCurrentActionBlock:(void (^)())currentActionBlock{
    
     objc_setAssociatedObject(self, &xw_btnCurrentActionBlockKey, currentActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())currentActionBlock{
    return objc_getAssociatedObject(self, &xw_btnCurrentActionBlockKey);
}

@end

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

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL origilaSEL = @selector(addTarget: action: forControlEvents:);
        
        SEL hook_SEL = @selector(xw_addTarget: action: forControlEvents:);
        
        //交换方法
        Method origilalMethod = class_getInstanceMethod(self, origilaSEL);
        
        
        Method hook_method = class_getInstanceMethod(self, hook_SEL);
        
        
        class_addMethod(self,
                        origilaSEL,
                        class_getMethodImplementation(self, origilaSEL),
                        method_getTypeEncoding(origilalMethod));
        
        class_addMethod(self,
                        hook_SEL,
                        class_getMethodImplementation(self, hook_SEL),
                        method_getTypeEncoding(hook_method));
        
        method_exchangeImplementations(class_getInstanceMethod(self, origilaSEL), class_getInstanceMethod(self, hook_SEL));
        
    });
    
}

- (void)xw_addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    
    
    __weak typeof(target) weakTarget = target;
    
    __weak typeof(self) weakSelf = self;
    
    //利用 关联对象 给UIButton 增加了一个 block
    if (action) {
        
        [self  setCurrentActionBlock:^{
            @try {
                 ((void (*)(void *, SEL,  typeof(weakSelf) ))objc_msgSend)((__bridge void *)(weakTarget), action , weakSelf);
            } @catch (NSException *exception) {
            } @finally {
            }
           
        }];
    }
    
    
    //发送消息 其实是本身  要执行的action 先执行，写下来的 xw_clicked:方法
    [self xw_addTarget:self action:@selector(xw_clicked:) forControlEvents:controlEvents];
}

//拦截了按钮点击后要执行的代码
- (void)xw_clicked:(UIButton *)sender{
    //统计 在这个方法中执行想要操作的
    
    self.btnClickedCount++;
    
    NSLog(@"%@ 点击 %ld次 ",[sender titleForState:UIControlStateNormal], self.btnClickedCount);
    
    
    //执行原来要执行的方法
    sender.currentActionBlock();
}



//增加一个 block 关联UIButton
- (void)setCurrentActionBlock:(void (^)())currentActionBlock{
    
     objc_setAssociatedObject(self, &xw_btnCurrentActionBlockKey, currentActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())currentActionBlock{
    return objc_getAssociatedObject(self, &xw_btnCurrentActionBlockKey);
}


#pragma mark -统计

//在分类中增加了 btnClickedCount的 (setter 和 getter）方法，使用关联对象增加了相关的成员空间
- (NSInteger)btnClickedCount{
    id tmp = objc_getAssociatedObject(self, &xw_btnClickedCountKey);
    NSNumber *number = tmp;
    return number.integerValue;
}


- (void)setBtnClickedCount:(NSInteger)btnClickedCount{
    objc_setAssociatedObject(self, &xw_btnClickedCountKey, @(btnClickedCount), OBJC_ASSOCIATION_ASSIGN);
}

@end

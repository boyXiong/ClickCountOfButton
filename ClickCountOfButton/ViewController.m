//
//  ViewController.m
//  ClickCountOfButton
//
//  Created by key on 15/10/22.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnClicked1:(id)sender {
    
    NSLog(@"我是按钮1");
}

- (IBAction)btnClicked2:(id)sender {
    
    NSLog(@"我是按钮2");

}
- (IBAction)exit:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{
    NSLog(@"销毁了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

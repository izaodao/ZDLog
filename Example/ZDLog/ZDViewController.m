//
//  ZDViewController.m
//  ZDLog
//
//  Created by 吕浩轩 on 12/16/2020.
//  Copyright (c) 2020 吕浩轩. All rights reserved.
//

#import "ZDViewController.h"
#import <ZDLog.h>

@interface ZDViewController ()

@end

@implementation ZDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    DDLogInfo(@"页面信息 ^_^");
    
    DDLogInfo(@"key-value:%@", @{@"key" : @"汉字"});
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        do {
            /* 留给测试的后门 */

            //异常的名字
            NSString *exceptionName = @"自定义异常";
            //异常的原因
            NSString *exceptionReason = @"你长得太帅了，所以程序崩溃了";
            //异常的信息
            NSDictionary *exceptionUserInfo = nil;
            //构造异常
            NSException *exception = [NSException exceptionWithName:exceptionName reason:exceptionReason userInfo:exceptionUserInfo];

            //抛异常
            @throw exception;
        } while (YES);
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

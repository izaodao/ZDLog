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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

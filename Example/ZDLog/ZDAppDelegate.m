//
//  ZDAppDelegate.m
//  ZDLog
//
//  Created by 吕浩轩 on 12/16/2020.
//  Copyright (c) 2020 吕浩轩. All rights reserved.
//

#import "ZDAppDelegate.h"
#import <ZDLog.h> // 依赖 CocoaLumberjack

@implementation ZDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    /* 收集运行日志 和 崩溃信息 */
    
    // 一. 设置输出级别
    [ZDLog logLevelAll];
    
    // 二. 添加 DDOSLogger，可以在控制台和日志系统里输出
    DDOSLogger *OSLogger = [DDOSLogger sharedInstance];
    [DDLog addLogger:OSLogger withLevel:ddLogLevel]; // 添加输出级别
    
    // 三. 设置 Log 日志文件
    ZDFileLogger *fileLogger = [[ZDFileLogger alloc] init];     // 日志路径、文件名等等。（需要自定义）
    fileLogger.rollingFrequency = 60 * 60 * 24;                 // 一个日志只保留 "24小时" 内容
    fileLogger.maximumFileSize = 1024 * 1024 * 1024;            // 文件大小 1GB
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;      // 最多保存 7 个文件
    fileLogger.logFormatter = [[ZDLogFormatter alloc] init];    // 设置日志输出样式（需要自定义）
    [DDLog addLogger:fileLogger withLevel:ddLogLevel];          // 添加输出级别
    
    // 四. 捕获'崩溃异常'的信息，可以选择不设置
    [ZDUncaughtExceptionHandler install];
    
    DDLogError(@"输出日志 ~ ~ ~");

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

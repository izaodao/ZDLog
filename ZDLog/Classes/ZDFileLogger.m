//
//  ZDFileLogger.m
//  ZDTalk
//
//  Created by 吕浩轩 on 2020/4/24.
//  Copyright © 2020 早道教育. All rights reserved.
//

#import "ZDFileLogger.h"
#import <TargetConditionals.h>

@implementation ZDFileLogger

#if TARGET_OS_OSX
- (instancetype)init {
    
    ///!!!: 已改动了 macOS 端的，iOS还没有改。
    
    NSString *path = @"/Users";
    path = [path stringByAppendingPathComponent:NSUserName()];
    path = [path stringByAppendingPathComponent:@"Library"];
    path = [path stringByAppendingPathComponent:@"Logs"];
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    path = [path stringByAppendingPathComponent:appName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    BOOL isD = NO;
    BOOL isWritable = [fileManager isWritableFileAtPath:path];
    if (![fileManager fileExistsAtPath:path isDirectory:&isD] || !isD || !isWritable) {
        path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Logs"];
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    ZDFileManagerDefault *defaultLogFileManager = [[ZDFileManagerDefault alloc] initWithLogsDirectory:path];
    return [self initWithLogFileManager:defaultLogFileManager];
}
#endif

@end

@implementation ZDFileManagerDefault

- (NSString *)newLogFileName {
    
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat: @"yyyyMMdd"];
    });
    
    NSString *formattedDate = [dateFormatter stringFromDate:[NSDate date]];
    
#if TARGET_OS_OSX
    return [NSString stringWithFormat:@"macOS_%@.log", formattedDate];
#else
    return [NSString stringWithFormat:@"iOS_%@.log", formattedDate];
#endif
}

- (BOOL)isLogFile:(NSString *)fileName {
    NSString *newFileName = [self newLogFileName];
    return [fileName isEqualToString:newFileName];
}

@end

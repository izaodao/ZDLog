//
//  ZDUncaughtExceptionHandler.m
//  ZDTalk
//
//  Created by 吕浩轩 on 2019/12/11.
//  Copyright © 2020 早道教育. All rights reserved.
//

#import "ZDLog.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

@interface ZDUncaughtExceptionHandler ()

@end

@implementation ZDUncaughtExceptionHandler
// 异常的处理方法
+ (void)install {
    
    NSSetUncaughtExceptionHandler(&HandleException);
    
    signal(SIGFPE,  SignalHandler);
    signal(SIGBUS,  SignalHandler);
    signal(SIGHUP,  SignalHandler);
    signal(SIGINT,  SignalHandler);
    signal(SIGILL,  SignalHandler);
    signal(SIGPIPE, SignalHandler);
    signal(SIGQUIT, SignalHandler);
    signal(SIGABRT, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGTRAP, SignalHandler);
    signal(SIGALRM, SignalHandler);
}

//获取调用堆栈
+ (NSArray *)backtrace {
    
    //指针列表
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (int i = 0; i < frames; i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

- (void)handleException:(NSException *)exception {
    
    HandleException(exception);
}

//处理signal报错
void SignalHandler(int signal) {
    
    NSString* description = nil;
    switch (signal) {
        case SIGSEGV:
            description = [NSString stringWithFormat:@"Signal SIGSEGV was raised!\n"];
            break;
        case SIGFPE:
            description = [NSString stringWithFormat:@"Signal SIGFPE was raised!\n"];
            break;
        case SIGBUS:
            description = [NSString stringWithFormat:@"Signal SIGBUS was raised!\n"];
            break;
        case SIGPIPE:
            description = [NSString stringWithFormat:@"Signal SIGPIPE was raised!\n"];
            break;
        case SIGHUP:
            description = [NSString stringWithFormat:@"Signal SIGHUP was raised!\n"];
            break;
        case SIGINT:
            description = [NSString stringWithFormat:@"Signal SIGINT was raised!\n"];
            break;
        case SIGQUIT:
            description = [NSString stringWithFormat:@"Signal SIGQUIT was raised!\n"];
            break;
        case SIGABRT:
            description = [NSString stringWithFormat:@"Signal SIGABRT was raised!\n"];
            break;
        case SIGILL:
            description = [NSString stringWithFormat:@"Signal SIGILL was raised!\n"];
            break;
        case SIGALRM:
            description = [NSString stringWithFormat:@"Signal SIGALRM was raised!\n"];
            
        default:
            description = [NSString stringWithFormat:@"Signal %d was raised!",signal];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSArray *callStack = [ZDUncaughtExceptionHandler backtrace];
    
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [userInfo setObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    
    NSException *exception = [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName reason: description userInfo: userInfo];
    
    HandleException(exception);
}

void HandleException(NSException *exception) {
    
    /* ---------- 编写崩溃信息 ---------- */
    NSString* name = [ exception name ];
    NSString* reason = [ exception reason];
    id symbols = [ exception callStackSymbols];
    
    NSMutableString* strSymbols;
    if ([symbols isKindOfClass:[NSArray class]]) {
        //异常发生时的调用栈
        strSymbols = [ [ NSMutableString alloc ] init ];
        //将调用栈拼成输出日志的字符串
        for ( NSString* item in symbols )
        {
            [strSymbols appendString: item ];
            [strSymbols appendString: @"\r\n" ];
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.sss ZZZ"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *app_Version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *app_BundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *version = [app_Version stringByAppendingFormat:@" (%@)", app_BundleVersion];
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSString *process = [[processInfo processName] stringByAppendingFormat:@" [%d]", [processInfo processIdentifier]];
    NSString *path = [[processInfo arguments] firstObject];
    NSString *OS_Version =  [processInfo operatingSystemVersionString];
    NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    NSString *UUID = [processInfo globallyUniqueString];
    
    //整合崩溃信息
    NSString *crashString = [NSString stringWithFormat:@"\n[ Uncaught Exception ]\n\nName: %@, \n\nReason: %@\n\nProcess: %@\n\nPath: %@\n\nIdentifier: %@\n\nVersion: %@\n\nDate/Time: %@\n\nOS Version: %@\n\nAnonymous UUID: %@\n\n[ Fe Symbols Start ]\n%@[ Fe Symbols End ]\n\n",  name, reason, process, path, bundleID, version, dateStr, OS_Version, UUID, strSymbols ? strSymbols : exception.userInfo];
    
    //向'文件' 和 '控制台' 输出崩溃信息
    DDLogError(@"崩溃信息：%@", crashString);
    
    // SIGSEGV 异常直接退出
    if ([reason containsString:@"SIGSEGV"]) {
#if DEBUG
        @throw exception;
#else
        exit(0);
#endif
    }
}

@end

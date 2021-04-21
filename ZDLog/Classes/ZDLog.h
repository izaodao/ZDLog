//
//  ZDLog.h
//  ZDLog
//
//  Created by 吕浩轩 on 2020/12/16.
//


#import <Foundation/Foundation.h>
#import "ZDFileLogger.h"
#import "ZDLogFormatter.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "ZDUncaughtExceptionHandler.h"

NS_ASSUME_NONNULL_BEGIN

extern DDLogLevel ddLogLevel;

@interface ZDLog : NSObject
/**
 *  No logs
 */
+ (void)logLevelOff;

/**
 *  Error logs only
 */
+ (void)logLevelError;

/**
 *  Error and warning logs
 */
+ (void)logLevelWarning;

/**
 *  Error, warning and info logs
 */
+ (void)logLevelInfo;

/**
 *  Error, warning, info and debug logs
 */
+ (void)logLevelDebug;

/**
 *  Error, warning, info, debug and verbose logs
 */
+ (void)logLevelVerbose;

/**
 *  All logs (1...11111)
 */
+ (void)logLevelAll;

@end

NS_ASSUME_NONNULL_END

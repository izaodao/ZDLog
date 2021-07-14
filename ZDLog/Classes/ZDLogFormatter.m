//
//  ZDLogFormatter.m
//  ZDTalk
//
//  Created by 吕浩轩 on 2020/4/1.
//  Copyright © 2020 早道教育. All rights reserved.
//

#import "ZDLogFormatter.h"

@implementation ZDLogFormatter

- (nullable NSString *)formatLogMessage:(nonnull DDLogMessage *)logMessage {
    NSString *loglevel = nil;
        switch (logMessage.flag)
        {
            case DDLogFlagError:
            {
                loglevel = @"❌ [ERROR]";
            }
                break;
            case DDLogFlagWarning:
            {
                loglevel = @"⚠️ [WARN] ";
            }
                break;
            case DDLogFlagInfo:
            {
                loglevel = @"✅ [INFO] ";
            }
                break;
            case DDLogFlagDebug:
            {
                loglevel = @"👨‍💻 [DEBUG]";
            }
                break;
            case DDLogFlagVerbose:
            {
                loglevel = @"🌀 [VBOSE]";
            }
                break;
                
            default:
                break;
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss:SSSZ"];
        [formatter setLocale:[NSLocale currentLocale]];
        NSString *logDateMessage = [formatter stringFromDate:logMessage->_timestamp];
        
        NSString *formatStr = [NSString stringWithFormat:@"%@ %@: %@", loglevel, logDateMessage, logMessage->_message];
        return formatStr;
}

@end

//
//  ZDLog.m
//  ZDLog
//
//  Created by 吕浩轩 on 2020/12/16.
//

#import "ZDLog.h"

DDLogLevel ddLogLevel = DDLogLevelOff;

@implementation ZDLog

+ (void)logLevelOff {
    ddLogLevel = DDLogLevelOff;
}

+ (void)logLevelError {
    ddLogLevel = DDLogLevelError;
}

+ (void)logLevelWarning {
    ddLogLevel = DDLogLevelWarning;
}

+ (void)logLevelInfo {
    ddLogLevel = DDLogLevelInfo;
}

+ (void)logLevelDebug {
    ddLogLevel = DDLogLevelDebug;
}

+ (void)logLevelVerbose {
    ddLogLevel = DDLogLevelVerbose;
}

+ (void)logLevelAll {
    ddLogLevel = DDLogLevelAll;
}

@end

#import <objc/runtime.h>

#pragma mark - 方法交换

static inline void ppl_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


#pragma mark - NSObject分类

@implementation NSObject (PrettyPrintedLog)
//将obj转换成json字符串。如果失败则返回nil.
- (NSString *)ppl_convertToJsonString {
    
    //先判断是否能转化为JSON格式
    if (![NSJSONSerialization isValidJSONObject:self])  return nil;
    NSError *error = nil;
    
    NSJSONWritingOptions jsonOptions = NSJSONWritingPrettyPrinted;
    
    if (@available(macOS 10.13, iOS 11.0, watchos 4.0, tvos 11.0, *)) {
        jsonOptions |= NSJSONWritingSortedKeys;
    }
#if (__clang_major__ > 10)
    if (@available(macOS 10.14, iOS 12.0, watchos 5.0, tvos 12.0, *)) {
        jsonOptions |= NSJSONWritingFragmentsAllowed;
    }
    
    if (@available(macOS 10.15, iOS 13.0, watchos 6.0, tvos 13.0, *)) {
        jsonOptions |= NSJSONWritingWithoutEscapingSlashes;
    }
#endif
    
    //核心代码，字典转化为有格式输出的JSON字符串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:jsonOptions  error:&error];
    if (error || !jsonData) return nil;
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
@end


#pragma mark - NSDictionary分类

@implementation NSDictionary (PrettyPrintedLog)

//用此方法交换系统的 descriptionWithLocale: 方法。该方法在代码打印的时候调用。
- (NSString *)ppl_descriptionWithLocale:(id)locale{

    NSString *result = [self ppl_convertToJsonString];//转换成JSON格式字符串
    if (!result) {
        result = [self ppl_descriptionWithLocale:locale];//如果无法转换，就使用原先的格式
        return result;
    }
    return result;
}
//用此方法交换系统的 descriptionWithLocale:indent:方法。功能同上。
- (NSString *)ppl_descriptionWithLocale:(id)locale indent:(NSUInteger)level {

    NSString *result = [self ppl_convertToJsonString];
    if (!result) {
        result = [self ppl_descriptionWithLocale:locale indent:level];//如果无法转换，就使用原先的格式
        return result;
    }
    return result;
}
//用此方法交换系统的 debugDescription 方法。该方法在控制台使用po打印的时候调用。
- (NSString *)ppl_debugDescription{
    
    NSString *result = [self ppl_convertToJsonString];
    if (!result) return [self ppl_debugDescription];
    return result;
}

//在load方法中完成方法交换
+ (void)load {
    
    //方法交换
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        ppl_swizzleSelector(class, @selector(descriptionWithLocale:), @selector(ppl_descriptionWithLocale:));
        ppl_swizzleSelector(class, @selector(descriptionWithLocale:indent:), @selector(ppl_descriptionWithLocale:indent:));
        ppl_swizzleSelector(class, @selector(debugDescription), @selector(ppl_debugDescription));
    });
}

@end


#pragma mark - NSArray分类

@implementation NSArray (PrettyPrintedLog)

//用此方法交换系统的 descriptionWithLocale: 方法。该方法在代码打印的时候调用。
- (NSString *)ppl_descriptionWithLocale:(id)locale{
    
    NSString *result = [self ppl_convertToJsonString];//转换成JSON格式字符串
    if (!result) {
        result = [self ppl_descriptionWithLocale:locale];//如果无法转换，就使用原先的格式
        return result;
    }
    return result;
}
//用此方法交换系统的 descriptionWithLocale:indent:方法。功能同上。
- (NSString *)ppl_descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    
    NSString *result = [self ppl_convertToJsonString];
    if (!result) {
        result = [self ppl_descriptionWithLocale:locale indent:level];//如果无法转换，就使用原先的格式
        return result;
    }
    return result;
}
//用此方法交换系统的 debugDescription 方法。该方法在控制台使用po打印的时候调用。
- (NSString *)ppl_debugDescription{
    
    NSString *result = [self ppl_convertToJsonString];
    if (!result) return [self ppl_debugDescription];
    return result;
}

//在load方法中完成方法交换
+ (void)load {
    
    //方法交换
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        ppl_swizzleSelector(class, @selector(descriptionWithLocale:), @selector(ppl_descriptionWithLocale:));
        ppl_swizzleSelector(class, @selector(descriptionWithLocale:indent:), @selector(ppl_descriptionWithLocale:indent:));
        ppl_swizzleSelector(class, @selector(debugDescription), @selector(ppl_debugDescription));
    });
}

@end

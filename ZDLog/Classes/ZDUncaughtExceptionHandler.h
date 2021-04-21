//
//  ZDUncaughtExceptionHandler.h
//  ZDTalk
//
//  Created by 吕浩轩 on 2019/12/11.
//  Copyright © 2020 早道教育. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDUncaughtExceptionHandler : NSObject

/// 异常的处理方法
+ (void)install;

@end

NS_ASSUME_NONNULL_END

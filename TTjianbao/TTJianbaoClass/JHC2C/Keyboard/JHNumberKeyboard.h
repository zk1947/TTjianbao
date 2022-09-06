//
//  JHNumberKeyboard.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/6/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const KeyboardDeleteId = @"13";
static NSString * const KeyboardEndId = @"14";
static NSString * const KeyboardABCId = @"12";
static NSString * const KeyboardDecimalId = @"10";

typedef void(^KeyboardHandler)(NSString *text);
@interface JHNumberKeyboard : UIView
@property (nonatomic, copy) KeyboardHandler handler;
@end

NS_ASSUME_NONNULL_END

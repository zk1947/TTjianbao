//
//  JHEmojiManager.h
//  TTjianbao
//
//  Created by apple on 2020/11/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,JHTextType){
    TextViewTypeUIText,
    TextViewTypeYYText,
};
@interface JHEmojiManager : NSObject
+ (instancetype)sharedInstance;
-(void)setCurrentText:(id)text andType:(UIFont *)font;
//按钮点击事件
- (void)changeKeyboardTo:(BOOL)isShow;
//表情匹配转化文字
- (NSString *)plainText;
@end

NS_ASSUME_NONNULL_END

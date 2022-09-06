//
//  JHTextLinePositionModifier.h
//  TTjianbao
//
//  Created by wuyd on 2020/4/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  文本 Line 位置修改
//  将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
//

#import <Foundation/Foundation.h>
#import <YYKit/YYKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHTextLinePositionModifier : NSObject <YYTextLinePositionModifier>

@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数

- (CGFloat)heightForLineCount:(NSUInteger)lineCount;

@end

NS_ASSUME_NONNULL_END

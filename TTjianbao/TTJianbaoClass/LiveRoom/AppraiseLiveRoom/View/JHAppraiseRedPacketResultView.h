//
//  JHAppraiseRedPacketResultView.h
//  TTjianbao
//  Descrription:鉴定师红包打开结果View（成功 与 失败）
//  Created by Jesse on 2020/7/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAppraiseRedPacketResultTag 987

NS_ASSUME_NONNULL_BEGIN
//点击开-结果页（成功 与 失败）
@interface JHAppraiseRedPacketResultView : UIView

- (void)showWithData:(id)model;
@end

NS_ASSUME_NONNULL_END

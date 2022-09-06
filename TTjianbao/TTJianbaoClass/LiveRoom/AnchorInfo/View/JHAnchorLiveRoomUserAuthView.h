//
//  JHAnchorLiveRoomUserAuthView.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHAnchorLiveRoomUserAuthView : UIView

/// 0-身份证正面    1-身份证反面
@property (nonatomic, assign) NSInteger type;

/// 重新提交
@property (nonatomic, assign) BOOL reCommit;

/// 图片（url/image）
@property (nonatomic, strong) id uploadImage;

@property (nonatomic, copy) dispatch_block_t clickBlock;

+ (CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END

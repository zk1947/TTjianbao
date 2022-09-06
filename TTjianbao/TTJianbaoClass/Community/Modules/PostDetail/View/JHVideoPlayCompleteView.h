//
//  JHVideoPlayCompleteView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/11/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHVideoPlayCompleteView : UIView


/// 1-微信    2-朋友圈   3-重播
@property (nonatomic, copy) void (^clickActionBlock) (NSInteger type);

@property (nonatomic, assign) CGFloat edgeTop;

@end

NS_ASSUME_NONNULL_END

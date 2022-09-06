//
//  JHBuyAppraiseTVBoxHeader.h
//  TTjianbao
//  购物鉴定电视机为（仓库直播或者回放）
//  Created by wangjianios on 2020/12/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@class JHBuyAppraiseTVBoxModel;

/// 购物鉴定电视机为（仓库直播或者回放）
@interface JHBuyAppraiseTVBoxHeader : UIView

/// 直播或者回放开始
- (void)start;

/// 直播或者回放结束
- (void)stop;

/// 请求数据
- (void)requestData;

/// 刷新数据
- (void)refreshData;


+ (CGSize)viewSize;

@end

NS_ASSUME_NONNULL_END

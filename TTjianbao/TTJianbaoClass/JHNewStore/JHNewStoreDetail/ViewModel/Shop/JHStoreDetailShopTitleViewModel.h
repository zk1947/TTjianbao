//
//  JHStoreDetailShopTitleViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 店铺标题区 viewModel

#import "JHStoreDetailCellBaseViewModel.h"
#import "JHUserAuthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailShopTitleViewModel : JHStoreDetailCellBaseViewModel
/// 店铺图标
@property (nonatomic, copy) NSString *iconUrl;
/// 标题
@property (nonatomic, copy) NSString *titleText;
/// 粉丝
@property (nonatomic, copy) NSString *fansText;
/// 好评度
@property (nonatomic, copy) NSString *praiseText;

/// 好评度
@property (nonatomic, strong) NSAttributedString *praiseTextAtt;

/// 综合评分
@property (nonatomic, copy) NSString *totalScore;

/// 关注 0 未关注 1 已关注
@property (nonatomic, assign) BOOL focusStatus;
/// 进入店铺
@property (nonatomic, copy) RACReplaySubject<NSString *> *goShopTextSubject;
/// 关注事件
@property (nonatomic, strong) RACSubject *focusAction;
/** 认证类型 0未认证、1个人、2企业、3个体户 */
@property (nonatomic, assign) JHUserAuthType sellerType;

/// 进入店铺 按钮 事件
@property (nonatomic, strong) RACSubject *goShopBtnAction;

@end

NS_ASSUME_NONNULL_END

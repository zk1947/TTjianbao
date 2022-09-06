//
//  JHMarketAnimalView.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketAnimalView : BaseView
/** 分数*/
@property (nonatomic, strong) UILabel *scoreLabel;
/** 今日曝光*/
@property (nonatomic, strong) UILabel *exposeLabel;
/** 擦亮按钮*/
@property (nonatomic, strong) UIButton *exposeButton;
@end

NS_ASSUME_NONNULL_END

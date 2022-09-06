//
//  JHSellRoomGuidenceView.h
//  TTjianbao
//
//  Created by mac on 2019/7/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSellRoomGuidenceView : BaseView
@property (nonatomic, strong)UIButton *saleGuideBtn;

/// 0普通 1原石 2回血
@property (nonatomic, assign)NSInteger type;

@property (nonatomic, copy) JHActionBlock completBlock;
@end

NS_ASSUME_NONNULL_END

//
//  JHStoneResaleHeaderView.h
//  TTjianbao
//
//  Created by jiang on 2019/12/1.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#define StoneHeaderImageRate (137./365.f)
#import "JHMainViewStoneResaleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoneResaleHeaderView :BaseView
@property(strong,nonatomic)JHMainViewStoneHeaderInfoModel *mode;
@end

NS_ASSUME_NONNULL_END

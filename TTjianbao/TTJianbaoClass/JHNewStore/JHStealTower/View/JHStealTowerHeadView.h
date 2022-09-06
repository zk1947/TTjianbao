//
//  JHStealTowerHeadView.h
//  TTjianbao
//
//  Created by zk on 2021/7/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStealTowerViewController.h"
#import "JHStealTowerRequestModel.h"
#import "JHStealTowerModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ReloadUIBlock)(BOOL showTag);

typedef void(^HeadChooseBlock)(JHStealTowerRequestModel *model);

@interface JHStealTowerHeadView : UIView

@property (nonatomic, strong) JHStealTowerModel *headModel;

@property (nonatomic, copy) ReloadUIBlock reloadUIBlock;

@property (nonatomic, copy) HeadChooseBlock headChooseBlock;

@property (nonatomic, weak) JHStealTowerViewController *vc;

- (void)hiddenClassAlert;

@end

NS_ASSUME_NONNULL_END

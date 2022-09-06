//
//  JHB2CReCommendTableViewCell.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/8/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHB2CRecommenViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHB2CReCommendCell : UITableViewCell

@property (nonatomic, assign) BOOL  canScroll;


/// 是否能滚动 过小
@property (nonatomic, assign) BOOL  supportScroll;

@property(nonatomic, strong) JHB2CRecommenViewModel * viewModel;

@property(nonatomic, strong) void(^superCanScroolBLock)(void);

@end

NS_ASSUME_NONNULL_END

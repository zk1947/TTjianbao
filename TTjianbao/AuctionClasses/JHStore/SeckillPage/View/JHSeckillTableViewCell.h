//
//  JHSeckillTableViewCell.h
//  TTjianbao
//
//  Created by jiang on 2020/3/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHGoodsInfoMode.h"
#import "JHSecKillTitleMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSeckillTableViewCell : UITableViewCell
@property (nonatomic, copy) JHActionBlock buttonClick;
@property (nonatomic, copy) JHGoodsInfoMode *goodMode;
@property (nonatomic, assign) NSInteger cellIndex;
@property (nonatomic, assign) NSInteger dataCount;
@property (nonatomic, strong) JHSecKillTitleMode *titleMode;
@end

NS_ASSUME_NONNULL_END

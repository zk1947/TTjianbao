//
//  JHWarnningTableViewCell.h
//  TTjianbao
//
//  Created by mac on 2019/7/30.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecommendAppraiserListItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHWarnningTableViewCell : UITableViewCell
@property (nonatomic, strong)JHRecommendAppraiserListItem *model;

@property(nonatomic, copy) JHActionBlock openWarnningBlock;
@end

NS_ASSUME_NONNULL_END

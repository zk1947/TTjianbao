//
//  JHBackPlayTableViewCell.h
//  TTjianbao
//
//  Created by mac on 2019/10/31.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBackPlayModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBackPlayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *beginTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *allTime;
@property(nonatomic, strong) JHBackPlayModel *model;

@end

NS_ASSUME_NONNULL_END

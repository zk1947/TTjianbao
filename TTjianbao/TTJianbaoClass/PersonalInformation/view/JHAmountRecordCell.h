//
//  JHAmountRecordCell.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/29.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAmountRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAmountRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *amoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) JHAmountRecordModel *model;

@end

NS_ASSUME_NONNULL_END

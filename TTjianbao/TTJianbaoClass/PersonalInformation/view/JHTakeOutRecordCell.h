//
//  JHTakeOutRecordCell.h
//  TTjianbao
//
//  Created by yaoyao on 2019/2/28.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAmountRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHTakeOutRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (strong, nonatomic) JHAmountRecordModel *model;

@end

NS_ASSUME_NONNULL_END

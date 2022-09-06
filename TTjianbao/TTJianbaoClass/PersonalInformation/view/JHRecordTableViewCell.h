//
//  JHRecordTableViewCell.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/13.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAppraiseRecordModel.h"
@interface JHRecordTableViewCell : UITableViewCell
@property (nonatomic, assign) NSInteger type;//主播 观众
@property (nonatomic, strong) JHAppraiseRecordModel *model;
@end

//
//  JHPresentRecordCell.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/3.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPresentRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHPresentRecordCell : UITableViewCell
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) JHPresentRecordModel *model;
@end

NS_ASSUME_NONNULL_END

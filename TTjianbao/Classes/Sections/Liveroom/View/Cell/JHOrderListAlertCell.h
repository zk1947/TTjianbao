//
//  JHOrderListAlertCell.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/24.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderListAlertCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (nonatomic, strong) OrderMode *model;

@end

NS_ASSUME_NONNULL_END

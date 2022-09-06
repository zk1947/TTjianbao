//
//  JHSendAmountCell.h
//  TTjianbao
//
//  Created by yaoyao on 2019/3/29.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CoponPackageMode;

@interface JHSendAmountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *desString;
@property (weak, nonatomic) IBOutlet UILabel *desc;//优惠券描述
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toCenterHeight;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (strong, nonatomic) CoponPackageMode *model;
@end

NS_ASSUME_NONNULL_END

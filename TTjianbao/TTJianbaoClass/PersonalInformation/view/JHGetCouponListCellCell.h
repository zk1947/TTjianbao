//
//  JHGetCouponListCellCell.h
//  TTjianbao
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSaleCouponModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHGetCouponListCellCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *getTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *useTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@property (strong, nonatomic) GetCouponUserModel *model;
@end

NS_ASSUME_NONNULL_END

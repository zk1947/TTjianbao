//
//  JHOrderSortTableViewCell.h
//  TTjianbao
//
//  Created by yaoyao on 2019/3/18.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRankingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderSortTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *sortImage;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreDes;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *anchorLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *buyerIcon;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) JHRankingNewModel *model;

@end

NS_ASSUME_NONNULL_END

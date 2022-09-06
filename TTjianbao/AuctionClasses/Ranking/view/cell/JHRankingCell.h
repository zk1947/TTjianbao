//
//  JHRankingCell.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/15.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMAvatarImageView.h"
#import "JHRankingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRankingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIImageView *rankImage;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *anchorLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic)  JHRankingModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

NS_ASSUME_NONNULL_END

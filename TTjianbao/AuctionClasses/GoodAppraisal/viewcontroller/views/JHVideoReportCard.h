//
//  JHVideoReportCard.h
//  TTjianbao
//
//  Created by yaoyao on 2019/4/15.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecorderModel.h"
#import "JHGestView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHVideoReportCard : JHGestView
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *trueOrFalseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *trueOrFalseImage;
@property (weak, nonatomic) IBOutlet UILabel *anchorLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic)JHRecorderModel *model;

@end

NS_ASSUME_NONNULL_END

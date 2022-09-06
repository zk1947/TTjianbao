//
//  JHReportRelatedHeaderView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/2/23.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHReporterDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHReportRelatedHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *trueOrFalseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *trueOrFalseImage;
@property (weak, nonatomic) IBOutlet UILabel *anchorLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property (weak, nonatomic) IBOutlet UILabel *videoDuring;
@property (weak, nonatomic) IBOutlet UIImageView *imgCover;

@property (weak, nonatomic) IBOutlet UILabel *cateName;

@property (weak, nonatomic) IBOutlet UILabel *anchorCenterLabel;

@property (strong, nonatomic)JHReporterDetailModel *model;


@end



NS_ASSUME_NONNULL_END

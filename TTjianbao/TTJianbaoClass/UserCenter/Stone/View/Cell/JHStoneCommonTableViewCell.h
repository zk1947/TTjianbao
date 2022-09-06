//
//  JHStoneCommonTableViewCell.h
//  TTjianbao
//  Description:相关基类：我的价格、买家出价、及回血直播中的原石回血、我的回血
//  Created by Jesse on 2019/11/28.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHCornerTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneCommonTableViewCell : JHCornerTableViewCell

@property (nonatomic, strong) UIImageView* ctxImage;  //内容，左边image
@property (nonatomic, strong) UIImageView* playImage; //ctxImage上面的播放图标，表示视频
@property (nonatomic, strong) UILabel* sawLabel; //N人看过
@property (nonatomic, strong) UILabel* idLabel;
@property (nonatomic, strong) UILabel* descpLabel;
@property (nonatomic, strong) UILabel* priceLabel;
@property (nonatomic, strong) JHCustomLine* bottomLine;

//根据theme需要,重置子view
- (void)resetSubview;
- (void)updateCell:(id)model;
@end

NS_ASSUME_NONNULL_END

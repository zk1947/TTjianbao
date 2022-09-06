//
//  JHStoneResaleDetailview.h
//  TTjianbao
//
//  Created by Jesse on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoneResaleDetailSubModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHStoneResaleDetailviewDelegate <NSObject>

//- (void)clickEventWithOK:(BOOL)isOK model:(JHBuyerPriceDetailModel*)model;

@end

@interface JHStoneResaleDetailview : UIView
{
    UIImageView* headImg;
    UILabel* nameLabel; //超过4个显示
    UILabel* timeLabel;
    UILabel* priceLabel;
    UIImageView* offerStatusImg;
    JHStoneResaleDetailSubModel* detailModel;
}

@property (nonatomic, weak) id <JHStoneResaleDetailviewDelegate>delegate;
@property (nonatomic, strong) UIImageView* headImg;
@property (nonatomic, strong) UILabel* nameLabel; //超过4个显示
@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) UILabel* priceLabel;
@property (nonatomic, strong) UIImageView* offerStatusImg;

- (void)updateCell:(JHStoneResaleDetailSubModel*)model;

@end

NS_ASSUME_NONNULL_END

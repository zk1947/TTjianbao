//
//  JHC2CProductDetailPaiMaiInfoTopView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYLabel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CProductDetailPaiMaiInfoTopView : UIView

@property(nonatomic, strong) UILabel * statusLbl;

@property(nonatomic, strong) UILabel * moneyValueLbl;

@property(nonatomic, strong) YYLabel * postMoneyLbl;
@property(nonatomic, strong) UILabel * endTimeTextLbl;

@property(nonatomic, strong) UIImageView * hourDianImageView;
@property(nonatomic, strong) UIImageView * secondDianImageView;

@property(nonatomic, strong) YYLabel * timeHourLbl;
@property(nonatomic, strong) YYLabel * timeMiniLbl;
@property(nonatomic, strong) YYLabel * timeSecLbl;


@end

NS_ASSUME_NONNULL_END

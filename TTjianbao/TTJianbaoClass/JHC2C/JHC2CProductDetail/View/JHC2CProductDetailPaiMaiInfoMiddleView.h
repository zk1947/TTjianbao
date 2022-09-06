//
//  JHC2CProductDetailPaiMaiInfoMiddleView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYLabel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CProductDetailPaiMaiInfoMiddleView : UIView
/// 说明
@property(nonatomic, strong) UILabel * titleLbl;

@property(nonatomic, strong) YYLabel * beginLbl;

@property(nonatomic, strong) YYLabel * addPriceLbl;

@property(nonatomic, strong) YYLabel * bugCountLbl;



- (void)refrshStartMoney:(NSString*)startMoney andAddMoney:(NSString*)addMoney andCount:(NSString*)count;

@end

NS_ASSUME_NONNULL_END

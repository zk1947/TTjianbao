//
//  JHC2CProductDetailNavView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHC2CProoductDetailModel.h"
#import "JHC2CSureMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHC2CProductDetailNavView : UIView

@property(nonatomic, strong) UIButton * quanBtn;
@property(nonatomic, strong) UIButton * wechatBtn;

@property(nonatomic, copy) NSString * productID;

@property (nonatomic, strong) JHC2CProoductDetailModel * dataModel;

@property(nonatomic, strong) JHC2CAuctionRefershModel * auModel;
@end

NS_ASSUME_NONNULL_END

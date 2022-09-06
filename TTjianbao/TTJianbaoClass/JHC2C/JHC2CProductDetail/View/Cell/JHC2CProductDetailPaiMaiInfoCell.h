//
//  JHC2CProductDetailPaiMaiInfoCell.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHC2CProoductDetailModel;
@class JHC2CAuctionRefershModel;

typedef NS_ENUM(NSInteger, JHC2CJingPaiStatus_Type){
    JHC2CJingPaiStatus_Type_WeiChuJia = 0,///未出价
    JHC2CJingPaiStatus_Type_YiChuJia,///已出价
    JHC2CJingPaiStatus_Type_ChengJiao,///成交
    JHC2CJingPaiStatus_Type_LiuPai,///流拍
} ;
@interface JHC2CProductDetailPaiMaiInfoCell : UITableViewCell

@property(nonatomic, copy) void (^tapSeletedJingPai)(void);

@property(nonatomic, strong) JHC2CProoductDetailModel * model;

@property(nonatomic, strong) JHC2CAuctionRefershModel * auModel;

@property(nonatomic, copy) void (^tapRefreshBlock)(void);


- (void)refreshStatus:(JHC2CJingPaiStatus_Type)status;

- (void)refreshPaiMai;
@end

NS_ASSUME_NONNULL_END

//
//  JHPopStoneOrderItem.h
//  TTjianbao
//  Description:
//  Created by mac on 2019/11/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLastSaleGoodsModel.h"
#import "JHPreTitleLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHPopStoneOrderItem : UIView
@property (nonatomic, strong) JHLastSaleGoodsModel *model;
- (instancetype)initVer;
@property (nonatomic, strong)JHPreTitleLabel *priceLabel;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)JHPreTitleLabel *codeLabel;
@property (nonatomic, strong)JHPreTitleLabel *shelveLabel;
@property (nonatomic, strong)UIImageView *coverImg;

@end

NS_ASSUME_NONNULL_END

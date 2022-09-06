//
//  JHMyCenterCollectionViewCell.m
//  TTjianbao
//
//  Created by apple on 2020/4/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMyCenterCollectionViewCell.h"
#import "JHMyCenterDotNumView.h"
#import "JHMyCenterDotModel.h"

@interface JHMyCenterCollectionViewCell ()

@property (nonatomic, weak) UIImageView *iconView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) JHMyCenterDotNumView *dotView;

@end


@implementation JHMyCenterCollectionViewCell

-(void)addSelfSubViews{
    _iconView = [UIImageView jh_imageViewWithContentModel:UIViewContentModeCenter addToSuperview:self.contentView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_top).offset(25);
        make.centerX.equalTo(self.contentView);
//        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];
    
    _titleLabel = [UILabel jh_labelWithFont:11 textColor:RGB(51,51,51) textAlignment:1 addToSuperView:self.contentView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
        make.centerX.equalTo(self.iconView);
    }];
    
    JHMyCenterDotNumView *dotView = [JHMyCenterDotNumView new];
    [self.contentView addSubview:dotView];
    _dotView = dotView;
    [_dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_centerX).offset(4);
        make.top.equalTo(self.iconView.mas_centerY).offset(-20);
    }];
}

-(void)setModel:(JHMyCenterMerchantCellButtonModel *)model{
    
    self.iconView.image = JHImageNamed(model.icon);
    self.titleLabel.text = model.title;
    switch (model.cellType) {
        case JHMyCenterMerchantPushTypeOrderWillPay:
        {/// 待付款
            self.dotView.number = [JHMyCenterDotModel shareInstance].waitPayCount;
        }
            break;
            
            case JHMyCenterMerchantPushTypeOrderWillSendGoods:
        {/// 待发货
            self.dotView.number = [JHMyCenterDotModel shareInstance].waitSendCount;
        }
            break;
            
        case JHMyCenterMerchantPushTypeOrderAfterSale:
        {/// 售后
            self.dotView.number = [JHMyCenterDotModel shareInstance].serviceAfterRefundCount;
        }
        break;
            
        case JHMyCenterMerchantPushTypeReSaleWillSale:
        {/// 待上架
            self.dotView.number = [JHMyCenterDotModel shareInstance].shelveCount;
        }
        break;
        case JHMyCenterMerchantPushTypeCustomizeOrderWillAccept:
        {/// 定制待接单
            self.dotView.number = [JHMyCenterDotModel shareInstance].customNumPointwaitCustomizerReceive;
        }
        break;
        case JHMyCenterMerchantPushTypeCustomizeOrderWillPay:
        {/// 定制待付款
            self.dotView.number = [JHMyCenterDotModel shareInstance].customRedPointWaitPayCount;
        }
        break;
        case JHMyCenterMerchantPushTypeCustomizeOrderPlanning:
        {/// 定制方案中
            self.dotView.number = [JHMyCenterDotModel shareInstance].customNumPointcustomizerPlaning;
        }
        break;
        case JHMyCenterMerchantPushTypeCustomizeOrderMaking:
        {/// 定制制作中
            self.dotView.number = [JHMyCenterDotModel shareInstance].customNumPointcustomizing;
        }
        break;
        case JHMyCenterMerchantPushTypeCustomizeOrderWillSend:
        {/// 定制待发货
            self.dotView.number = [JHMyCenterDotModel shareInstance].CustomNumPointweitSendCount;
        }
        break;
        case JHMyCenterMerchantPushTypeRecyleWillPay:
        {/// 回收待付款
            self.dotView.number = [JHMyCenterDotModel shareInstance].recycleRedPointWillPayCount;
        }
        break;
        case JHMyCenterMerchantPushTypeRecyleWillSend:
        {/// 回收待发货
            self.dotView.number = [JHMyCenterDotModel shareInstance].recycleRedPointWillSendCount;
        }
        break;
        case JHMyCenterMerchantPushTypeRecyleDidSend:
        {/// 回收待收货
            self.dotView.number = [JHMyCenterDotModel shareInstance].recycleRedPointDidSendCount;
        }
        break;
        case JHMyCenterMerchantPushTypeRecyleWillConfirmPrice:
        {/// 回收待确认价格
            self.dotView.number = [JHMyCenterDotModel shareInstance].recycleRedPointWillConfirmPrice;
        }
        break;
        default:{
            self.dotView.number = 0;
        }
            break;
    }
}
+ (CGSize)itemSize{
    return CGSizeMake(floorl((ScreenW-20)/4.f), 70);
}
@end

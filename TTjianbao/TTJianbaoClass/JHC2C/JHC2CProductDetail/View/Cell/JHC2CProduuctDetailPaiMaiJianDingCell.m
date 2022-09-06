//
//  JHC2CProduuctDetailPaiMaiJianDingCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/7/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProduuctDetailPaiMaiJianDingCell.h"

#import "JHC2CProductDetailJianDingStatuView.h"
#import <YYLabel.h>
#import "JHC2CProoductDetailModel.h"

@interface JHC2CProduuctDetailPaiMaiJianDingCell()

@property(nonatomic, strong) UIView * backView;

@property(nonatomic, strong) JHC2CProductDetailJianDingStatuView * topJianDingImageView;

@end

@implementation JHC2CProduuctDetailPaiMaiJianDingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backView];
    
    [self.backView addSubview:self.topJianDingImageView];

}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.topJianDingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@0).offset(12);
        make.bottom.equalTo(@0);
    }];
}
//鉴定结果类型 0 真 1 仿品 2 存疑 3 现代工艺品 999:异常     100021:鉴定中
- (void)setModel:(JHC2CProoductDetailModel *)model{
    _model = model;
    [self refreshJianDingView];
}


- (void)refreshJianDingView{
    JHC2CProductDetailJianDingType type  = JHC2CProductDetailJianDingType_NotJianDing;
    if (self.model.appraisalResult) {
        NSInteger idex = self.model.appraisalResult.appraisalResultType.integerValue;
//        鉴定结果类型 0 真 1 仿品 2 存疑 3 现代工艺品
        switch (idex) {
                //0 真
            case 0:
            {
                type  = JHC2CProductDetailJianDingType_Real;
            }
                break;
            case 1:
            {
                type  = JHC2CProductDetailJianDingType_Jia;
            }
                break;
                
            case 2:
            {
                type  = JHC2CProductDetailJianDingType_CunYi;
            }
                break;
            case 3:
            {
                type  = JHC2CProductDetailJianDingType_GongYiPin;
            }
                break;
            default:
                break;
        }
    }
    [self.topJianDingImageView refreshStatusType:type];

}

#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        _backView = view;
    }
    return _backView;
}

- (JHC2CProductDetailJianDingStatuView *)topJianDingImageView{
    if (!_topJianDingImageView) {
        JHC2CProductDetailJianDingStatuView *view = [JHC2CProductDetailJianDingStatuView new];
        _topJianDingImageView = view;
    }
    return _topJianDingImageView;
}

- (void)setGoJianDingBlock:(void (^)(void))goJianDingBlock{
    self.topJianDingImageView.goJianDingBlock = goJianDingBlock;
}

@end


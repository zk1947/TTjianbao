//
//  JHGoodsDetailRepertoryCell.m
//  TTjianbao
//
//  Created by lihui on 2020/3/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGoodsDetailRepertoryCell.h"
#import "CGoodsDetailModel.h"

@interface JHGoodsDetailRepertoryCell ()

@property (nonatomic, strong) UILabel *reoertoryLabel;      //库存显示
@property (nonatomic, strong) UILabel *countLabel;          //当前剩余商品数量

@end

@implementation JHGoodsDetailRepertoryCell

+ (CGFloat)cellHeight {
    return 41;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)setGoodsInfo:(CGoodsInfo *)goodsInfo {
    if (!goodsInfo) {
        return;
    }
    _goodsInfo = goodsInfo;
    _countLabel.text = _goodsInfo.stock?:@"0";
}

- (void)configUI {
    //库存文字显示
    _reoertoryLabel = [[UILabel alloc] init];
    _reoertoryLabel.text = @"库存(件)";
    _reoertoryLabel.font = [UIFont fontWithName:kFontNormal size:15];
    
    //当前商品库存数量
    _countLabel  = [[UILabel alloc] init];
    _countLabel.text = @"0";
    _countLabel.font = [UIFont fontWithName:kFontNormal size:15];
    
    //加入视图
    [self.contentView addSubview:_reoertoryLabel];
    [self.contentView addSubview:_countLabel];
    
    [_reoertoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.reoertoryLabel);
        make.height.equalTo(self.contentView);
        make.width.mas_lessThanOrEqualTo(150);
    }];
}



@end

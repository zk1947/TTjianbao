//
//  JHDetailAgreementView.m
//  TTjianbao
//
//  Created by liuhai on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHDetailAgreementView.h"

@implementation JHDetailAgreementView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF5F5F8);
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    UIImageView *handleImg = [[UIImageView alloc] init];
    [self addSubview:handleImg];
    [handleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@9);
        make.left.right.equalTo(self);
        make.height.equalTo(@36);
    }];
    UIImage *img = [UIImage imageNamed:@"newStroe_detailAgreementBg"];
   // 四个数值对应图片中距离上、左、下、右边界的不拉伸部分的范围宽度
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 80, 0, 35) resizingMode:UIImageResizingModeStretch];
    handleImg.image = img;
    
    //  //
    UIImageView *safeImage = [[UIImageView alloc] init];
    safeImage.image = [UIImage imageNamed:@"newStoreSpecialSafeIcon"];
    [handleImg addSubview:safeImage];
    [safeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@12);
        make.size.mas_equalTo(CGSizeMake(14, 16));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"严选好物 值得收藏";
    titleLabel.font = JHBoldFont(13);
    titleLabel.textColor = HEXCOLOR(0xB38A50);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [handleImg addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(safeImage.mas_right).offset(4);
        make.top.equalTo(@9);
    }];
    
    UIImageView *arrowImage = [[UIImageView alloc] init];
    arrowImage.image = [UIImage imageNamed:@"newStoreSpecialArrow"];
    [handleImg addSubview:arrowImage];
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@14);
        make.right.equalTo(@-12);
        make.size.mas_equalTo(CGSizeMake(6, 8));
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"专业鉴定·先鉴后发·假一赔三·售后无忧";
    descLabel.font = JHFont(11);
    descLabel.textColor = HEXCOLOR(0xB38A50);
    descLabel.textAlignment = NSTextAlignmentRight;
    [handleImg addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(arrowImage.mas_left).offset(-5);
        make.top.equalTo(@10);
    }];
}

@end

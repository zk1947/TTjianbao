//
//  JHRecyclePublishProcessView.m
//  TTjianbao
//
//  Created by liuhai on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePublishProcessView.h"

@implementation JHRecyclePublishProcessView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
   
    UIImageView *safeImage = [[UIImageView alloc] init];
    safeImage.image = [UIImage imageNamed:@"recycleprocess1"];
    [self addSubview:safeImage];
    [safeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"发布宝贝";
    titleLabel.font = JHMediumFont(12);
    titleLabel.textColor = HEXCOLOR(0xFF6A00);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(safeImage.mas_right).offset(4);
    }];
    
    UIImageView *arrowImage = [[UIImageView alloc] init];
    arrowImage.image = [UIImage imageNamed:@"recycleprocess6"];
    [self addSubview:arrowImage];
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(titleLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(5, 8));
    }];
    
    UIImageView *safeImage2 = [[UIImageView alloc] init];
    safeImage2.image = [UIImage imageNamed:@"recycleprocess2"];
    [self addSubview:safeImage2];
    [safeImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(arrowImage.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    UILabel *titleLabel2 = [[UILabel alloc] init];
    titleLabel2.text = @"确认报价 ";
    titleLabel2.font = JHMediumFont(12);
    titleLabel2.textColor = HEXCOLOR(0x888888);
    titleLabel2.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel2];
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(safeImage2.mas_right).offset(4);
    }];
    
    UIImageView *arrowImage2 = [[UIImageView alloc] init];
    arrowImage2.image = [UIImage imageNamed:@"recycleprocess6"];
    [self addSubview:arrowImage2];
    [arrowImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(titleLabel2.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(5, 8));
    }];
    
    UIImageView *safeImage3 = [[UIImageView alloc] init];
    safeImage3.image = [UIImage imageNamed:@"recycleprocess3"];
    [self addSubview:safeImage3];
    [safeImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(arrowImage2.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    UILabel *titleLabel3 = [[UILabel alloc] init];
    titleLabel3.text = @"顺丰取件 ";
    titleLabel3.font = JHMediumFont(12);
    titleLabel3.textColor = HEXCOLOR(0x888888);
    titleLabel3.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel3];
    [titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(safeImage3.mas_right).offset(4);
    }];
    
    UIImageView *arrowImage4 = [[UIImageView alloc] init];
    arrowImage4.image = [UIImage imageNamed:@"recycleprocess6"];
    [self addSubview:arrowImage4];
    [arrowImage4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(titleLabel3.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(5, 8));
    }];
    
    UIImageView *safeImage4 = [[UIImageView alloc] init];
    safeImage4.image = [UIImage imageNamed:@"recycleprocess4"];
    [self addSubview:safeImage4];
    [safeImage4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(arrowImage4.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    UILabel *titleLabel4 = [[UILabel alloc] init];
    titleLabel4.text = @"快速回款 ";
    titleLabel4.font = JHMediumFont(12);
    titleLabel4.textColor = HEXCOLOR(0x888888);
    titleLabel4.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel4];
    [titleLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(safeImage4.mas_right).offset(4);
        make.right.equalTo(self.mas_right).offset(0);
    }];
}


@end

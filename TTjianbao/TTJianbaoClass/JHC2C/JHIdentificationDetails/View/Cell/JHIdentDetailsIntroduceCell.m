//
//  JHIdentDetailsIntroduceCell.m
//  TTjianbao
//
//  Created by miao on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIdentDetailsIntroduceCell.h"
#import "JHIdentificationDetailsSubView.h"
#import "JHIdentificationDetailsModel.h"

@interface JHIdentDetailsIntroduceCell ()

/// 宝贝分类
@property (nonatomic, strong) JHIdentificationDetailsSubView *babyClassification;
/// 鉴定费用
@property (nonatomic, strong) JHIdentificationDetailsSubView *appraisalCharge;
/// 介绍
@property (nonatomic, strong) UILabel *introduceLable;


@end

@implementation JHIdentDetailsIntroduceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self p_drawSubViews];
        [self p_makeLayout];
    }
    return self;
}

- (void)p_drawSubViews {
    
    _babyClassification = [JHIdentificationDetailsSubView new];
    _babyClassification.identificationTitleLabel.text = @"宝贝分类：";
    _babyClassification.identificationTitleLabel.font = JHFont(16);
    [self addSubview:_babyClassification];
    
    _appraisalCharge = [JHIdentificationDetailsSubView  new];
    _appraisalCharge.identificationTitleLabel.text = @"鉴定费用：";
    _appraisalCharge.identificationResultsLabel.font = [UIFont fontWithName:kFontBoldDIN size:14];
    _appraisalCharge.identificationResultsLabel.textColor = HEXCOLOR(0xF23730);
    [self addSubview:_appraisalCharge];
    
    _introduceLable = [UILabel new];
    _introduceLable.font = JHFont(16);
    _introduceLable.textColor = HEXCOLOR(0x333333);
    _introduceLable.numberOfLines = 0;
    [self addSubview:_introduceLable];
    
    
}

- (void)p_makeLayout {
    [_babyClassification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.height.mas_offset(23);
        make.left.right.equalTo(self);
            
    }];
    
    [_appraisalCharge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_babyClassification.mas_bottom).offset(10);
        make.height.equalTo(_babyClassification);
        make.left.right.equalTo(_babyClassification);
    }];

    [_introduceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_appraisalCharge.mas_bottom).offset(10);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
    }];
}

- (void)setIntroduceModel:(JHIdentificationDetailsModel *)introduceModel {
    
    _babyClassification.identificationResultsLabel.text = introduceModel.showCategoryName;
    _appraisalCharge.identificationResultsLabel.text = introduceModel.showAppraisalFeeYuan;
    _introduceLable.text = introduceModel.productDesc;
    
}

@end

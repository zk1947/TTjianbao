//
//  JHUserAuthEnterpriseHeader.m
//  TTjianbao
//
//  Created by lihui on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUserAuthEnterpriseHeader.h"
#import "UIButton+ImageTitleSpacing.h"

@interface JHUserAuthEnterpriseHeader ()
///个体工商户
@property (nonatomic, strong) UIButton *personalButon;
///普通企业
@property (nonatomic, strong) UIButton *enterpriseButon;
@end

@implementation JHUserAuthEnterpriseHeader

+ (CGFloat)headerHeight {
    return 92.f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kColorF5F5F8;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomView.backgroundColor = kColorFFF;
    bottomView.layer.cornerRadius = 8.f;
    bottomView.layer.masksToBounds = YES;
    [self.contentView addSubview:bottomView];
    
    UILabel * label = [[UILabel alloc] init];
    label.text = @"企业类型";
    label.font = [UIFont fontWithName:kFontMedium size:13.];
    label.textColor = kColor333;
    [bottomView addSubview:label];
    
    UIButton *personalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [personalButton setTitle:@"个体工商户" forState:UIControlStateNormal];
    [personalButton setTitle:@"个体工商户" forState:UIControlStateSelected];
    [personalButton setTitleColor:kColor333 forState:UIControlStateNormal];
    [personalButton setTitleColor:kColor333 forState:UIControlStateSelected];
    [personalButton setImage:[UIImage imageNamed:@"icon_user_auth_select_nor"] forState:UIControlStateNormal];
    [personalButton setImage:[UIImage imageNamed:@"icon_user_auth_select_sel"] forState:UIControlStateSelected];
    personalButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:13.];
    [personalButton addTarget:self action:@selector(handlerPersonalButtonActionEvent) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:personalButton];
    personalButton.selected = YES;
    _personalButon = personalButton;
    
    UIButton *enterpriseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterpriseButton setTitle:@"普通企业" forState:UIControlStateNormal];
    [enterpriseButton setTitle:@"普通企业" forState:UIControlStateSelected];
    [enterpriseButton setTitleColor:kColor333 forState:UIControlStateNormal];
    [enterpriseButton setTitleColor:kColor333 forState:UIControlStateSelected];
    [enterpriseButton setImage:[UIImage imageNamed:@"icon_user_auth_select_nor"] forState:UIControlStateNormal];
    [enterpriseButton setImage:[UIImage imageNamed:@"icon_user_auth_select_sel"] forState:UIControlStateSelected];
    enterpriseButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:13.];
    [enterpriseButton addTarget:self action:@selector(handlerEnterpriseButtonActionEvent) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:enterpriseButton];
    _enterpriseButon = enterpriseButton;
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(12, 12, 0, 12));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(10);
        make.top.equalTo(bottomView).offset(13);
    }];
    
    [personalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label);
        make.top.equalTo(label.mas_bottom).offset(14);
    }];
    
    [enterpriseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(personalButton.mas_right).offset(46.);
        make.centerY.equalTo(self.personalButon);
    }];
    
    [self layoutIfNeeded];
    [personalButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8.];
    [enterpriseButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8.];
}

- (void)handlerPersonalButtonActionEvent {
    if (self.actionBlock) {
        self.personalButon.selected = YES;
        self.enterpriseButon.selected = !self.personalButon.selected;
        self.actionBlock(JHUserAuthTypeIndividualBunsiness);
    }
}

- (void)handlerEnterpriseButtonActionEvent {
    if (self.actionBlock) {
        self.enterpriseButon.selected = YES;
        self.personalButon.selected = !self.enterpriseButon.selected;
        self.actionBlock(JHUserAuthTypeCommonBunsiness);
    }
}

@end

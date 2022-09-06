//
//  JHCustomerSectionHeader.m
//  TTjianbao
//
//  Created by lihui on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerSectionHeader.h"
#import "UIButton+ImageTitleSpacing.h"
#import "TTjianbaoMarcoUI.h"

@interface JHCustomerSectionHeader ()

///直播图标
//@property (nonatomic, strong) UIImageView *headerIcon;
///直播间名称
@property (nonatomic, strong) UILabel *nameLabel;
///编辑按钮
@property (nonatomic, strong) UIButton *editButton;
///申请定制按钮
@property (nonatomic, strong) UIButton *applyButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) BOOL isShowEdit;

@end


@implementation JHCustomerSectionHeader

#pragma mark -
#pragma mark - setter / getter

- (void)setSectionTitle:(NSString *)sectionTitle {
    _sectionTitle = sectionTitle;
    self.nameLabel.text = [sectionTitle isNotBlank] ? sectionTitle : @"";
}

- (instancetype)initWithFrame:(CGRect)frame isShowEdit:(BOOL)isShow section:(NSInteger)section {
    self = [super initWithFrame:frame];
    if (self) {
        _isShowEdit = isShow;
        _section = section;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"--";
    nameLabel.font = [UIFont fontWithName:kFontMedium size:15];
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setImage:[UIImage imageNamed:@"store_icon_seller_more_arrow"] forState:UIControlStateNormal];
    [editBtn setTitleColor:kColor999 forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
    [editBtn addTarget:self action:@selector(editBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    editBtn.hidden = !_isShowEdit;
    [self addSubview:editBtn];
    _editButton = editBtn;
    
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyBtn setTitle:@"申请定制" forState:UIControlStateNormal];
    [applyBtn setImage:[UIImage imageNamed:@"icon_user_info_arrow_orange"] forState:UIControlStateNormal];
    [applyBtn setTitleColor:HEXCOLOR(0xFE9100) forState:UIControlStateNormal];
    applyBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:12];
    [applyBtn addTarget:self action:@selector(handleApplyClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
    BOOL isShow = [self showApplyButton];
    applyBtn.hidden = isShow;
    [self addSubview:applyBtn];
    _applyButton = applyBtn;
    
    [self makeLayouts];
}

- (void)makeLayouts {
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.f);
        make.top.equalTo(self).offset(15.f);
        make.right.equalTo(self);
    }];

    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15.f);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    [_applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15.f);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    [self layoutIfNeeded];
    [_editButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5.];
    [_applyButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5.];
}


#pragma mark -
#pragma mark - action event

///申请定制
- (void)handleApplyClickEvent {
    if (IS_LOGIN && self.actionBlock) {
        self.actionBlock(self.section);
    }
}

///编辑
- (void)editBtnEvent {
    NSLog(@"editBtnEvent");
    if (IS_LOGIN && self.actionBlock) {
        self.actionBlock(self.section);
    }
}

- (BOOL)showApplyButton {
    BOOL isShow = NO;
    if (!_isShowEdit) {
        ///不显示编辑 根据section判断是否需要显示申请定制入口
        isShow = (_section == 4);
    }
    return !isShow;
}

- (void)hiddenRecycleCagetory:(BOOL)isHidden {
    self.editButton.hidden = isHidden;
}


- (void)reloadApplayStatus:(NSString *)str {
    if (!_isShowEdit) {
        if ([str isEqualToString:@"定制费用说明"]) {
            self.applyButton.hidden = NO;
        } else {
            self.applyButton.hidden = YES;
        }
    }
}


@end

//
//  JHRecycleInfoSectionHeader.m
//  TTjianbao
//
//  Created by user on 2021/4/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleInfoSectionHeader.h"
#import "UIButton+ImageTitleSpacing.h"
#import "TTjianbaoMarcoUI.h"

@interface JHRecycleInfoSectionHeader ()

/// 图标
@property (nonatomic, strong) UIImageView *headerIcon;
/// 直播间名称
@property (nonatomic, strong) UILabel     *nameLabel;
/// 编辑按钮
@property (nonatomic, strong) UIButton    *editButton;
@property (nonatomic, assign) NSInteger    section;
@property (nonatomic, assign) BOOL         isShowEdit;
@end

@implementation JHRecycleInfoSectionHeader
#pragma mark - setter / getter

- (void)setSectionTitle:(NSString *)sectionTitle image:(NSString *)image {
    _sectionTitle = sectionTitle;
    _nameLabel.text = [sectionTitle isNotBlank] ? sectionTitle : @"";
    _headerIcon.image = [UIImage imageNamed:image];
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
    UIImageView *headerIcon = [[UIImageView alloc] init];
    [self addSubview:headerIcon];
    _headerIcon = headerIcon;
    
    
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
    [self makeLayouts];
}

- (void)makeLayouts {
    [_headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.f);
        make.top.equalTo(self).offset(15.f);
        make.width.height.mas_equalTo(20.f);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIcon.mas_right).offset(8.f);
        make.centerY.equalTo(self.headerIcon.mas_centerY);
        make.right.equalTo(self);
    }];

    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15.f);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    [self layoutIfNeeded];
    [_editButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5.];
}


#pragma mark -
#pragma mark - action event
///编辑
- (void)editBtnEvent {
    if (IS_LOGIN && self.actionBlock) {
        self.actionBlock(self.section);
    }
}

- (void)hiddenRecycleCagetory:(BOOL)isHidden {
    self.editButton.hidden = isHidden;
}

@end

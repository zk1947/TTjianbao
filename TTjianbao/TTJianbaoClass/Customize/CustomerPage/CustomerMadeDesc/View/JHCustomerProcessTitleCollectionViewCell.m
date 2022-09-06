//
//  JHCustomerProcessTitleCollectionViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerProcessTitleCollectionViewCell.h"
#import "JHDetailHotNewSwtchView.h"
#import "UIView+JHGradient.h"

@interface JHCustomerProcessTitleCollectionViewCell ()
@property (nonatomic, strong) UILabel                 *titleLabel;
@property (nonatomic, strong) JHDetailHotNewSwtchView *segView;
@property (nonatomic, strong) UIButton                *addInfoBtn;
@end

@implementation JHCustomerProcessTitleCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = HEXCOLOR(0xffffff);

    _titleLabel                      = [[UILabel alloc] init];
    _titleLabel.textColor            = HEXCOLOR(0x333333);
    _titleLabel.textAlignment        = NSTextAlignmentLeft;
    _titleLabel.font                 = [UIFont fontWithName:kFontMedium size:15.f];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.height.mas_equalTo(21.f);
    }];

    _segView                         = [[JHDetailHotNewSwtchView alloc] init];
    [_segView setSwitchBtnName:@[@"正序",@"倒序"]];
    [self.contentView addSubview:_segView];
    [_segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.width.mas_equalTo(76.f);
        make.height.mas_equalTo(22.f);
    }];
    [_segView setSelectIndex:1]; /// 默认倒序
    @weakify(self);
    _segView.selectBlock = ^(NSInteger index) {
        @strongify(self);
        [self sortMethod:index];
    };

    _addInfoBtn                      = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addInfoBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [_addInfoBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _addInfoBtn.titleLabel.font      = [UIFont fontWithName:kFontNormal size:16.f];
    [_addInfoBtn setTitle:@"添加沟通信息" forState:UIControlStateNormal];
    [_addInfoBtn addTarget:self action:@selector(addInfoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _addInfoBtn.layer.cornerRadius   = 22.f;
    _addInfoBtn.layer.masksToBounds  = YES;
    _addInfoBtn.hidden               = YES;
    [self.contentView addSubview:_addInfoBtn];
    [_addInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15.f);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(ScreenWidth - 44.f);
        make.height.mas_equalTo(44.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-8.f);
    }];
}

- (void)sortMethod:(NSInteger)index {
    if (!self.orderByBlock) {
        return;
    }
    if (index == 0) {
        /// 正序
        self.orderByBlock(YES);
    } else {
        /// 倒叙
        self.orderByBlock(NO);
    }
}

- (void)setOrderStatus:(BOOL)isOrderByYes {
    if (isOrderByYes) {
        [self.segView setSelectIndex:0]; /// 正序
    } else {
        [self.segView setSelectIndex:1]; /// 倒序
    }
}

- (void)addInfoBtnAction:(UIButton *)sender {
    if (self.addBlock) {
        self.addBlock();
    }
}

- (void)setViewModel:(BOOL)viewModel {
    self.titleLabel.text = @"定制过程";
    self.addInfoBtn.hidden = !viewModel;
    if (viewModel) {
        [self.addInfoBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(15.f);
            make.height.mas_equalTo(44.f);
        }];
    } else {
        [self.addInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0.f);
        }];
    }
}


@end

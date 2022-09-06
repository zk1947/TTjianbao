//
//  JHGoodManagerListNavView.m
//  TTjianbao
//
//  Created by user on 2021/7/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerListNavView.h"
#import "JHGoodManagerListChooseItemView.h"
#import "JHGoodManagerSingleton.h"
#import "UIButton+LXExpandBtn.h"

@interface JHGoodManagerListNavSearchView : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *searchTextField;
@end

@implementation JHGoodManagerListNavSearchView
- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIImageView *searchIcon      = [[UIImageView alloc] init];
    searchIcon.image             = [UIImage imageNamed:@"jhGoodManagerList_search"];
    [self addSubview:searchIcon];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(9.f);
        make.width.mas_equalTo(15.f);
        make.height.mas_equalTo(15.f);
    }];

    _searchTextField                 = [[UITextField alloc] init];
    _searchTextField.textColor       = HEXCOLOR(0x333333);
    _searchTextField.font            = [UIFont fontWithName:kFontNormal size:13.f];
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.placeholder     = @"输入商品名称搜索";
    _searchTextField.delegate        = self;
    _searchTextField.returnKeyType   = UIReturnKeySearch;
    [self addSubview:_searchTextField];
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(searchIcon.mas_right).offset(5.f);
        make.right.equalTo(self.mas_right).offset(-5.f);
        make.height.mas_equalTo(18.f);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.searchTextField.text.length >0) {
        [JHGoodManagerSingleton shared].searchName = self.searchTextField.text;
    } else {
        [JHGoodManagerSingleton shared].searchName = @"";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.searchTextField.text.length >0) {
        [JHGoodManagerSingleton shared].searchName = self.searchTextField.text;
    } else {
        [JHGoodManagerSingleton shared].searchName = @"";
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JHGOODMANAGERLISTSHOULDREQUEST" object:nil];
    return YES;
}

@end



@interface JHGoodManagerListNavView ()
@property (nonatomic, strong) UIView                          *backView;
@property (nonatomic, strong) UIButton                        *backButton;
@property (nonatomic, strong) UIButton                        *channelButton;
@property (nonatomic, strong) JHGoodManagerListNavSearchView  *searchView;
@property (nonatomic, strong) JHGoodManagerListChooseItemView *chooseItemView;
@end

@implementation JHGoodManagerListNavView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = HEXCOLOR(0xFFFFFF);
    [self addSubview:_backView];
    CGFloat statusBarHeight          = UI.statusBarHeight;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(statusBarHeight);
        make.height.mas_equalTo(44.f);
    }];
    
    /// 返回按钮
    _backButton                        = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImage:[UIImage imageNamed:@"jhGoodManagerList_back"] forState:UIControlStateNormal];
    [_backView addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8.f);
        make.centerY.equalTo(self.backView.mas_centerY);
        make.width.mas_equalTo(23.f);
        make.height.mas_equalTo(32.f);
    }];
    
    /// 筛选
    _channelButton                     = [UIButton buttonWithType:UIButtonTypeCustom];
    [_channelButton addTarget:self action:@selector(channelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_channelButton setTitle:@"筛选" forState:UIControlStateNormal];
    [_channelButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _channelButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13.f];
    [_channelButton setImage:[UIImage imageNamed:@"jhGoodManagerList_channel"] forState:UIControlStateNormal];
    [_channelButton layoutButtonWithEdgeInsetsStyle:LXButtonEdgeInsetsStyleLeft imageTitleSpace:5.f];
    _channelButton.hitTestEdgeInsets = UIEdgeInsetsMake(-5.f, -5.f, -5.f, -5.f);
    [_backView addSubview:_channelButton];
    [_channelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right).offset(-10.f);
        make.centerY.equalTo(self.backView.mas_centerY);
        make.width.mas_equalTo(53.f);
        make.height.mas_equalTo(18.f);
    }];
    
    
    /// 搜索
    _searchView = [[JHGoodManagerListNavSearchView alloc] init];
    _searchView.layer.cornerRadius = 15.f;
    _searchView.layer.masksToBounds = YES;
    _searchView.backgroundColor = HEXCOLOR(0xF8F8F8);
    [_backView addSubview:_searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton.mas_right).offset(11.f);
        make.right.equalTo(self.channelButton.mas_left).offset(-15.f);
        make.centerY.equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    
    /// 筛选项
    _chooseItemView = [[JHGoodManagerListChooseItemView alloc] init];
    _chooseItemView.backgroundColor = HEXCOLOR(0xFFFFFF);
    [self addSubview:_chooseItemView];
    [_chooseItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(46.f);
    }];
}

- (void)setIsAuction:(BOOL)isAuction {
    _isAuction = isAuction;
    _chooseItemView.isAuction = _isAuction;
}


/// 点击返回
- (void)backButtonAction:(UIButton *)sender {
    if (self.backBlock) {
        self.backBlock();
    }
}

/// 点击筛选
- (void)channelButtonAction:(UIButton *)sender {
    if (self.channelBlock) {
        self.channelBlock();
    }
}


- (void)setViewModel:(NSArray<JHGoodManagerListTabChooseModel *> *)viewModel {
    [self.chooseItemView setviewModel:viewModel];
}


@end

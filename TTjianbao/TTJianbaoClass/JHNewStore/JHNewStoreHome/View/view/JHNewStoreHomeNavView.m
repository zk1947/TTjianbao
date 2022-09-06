//
//  JHNewStoreHomeNavView.m
//  TTjianbao
//
//  Created by user on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeNavView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHHotWordModel.h"
#import "JHWebViewController.h"
#import "JHNewStoreHomeReport.h"
#import "JHMyCenterDotNumView.h"
#import "JHSQHelper.h"

@interface JHNewStoreHomeSearchView : UIView
@property (nonatomic, strong) UILabel *searchDefaultLabel;
@end

@implementation JHNewStoreHomeSearchView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"jh_newStore_homeNavSearch"];
    [self addSubview:searchIcon];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(10.f);
        make.width.mas_equalTo(13.f);
        make.height.mas_equalTo(12.f);
    }];
    
    _searchDefaultLabel           = [[UILabel alloc] init];
    _searchDefaultLabel.textColor = HEXCOLOR(0x888888);
    _searchDefaultLabel.font      = [UIFont fontWithName:kFontNormal size:13.f];
    _searchDefaultLabel.text      = @"翡翠吊坠";
    [self addSubview:_searchDefaultLabel];
    [_searchDefaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(searchIcon.mas_right).offset(5.f);
        make.right.equalTo(self.mas_right).offset(-5.f);
        make.height.mas_equalTo(18.f);
    }];
}

- (void)reloadSearchHotKey:(NSString *)str {
    self.searchDefaultLabel.text = NONNULL_STR(str);
}

@end


@interface JHNewStoreHomeNavView ()
@property (nonatomic, strong) UIButton                 *titleLabelBtn;
@property (nonatomic, strong) UILabel                  *subTitleLabel;
@property (nonatomic, strong) UIButton                 *messageBtn;
/// 右上角消息按钮
@property (nonatomic, strong) JHMyCenterDotNumView     *messageLabel;
//@property (nonatomic, strong) JHNewStoreHomeSearchView *searchView;
@property (nonatomic, strong) JHEasyPollSearchBar *searchBar;

@property (nonatomic, strong) UIImageView              *backDownImageView;
@property (nonatomic, strong) UIImageView              *backUpImageView;
@end

@implementation JHNewStoreHomeNavView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLOR(0xFFFFFF);
    
    _backDownImageView = [[UIImageView alloc] init];
    _backDownImageView.image = [UIImage imageNamed:@"jh_newStore_homeNavBack_down"];
    [self addSubview:_backDownImageView];
    [_backDownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(UI.statusBarHeight);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(88.f - 12.f);
    }];
    
    _titleLabelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_titleLabelBtn setTitle:@"严选好物 值得收藏" forState:UIControlStateNormal];
    [_titleLabelBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _titleLabelBtn.titleLabel.font = [UIFont fontWithName:kFontBoldPingFang size:16.f];
    [_titleLabelBtn setImage:[UIImage imageNamed:@"jh_newStore_homeNavRight"] forState:UIControlStateNormal];
    [_titleLabelBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10.f];
    [_titleLabelBtn addTarget:self action:@selector(goToStoreH5) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_titleLabelBtn];
    [_titleLabelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(UI.statusBarHeight + 6.f);
        make.left.equalTo(self.mas_left).offset(12.f);
        make.height.mas_equalTo(16.f);
    }];

    _subTitleLabel                        = [[UILabel alloc] init];
    _subTitleLabel.textColor              = HEXCOLOR(0x333333);
    _subTitleLabel.font                   = [UIFont fontWithName:kFontLight size:11.f];
    _subTitleLabel.text                   = @"专业鉴定 · 先鉴后发 · 假一赔三 · 售后无忧";
    _subTitleLabel.userInteractionEnabled = YES;
    [self addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabelBtn.mas_bottom).offset(5.f);
        make.left.equalTo(self.titleLabelBtn.mas_left);
        make.height.mas_equalTo(16.f);
    }];
    UITapGestureRecognizer *subTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToStoreH5)];
    [_subTitleLabel addGestureRecognizer:subTap];
    
    _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_messageBtn setImage:[UIImage imageNamed:@"navi_icon_message"] forState:UIControlStateNormal];
    [_messageBtn addTarget:self action:@selector(messageBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_messageBtn];
    [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(UI.statusBarHeight);
        make.right.equalTo(self.mas_right);
        make.width.mas_equalTo(40.f);
        make.height.mas_equalTo(44.f);
    }];
    
    _messageLabel                     = [[JHMyCenterDotNumView alloc] init];
    _messageLabel.backgroundColor     = HEXCOLOR(0xF03D37);
    _messageLabel.textColor           = HEXCOLOR(0xFFFFFF);
//    _messageLabel.font                = [UIFont fontWithName:kFontBoldPingFang size:11.f];
    _messageLabel.textAlignment       = NSTextAlignmentCenter;
    _messageLabel.layer.cornerRadius  = 7.5f;
    _messageLabel.layer.masksToBounds = YES;
    _messageLabel.hidden              = YES;
    [self addSubview:_messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.messageBtn.mas_centerX);
//        make.bottom.equalTo(self.messageBtn.mas_centerY).offset(-3.f);
//        make.width.mas_equalTo(15.f);
//        make.height.mas_equalTo(15.f);
        make.right.equalTo(self.messageBtn).offset(-8);
        make.top.equalTo(self.messageBtn.mas_centerY).offset(-20);
    }];

//    _searchView                        = [[JHNewStoreHomeSearchView alloc] init];
//    _searchView.layer.cornerRadius     = 15.f;
//    _searchView.layer.masksToBounds    = YES;
//    _searchView.layer.borderWidth      = 1.f;
//    _searchView.layer.borderColor      = HEXCOLOR(0xFFCB0F).CGColor;
//    _searchView.backgroundColor        = HEXCOLOR(0xFFFFFF);
//    _searchView.userInteractionEnabled = YES;
//    [self addSubview:_searchView];
//    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabelBtn.mas_left);
//        make.right.equalTo(_messageBtn.mas_right).offset(-10.f);
//        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(12.f);
//        make.height.mas_equalTo(30.f);
//    }];
    
    _searchBar = [JHSQHelper searchBar];
    _searchBar.backgroundColor = kColorFFF;
    _searchBar.layer.borderColor = HEXCOLOR(0xFFD70F).CGColor;
    _searchBar.layer.borderWidth = 1.5;
    _searchBar.searchBarShowFrom = JHSearchBarShowFromSoureHome;
    [self addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabelBtn.mas_left);
        make.right.equalTo(_messageBtn.mas_right).offset(-10.f);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(12.f);
        make.height.mas_equalTo(30.f);
    }];
//    _searchBar.frame = CGRectMake(12, UI.statusAndNavBarHeight + 10, kScreenWidth-54, 30);
    //搜索事件
    @weakify(self);
    _searchBar.didSelectedBlock = ^(NSInteger selectedIndex, BOOL isLeft) {
        @strongify(self);
        if (self.searchScrollBlock) {
            self.searchScrollBlock(selectedIndex);
        }
    };
    UIView *backUpView = [[UIView alloc] init];
    backUpView.backgroundColor = HEXCOLOR(0xFFFFFF);
    [self addSubview:backUpView];
    [backUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(UI.statusBarHeight);
    }];

    _backUpImageView = [[UIImageView alloc] init];
    _backUpImageView.image = [UIImage imageNamed:@"jh_newStore_homeNavBack_up"];
    [self addSubview:_backUpImageView];
    [_backUpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(UI.statusBarHeight);
    }];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchDidClicked)];
//    [_searchView addGestureRecognizer:tap];
}


- (void)goToStoreH5 {
    [JHNewStoreHomeReport jhNewStoreHomeGoToEducationClick];
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.urlString = H5_BASE_STRING(@"/jianhuo/app/shop/check.html");
    [JHRootController.currentViewController.navigationController pushViewController:webVC animated:YES];
}

- (void)reloadHotKeys {
    if (self.hotKeysArray.count <= 0) {
        return;
    }
    
    self.searchBar.placeholderArray = self.hotKeysArray;
//    [self.searchView reloadSearchHotKey:[self resetRandomSearchDefaultQuery]];
}

- (NSString *)resetRandomSearchDefaultQuery {
    if (self.hotKeysArray.count <= 0) {
        return nil;
    }
    NSInteger index = arc4random()%self.hotKeysArray.count;
    if (index < self.hotKeysArray.count) {
        JHHotWordModel *model = self.hotKeysArray[index];
        return NONNULL_STR(model.title);
    } else {
        return nil;
    }
}

- (void)searchDidClicked {
    if (self.searchClickBlock) {
        self.searchClickBlock();
    }
}

- (void)messageBtnDidClicked:(UIButton *)sender {
    if (self.messageBtnClickBlock) {
        self.messageBtnClickBlock();
    }
}

- (void)reloadMessageInfoCount:(NSString *)count {
    if (!isEmpty(count) && [count integerValue] >0) {
        self.messageLabel.hidden = NO;
        self.messageLabel.number = [count integerValue];
    } else {
        self.messageLabel.hidden = YES;
    }
}


- (void)reloadAnimation:(CGFloat)offset {
    self.titleLabelBtn.alpha = (1-(1.f/30.f)*offset);
    self.subTitleLabel.alpha = (1-(1.f/30.f)*offset);
    self.backUpImageView.alpha = (1-(1.f/30.f)*offset);
    self.backDownImageView.alpha = (1-(1.f/30.f)*offset);
    self.messageBtn.alpha = (1-(1.f/30.f)*offset);
    self.messageLabel.alpha = (1-(1.f/30.f)*offset);
    
    CGFloat titleLabelTop = UI.statusBarHeight + 6.f - offset;
    if (offset >= 45) {
        titleLabelTop = UI.statusBarHeight + 6.f - 45.f;
    }
    [self.titleLabelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(titleLabelTop);
    }];
    
//    CGFloat searchViewRight = offset * ((16.f+19)/45.f);
//    if (offset >= 45.f) {
//        searchViewRight = 16 + 19.f;
//    }
//    [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.messageBtn.mas_right).offset(-10.f -searchViewRight);
//    }];
}


@end

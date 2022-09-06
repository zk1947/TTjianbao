//
//  JHFoucsListRootController.m
//  TTjianbao
//
//  Created by apple on 2020/2/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHFoucsListShopViewModel.h"
#import "JHFoucsListRootController.h"
#import "JHFoucsShopListController.h"
#import "JHFoucsPlateController.h"

@interface JHFoucsListRootController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *rootScrollView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *shopButton;
@property (nonatomic, strong) UIButton *userButton;
@property (nonatomic, strong) UIButton *plateButton;

@property (nonatomic, strong) JHFoucsShopListController *shopVC;
@property (nonatomic, strong) JHUserFriendListController *userVC;
@property (nonatomic, strong) JHFoucsPlateController *plateVC;

@property (nonatomic, strong) UIView *contentView;
@end

@implementation JHFoucsListRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.jhTitleLabel.font = JHMediumFont(15);
    [self jhNavBottomLine];
    _rootScrollView = [UIScrollView jh_scrollViewWithContentSize:CGSizeZero showsScrollIndicator:NO scrollsToTop:NO bounces:NO pagingEnabled:YES addToSuperView:self.view];
    _rootScrollView.delegate = self;
    [_rootScrollView mas_makeConstraints:^(MASConstraintMaker *make)
    { make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight + 44, 0, 0, 0));
    }];
    
    _contentView = [UIView jh_viewWithColor:[UIColor whiteColor] addToSuperview:_rootScrollView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_rootScrollView);
        make.size.mas_equalTo(CGSizeMake(ScreenW*3, ScreenH - UI.statusAndNavBarHeight - 44));
    }];
    
    _userButton = [UIButton jh_buttonWithTitle:@"宝友" fontSize:15 textColor:[UIColor blackColor] target:self action:@selector(selectUserListMethod) addToSuperView:self.view];
    [_userButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jhNavView);
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(ScreenW/3.0, 44));
    }];
    
    _plateButton = [UIButton jh_buttonWithTitle:@"版块" fontSize:15 textColor:[UIColor blackColor] target:self action:@selector(selectPlateListMethod) addToSuperView:self.view];
    [_plateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userButton.mas_right);
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(ScreenW/3.0, 44));
    }];
    
    _shopButton = [UIButton jh_buttonWithTitle:@"店铺" fontSize:15 textColor:[UIColor blackColor] target:self action:@selector(selectShopListMethod) addToSuperView:self.view];
    [_shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.jhNavView);
        make.top.equalTo(self.userButton);
        make.size.equalTo(self.userButton);
    }];
    
    _lineView = [UIView jh_viewWithColor:RGB(254, 225, 0) addToSuperview:self.view];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 2.f));
        make.centerX.equalTo(self.view).offset(-ScreenW/3.f);
        make.bottom.equalTo(self.userButton).offset(-6);
    }];
    
    [[UIView jh_viewWithColor:RGB(238, 238, 238) addToSuperview:self.view]
     mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.shopButton);
    }];
    
    [self selectUserListMethod];
    [self updateNumber];
}

-(void)updateNumber
{
    [JHFoucsListShopViewModel foucsShopAndUserWithUserId:self.userId ompleteBlock:^(JHFoucsUserAndShopNumModel * _Nonnull model) {
        self.shopButton.jh_title([NSString stringWithFormat:@"店铺%@",@(model.shop_num)]);
        self.plateButton.jh_title([NSString stringWithFormat:@"版块%@",@(model.channel_num)]);
        self.userButton.jh_title([NSString stringWithFormat:@"宝友%@",@(model.general_num)]);
    }];
}

#pragma mark --------------- method ---------------
-(void)selectUserListMethod
{
    [_rootScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self loadListPageWithIndex:0];
}

-(void)selectShopListMethod
{
    [_rootScrollView setContentOffset:CGPointMake(2*ScreenW, 0) animated:YES];
    [self loadListPageWithIndex:2];
}

-(void)selectPlateListMethod
{
    [_rootScrollView setContentOffset:CGPointMake(ScreenW, 0) animated:YES];
    [self loadListPageWithIndex:1];
}

-(void)loadListPageWithIndex:(NSInteger)index
{

    switch (index) {
        case 0:
        {
            if (!_userVC) {
                _userVC = [JHUserFriendListController new];
                _userVC.user_id = self.userId;
                _userVC.type = 1;
                [self addChildViewController:_userVC];
                [_contentView addSubview:_userVC.view];
                @weakify(self);
                _userVC.updateNumberBlock = ^{
                    @strongify(self);
                    [self updateNumber];
                };
                [_userVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.equalTo(_contentView);
                    make.width.mas_equalTo(ScreenW);
                }];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.view setNeedsUpdateConstraints];
                [UIView animateWithDuration:0.3 animations:^{
                    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.view).offset(-ScreenW/3.f);
                    }];
                    [self.view layoutIfNeeded];
                }];
            });
                
        }
            break;
            
        case 1:
        {
            if (!_plateVC) {
                _plateVC = [JHFoucsPlateController new];
                _plateVC.userId = self.userId;
                _plateVC.pageType = JHPageTypeSQHome;
                [self addChildViewController:_plateVC];
                [_contentView addSubview:_plateVC.view];
                @weakify(self);
                _plateVC.updateNumberBlock = ^{
                    @strongify(self);
                    [self updateNumber];
                };
                [_plateVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(_contentView);
                    make.left.mas_equalTo(ScreenW);
                    make.width.mas_equalTo(ScreenW);
                }];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.view setNeedsUpdateConstraints];
                [UIView animateWithDuration:0.3 animations:^{
                    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.view).offset(0);
                    }];
                    [self.view layoutIfNeeded];
                }];
            });
        }
            break;
        case 2:
        {
            if (!_shopVC) {
                _shopVC = [JHFoucsShopListController new];
                _shopVC.userId = self.userId;
                [self addChildViewController:_shopVC];
                [_contentView addSubview:_shopVC.view];
                @weakify(self);
                _shopVC.updateNumberBlock = ^{
                    @strongify(self);
                    [self updateNumber];
                };
                [_shopVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.top.bottom.equalTo(_contentView);
                    make.width.mas_equalTo(ScreenW);
                }];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.view setNeedsUpdateConstraints];
                [UIView animateWithDuration:0.3 animations:^{
                    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.view).offset(ScreenW/3.f);
                    }];
                    [self.view layoutIfNeeded];
                }];
            });
        }
            break;
        default:
            break;
    }
}

#pragma mark --------------- ScrollViewDelegate ---------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    int page = sender.contentOffset.x / ScreenW;
    [self loadListPageWithIndex:page];
}

@end

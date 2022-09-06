//
//  JHUserAuthInfoViewController.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUserAuthInfoViewController.h"
#import "JHUserAuthPersonalController.h"
#import "JHUserAuthEnterpriseController.h"
#import "UserInfoRequestManager.h"

@interface JHUserAuthInfoViewController ()

@property (nonatomic, weak) UIScrollView *rootScrollView;

@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, weak) UIButton *personalButton;

@property (nonatomic, weak) UIButton *enterpriseButton;

//@property (nonatomic, weak) JHFoucsShopListController *shopVC;
//@property (nonatomic, weak) JHUserFriendListController *userVC;

@property (nonatomic, weak) UIView *contentView;
@end

@implementation JHUserAuthInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资质信息";
    [self addCommitUI];
}

/// 添加提交信息UI
- (void)addCommitUI {
    User *user = [UserInfoRequestManager sharedInstance].user;
    
    if(user.authType > 0) {
        [JHUserAuthModel requestUserAuthInfo:^(JHUserAuthModel *model, BOOL hasError) {
            if (!hasError) {
                ////获取到认证信息
                if(user.authType == JHUserAuthTypePersonal) {
                    JHUserAuthPersonalController *vc1 = [JHUserAuthPersonalController new];
                    vc1.authModel = model;
                    [self addChildViewController:vc1];
                    [self.view addSubview:vc1.view];
                    [vc1.view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.bottom.right.equalTo(self.view);
                        make.top.equalTo(self.jhNavView.mas_bottom);
                    }];
                }
                else {
                    JHUserAuthEnterpriseController *vc2 = [JHUserAuthEnterpriseController new];
                    vc2.authModel = model;
                    [self addChildViewController:vc2];
                    [self.view addSubview:vc2.view];
                    [vc2.view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.bottom.right.equalTo(self.view);
                        make.top.equalTo(self.jhNavView.mas_bottom);
                    }];
                }
            }
        }];
    }
    else {
        _rootScrollView = [UIScrollView jh_scrollViewWithContentSize:CGSizeZero showsScrollIndicator:NO scrollsToTop:NO bounces:NO pagingEnabled:YES addToSuperView:self.view];
        _rootScrollView.scrollEnabled = NO;
        [_rootScrollView mas_makeConstraints:^(MASConstraintMaker *make)
         { make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight + 44, 0, 0, 0));
        }];
        
        _contentView = [UIView jh_viewWithColor:[UIColor whiteColor] addToSuperview:_rootScrollView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_rootScrollView);
            make.size.mas_equalTo(CGSizeMake(ScreenW * 2, ScreenH - UI.statusAndNavBarHeight - 44));
        }];
        
        _personalButton = [UIButton jh_buttonWithTitle:@"个人" fontSize:15 textColor:[UIColor blackColor] target:self action:@selector(selectPersonalListMethod) addToSuperView:self.view];
        [_personalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
            make.size.mas_equalTo(CGSizeMake(100, 44));
        }];
        
        _enterpriseButton = [UIButton jh_buttonWithTitle:@"企业" fontSize:15 textColor:[UIColor blackColor] target:self action:@selector(selectEnterpriseListMethod) addToSuperView:self.view];
        [_enterpriseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_centerX);
            make.top.width.height.equalTo(self.personalButton);
        }];
        
        _lineView = [UIView jh_viewWithColor:RGB(254, 225, 0) addToSuperview:self.view];
        [_lineView jh_cornerRadius:1.5];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(21, 3.f));
            make.centerX.equalTo(self.view).offset(- 50);
            make.bottom.equalTo(self.personalButton).offset(-6);
        }];
        
        JHUserAuthPersonalController *vc1 = [JHUserAuthPersonalController new];
        [self addChildViewController:vc1];
        [_contentView addSubview:vc1.view];
        [vc1.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(ScreenW);
        }];
        
        JHUserAuthEnterpriseController *vc2 = [JHUserAuthEnterpriseController new];
        
        [self addChildViewController:vc2];
        [_contentView addSubview:vc2.view];
        [vc2.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(ScreenW);
        }];
    }
    
    
}

#pragma mark --------------- method ---------------
- (void)selectPersonalListMethod {
    [_rootScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(- 50);
    }];
}

- (void)selectEnterpriseListMethod {
    [_rootScrollView setContentOffset:CGPointMake(ScreenW, 0) animated:YES];
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(50);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

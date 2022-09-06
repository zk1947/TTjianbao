//
//  JHBusinessFansSettingViewController.m
//  TTjianbao
//
//  Created by user on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//111

#import "JHBusinessFansSettingViewController.h"
#import "UIView+JHGradient.h"
#import "JHBusinessFansSettingBusiness.h"
#import "JHBusinessFansSettingDetailViewController.h"
#import "JHBusinessFansSettingShowViewController.h"
#import "JHWebViewController.h"
#import "IQKeyboardManager.h"

@interface JHBusinessFansSettingViewController ()
@property (nonatomic, strong) JHBusinessFansSettingModel *setModel;
@end

@implementation JHBusinessFansSettingViewController
- (void)dealloc {
    NSLog(@"++++ 状态父视图 release");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF5F5F8);
    [self setupNav];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)loadData {
    @weakify(self);
    [SVProgressHUD show];
    [JHBusinessFansSettingBusiness businessConfigurateFans:[self.anchorId integerValue] channelId:[self.channelId integerValue] re:@"0" Completion:^(NSError * _Nullable error, JHBusinessFansSettingModel * _Nullable model) {
        @strongify(self);
        [SVProgressHUD dismiss];
        NSLog(@"%@",model);
        if (!model || error) {
            JHEmptyView *emptyView = [[JHEmptyView alloc] init];
            [self.view addSubview:emptyView];
            [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
              return;
        }
        self.setModel = model;
        switch (model.examineStatus) {
            case JHFansExamineStatus_noApply: { /// 未审核
                [self setupViews];
            }
                break;
            case JHFansExamineStatus_applying: { /// 审核中
                [self applyiewsWithStatus:YES withModel:model];
            }
                break;
            case JHFansExamineStatus_applyPass: { /// 审核通过
                [self applyiewsWithStatus:NO withModel:model];
            }
                break;
            case JHFansExamineStatus_applyReject: { /// 审核拒绝
                [self setupNoPassViews:model.rejectReason];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)setupNav {
    self.title = @"直播间粉丝团设置";
    [self initRightButtonWithImageName:@"setting_business_more" action:@selector(fanSettingClick:)];
}

- (void)fanSettingClick:(UIButton *)sender {
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.urlString = H5_BASE_STRING(@"/jianhuo/app/fensRule.html");
    [JHRootController.currentViewController.navigationController pushViewController:webVC animated:YES];
}

- (void)setupViews {
    UIImageView *emptyImageView        = [UIImageView jh_imageViewWithImage:@"img_default_page" addToSuperview:self.view];
    [emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.jhNavView.mas_bottom).offset(89.f);
    }];

    UILabel *emptyLabel                = [UILabel jh_labelWithText:@"暂无直播间粉丝团" font:12 textColor:HEXCOLOR(0x999999) textAlignment:1 addToSuperView:self.view];
    [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emptyImageView.mas_bottom).offset(15.f);
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    UIButton *applicationBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
    applicationBtn.titleLabel.font     = [UIFont fontWithName:kFontNormal size:15.f];
    applicationBtn.layer.cornerRadius  = 22.f;
    applicationBtn.layer.masksToBounds = YES;
    [applicationBtn setTitle:@"申请粉丝团" forState:UIControlStateNormal];
    [applicationBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    [applicationBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [applicationBtn addTarget:self action:@selector(applicationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applicationBtn];
    [applicationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emptyLabel.mas_bottom).offset(30.f);
        make.left.equalTo(self.view.mas_left).offset(28.f);
        make.right.equalTo(self.view.mas_right).offset(-28.f);
        make.height.mas_equalTo(44.f);
    }];
}

- (void)setupNoPassViews:(NSString *)str {
    UIImageView *emptyImageView        = [UIImageView jh_imageViewWithImage:@"setting_business_noPass" addToSuperview:self.view];
    [emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.jhNavView.mas_bottom).offset(20.f);
        make.width.height.mas_equalTo(60.f);
    }];

    UILabel *npPassLabel               = [[UILabel alloc] init];
    npPassLabel.textColor              = HEXCOLOR(0x333333);
    npPassLabel.font                   = [UIFont fontWithName:kFontMedium size:18.f];
    npPassLabel.text                   = @"未通过";
    npPassLabel.textAlignment          = NSTextAlignmentCenter;
    [self.view addSubview:npPassLabel];
    [npPassLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emptyImageView.mas_bottom).offset(15.f);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(25.f);
    }];

    UILabel *npPassReasonLabel         = [[UILabel alloc] init];
    npPassReasonLabel.textColor        = HEXCOLOR(0x999999);
    npPassReasonLabel.font             = [UIFont fontWithName:kFontNormal size:15.f];
    npPassReasonLabel.textAlignment    = NSTextAlignmentCenter;
    npPassReasonLabel.numberOfLines    = 2;
    npPassReasonLabel.text             = [NSString stringWithFormat:@"原因：%@",str];
    [self.view addSubview:npPassReasonLabel];
    [npPassReasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(npPassLabel.mas_bottom).offset(10.f);
        make.left.equalTo(self.view.mas_left).offset(30.f);
        make.right.equalTo(self.view.mas_right).offset(-30.f);
        make.height.mas_equalTo(46.f);
    }];

    UIButton *applicationBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
    applicationBtn.titleLabel.font     = [UIFont fontWithName:kFontNormal size:15.f];
    applicationBtn.layer.cornerRadius  = 22.f;
    applicationBtn.layer.masksToBounds = YES;
    [applicationBtn setTitle:@"重新申请" forState:UIControlStateNormal];
    [applicationBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    [applicationBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [applicationBtn addTarget:self action:@selector(applicationAgainBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applicationBtn];
    [applicationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(npPassReasonLabel.mas_bottom).offset(40.f);
        make.left.equalTo(self.view.mas_left).offset(28.f);
        make.right.equalTo(self.view.mas_right).offset(-28.f);
        make.height.mas_equalTo(44.f);
    }];
}

- (void)applicationBtnAction:(UIButton *)sender {
    JHBusinessFansSettingDetailViewController *vc = [[JHBusinessFansSettingDetailViewController alloc] init];
    vc.anchorId  = self.anchorId;
    vc.channelId = self.channelId;
    vc.setModel  = self.setModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)applicationAgainBtnAction:(UIButton *)sender {
    JHBusinessFansSettingDetailViewController *vc = [[JHBusinessFansSettingDetailViewController alloc] init];
    vc.anchorId  = self.anchorId;
    vc.channelId = self.channelId;
    vc.setModel  = self.setModel;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)applyiewsWithStatus:(BOOL)isApplying withModel:(JHBusinessFansSettingModel *)showModel {
    JHBusinessFansSettingShowViewController *vc = [[JHBusinessFansSettingShowViewController alloc] init];
    vc.isApplying = isApplying;
    vc.anchorId   = self.anchorId;
    vc.channelId  = self.channelId;
    vc.showModel  = self.setModel;
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}


@end

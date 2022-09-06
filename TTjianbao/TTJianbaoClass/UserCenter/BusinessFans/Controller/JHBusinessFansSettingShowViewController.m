//
//  JHBusinessFansSettingShowViewController.m
//  TTjianbao
//
//  Created by user on 2021/3/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansSettingShowViewController.h"
#import "JHBusinessFansMissionProgressView.h"
#import "JHBusinessFansPassBottonView.h"
#import "JHBusinessFansSettingBusiness.h"
#import "JHBusinessFansSettingDetailViewController.h"

/// show vc
#import "JHBusinessFansLevelShowViewController.h"
#import "JHBusinessFansEquityShowViewController.h"
#import "JHBusinessFansMissionShowViewController.h"
#import "JHWebViewController.h"
#import "CommAlertView.h"

@interface JHBusinessFansSettingShowViewController ()
@property (nonatomic, strong) JHBusinessFansMissionProgressView *settingView;
@property (nonatomic, strong) JHBusinessFansPassBottonView      *bottomView;
@property (nonatomic, assign) NSInteger                          currentIndex;
@end

@implementation JHBusinessFansSettingShowViewController
- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = 0;
    self.view.backgroundColor = HEXCOLOR(0xFFFFFF);
    [self setupNav];
    [self setupSettingStatusViews];
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

- (void)setupSettingStatusViews {
    self.settingView = [[JHBusinessFansMissionProgressView alloc] init];
    self.settingView.canClick = YES;
    self.settingView.backgroundColor = HEXCOLOR(0x424242);
    [self.view addSubview:self.settingView];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.height.mas_equalTo(51.f);
    }];
    [self.settingView setLabelStatus:JHBusinessFansMissionSettingStatus_equity];
    @weakify(self);
    self.settingView.clickBlock = ^(NSInteger index) {
        @strongify(self);
        if (self.currentIndex == index) {
            return;
        }
        if (index == 0) {
            JHBusinessFansLevelShowViewController *vc = [[JHBusinessFansLevelShowViewController alloc] init];
            vc.showModel = self.showModel;
            [self addChildViewController:vc];
            [self.view addSubview:vc.view];
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.top.equalTo(self.settingView.mas_bottom);
                make.bottom.equalTo(self.bottomView.mas_top);
            }];
        } else if (index == 2) {
            JHBusinessFansEquityShowViewController *vc = [[JHBusinessFansEquityShowViewController alloc] init];
            vc.showModel = self.showModel;
            [self addChildViewController:vc];
            [self.view addSubview:vc.view];
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.top.equalTo(self.settingView.mas_bottom);
                make.bottom.equalTo(self.bottomView.mas_top);
            }];
        } else {
            JHBusinessFansMissionShowViewController *vc = [[JHBusinessFansMissionShowViewController alloc] init];
            vc.showModel = self.showModel;
            [self addChildViewController:vc];
            [self.view addSubview:vc.view];
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.top.equalTo(self.settingView.mas_bottom);
                make.bottom.equalTo(self.bottomView.mas_top);
            }];
        }
        self.currentIndex = index;
    };
    
    
    self.bottomView = [[JHBusinessFansPassBottonView alloc] init];
    self.bottomView.isApplying = self.isApplying;
    [self.bottomView setupViews];
    [self.view addSubview:self.bottomView];
    CGFloat bottomHeight = UI.bottomSafeAreaHeight + (self.isApplying?69.f:119.f);
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(bottomHeight);
    }];
    self.bottomView.clickBlock = ^{
        @strongify(self);
        [self noticeAlert];
    };
    
    
    JHBusinessFansLevelShowViewController *vc = [[JHBusinessFansLevelShowViewController alloc] init];
    vc.showModel = self.showModel;
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.settingView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (void)noticeAlert{
//    app/fans/fans-club/checkReApply", method = RequestMethod.POST)
//    @ApiOperation(value = "校验是否能再次申请")
    NSString *url = FILE_BASE_STRING(@"/app/fans/fans-club/checkReApply");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSNumber *aa = respondObject.data;
        if (aa.boolValue) {
            [self requestData];
        }else{
            [self showAlert];
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self requestData];
    }];
    
}
- (void)showAlert{
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"每周可重新修改一次。\n您当月已提交过请下月提交或联系平台。" cancleBtnTitle:@"我知道了"];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    alert.cancleHandle = ^{
    };

}

- (void)requestData{
    [JHBusinessFansSettingBusiness businessConfigurateFans:[self.anchorId integerValue] channelId:[self.channelId integerValue] re:@"1" Completion:^(NSError * _Nullable error, JHBusinessFansSettingModel * _Nullable model) {
        JHBusinessFansSettingDetailViewController *vc = [[JHBusinessFansSettingDetailViewController alloc] init];
        vc.anchorId  = self.anchorId;
        vc.channelId = self.channelId;
        vc.setModel  = model;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}


@end

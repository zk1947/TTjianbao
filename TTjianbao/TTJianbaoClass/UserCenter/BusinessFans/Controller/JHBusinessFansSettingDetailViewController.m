//
//  JHBusinessFansSettingDetailViewController.m
//  TTjianbao
//
//  Created by user on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansSettingDetailViewController.h"
#import "JHBusinessFansMissionProgressView.h"
#import "JHBusinessFansSettingLevelViewController.h"
#import "JHBusinessFansSettingApplyModel.h"
#import "JHWebViewController.h"

@interface JHBusinessFansSettingDetailViewController ()
@property (nonatomic, strong) JHBusinessFansMissionProgressView *settingView;
@end

@implementation JHBusinessFansSettingDetailViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"++++ 设置父视图 release");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xFFFFFF);
    [self setupNav];
    [self setupSettingStatusViews];
    [self addObserve];
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
    self.settingView.backgroundColor = HEXCOLOR(0x424242);
    [self.view addSubview:self.settingView];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.height.mas_equalTo(51.f);
    }];
    [self.settingView setLabelStatus:JHBusinessFansMissionSettingStatus_level];
    
    JHBusinessFansSettingApplyModel *model = [[JHBusinessFansSettingApplyModel alloc] init];
    model.anchorId  = [self.anchorId integerValue];
    model.channelId = [self.channelId integerValue];
    
    JHBusinessFansSettingLevelViewController *vc = [[JHBusinessFansSettingLevelViewController alloc] init];
    vc.applyModel = model;
    vc.setModel   = self.setModel;
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.settingView.mas_bottom);
    }];
}

- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingStatus:) name:@"JHBUSINESSSETTINGPROCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToSup:) name:@"JHBUSINESSFANSSETTINGSUCCESS" object:nil];

}

- (void)settingStatus:(NSNotification *)no {
    NSNumber *number = no.object;
    if ([number integerValue] == 0) {
        [self.settingView setLabelStatus:JHBusinessFansMissionSettingStatus_level];
    } else if ([number integerValue] == 1) {
        [self.settingView setLabelStatus:JHBusinessFansMissionSettingStatus_mission];
    } else {
        [self.settingView setLabelStatus:JHBusinessFansMissionSettingStatus_equity];
    }
}

- (void)backToSup:(NSNotification *)no {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end

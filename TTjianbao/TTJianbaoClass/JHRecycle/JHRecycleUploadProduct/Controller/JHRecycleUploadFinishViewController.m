//
//  JHRecycleUploadFinishViewController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleUploadFinishViewController.h"
#import "JHRecycleSureButton.h"
#import "BaseNavViewController.h"
#import "JHRecycleUploadTypeSeleteViewController.h"
#import "JHHomeTabController.h"
#import "NTESAudienceLiveViewController.h"
#import "CommAlertView.h"
@interface JHRecycleUploadFinishViewController ()
@property(nonatomic, strong) UIImageView * successImageView;
@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UILabel * detailLbl;

@property(nonatomic, strong) JHRecycleSureButton * sureBtn;

@property(nonatomic, strong) UIButton * shopBtn;
@property(nonatomic, strong) UIButton * liveBtn;
@property(nonatomic, strong) UIView * lineView;

@end

@implementation JHRecycleUploadFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布成功";
    [self setItems];
    [self layoutItems];
    [NSNotificationCenter.defaultCenter postNotificationName:@"RecycleGoodsNumChangeNotification" object:@"1"];
    [JHTracking trackEvent:@"appPageView" property:@{@"page_name":@"回收商品发售完成页"}];
}

- (void)setItems{
    [self.view addSubview:self.successImageView];
    [self.view addSubview:self.titleLbl];
    [self.view addSubview:self.detailLbl];
    [self.view addSubview:self.sureBtn];
    [self.view addSubview:self.shopBtn];
    [self.view addSubview:self.liveBtn];
    [self.view addSubview:self.lineView];

    BOOL isOpen = [CommHelp isUserNotificationEnable];
    if (!isOpen) {
        CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"为了您能及时的接收到重要的\n 报价提醒请开启消息通知" cancleBtnTitle:@"取消" sureBtnTitle:@"去开启"];
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        alert.handle = ^{
            [CommHelp goToAppSystemSetting];
        };
        alert.cancleHandle = ^{

        };
    }
}

- (void)layoutItems{
    [self.successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(52, 52));
        make.centerX.equalTo(@0);
        make.top.equalTo(self.jhNavView.mas_bottom).offset(64);
    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.successImageView.mas_bottom).offset(16);
    }];
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.detailLbl.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(310, 50));
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.sureBtn.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(1, 18));
    }];
    [self.shopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lineView);
        make.size.mas_equalTo(CGSizeMake(82, 25));
        make.right.equalTo(self.lineView.mas_left).offset(-44);
    }];
    [self.liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lineView);
        make.size.mas_equalTo(CGSizeMake(82, 25));
        make.left.equalTo(self.lineView.mas_right).offset(44);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationController *naV = self.navigationController;
    if ([naV isKindOfClass:BaseNavViewController.class]) {
        BaseNavViewController *baseNav = (BaseNavViewController *)naV;
        baseNav.isForbidDragBack = YES;
    }

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UINavigationController *naV = self.navigationController;
    if ([naV isKindOfClass:BaseNavViewController.class]) {
        BaseNavViewController *baseNav = (BaseNavViewController *)naV;
        baseNav.isForbidDragBack = NO;
    }
}


#pragma mark -- <Button Actions>
- (void)backActionButton:(UIButton *)sender{
    __block NSInteger index = NSNotFound;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:JHRecycleUploadTypeSeleteViewController.class]) {
            index = idx;
        }
    }];
    if (index != NSNotFound && index > 0) {
        UIViewController * vc = self.navigationController.viewControllers[index-1];
        [self.navigationController popToViewController:vc animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)goShop{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [JHRootController.homeTabController setSelectedIndex:2];
    [self addStatisticWithName:@"clickGoShop"];
}

- (void)goLive{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [JHRootController.homeTabController setSelectedIndex:1];
    [self addStatisticWithName:@"clickGoLive"];
}

- (void)continuePublish{
    __block JHRecycleUploadTypeSeleteViewController *vc = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:JHRecycleUploadTypeSeleteViewController.class]) {
            vc = obj;
        }
    }];
    [self.navigationController popToViewController:vc animated:YES];
    [self addStatisticWithName:@"clickContinueRelease"];
}


#pragma mark -- <set and get>

- (UIImageView *)successImageView{
    if (!_successImageView) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_success"]];
        _successImageView = view;
    }
    return _successImageView;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(20);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"宝贝发布成功啦！";
        _titleLbl = label;
    }
    return _titleLbl;
}
- (UILabel *)detailLbl{
    if (!_detailLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(13);
        label.textColor = HEXCOLOR(0x666666);
        label.text = @"回收商预计会48小时内给出报价请及时确认";
        _detailLbl = label;
    }
    return _detailLbl;
}

- (JHRecycleSureButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [JHRecycleSureButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn addTarget:self action:@selector(continuePublish) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitle:@"继续发布" forState:UIControlStateNormal];
    }
    return _sureBtn;
}

- (UIButton *)shopBtn{
    if (!_shopBtn) {
        _shopBtn = [self getButtonWithTitle:@"去商城" andImageName:@"recycle_uploadproduct_gomall"];
        [_shopBtn addTarget:self action:@selector(goShop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shopBtn;
}
- (UIButton *)liveBtn{
    if (!_liveBtn) {
        _liveBtn = [self getButtonWithTitle:@"去直播" andImageName:@"recycle_uploadproduct_golive"];
        [_liveBtn addTarget:self action:@selector(goLive) forControlEvents:UIControlEventTouchUpInside];
    }
    return _liveBtn;
}
- (UIView *)lineView{
    if (!_lineView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xE6E6E6);
        _lineView = view;
    }
    return _lineView;
}

- (UIButton*)getButtonWithTitle:(NSString*)title andImageName:(NSString*)imageName{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    leftImageView.image = [UIImage imageNamed:imageName];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(82-4, 0, 4, 8)];
    arrowImageView.image = [UIImage imageNamed:@"recycle_uploadproduct_arrow"];
    arrowImageView.centerY = leftImageView.centerY;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 53, 25)];
    label.font = JHFont(14);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = HEXCOLOR(0x666666);
    label.text = title;

    [btn addSubview:label];
    [btn addSubview:leftImageView];
    [btn addSubview:arrowImageView];
    return btn;
}



#pragma mark -- <打点统计>
//打点统计
- (void)addStatisticWithName:(NSString*)statisName{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"page_position"] = @"recycleReleaseComplete";
    [JHAllStatistics jh_allStatisticsWithEventId:statisName params:parDic type:JHStatisticsTypeSensors];
}


@end

//
//  JHSignViewController.m
//  TTjianbao
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHSignViewController.h"
#import "JHWebViewController.h"

@interface JHSignViewController ()


@end

@implementation JHSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNav];
    [self configUI];
}

- (NSString *)checkStatusString {
    NSString *str;
    switch (_checkStatus) {
        case JHCheckStatusUnCheck:
            str = @"未审核";
            break;
        case JHCheckStatusChecking:
            str = @"认证审核中";
            break;
        case JHCheckStatusCheckSuccess:
            str = @"恭喜您 认证通过！";
            break;
        case JHCheckStatusCheckFailure:
            str = @"对不起，审核未通过！";
            break;
        default:
            break;
    }
    return str;
}

- (void)configUI {
    BOOL isSuccess = self.checkStatus == JHCheckStatusCheckSuccess;

    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:isSuccess ? @"icon_auth_success" : @"icon_auth_checking"];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [self checkStatusString];
    label.font = [UIFont fontWithName:kFontBoldPingFang size:18];
    label.textAlignment = NSTextAlignmentCenter;
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"认证审核中，请您耐心等待哦~";
    detailLabel.font = [UIFont fontWithName:kFontNormal size:14];
    detailLabel.textAlignment = NSTextAlignmentCenter;
  
    
    UIButton *signButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signButton addTarget:self action:@selector(requestSignUrl) forControlEvents:UIControlEventTouchUpInside];
    [signButton setTitle:isSuccess ? @"马上进入签约" : @"审核中" forState:UIControlStateNormal];
    signButton.backgroundColor = isSuccess ? HEXCOLOR(0xFEE100) : HEXCOLOR(0xCCCCCC);
    [signButton setTitleColor:isSuccess ? HEXCOLOR(0x333333) : HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
    
    [self.view addSubview:imageV];
    [self.view addSubview:label];
    [self.view addSubview:detailLabel];
    [self.view addSubview:signButton];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@100);
        make.top.equalTo(self.jhNavView.mas_bottom).with.offset(40);
        make.centerX.equalTo(self.view);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(imageV.mas_bottom).with.offset(32);
        make.height.equalTo(@25);
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(label);
        make.top.equalTo(label.mas_bottom).with.offset(13);
        make.height.equalTo(@(!isSuccess ? 20 : 0));
    }];
    
    [signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.top.equalTo(detailLabel.mas_bottom).with.offset(67);
        make.height.equalTo(@44);
    }];
       
    [self.view layoutIfNeeded];
    signButton.layer.cornerRadius = signButton.height/2.f;
    signButton.layer.masksToBounds = YES;
}

///签约跳转h5
- (void)requestSignUrl {
    if (self.checkStatus == JHCheckStatusChecking) {
        ///审核中 按钮不可点
        return;
    }
    @weakify(self);
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/contract/sign");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        NSLog(@"请求成功:%@", respondObject.data);
        ///跳转签约界面
        @strongify(self);
        NSString *urlString = respondObject.data[@"url"];
        [self gotoSignFile:urlString];
    } failureBlock:^(RequestModel *respondObject) {
        NSString *message = respondObject.message;
        [UITipView showTipStr:message ? message : @"跳转失败"];
    }];
}

- (void)gotoSignFile:(NSString *)htmlString {
    JHWebViewController *webVC = [[JHWebViewController alloc] init];
    webVC.urlString =  htmlString;
    webVC.isNeedPoptoRoot = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)configNav {
//    [self initToolsBar];
    BOOL isSuccess = self.checkStatus == JHCheckStatusCheckSuccess;
//    [self.navbar setTitle:(isSuccess ? @"认证通过" : @"审核中")];
    self.title = (isSuccess ? @"认证通过" : @"审核中");
//    self.navbar.ImageView.layer.shadowColor = [UIColor whiteColor].CGColor;
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backActionButton:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}

@end

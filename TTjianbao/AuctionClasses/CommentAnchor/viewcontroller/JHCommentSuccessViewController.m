//
//  JHCommentSuccessViewController.m
//  TTjianbao
//
//  Created by mac on 2019/5/16.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHCommentSuccessViewController.h"
#import "JHRankingModel.h"
#import "JHBaseOperationView.h"
#import "UMengManager.h"

@interface JHCommentSuccessViewController ()
@property (strong, nonatomic) JHRankingNewModel *model;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeight;


@end

@implementation JHCommentSuccessViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initToolsBar];
    self.jhNavView.backgroundColor = [UIColor clearColor];
//    self.navbar.ImageView.hidden = YES;
    self.view.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.toTopHeight.constant = UI.statusAndNavBarHeight;
    

    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
    if (array.count>=2) {
        [array removeObjectAtIndex:array.count-2];
        self.navigationController.viewControllers = [array copy];
    }
    
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeShare) name:@"NotificationNameCommentRedPocket" object:nil];
    self.priceLabel.text = self.price;
}

- (void)completeShare {
//        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/coupon/receive/shareCoupon/auth") Parameters:@{@"orderId":self.orderId} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
//            [[UIApplication sharedApplication].keyWindow makeToast:@"领取红包成功!"];
//
//            [self.navigationController popViewControllerAnimated:YES];
//
//
//        } failureBlock:^(RequestModel *respondObject) {
//
//        }];
    
    NSDictionary *parameters=@{@"id":@(16),@"type":@"coupon",};
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/coupon/receive/auth") Parameters:parameters requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication].keyWindow makeToast:@"领取成功" duration:1.0 position:CSToastPositionCenter];
        
        [self.navigationController popViewControllerAnimated:YES];
    
    } failureBlock:^(RequestModel *respondObject) {
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
        
    [SVProgressHUD show];

}

- (IBAction)shareAction:(id)sender {
    
//如果有评估报告就分享评估报告 没有就分享官网
    if (self.model) {
        NSString *title = [NSString stringWithFormat:@"我在天天鉴宝买的%@，综合评分%.2f分。%@",self.model.reportGoodsName, self.model.scoreAverage, self.model.overshoot];
//        [[UMengManager shareInstance] showShareWithTarget:nil title:title text:ShareOrderReportText thumbUrl:nil webURL:[NSString stringWithFormat:@"%@id=%@",[UMengManager shareInstance].shareSaleReporterUrl,self.model.Id] type:ShareObjectTypeSaleReportComment object:self.model.Id];
        JHShareInfo* info = [JHShareInfo new];
        info.title = title;
        info.desc = ShareOrderReportText;
        info.shareType = ShareObjectTypeSaleReportComment;
        info.url = [NSString stringWithFormat:@"%@id=%@",[UMengManager shareInstance].shareSaleReporterUrl,self.model.Id];
        [JHBaseOperationView showShareView:info objectFlag:self.model.Id]; //TODO:Umeng share
        
    }else {
        
        NSString *title = @"天天鉴宝翡翠玉石源头直购";
        
        NSString *text = @"精品翡翠玉石，鉴定师每日在线直播鉴定真伪。";
        
        NSString *url = @"http://www.ttjianbao.com?";
        
//        [[UMengManager shareInstance] showShareWithTarget:nil title:title text:text thumbUrl:nil webURL:url type:ShareObjectTypeSaleReportComment object:self.model.Id];
        JHShareInfo* info = [JHShareInfo new];
        info.title = title;
        info.desc = text;
        info.shareType = ShareObjectTypeSaleReportComment;
        info.url = url;
        [JHBaseOperationView showShareView:info objectFlag:self.model.Id]; //TODO:Umeng share
    }
}


- (void)requestData {
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/report/authoptional/reportDetail/order") Parameters:@{@"id":self.orderId,@"type":@(1)} successBlock:^(RequestModel *respondObject) {
        self.model = [JHRankingNewModel mj_objectWithKeyValues:respondObject.data];
        
    } failureBlock:^(RequestModel *respondObject) {
//        [SVProgressHUD showErrorWithStatus:respondObject.data];
    }];
}

@end

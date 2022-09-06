//
//  JHOfferPriceViewController.m
//  TTjianbao
//
//  Created by jiang on 2019/12/3.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHOfferPriceViewController.h"
#import "JHOfferPriceView.h"
#import "JHGoodResaleListModel.h"
#import "JHOrderPayViewController.h"
#import "JHGrowingIO.h"

@interface JHOfferPriceViewController ()
{
    JHOfferPriceView * offerView;
}
@property (nonatomic, strong) JHStoneOfferModel * stoneModel;
 
@end

@implementation JHOfferPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNav];
    [self initContentView];
    [self requestInfo];
}
- (void)makeNav
{
    self.view.backgroundColor = HEXCOLOR(0xffffff);
//    [self initToolsBar];
//    [self.navbar setTitle:@"出价并支付意向金"];
    self.title = @"出价并支付意向金";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)requestInfo{
    [JHStoneOfferModel requestStoneOfferDetail:self.stoneRestoreId isResaleFlag:self.resaleFlag completion:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
           self.stoneModel = [JHStoneOfferModel mj_objectWithKeyValues:respondObject.data];
            [offerView setStoneMode:self.stoneModel];
        }
    } ];
}
-(void)initContentView{
    offerView=[[JHOfferPriceView alloc]init];
    [offerView setResaleFlag:self.resaleFlag];
    [self.view addSubview:offerView];
    [offerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
        make.left.right.equalTo(self.view);
    }];
    JH_WEAK(self)
    offerView.handle = ^(NSString * _Nonnull price) {
        JH_STRONG(self)
        JHGoodOrderSaveReqModel* model = [JHGoodOrderSaveReqModel new];
        model.stoneId = self.stoneRestoreId;
        model.orderPrice = price;
        if (!self.resaleFlag) {
            model.orderCategory = @"restoreIntentionOrder";
            model.channelCategory = @"restoreStone";
        }
        else{
            model.orderCategory = @"resaleIntentionOrder";
            model.channelCategory = @"";
        }
        
        [JHStoneOfferModel requestOffer:model completion:^(RequestModel *respondObject, NSError *error) {
               [SVProgressHUD dismiss];
            NSMutableDictionary* dic = [NSMutableDictionary dictionary];
            if (!error) {
                JHGoodOrderSaveModel *mode =[JHGoodOrderSaveModel mj_objectWithKeyValues:respondObject.data];
                JHOrderPayViewController *vc = [JHOrderPayViewController new];
                vc.orderId=mode.orderId;
                [self.navigationController pushViewController:vc animated:YES];
                [dic setValue:@"true" forKey:@"result"];
            }
            else{
                [self.view makeToast:error.localizedDescription];
                [dic setValue:@"false" forKey:@"result"];
            }
            [dic setValue:model.orderCategory forKey:@"orderCategory"];
            //埋点：订单成功与失败
            [JHGrowingIO trackEventId:JHTrackStoneRestore_orderoffer variables:dic];
        }];
        [SVProgressHUD show];
        
        
    };
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

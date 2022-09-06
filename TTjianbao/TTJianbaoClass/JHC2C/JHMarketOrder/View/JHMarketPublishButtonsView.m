//
//  JHMarketPublishButtonsView.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketPublishButtonsView.h"
#import "JHMarketOrderRefundViewController.h"
#import "CommAlertView.h"
#import "JHMarketQuickPriceView.h"
#import "JHMarketOrderViewModel.h"
#import "JHAppraisePayView.h"
#import "JHWebViewController.h"
#import "JHMarketQuickPriceTwoView.h"
#import "JHC2CUploadProductController.h"
#import "CommAlertView.h"
@interface JHMarketPublishButtonsView()
/** 查看报告*/
@property (nonatomic, strong) UIButton *seeReportButton;
/** 下架*/
@property (nonatomic, strong) UIButton *offSaleButton;
/** 调价*/
@property (nonatomic, strong) UIButton *adjustPriceButton;
/** 一键鉴定*/
@property (nonatomic, strong) UIButton *appraiseButton;
/** 上架*/
@property (nonatomic, strong) UIButton *onSaleButton;
/** 编辑*/
@property (nonatomic, strong) UIButton *editButton;
/// 删除
@property (nonatomic, strong) UIButton *deleteButton;
@end
@implementation JHMarketPublishButtonsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

//按钮添加顺序如下:查看报告 下架 上架 调价 一键鉴定 一键转售
- (void)setPublishModel:(JHMarketPublishModel *)publishModel {
    _publishModel = publishModel;
    [self initializeConstraints];  //先初始化一下约束
    NSMutableArray *array = [NSMutableArray array];
    
    if (publishModel.updateFlag) {
        [array addObject:self.editButton];
    }
    
    if (publishModel.viewReportFlag) {
        [array addObject:self.seeReportButton];
    }
    if (publishModel.downProductFlag) {
        [array addObject:self.offSaleButton];
    }
    if (publishModel.upProductFlag) {
        [array addObject:self.onSaleButton];
    }
    if (publishModel.modifyPriceFlag) {
        [array addObject:self.adjustPriceButton];
    }
    if (publishModel.goAppraisalFlag) {
        [array addObject:self.appraiseButton];
    }
    if (publishModel.deleteFlag) {
        [array addObject:self.deleteButton];
    }
    self.dataSource = array;
    [self remakeConstraintsWithArray:array];
}
// 重新定义button的约束,使该显示的显示 该隐藏的隐藏
- (void)remakeConstraintsWithArray:(NSArray <UIButton *>*)buttonsArray {
    //数组逆序
    buttonsArray = [[buttonsArray reverseObjectEnumerator] allObjects];
    UIButton *lastButton;
    for (int i = 0; i < buttonsArray.count; i++) {
        UIButton *button = buttonsArray[i];
        if (buttonsArray.count > 3) { //按钮超出3个 用小字号
            button.titleLabel.font = [UIFont fontWithName:kFontNormal size:11];
        } else {
            button.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        }
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (buttonsArray.count > 3) {  //按钮超出3个 约束用窄的
                make.width.mas_equalTo(64);
            } else{
                make.width.mas_equalTo(84);
            }
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(self);
            if (i == 0) {
                make.right.mas_equalTo(self);
            }else {
                make.right.mas_equalTo(lastButton.mas_left).offset(-6);
            }
        }];
        lastButton = button;
    }
}
// 按钮点击事件
- (void)buttonClickAction:(UIButton *)sender {
    switch (sender.tag) {
        case MarketPublishButtonTagSeeReport:
        {
            NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/reportGraphic.html?customerId=%@&productSn=%@"), customerId, self.publishModel.productSn];
            [self.viewController.navigationController pushViewController:webView animated:YES];
        }
            break;
        case MarketPublishButtonTagOffSale:
        {
            CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"提示" andDesc:@"确认要下架么?" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            @weakify(self);
            alert.handle = ^{
                @strongify(self);
                [self updateGoodsStatus:NO];
            };
        }
            break;
        case MarketPublishButtonTagAdjustPrice:
        {
            [self changePrice];
        }
            break;
        case MarketPublishButtonTagAppraise:
        {
            [self appriseButtonlick];
        }
            break;
        case MarketPublishButtonTagOnSale:
        {
            [self updateGoodsStatus:YES];
        }
            break;
        case MarketPublishButtonTagEdit:
        {
            [self getEditPageData];
        }
            break;
        case MarketPublishButtonTagDelete:
            [self marketDelete];
            break;
        default:
            break;
    }
}
//修改价格
- (void)changePrice {
    if (self.publishModel.productStatus == 5) {  //流拍不允许改价
        JHTOAST(@"流拍商品不能调价，请重新发布");
        return;
    }
    if (self.publishModel.productType == 1) { //拍卖
        JHMarketQuickPriceTwoView *quickPrice = [[JHMarketQuickPriceTwoView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        quickPrice.publishModel = self.publishModel;
        quickPrice.completeBlock = ^{
            if (self.reloadDataBlock) {
                self.reloadDataBlock(NO);
            }
        };
        [[UIApplication sharedApplication].keyWindow addSubview:quickPrice];
    } else {
        JHMarketQuickPriceView *quickPrice = [[JHMarketQuickPriceView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        quickPrice.completeBlock = ^{
            if (self.reloadDataBlock) {
                self.reloadDataBlock(NO);
            }
        };
        quickPrice.productId = self.publishModel.productId;
        quickPrice.oriPrice = self.publishModel.price;
        [[UIApplication sharedApplication].keyWindow addSubview:quickPrice];
    }
}
//上下架商品
- (void)updateGoodsStatus:(BOOL)onSale {
    //这个判断我加了,我又给去掉了,后端没加安全判断,移动端不能加.如果有bug让后端去改去.
//    if (self.publishModel.auctionStartRemainTime > 0) {
//        JHTOAST(@"未到设置的拍卖时间，不能上架");
//        return;
//    }
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"productId"] = self.publishModel.productId;
    params[@"productStatus"] = onSale ? @(0) : @(1);
    [JHMarketOrderViewModel updateGoodsStatus:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [SVProgressHUD dismiss];
        if (!error) {
            JHTOAST(onSale ? @"上架成功" : @"下架成功");
            if (self.reloadDataBlock) {
                self.reloadDataBlock(YES);
            }
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

//一键鉴定,先下单,后跳转到支付页面
- (void)appriseButtonlick {
    //调取下单接口
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"productId"] = self.publishModel.productId;
    [JHMarketOrderViewModel appriaseProductAuth:params Completion:^(NSError * _Nullable error, JHMarketProductAuthModel * _Nullable model) {
        if (model) {
            //下面是支付页面
            JHAppraisePayView * payView = [[JHAppraisePayView alloc]init];
            payView.orderId = model.orderId;
            @weakify(self);
            payView.paySuccessBlock = ^{  //支付成功刷新UI
                @strongify(self);
                if (self.reloadDataBlock) {
                    self.reloadDataBlock(NO);
                }
            };
            [JHKeyWindow addSubview:payView];
            [payView showAlert];
        }else if (error) {
            JHTOAST(error.localizedDescription);
        }
    }];
}
///编辑商品
- (void)getEditPageData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"productId"] = self.publishModel.productId;
    params[@"backCateId"] = @0;
    @weakify(self);
    [JHMarketOrderViewModel getEditGoodsData:params Completion:^(NSError * _Nullable error, JHIssueGoodsEditModel * _Nullable model) {
        @strongify(self);
        if (model) {
            if (self.issueEditBlock) {
                self.issueEditBlock(model);
            }
        }
    }];
}
/// 删除
- (void)marketDelete {
    
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"删除后此商品将不再展示，请确认操作？" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        [JHMarketOrderViewModel deletePublishGoods:self.publishModel.productId Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
            if (!error) {
                if (self.reloadDataBlock) {
                    self.reloadDataBlock(true);
                }
            }else {
                JHTOAST(error.localizedDescription);
            }
        }];
    };
    
    alert.cancleHandle = ^{

    };
}
#pragma mark - PUSH - 关闭交易

- (void)configUI {
    [self addSubview:self.editButton];
    [self addSubview:self.seeReportButton];
    [self addSubview:self.offSaleButton];
    [self addSubview:self.adjustPriceButton];
    [self addSubview:self.appraiseButton];
    [self addSubview:self.onSaleButton];
    [self addSubview:self.deleteButton];
    for (UIButton *button in @[self.editButton,self.seeReportButton, self.offSaleButton,self.adjustPriceButton, self.appraiseButton, self.onSaleButton]) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self);
        }];
    }
}
//初始化约束,设置宽度为0,按钮全部隐藏
- (void)initializeConstraints {
    
    for (UIButton *button in @[self.editButton,self.seeReportButton, self.offSaleButton,self.adjustPriceButton, self.appraiseButton, self.onSaleButton]) {
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}

- (UIButton *)seeReportButton {
    if (_seeReportButton == nil) {
        _seeReportButton = [self getButtonWithColor:NO name:@"查看报告" tag:MarketPublishButtonTagSeeReport];
    }
    return _seeReportButton;
}
- (UIButton *)offSaleButton {
    if (_offSaleButton == nil) {
        _offSaleButton = [self getButtonWithColor:NO name:@"下架" tag:MarketPublishButtonTagOffSale];
    }
    return _offSaleButton;
}
- (UIButton *)adjustPriceButton {
    if (_adjustPriceButton == nil) {
        _adjustPriceButton = [self getButtonWithColor:NO name:@"调价" tag:MarketPublishButtonTagAdjustPrice];
    }
    return _adjustPriceButton;
}
- (UIButton *)appraiseButton {
    if (_appraiseButton == nil) {
        _appraiseButton = [self getButtonWithColor:YES name:@"一键鉴定" tag:MarketPublishButtonTagAppraise];
    }
    return _appraiseButton;
}
- (UIButton *)onSaleButton {
    if (_onSaleButton == nil) {
        _onSaleButton = [self getButtonWithColor:NO name:@"上架" tag:MarketPublishButtonTagOnSale];
    }
    return _onSaleButton;
}

- (UIButton *)editButton {
    if (_editButton == nil) {
        _editButton = [self getButtonWithColor:NO name:@"编辑" tag:MarketPublishButtonTagEdit];
    }
    return _editButton;
}
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [self getButtonWithColor:NO name:@"删除" tag:MarketPublishButtonTagDelete];
    }
    return _deleteButton;
}
// 初始化按钮
- (UIButton *)getButtonWithColor:(BOOL )backColor name:(NSString *)name tag:(NSInteger )tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:name forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
    [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    button.layer.cornerRadius = 15;
    button.clipsToBounds = YES;
    if (backColor) { //需要填充按钮颜色
        button.backgroundColor = HEXCOLOR(0xffd70f);
    }else {
        button.layer.borderColor = HEXCOLOR(0xbdbfc2).CGColor;
        button.layer.borderWidth = 0.5;
    }
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}


@end

//
//  JHMarketFloatLowerLeftView.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketFloatLowerLeftView.h"
#import "JHMarketHomeBusiness.h"
#import "JHMarketHomeModel.h"
#import "JHSQCollectViewController.h"
#import "JHMyCompeteViewController.h"
#import "JHC2CSelectClassViewController.h"
#import "JHC2CUploadProductController.h"
#import "CommAlertView.h"
#import "UILabel+edgeInsets.h"

@interface JHMarketFloatLowerLeftView ()
///竞拍
@property (nonatomic, strong) UIButton *biddingBtn;
@property (nonatomic, strong) UILabel *biddingPointLabel;
///收藏
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UILabel *collectPointLabel;
///卖宝贝
@property (nonatomic, strong) UIButton *sellGoodsBtn;
@property (nonatomic, strong) UILabel *sellGoodsPointLabel;
///样式 1-全展示 2-隐藏收藏 3-隐藏竞拍 4-隐藏收藏和竞拍
@property (nonatomic, assign) int floatType;
///收藏数量
@property (nonatomic, assign) int likeNum;
///竞拍状态 1-出价 2-出局 3-领先 4-中拍
@property (nonatomic, assign) int auctionNum;
@property (nonatomic, assign) JHMarketFloatShowType showType;
///弹窗
@property (nonatomic, strong) CommAlertView *sendAlert;
@end

@implementation JHMarketFloatLowerLeftView

- (instancetype)initWithShowType:(JHMarketFloatShowType)type{
    self = [super init];
    if (self) {
        self.showType = type;
    }
    return self;
}
//当点击不在按钮上时，点击穿透
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:self.class]) {
        return nil;
    }
    return view;
}

- (void)layoutMySubView{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGFloat bottomFloat = self.isHaveTabBar ? -20 : -20-UI.tabBarAndBottomSafeAreaHeight;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(bottomFloat);
        make.width.mas_equalTo(58);
        make.height.mas_equalTo(60*3);
    }];
    //竞拍
    [self addSubview:self.biddingBtn];
    [self.biddingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50,50));
    }];
    [self.biddingBtn addSubview:self.biddingPointLabel];
    [self.biddingPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    //收藏
    [self addSubview:self.collectBtn];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.biddingBtn.mas_bottom).offset(10);
        make.right.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50,50));
    }];
    [self.collectBtn addSubview:self.collectPointLabel];
    [self.collectPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    //卖宝贝
    [self addSubview:self.sellGoodsBtn];
    [self.sellGoodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectBtn.mas_bottom).offset(10);
        make.right.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(58,58));
    }];
    [self.sellGoodsBtn addSubview:self.sellGoodsPointLabel];
    [self.sellGoodsPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(14);
    }];
    //返回顶部
    [self addSubview:self.topButton];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectBtn.mas_bottom).offset(10);
        make.right.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50,50));
    }];

    //floatType;//样式 1-全展示 2-隐藏收藏 3-隐藏竞拍 4-隐藏收藏和竞拍
    switch (self.floatType) {
        case 1:
            self.collectBtn.hidden = NO;
            self.biddingBtn.hidden = NO;
            break;
        case 2:{
            self.collectBtn.hidden = YES;
            self.biddingBtn.hidden = NO;
            [self.biddingBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(60);
            }];
            [self.sellGoodsBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.biddingBtn.mas_bottom).offset(10);
            }];
            [self.topButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.biddingBtn.mas_bottom).offset(10);
            }];
            break;
        }
        case 3:
            self.collectBtn.hidden = NO;
            self.biddingBtn.hidden = YES;
            break;
        case 4:
            self.collectBtn.hidden = YES;
            self.biddingBtn.hidden = YES;
            break;
            
        default:
            break;
    }
    if (self.showType > 0) {
        if (self.showType == JHMarketFloatShowTypeSallGoods) {
            self.sellGoodsBtn.hidden = NO;
        }else{
            self.sellGoodsBtn.hidden = YES;
        }
    }
}


#pragma mark - LoadData
- (void)loadData{
    @weakify(self);
    [JHMarketHomeBusiness getMyAcutionStatus:^(NSError * _Nullable error, JHMarketHomeLikeStatusModel * _Nonnull model) {
        @strongify(self);
        //更新角标显示
        [self setCollectNum:model.num auctionStatus:model.auctionResult];
    }];
}

- (void)setCollectNum:(int)collectNum auctionStatus:(int)auctionStatus{
    //更新样式布局
    int status = 4;
    if (collectNum > 0 && auctionStatus > 0) {//1-全展示
        status = 1;
    }else if (collectNum == 0 && auctionStatus > 0){//2-隐藏收藏
        status = 2;
    }else if (collectNum > 0 && auctionStatus == 0){//3-隐藏竞拍
        status = 3;
    }else if (collectNum == 0 && auctionStatus == 0){//4-隐藏收藏和竞拍
        status = 4;
    }
    
    self.floatType = status;
    
    [self layoutMySubView];
    
    //更新收藏数
    self.likeNum = collectNum;
    //更新竞拍状态
    self.auctionNum = auctionStatus;
    
}

- (void)setLikeNum:(int)likeNum{
    _likeNum = likeNum;
    NSString *txtStr = [NSString stringWithFormat:@"%d",_likeNum];
    if (likeNum > 99) {
        txtStr = @"99+";
    }
    _collectPointLabel.text = txtStr;
}

- (void)setAuctionNum:(int)auctionNum{
    _auctionNum = auctionNum;
    switch (_auctionNum) {
        case 1:self.biddingPointLabel.text = @"待出价";
            break;
        case 2:self.biddingPointLabel.text = @"出局";
            break;
        case 3:self.biddingPointLabel.text = @"领先";
            break;
        case 4:self.biddingPointLabel.text = @"成交";
            break;
        default:self.biddingPointLabel.text = @"";
            break;
    }
}


#pragma mark - Action
- (void)buttonAction:(UIButton *)button{
    //判断登录，未登录跳登录
    if (IS_LOGIN) {
        NSInteger index = button.tag-2021;
        switch (index) {
            case 0:{//收藏
                if (self.collectGoodsBlock) {
                    self.collectGoodsBlock();
                }
                JHSQCollectViewController *collectVC = [[JHSQCollectViewController alloc] init];
                collectVC.defaultSelectedIndex = 1;
                [JHRootController.navigationController pushViewController:collectVC animated:YES];
            }
                break;
            case 1:{//竞拍
                JHMyCompeteViewController *vc = [JHMyCompeteViewController new];
                [JHRootController.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:{//发布
                //先判断用户是否被平台处罚限制发布
                @weakify(self);
                [JHMarketHomeBusiness cheakUserIsLimit:1 sellerId:0 completion:^(NSString * _Nullable reason, int level) {
                    @strongify(self);
                    if (reason.length > 0) {
//                        NSMutableAttributedString *attStr = [self matchString:reason];
//                        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andMutableDesc:attStr cancleBtnTitle:@"确定"];
                        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:reason cancleBtnTitle:@"确定"];
                        [alert show];
                        return;
                    }
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"unfinishupload"]) {
                        [self.sendAlert show];
                    }else{
                        [self gotoSendVc];
                    }
                }];
            }
                break;
            default:
                break;
        }
    }
    
}

- (NSMutableAttributedString *)matchString:(NSString *)string{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
    //提取[]中字符串正则表达式
    NSString *regexStr = @"(?<=\\[)[^\\]]+";
    //提取正则
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *object in matches) {
//            NSLog(@"range = %@ str = %@", NSStringFromRange(object.range),
//                                          [string substringWithRange:object.range]);
//        [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13.0f] range:hightlightTextRange];
        NSRange attRange = NSMakeRange(object.range.location-1, object.range.length+2);
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:HEXCOLOR(0xFE4200) 
                             range:attRange];
        }
    return attributeStr;
}

- (void)backTopBtnClick:(UIButton *)button{
    if (self.backTopViewBlock) {
        self.backTopViewBlock();
    }
}

- (CommAlertView *)sendAlert{
    if (!_sendAlert) {
        NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:@"发现您有一个未完成发布的宝贝，是否继续发布。"];
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andMutableDesc:messageAtt cancleBtnTitle:@"发布新宝贝" sureBtnTitle:@"继续发布" andIsLines:NO];
        @weakify(self);
        //发布新宝贝
        alert.cancleHandle = ^{
            @strongify(self);
            [self gotoSendVc];
        };
        //继续发布
        alert.handle = ^{
            @strongify(self);
            [self gotoUploadVc];
        };
        _sendAlert = alert;
    }
    return _sendAlert;
}

- (void)gotoSendVc{
    JHC2CSelectClassViewController *vc = [JHC2CSelectClassViewController new];
    [JHRootController.navigationController  pushViewController:vc animated:YES];
}

- (void)gotoUploadVc{
    JHC2CUploadProductController *vc = [JHC2CUploadProductController new];
    vc.needUnFinishReStart = YES;
    [JHRootController.navigationController  pushViewController:vc animated:YES];
}

#pragma mark - Delegate

#pragma mark - Lazy
- (UIButton *)collectBtn{
    if (!_collectBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 2021;
        [button setBackgroundImage:JHImageNamed(@"c2c_pd_shoucang") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = YES;
        _collectBtn = button;
    }
    return _collectBtn;
}

- (UIButton *)biddingBtn{
    if (!_biddingBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 2022;
        [button setBackgroundImage:JHImageNamed(@"c2c_pd_paimai") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = YES;
        _biddingBtn = button;
    }
    return _biddingBtn;
}

- (UIButton *)sellGoodsBtn{
    if (!_sellGoodsBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 2023;
        [button setBackgroundImage:JHImageNamed(@"c2c_market_float3_icon") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = YES;
        _sellGoodsBtn = button;
    }
    return _sellGoodsBtn;
}

- (UIButton *)topButton{
    if (!_topButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:JHImageNamed(@"c2c_pd_top") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = YES;
        _topButton = button;
    }
    return _topButton;
    
}

- (UILabel *)collectPointLabel{
    if (!_collectPointLabel) {
        UILabel *lab = [UILabel new];
        lab.backgroundColor = HEXCOLOR(0xF03D37);
        lab.textColor = kColorFFF;
        lab.font = JHFont(10);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.layer.cornerRadius  = 7;
        lab.layer.masksToBounds = YES;
        lab.edgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _collectPointLabel = lab;
    }
    return _collectPointLabel;
}

- (UILabel *)biddingPointLabel{
    if (!_biddingPointLabel) {
        UILabel *lable = [[UILabel alloc]init];
        lable.textColor = kColorFFF;
        lable.font = JHFont(10);
        lable.textAlignment = NSTextAlignmentCenter;
        lable.backgroundColor = HEXCOLOR(0xF23730);
        lable.layer.cornerRadius = 7;
        lable.layer.masksToBounds = YES;
        lable.edgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _biddingPointLabel = lable;
    }
    return _biddingPointLabel;
}

- (UILabel *)sellGoodsPointLabel{
    if (!_sellGoodsPointLabel) {
        UILabel *lable = [[UILabel alloc]init];
        lable.text = @"卖宝贝";
        lable.textColor = kColorFFF;
        lable.font = JHFont(10);
        lable.textAlignment = NSTextAlignmentCenter;
        lable.backgroundColor = HEXCOLOR(0xF23730);
        lable.layer.cornerRadius = 7;
        lable.layer.masksToBounds = YES;
        _sellGoodsPointLabel = lable;
    }
    return _sellGoodsPointLabel;
}


@end

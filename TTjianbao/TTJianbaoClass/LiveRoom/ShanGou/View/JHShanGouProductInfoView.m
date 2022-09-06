//
//  JHShanGouProductInfoView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/9/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHShanGouProductInfoView.h"
#import "JHShanGouModel.h"
#import "CommAlertView.h"


@interface JHShanGouProductInfoView()
@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) UIButton * closeBtn;
@property(nonatomic, strong) UILabel * titleLbl;

@property(nonatomic, strong) UIImageView * iconImageView;

//@property(nonatomic, strong) UIScrollView * scroolView;


@property(nonatomic, strong) UIView * productTitleView;
@property(nonatomic, strong) UILabel * productTitleLbl;

@property(nonatomic, strong) UIButton * downBtn;

@end

@implementation JHShanGouProductInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.backView];
    self.backView.hidden = YES;
    [self.backView addSubview:self.titleLbl];
    [self.backView addSubview:self.closeBtn];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.productTitleView];
    [self.backView addSubview:self.downBtn];
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.mas_equalTo(270);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(16);
        make.centerX.equalTo(@0);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(@0).offset(10);
        make.right.equalTo(@0).offset(-10);
    }];

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(159, 178));
        make.top.equalTo(self.titleLbl.mas_bottom).offset(20);
        make.centerX.equalTo(@0);
    }];

    [self.productTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(270, 40));
        make.top.equalTo(self.iconImageView.mas_bottom).offset(13);
        make.left.right.equalTo(@0);
    }];
    
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(240, 38));
        make.bottom.equalTo(@0).offset(-12);
        make.centerX.equalTo(@0);
    }];

}

- (void)setShanGouModel:(JHShanGouModel *)shanGouModel{
    _shanGouModel = shanGouModel;
    self.productTitleLbl.text = shanGouModel.productTitle;
    [self.iconImageView jhSetImageWithURL:[NSURL URLWithString:shanGouModel.productImg] placeholder:kDefaultCoverImage];
    [self addParItem];
}

- (void)setProductCode:(NSString *)productCode{
    _productCode = productCode;
    NSString *url = FILE_BASE_STRING(@"/app/flash/sales/product");
    @weakify(self);
    [HttpRequestTool getWithURL:url Parameters:@{@"productCode":self.productCode} successBlock:^(RequestModel * _Nullable respondObject) {
        JHShanGouModel *model = [JHShanGouModel mj_objectWithKeyValues:respondObject.data];
        @strongify(self);
        self.shanGouModel = model;
        self.productTitleLbl.text = self.shanGouModel.productTitle;
        [self.iconImageView jhSetImageWithURL:[NSURL URLWithString:self.shanGouModel.productImg] placeholder:kDefaultCoverImage];
        [self addParItem];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        JHTOAST(respondObject.message);
    }];
    self.downBtn.hidden = YES;
}

- (void)addParItem{
    self.backView.hidden = NO;
    //商品类型 normal-常规 processingOrder-加工 giftOrder-福利单
    NSString * title = @"闪购常规单";
    if ([self.shanGouModel.productType isEqualToString:@"processingOrder"]) {
        title = @"闪购加工单";
    }else if([self.shanGouModel.productType isEqualToString:@"giftOrder"]){
        title = @"闪购福利单";
    }
    self.titleLbl.text = title;
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    if (self.shanGouModel.secondCategory.length) {
        [arr addObject:@{@"name" : @"选择类别", @"value" : self.shanGouModel.secondCategory}];
    }
    [arr addObject:@{@"name" : @"剩余库存", @"value" : [NSString stringWithFormat:@"%ld/%ld",self.shanGouModel.usableStore, self.shanGouModel.store]}];
    if (self.shanGouModel.price.length) {
        [arr addObject:@{@"name" : @"宝贝价格", @"value" : [@"￥" stringByAppendingString:self.shanGouModel.price]}];
    }
    if ([self.shanGouModel.productType isEqualToString:@"processingOrder"]) {
        [arr addObject:@{@"name" : @"材料费", @"value" : [@"￥" stringByAppendingString:self.shanGouModel.materialCost]}];
        [arr addObject:@{@"name" : @"手工费", @"value" : [@"￥" stringByAppendingString:self.shanGouModel.manualCost]}];
        [arr addObject:@{@"name" : @"合计", @"value" : [@"￥" stringByAppendingString:self.shanGouModel.totalPrice]}];
    }
    [arr addObject:@{@"name" : @"闪购名单", @"value" : @"查看详情"}];

    UIView *lastView = self.productTitleView;
    for (int i = 0; i< arr.count; i++) {
        CGFloat pin = i == 0 ? 0 : 7.f;
        NSDictionary *dic = arr[i];
        UIView* view = [self getViewWithTitle:dic[@"name"] andDes:dic[@"value"]];
        [self.backView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(28);
            make.top.equalTo(lastView.mas_bottom).offset(pin);
            make.left.right.equalTo(@0);
            if (i+1 == arr.count) {
                make.bottom.equalTo(@0).offset(-62);
            }
        }];
        lastView = view;
    }
    
}

- (UIView*)getViewWithTitle:(NSString*)title andDes:(NSString*)des{
    UIView* view =  [UIView new];
    
    UILabel *label1 = [UILabel new];
    label1.font = JHFont(13);
    label1.text = title;
    label1.textColor = HEXCOLOR(0x333333);
    [view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).offset(16);
        make.centerY.equalTo(@0);
        make.width.mas_lessThanOrEqualTo(@55);
    }];
    if ([title isEqualToString:@"闪购名单"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *att = [[NSAttributedString alloc] initWithString:des
                                                                  attributes:@{NSFontAttributeName : JHFont(13),
                                                                               NSForegroundColorAttributeName : HEXCOLOR(0x2F66A0),
                                                                               NSUnderlineStyleAttributeName : @1
                                                                  }];
        [btn setAttributedTitle:att forState:UIControlStateNormal];
        [view addSubview:btn];
        [btn addTarget:self action:@selector(seeListAction:) forControlEvents:UIControlEventTouchUpInside];

        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0).offset(80);
            make.centerY.equalTo(@0);
        }];
    }else{
        
        UILabel *label2 = [UILabel new];
        label2.font = JHFont(13);
        label2.text = des;
        label2.textColor = HEXCOLOR(0x333333);
        if ([title isEqualToString:@"宝贝价格"] || [title isEqualToString:@"合计"]) {
            label2.textColor = HEXCOLOR(0xF23730);
        }
        
        [view addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0).offset(80);
            make.centerY.equalTo(@0);
            make.right.equalTo(@0).offset(-10);
        }];
    }
    return view;
}
- (void)downBtnActionWithSender:(UIButton*)sender{
    
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"提示" andDesc:@"下架后，用户将不能参与此闪购活动，请确认操作" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        [self downProduct];
    };
    alert.cancleHandle = ^{

    };

}

- (void)downProduct{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/flash/sales/under") Parameters:@{@"anchorId" : self.anchorId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
//        NSDictionary *dic = respondObject.data;
        [self closeActionWithSender:nil];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        JHTOAST(respondObject.message);
    }];

}

- (void)seeListAction:(UIButton*)sender{
    if (self.jumpUserListBlock) {
        self.jumpUserListBlock(self.shanGouModel);
    }
    [self closeActionWithSender:nil];
}

- (void)closeActionWithSender:(UIButton*)sender{
    [self removeFromSuperview];
}
#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 5;
        _backView = view;
    }
    return _backView;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"fans_alert_close"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = btn;
    }
    return _closeBtn;
}
- (UIButton *)downBtn{
    if (!_downBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"下架" forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(15);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 19;
        [btn addTarget:self action:@selector(downBtnActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _downBtn = btn;
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xFEE100).CGColor, (__bridge id)HEXCOLOR(0xFFC242).CGColor];
        gradientLayer.locations = @[@0, @1];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        gradientLayer.frame = CGRectMake(0, 0, 240, 38);
        [btn.layer insertSublayer:gradientLayer atIndex:0];
        
    }
    return _downBtn;

}
- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHBoldFont(16);
        label.text = @"闪购加工单";
        label.textColor = HEXCOLOR(0x333333);
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        _iconImageView = view;
    }
    return _iconImageView;
}

- (UIView *)productTitleView{
    if (!_productTitleView) {
        UIView *view = [UIView new];
    
        UILabel *label1 = [UILabel new];
        label1.font = JHFont(13);
        label1.text = @"商品标题";
        label1.textColor = HEXCOLOR(0x333333);
        [view addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0).offset(16);
            make.centerY.equalTo(@0);
            make.width.mas_lessThanOrEqualTo(@55);
        }];

        UILabel *label2 = [UILabel new];
        label2.font = JHFont(13);
        label2.textColor = HEXCOLOR(0x333333);
        label2.numberOfLines = 2;
        [view addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0).offset(80);
            make.centerY.equalTo(@0);
            make.right.equalTo(@0).offset(-10);
        }];
        self.productTitleLbl = label2;
        _productTitleView = view;
    }
    return _productTitleView;
}


@end

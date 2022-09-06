//
//  JHLuckyBagTaskView.m
//  TTjianbao
//
//  Created by zk on 2021/11/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLuckyBagTaskView.h"
#import "JHMyCompeteCountdownView.h"

@interface JHLuckyBagTaskView ()

@property(nonatomic,strong) UIButton *maskView;//遮罩

@property(nonatomic,strong) UIView *headView;//头部渐变

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) JHMyCompeteCountdownView *countdownView; /// 倒计时视图

@property (nonatomic, strong) UIImageView *lGoodsImgV;

@property (nonatomic, strong) UILabel *goodsNameLab;

@property (nonatomic, strong) UILabel *numLab;

@property (nonatomic, strong) UILabel *conLab1;

@property (nonatomic, strong) UILabel *conLab2;

@property (nonatomic, strong) UILabel *conStatusLab1;

@property (nonatomic, strong) UILabel *conStatusLab2;

@property(nonatomic,strong) UIView *submitBtnBackView;
@property(nonatomic,strong) UIButton *submitBtn;

@end

@implementation JHLuckyBagTaskView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)loadData:(NSInteger)bagId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(bagId) forKey:@"sellerConfigId"];
    @weakify(self);
    [JHLuckyBagBusiniss loadBagTaskData:param completion:^(NSError * _Nullable error, JHLuckyBagTaskModel * _Nullable model) {
        @strongify(self);
        if (!error) {
            self.taskModel = model;
            [self reloadData:model];
        }
    }];
}

- (void)reloadData:(JHLuckyBagTaskModel *)model{
    
    [self.lGoodsImgV jhSetImageWithURL:[NSURL URLWithString:model.imgUrl] placeholder:JHImageNamed(@"newStore_detail_shopProduct_Placeholder")];
    self.goodsNameLab.text = model.bagTitle;
    self.numLab.text = [NSString stringWithFormat:@"%d个福袋 | %d人已参与",model.prizeNumber,model.joinNumber];
    self.conLab2.text = [NSString stringWithFormat:@"发表评论：%@",model.bagKey];
    [self.submitBtn setTitle:model.buttonTitle forState:UIControlStateNormal];
    [self removeColorlayer:self.submitBtnBackView];
    switch (model.buttonType) {
        case 0:{//已参与
            self.conLab1.textColor = kColor999;
            self.conStatusLab1.text = @"已达成";
            self.conStatusLab1.textColor = kColor999;
            self.conLab2.textColor = kColor999;
            self.conStatusLab2.text = @"已达成";
            self.conStatusLab2.textColor = kColor999;
            self.submitBtnBackView.backgroundColor = HEXCOLOR(0xFFEF9F);
        }
            break;
        case 1:{//关注
            self.conLab1.textColor = kColor333;
            self.conStatusLab1.text = @"未达成";
            self.conStatusLab1.textColor = kColor333;
            self.conLab2.textColor = kColor333;
            self.conStatusLab2.text = @"未达成";
            self.conStatusLab2.textColor = kColor333;
            [self addGradualColor2:self.submitBtnBackView];
        }
            break;
        case 2:{//发布评论
            self.conLab1.textColor = kColor999;
            self.conStatusLab1.text = @"已达成";
            self.conStatusLab1.textColor = kColor999;
            self.conLab2.textColor = kColor333;
            self.conStatusLab2.text = @"未达成";
            self.conStatusLab2.textColor = kColor333;
            [self addGradualColor2:self.submitBtnBackView];
        }
            break;
        default:
            break;
    }
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 364);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    [self addSubview:self.headView];
    
    UILabel *titLab = [UILabel new];
    titLab.text = @"鉴宝福袋";
    titLab.textColor = kColor333;
    titLab.font = JHMediumFont(18);
    titLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titLab];
    [titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(25);
    }];
    
    UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ruleBtn setImage:JHImageNamed(@"setting_business_more") forState:UIControlStateNormal];
    [ruleBtn setImageEdgeInsets:UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5)];
    [ruleBtn addTarget:self action:@selector(ruleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ruleBtn];
    [ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.right.mas_equalTo(-12);
        make.width.height.mas_equalTo(30);
    }];
    
    self.countdownView = [[JHMyCompeteCountdownView alloc]init];
    [self.countdownView changeTextAttribute:JHMediumFont(16) color:HEXCOLOR(0xFF4200) bgColor:[UIColor clearColor]];
    [self addSubview:self.countdownView];
    [self.countdownView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titLab.mas_bottom).offset(7);
        make.height.mas_equalTo(22);
    }];
    
    [self addSubview:self.lGoodsImgV];
    [self.lGoodsImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36);
        make.top.mas_equalTo(self.headView.mas_bottom).offset(13);
        make.width.height.mas_equalTo(54);
    }];
    
    [self addSubview:self.goodsNameLab];
    [self.goodsNameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lGoodsImgV.mas_right).offset(14);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.headView.mas_bottom).offset(15);
        make.height.mas_equalTo(21);
    }];
    
    [self addSubview:self.numLab];
    [self.numLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lGoodsImgV.mas_right).offset(14);
        make.top.mas_equalTo(self.goodsNameLab.mas_bottom).offset(10);
        make.height.mas_equalTo(18);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = HEXCOLOR(0x979797);
    line.alpha = 0.1;
    [self addSubview:line];
    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36);
        make.right.mas_equalTo(-36);
        make.top.mas_equalTo(self.numLab.mas_bottom).offset(13);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *expLab = [UILabel new];
    expLab.text = @"参与条件";
    expLab.textColor = kColor333;
    expLab.font = JHMediumFont(15);
    [self addSubview:expLab];
    [expLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(33);
        make.top.mas_equalTo(line.mas_bottom).offset(10);
        make.height.mas_equalTo(21);
    }];
    
    [self addSubview:self.conLab1];
    [self.conLab1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(33);
        make.top.mas_equalTo(expLab.mas_bottom).offset(9);
        make.height.mas_equalTo(18);
    }];
    
    [self addSubview:self.conStatusLab1];
    [self.conStatusLab1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(expLab.mas_bottom).offset(9);
        make.height.mas_equalTo(18);
    }];
    
    [self addSubview:self.conLab2];
    [self.conLab2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(33);
        make.right.mas_equalTo(-95);
        make.top.mas_equalTo(self.conLab1.mas_bottom).offset(9);
        make.height.mas_equalTo(18);
    }];
    
    [self addSubview:self.conStatusLab2];
    [self.conStatusLab2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(self.conStatusLab1.mas_bottom).offset(9);
        make.height.mas_equalTo(18);
    }];
    
    [self addSubview:self.submitBtnBackView];
    [self addSubview:self.submitBtn];

}

-(void)show:(NSInteger)bagId secandStr:(NSString *)secandStr{
    [self dealTimeUI:secandStr];
    [self loadData:bagId];
    [self addAlertToView];
}

- (void)dealTimeUI:(NSString *)secandStr{
    //转成秒数
    NSArray *arr = [secandStr componentsSeparatedByString:@":"];
    int secand = [arr[0] intValue]*60+[arr[1] intValue];
    @weakify(self);
    //model.countdownSeconds
    [self.countdownView setSecandData:secand expString:@"后开奖" completion:^(BOOL finished) {
        @strongify(self);
        self.countdownView.hidden = NO;
        self.countdownView.countdownLable.text = @"00:00后开奖";
        self.taskModel.buttonType = 0;
        [self removeColorlayer:self.submitBtnBackView];
        self.submitBtnBackView.backgroundColor = HEXCOLOR(0xFFEF9F);
    }];
}

- (void)addAlertToView{
    [[JHRootController currentViewController].view addSubview:self.maskView];
    [[JHRootController currentViewController].view addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        self.maskView.alpha = 0.5;
        CGAffineTransform transform = self.transform;
        self.transform = CGAffineTransformTranslate(transform, 0, -self.height);
    }];
}

- (void)remove{
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 0.0;
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
//        [self.maskView removeFromSuperview];
//        [self removeFromSuperview];
    }];
}

- (void)addGradualColor:(UIView *)view{
    if (!self.gradientLayer) {
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xFFF9D3).CGColor, (__bridge id)HEXCOLOR(0xFFFFFF).CGColor];
        self.gradientLayer.startPoint = CGPointMake(0, 0);
        self.gradientLayer.endPoint = CGPointMake(0, 1.0);
        self.gradientLayer.frame = view.bounds;
        [view.layer addSublayer:self.gradientLayer];
    }
}
    
- (void)ruleBtnAction{
    if (self.ruleBlock) {
        self.ruleBlock();
    }
}

- (void)submitBtnAction:(UIButton *)btn{
    if (self.taskModel.buttonType == 1 || self.taskModel.buttonType == 2) {
        if (self.taskBlock) {
            self.taskBlock(self.taskModel.buttonType);
        }
    }
}

- (void)downLuckyBag{
    @weakify(self);
    [self.countdownView setSecandData:1 expString:@"后开奖" completion:^(BOOL finished) {
        @strongify(self);
        self.taskModel.buttonType = 0;
        self.countdownView.countdownLable.text = @"福袋活动已下架";
    }];
    [self.submitBtn setTitle:@"福袋活动已下架" forState:UIControlStateNormal];
    [self removeColorlayer:self.submitBtnBackView];
    self.submitBtnBackView.backgroundColor = HEXCOLOR(0xFFEF9F);
}

#pragma mark - Lazy load Methods：

- (UIButton *)maskView{
    if (!_maskView) {
        UIButton *maskView = [UIButton buttonWithType:UIButtonTypeCustom];
        maskView.frame = [UIScreen mainScreen].bounds;
        maskView.alpha = 0.0;
        maskView.backgroundColor = [UIColor blackColor];
        [maskView addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        _maskView = maskView;
    }
    return _maskView;
}

- (UIView *)headView{
    if (!_headView) {
        UIView *headView = [UIView new];
        headView.frame = CGRectMake(0, 0, self.width, 80);
        [self addGradualColor:headView];
        _headView = headView;
    }
    return _headView;
}
  
- (UIImageView *)lGoodsImgV{
    if (!_lGoodsImgV) {
        UIImageView *imgv = [UIImageView new];
        [imgv jh_cornerRadius:4];
        imgv.image = JHImageNamed(@"newStore_detail_shopProduct_Placeholder");
        _lGoodsImgV = imgv;
    }
    return _lGoodsImgV;
}

- (UILabel *)goodsNameLab{
    if (!_goodsNameLab) {
        UILabel *goodsNameLab = [UILabel new];
        goodsNameLab.text = @"宝贝名称";
        goodsNameLab.textColor = kColor333;
        goodsNameLab.font = JHMediumFont(15);
        _goodsNameLab = goodsNameLab;
    }
    return _goodsNameLab;
}

- (UILabel *)numLab{
    if (!_numLab) {
        UILabel *numLab = [UILabel new];
        numLab.text = @"0个福袋 ｜ 0人已参与";
        numLab.textColor = kColor666;
        numLab.font = JHFont(13);
        _numLab = numLab;
    }
    return _numLab;
}

- (UILabel *)conLab1{
    if (!_conLab1) {
        UILabel *conLab1 = [UILabel new];
        conLab1.text = @"关注主播";
        conLab1.textColor = kColor333;
        conLab1.font = JHFont(13);
        _conLab1 = conLab1;
    }
    return _conLab1;
}

- (UILabel *)conLab2{
    if (!_conLab2) {
        UILabel *conLab2 = [UILabel new];
        conLab2.text = @"发表评论：评论口令";
        conLab2.textColor = kColor333;
        conLab2.font = JHFont(13);
        conLab2.numberOfLines = 2;
        _conLab2 = conLab2;
    }
    return _conLab2;
}

- (UILabel *)conStatusLab1{
    if (!_conStatusLab1) {
        UILabel *conStatusLab1 = [UILabel new];
        conStatusLab1.text = @"未达成";
        conStatusLab1.textColor = kColor333;
        conStatusLab1.font = JHFont(13);
        _conStatusLab1 = conStatusLab1;
    }
    return _conStatusLab1;
}

- (UILabel *)conStatusLab2{
    if (!_conStatusLab2) {
        UILabel *conStatusLab2 = [UILabel new];
        conStatusLab2.text = @"未达成";
        conStatusLab2.textColor = kColor333;
        conStatusLab2.font = JHFont(13);
        _conStatusLab2 = conStatusLab2;
    }
    return _conStatusLab2;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(28, self.height-94, self.width-56, 44);
        [submitBtn jh_cornerRadius:22];
        [submitBtn setTitle:@"关注主播" forState:UIControlStateNormal];
        [submitBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        submitBtn.titleLabel.font = JHMediumFont(15);
        [submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn = submitBtn;
    }
    return _submitBtn;
}

- (UIView *)submitBtnBackView{
    if (!_submitBtnBackView) {
        UIView *submitBtnBackView = [UIView new];
        submitBtnBackView.frame = CGRectMake(28, self.height-94, self.width-56, 44);
        [self addGradualColor2:submitBtnBackView];
        [submitBtnBackView jh_cornerRadius:22];
        _submitBtnBackView = submitBtnBackView;
    }
    return _submitBtnBackView;
}

- (void)addGradualColor2:(UIView *)view{
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.colors = @[(__bridge id)HEXCOLOR(0xFEE100).CGColor, (__bridge id)HEXCOLOR(0xFFC242).CGColor];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1.0, 0.0);
    gradientLayer2.frame = view.bounds;
    [view.layer addSublayer:gradientLayer2];
}

- (void)removeColorlayer:(UIView *)view{
    for (CALayer *layer in view.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
}

@end

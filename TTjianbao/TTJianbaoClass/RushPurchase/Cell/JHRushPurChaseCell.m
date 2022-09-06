//
//  JHRushPurChaseCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/9/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRushPurChaseCell.h"
#import "JHRushPurPresentView.h"
#import "JHRushPurBusiness.h"

#pragma mark -- tag 视图
///tag 视图
@interface JHRushPurTagView : UIView

@property(nonatomic, strong) UIView * backView;

@property(nonatomic, strong) NSMutableArray <UILabel*>* tagArr;

@end

@implementation JHRushPurTagView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    [self addSubview:self.backView];
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}


/// 刷新tag
/// @param arr 字符串数组
- (void)refreshTagsWithArr:(NSArray<NSString*>*)arr{
    [self.tagArr  enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self.tagArr removeAllObjects];
    UIView *lastView = nil;
    CGFloat maxWide = kScreenWidth - 24 - 138 - 18;
    for (int i = 0; i< arr.count; i++) {
        NSString *text  = arr[i];
        UILabel *tag = [UILabel new];
        tag.font = JHFont(10);
        tag.textColor = HEXCOLOR(0xF23730);
        tag.text = text;
        tag.textAlignment = NSTextAlignmentCenter;
        tag.layer.cornerRadius = 2;
        tag.layer.borderColor = HEXCOLOR(0xF23730).CGColor;
        tag.layer.borderWidth = 0.5;
        CGFloat orignX = lastView ? CGRectGetMaxX(lastView.frame) + 4 : 0;
        CGFloat orignY = lastView ? lastView.mj_y : 0;
        CGFloat width = [self getWidthWithSting:text];
        
        if (i == 0 && width > maxWide) {width = maxWide;}
        tag.frame = CGRectMake(orignX, orignY, width, 15);
        
        if (lastView && (orignX + width) >= maxWide) {
            break;
        }
        [self.tagArr addObject:tag];
        [self.backView addSubview:tag];
        lastView = tag;
    }
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        if (lastView) {
            make.bottom.equalTo(lastView).offset(6);
        }
    }];
}

- (CGFloat)getWidthWithSting:(NSString*)text{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0)
                       options:NSStringDrawingUsesLineFragmentOrigin
                    attributes:@{NSFontAttributeName : JHFont(10)}
                       context:nil].size.width;
    return  width  + 8;
}

- (NSMutableArray<UILabel *> *)tagArr{
    if (!_tagArr) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        _tagArr = arr;
    }
    return _tagArr;
}

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        _backView = view;
    }
    return _backView;
}

@end




@interface JHRushPurChaseCell()

/// 底部圆角白色view
@property(nonatomic, strong) UIView * backView;

/// 左侧商品icon
@property(nonatomic, strong) UIImageView * iconImageView;

/// title
@property(nonatomic, strong) UILabel * nameLbl;

/// 右侧箭头icon
@property(nonatomic, strong) UILabel * tagIconImageView;

/// title
@property(nonatomic, strong) JHRushPurPresentView * purPresentView;

@property(nonatomic, strong) UIButton * rightBtn;

@property(nonatomic, strong) JHRushPurTagView * tagView;

/// title
@property(nonatomic, strong) UILabel * currentPriceLbl;

/// title
@property(nonatomic, strong) UILabel * basePriceLbl;

/// title
@property(nonatomic, strong) UILabel * appenBasePriceLbl;

/// title
@property(nonatomic, strong) UIView * imageMaskView;


/// title
@property(nonatomic, strong) UIView * functionView;



/// 左侧商品icon
@property(nonatomic, strong) UIImageView * bolangImageView;
/// 左侧商品icon
@property(nonatomic, strong) UIImageView * bigArrowImageView;

@property(nonatomic, strong) UIImageView * jianTouPriceImageView;

/// title
@property(nonatomic, strong) UIView * rightBtnAppendView;


/// title
@property(nonatomic, strong) UILabel * shengLbl;

/// title
@property(nonatomic, strong) UILabel * jianshuLbl;

/// title
@property(nonatomic, strong) UILabel * fuhaoLbl;


//miaosha_bolang

@end

@implementation JHRushPurChaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.contentView.backgroundColor = HEXCOLOR(0xF5F5F8);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.nameLbl];
//    [self.backView addSubview:self.purPresentView];
    [self.backView addSubview:self.tagView];
    [self.backView addSubview:self.rightBtn];
    [self.backView addSubview:self.functionView];
    
    [self.backView addSubview:self.bolangImageView];
    [self.backView addSubview:self.bigArrowImageView];

    
    [self.functionView addSubview:self.currentPriceLbl];
    [self.functionView addSubview:self.basePriceLbl];
    [self.functionView addSubview:self.appenBasePriceLbl];
    [self.functionView addSubview:self.tagIconImageView];

    [self.backView addSubview:self.jianTouPriceImageView];

    
}

- (void)setViewModel:(JHRushPurChaseCellViewModel *)viewModel{
    _viewModel =  viewModel;
    [self bindData];
}

- (void)bindData{
    [self.tagView refreshTagsWithArr:self.viewModel.productTagList];
    RAC(self.nameLbl, text) = [RACObserve(self.viewModel, title) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.currentPriceLbl, attributedText) = [RACObserve(self.viewModel, currentPriceAtt) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.basePriceLbl, attributedText) = [RACObserve(self.viewModel, basePriceAtt) takeUntil:self.rac_prepareForReuseSignal];
//    RAC(self.purPresentView, peresent) = [RACObserve(self.viewModel, seckillProgress) takeUntil:self.rac_prepareForReuseSignal];
    @weakify(self);
    [[RACObserve(self.viewModel, status) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSInteger status = [x integerValue];
        [self refershWithStatus:status];
    }];
    [[RACObserve(self.viewModel, leftImageUrl) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self.iconImageView jhSetImageWithURL:[NSURL URLWithString:x] placeholder:kDefaultCoverImage];
    }];
    
    self.shengLbl.text = self.viewModel.saveMoney;
    
//    如原型所示，显示“仅剩/限量YY件”；
//    当0<YY<=5时，显示“仅剩YY件”；
//    当5<YY时，显示“限量YY件”；
//    当YY=0时，不显示“仅剩/限量YY件”。
//    其中“YY件”为当前商品可售库存数，自然数显示；
//    涉及“抢购中”商品状态；
    if (self.viewModel.sellStock == 0) {
        self.jianshuLbl.text =   @"";
    }else if(self.viewModel.sellStock < 6){
        self.jianshuLbl.text =   [NSString stringWithFormat:@"仅剩%ld件", self.viewModel.sellStock];
    }else{
        self.jianshuLbl.text =   [NSString stringWithFormat:@"限量%ld件", self.viewModel.sellStock];
    }

    [self.fuhaoLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).offset(7);
        make.bottom.equalTo(self.shengLbl.mas_bottom).offset(-1);
    }];
    self.tagIconImageView.hidden = self.viewModel.currentPriceAtt.string.length > 6;
    self.appenBasePriceLbl.hidden = self.viewModel.basePriceAtt.string.length > 10;
}

- (void)rightBtnActionWithSender:(UIButton*)sender{
    [SVProgressHUD show];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"productId"] = self.viewModel.productId;
    dic[@"showId"] = self.viewModel.showId;
    [JHRushPurBusiness  requestSalesReminder:dic completion:^(NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (!error) {
            self.viewModel.status = JHRushPurChaseCell_Status_ReMinded;
        }else{
            JHTOAST(error.localizedDescription);
        }
    }];
    NSMutableDictionary *dicStatic = [NSMutableDictionary dictionary];
    dicStatic[@"commodity_id"] = self.viewModel.productId;
    dicStatic[@"zc_id"] = self.viewModel.showId;
    dicStatic[@"page_position"] = @"商城秒杀落地页";
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickRemind" params:dicStatic type:JHStatisticsTypeSensors];
}

- (void)refershWithStatus:(JHRushPurChaseCell_Status)status{
    [self refreshButtonStatus:status];
    [self refreshImageViewStatus:status];
//    [self refreshpurPresentViewStatus:status];
    
}

- (void)refreshButtonStatus:(JHRushPurChaseCell_Status)status{
    self.rightBtn.userInteractionEnabled = NO;
    [self.rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.rightBtn.layer.borderWidth = 0;
    self.rightBtn.titleLabel.font = JHFont(14);
    self.bolangImageView.alpha = 1;
    self.bigArrowImageView.alpha = 1;
    self.rightBtnAppendView.hidden = YES;

    NSString *btnName = @"马上抢";
    UIColor  *backColor = HEXCOLOR(0xFF5200);
    switch (status) {
            //马上抢
        case JHRushPurChaseCell_Status_RushPur:
        {
            backColor = HEXCOLOR(0xFF5200);
            btnName = @"";
            self.jianTouPriceImageView.image = [UIImage imageNamed:@"miaosha_mode1"];
            self.rightBtnAppendView.hidden = NO;
        }
            break;
            //开售提醒
        case JHRushPurChaseCell_Status_ReMind:
        {
            backColor = HEXCOLOR(0xFF8C00);
            btnName = @"提醒我";
            self.rightBtn.userInteractionEnabled = YES;
            self.jianTouPriceImageView.image = [UIImage imageNamed:@"miaosha_mode2"];

        }
            break;
            //已设置提醒
        case JHRushPurChaseCell_Status_ReMinded:
        {
            backColor = HEXCOLOR(0xF8DAA2);
            self.rightBtn.titleLabel.font = JHFont(13);
            [self.rightBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            btnName = @"已设置";
            self.jianTouPriceImageView.image = [UIImage imageNamed:@"miaosha_mode3"];
        }
            break;
            //已抢光
        case JHRushPurChaseCell_Status_Empty:
        {
            backColor = HEXCOLOR(0xC0C0C0);
            btnName = @"已抢光";
            self.bolangImageView.alpha = 0.5;
            self.bigArrowImageView.alpha = 0.5;
            self.jianTouPriceImageView.image = [UIImage imageNamed:@"miaosha_mode4"];


        }
            break;
            //已下架
        case JHRushPurChaseCell_Status_XiaJia:
        {
            backColor = HEXCOLOR(0xC0C0C0);
            btnName = @"已下架";
            self.bolangImageView.alpha = 0.5;
            self.bigArrowImageView.alpha = 0.5;
            self.jianTouPriceImageView.image = [UIImage imageNamed:@"miaosha_mode4"];

        }
            break;
        default:
            break;
    }
    self.rightBtn.backgroundColor = backColor;
    [self.rightBtn setTitle:btnName forState:UIControlStateNormal];
}

- (void)refreshImageViewStatus:(JHRushPurChaseCell_Status)status{
    [self.imageMaskView removeFromSuperview];
    if (status == JHRushPurChaseCell_Status_Empty  || status == JHRushPurChaseCell_Status_XiaJia) {
        self.imageMaskView = [self getImageMaskViewStatusSellOut:status == JHRushPurChaseCell_Status_Empty];
        [self.iconImageView addSubview:self.imageMaskView];
        [self.imageMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
}


- (void)refreshpurPresentViewStatus:(JHRushPurChaseCell_Status)status{
    BOOL showPresntView = !(status == JHRushPurChaseCell_Status_ReMind || status == JHRushPurChaseCell_Status_ReMinded);
    self.purPresentView.hidden = !showPresntView;
    [self.purPresentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0).offset(-10);
        make.left.equalTo(self.nameLbl);
        make.size.mas_equalTo(CGSizeMake(108.f, showPresntView ? 15.f : 0.1f));
    }];
    self.purPresentView.sepStatus = (status == JHRushPurChaseCell_Status_XiaJia || status == JHRushPurChaseCell_Status_Empty);
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(5);
        make.left.equalTo(@0).offset(12);
        make.right.equalTo(@0).offset(-12);
        make.bottom.equalTo(@9).offset(-5);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(162.f, 162.f));
    }];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(11);
        make.left.equalTo(self.iconImageView.mas_right).offset(9);
        make.right.equalTo(@0).offset(-10);
    }];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLbl.mas_bottom).offset(4);
        make.left.equalTo(self.nameLbl);
        make.right.equalTo(@0).offset(-10);
    }];
//    [self.purPresentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(@0).offset(-10);
//        make.left.equalTo(self.nameLbl);
//        make.size.mas_equalTo(CGSizeMake(108.f, 15.f));
//    }];
    
    [self.currentPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0).offset(-18);
        make.left.equalTo(@0).offset(7);
    }];
    [self.basePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.functionView.mas_bottom).offset(-9);
        make.left.equalTo(@0).offset(7);
    }];
    
    [self.appenBasePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.basePriceLbl);
        make.left.equalTo(self.basePriceLbl.mas_right).offset(2);
    }];
    
    [self.tagIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentPriceLbl.mas_right).offset(2);
        make.bottom.equalTo(self.currentPriceLbl).offset(-2);
    }];
    
    [self.functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(11);
        make.bottom.equalTo(@0).offset(-8);
        make.size.mas_equalTo(CGSizeMake(109.f, 44.f));
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0).offset(-11);
        make.bottom.equalTo(@0).offset(-8);
        make.height.mas_equalTo(44.f);
        make.left.equalTo(self.functionView.mas_right);

    }];

    [self.bolangImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(13);
        make.bottom.equalTo(self.functionView.mas_top).offset(-5);
        make.size.mas_equalTo(CGSizeMake(158.f, 17.f));
    }];
    [self.bigArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bolangImageView).offset(-2.5);
        make.bottom.equalTo(self.bolangImageView.mas_top).offset(9);
        make.size.mas_equalTo(CGSizeMake(45.f, 39.f));
    }];

    [self.jianTouPriceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightBtn);
        make.right.equalTo(self.rightBtn.mas_left).offset(4);
        make.size.mas_equalTo(CGSizeMake(23.f, 44.f));
    }];

    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.layer.cornerRadius = 8;
        view.layer.masksToBounds = YES;
        view.backgroundColor = UIColor.whiteColor;
        _backView = view;
    }
    return _backView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        view.backgroundColor = HEXCOLOR(0xFAFAFA);
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.layer.masksToBounds = YES;
        _iconImageView = view;
    }
    return _iconImageView;
}

- (UILabel *)nameLbl{
    if (!_nameLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(15);
        label.textColor = HEXCOLOR(0x333333);
        _nameLbl = label;
    }
    return _nameLbl;
}

- (UILabel *)appenBasePriceLbl{
    if (!_appenBasePriceLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(9);
        label.text = @"原价";
        label.textColor = HEXCOLOR(0xF7EDD4);
        _appenBasePriceLbl = label;
    }
    return _appenBasePriceLbl;
}

- (UIImageView *)bolangImageView{
    if (!_bolangImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"miaosha_bolang"];
        _bolangImageView = view;
    }
    return _bolangImageView;
}

- (UIImageView *)jianTouPriceImageView{
    if (!_jianTouPriceImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"miaosha_mode1"];
        _jianTouPriceImageView = view;
    }
    return _jianTouPriceImageView;
}




- (UIImageView *)bigArrowImageView{
    if (!_bigArrowImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"miaosha_redArrow"];
        _bigArrowImageView = view;
        
        UILabel *topLbl = [UILabel new];
        topLbl.font = JHBoldFont(11.5);
        topLbl.textColor = HEXCOLOR(0xffffff);
        topLbl.text = @"省";
        [view addSubview:topLbl];
        
        [topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(@0);
        }];

        UILabel *bottomLbl1 = [UILabel new];
        bottomLbl1.font = JHFont(8);
        bottomLbl1.textColor = HEXCOLOR(0xffffff);
        bottomLbl1.text = @"￥";
        [view addSubview:bottomLbl1];
        UILabel *bottomLbl2 = [UILabel new];
        bottomLbl2.textColor = HEXCOLOR(0xffffff);
        bottomLbl2.text = @"200";
        bottomLbl2.adjustsFontSizeToFitWidth = true;

        [view addSubview:bottomLbl2];
        self.shengLbl = bottomLbl2;
        self.fuhaoLbl = bottomLbl1;

        
        [bottomLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0).offset(7);
            make.bottom.equalTo(bottomLbl2.mas_bottom).offset(-1);
        }];
        [bottomLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomLbl1.mas_right);
            make.bottom.equalTo(@0).offset(-7);
            make.right.equalTo(@0).offset(-7);
//            make.width.mas_equalTo(22.f);
        }];
        
    }
    return _bigArrowImageView;
}


- (JHRushPurPresentView *)purPresentView{
    if (!_purPresentView){
        JHRushPurPresentView *view = [JHRushPurPresentView new];
        _purPresentView = view;
    }
    return _purPresentView;
}

- (JHRushPurTagView *)tagView{
    if (!_tagView) {
        JHRushPurTagView *view = [JHRushPurTagView new];
        _tagView = view;
    }
    return _tagView;
}

- (UILabel *)tagIconImageView{
    if (!_tagIconImageView) {
        UILabel *view = [UILabel new];
        view.text = @"秒杀价";
        view.font = JHMediumFont(9);
        view.textColor = HEXCOLOR(0xF63421);
        _tagIconImageView = view;
    }
    return _tagIconImageView;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"马上抢" forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(14);
        [btn addTarget:self action:@selector(rightBtnActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        [btn jh_cornerRadius:2];
        btn.backgroundColor = HEXCOLOR(0xFF5200);
        _rightBtn = btn;
        
        [btn addSubview:self.rightBtnAppendView];
        [self.rightBtnAppendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        self.rightBtnAppendView.hidden = YES;
    }
    return _rightBtn;
}

- (UILabel *)currentPriceLbl{
    if (!_currentPriceLbl) {
        UILabel *label = [UILabel new];
        label.textColor = HEXCOLOR(0xF23730);
        _currentPriceLbl = label;
    }
    return _currentPriceLbl;
}
- (UILabel *)basePriceLbl{
    if (!_basePriceLbl) {
        UILabel *label = [UILabel new];
        label.textColor = HEXCOLOR(0x999999);
        _basePriceLbl = label;
    }
    return _basePriceLbl;
}


- (UIView *)functionView{
    if (!_functionView) {
        UIView *view = [UIView new];
        view.layer.cornerRadius = 2;
        view.layer.masksToBounds = YES;
        view.backgroundColor = UIColor.whiteColor;
        view.layer.borderWidth = 1;
        view.layer.borderColor = HEXCOLOR(0xFF5200).CGColor;
        _functionView = view;
        
        UIView *bottomBlackView = [UIView new];
        bottomBlackView.backgroundColor = HEXCOLOR(0x494B44);
        [view addSubview:bottomBlackView];
        [bottomBlackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.mas_equalTo(18.f);
        }];
    }
    return _functionView;
}



- (UIView *)rightBtnAppendView{
    if (!_rightBtnAppendView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.clearColor;
        _rightBtnAppendView = view;
        
        UILabel *topLbl = [UILabel new];
        topLbl.font = JHBoldFont(14);
        topLbl.textColor = HEXCOLOR(0xffffff);
        topLbl.text = @"马上抢";
        [view addSubview:topLbl];
        
        [topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0).offset(2);
            make.top.equalTo(@0).offset(5);
        }];

        UILabel *bottomLbl = [UILabel new];
        bottomLbl.font = JHFont(9);
        bottomLbl.textColor = HEXCOLOR(0xffffff);
        bottomLbl.textAlignment = 1;
        bottomLbl.text = @"仅剩0件";
        bottomLbl.adjustsFontSizeToFitWidth = true;
        [view addSubview:bottomLbl];
        [bottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLbl.mas_bottom).offset(1);
            make.left.right.equalTo(@0);
        }];
        self.jianshuLbl = bottomLbl;
        
    }
    return _rightBtnAppendView;
}


- (UIView *)getImageMaskViewStatusSellOut:(BOOL)sellOut{
    UIView *view = [UIView new];
    view.backgroundColor = HEXCOLORA(0xffffff, 0.7);
    UIImageView* img = [UIImageView new];
    NSString *name = sellOut ? @"miaosha_qiangguagn" : @"miaosha_xiajia";
    img.image = [UIImage imageNamed:name];
    [view addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
    return view;
}

@end


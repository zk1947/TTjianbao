//
//  JHBuyAppraiseCheckCountView.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBuyAppraiseCheckCountView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "NSString+AttributedString.h"
#import "SourceMallApiManager.h"
#import "JHWebViewController.h"
#import "JHFilterBoxView.h"
#import "MBProgressHUD.h"
#import "JHGrowingIO.h"
@interface JHBuyAppraiseCheckCountView()<JHFilterBoxViewDelegate>

/** 累计鉴定数量*/
@property (nonatomic, strong) UILabel *countLabel;
/** 筛选按钮*/
@property (nonatomic, strong) UIButton *siftButton;
/** 把关标准背景*/
@property (nonatomic, strong) UIView *ruleBackView;
/** 背景纹理*/
@property (nonatomic, strong) UIImageView *ruleBackImageView;
/** 把关标准Tag*/
@property (nonatomic, strong) UILabel *ruleTagLabel;
/** 行业标准*/
@property (nonatomic, strong) UIButton *ruleButton;
/** 鉴定专家*/
@property (nonatomic, strong) UIButton *masterButton;
/** 服务开拓者*/
@property (nonatomic, strong) UIButton *openButton;
/** 查看更多Logo*/
@property (nonatomic, strong) UIImageView *moreImageView;
/** 侧边栏*/
@property (nonatomic, strong) JHFilterBoxView *popView;
/** 跳转页面*/
@property (nonatomic, copy) NSString *urlString;
@end

@implementation JHBuyAppraiseCheckCountView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = HEXCOLOR(0xffffff);
        [self configUI];
        self.urlString = H5_BASE_STRING(@"/jianhuo/app/identificationIntroduced/identificationIntroduced.html");
    }
    return self;
}

- (void)refreshData{
    /// 获取为宝友把关数量
    MJWeakSelf;
    [SourceMallApiManager requestOrderCountBlock:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
            NSString *count = respondObject.data;
            NSMutableArray *itemsArray = [NSMutableArray array];
            itemsArray[0] = @{@"string":@"累计为宝友鉴定 ", @"color":HEXCOLOR(0x666666), @"font":[UIFont fontWithName:kFontNormal size:12]};
            itemsArray[1] = @{@"string":[CommHelp jh_numberSplitWithComma:count.integerValue], @"color":HEXCOLOR(0x222222), @"font":[UIFont fontWithName:kFontBoldDIN size:20]};
            itemsArray[2] = @{@"string":@" 件商品", @"color":HEXCOLOR(0x666666), @"font":[UIFont fontWithName:kFontNormal size:12]};
            weakSelf.countLabel.attributedText = [NSString mergeStrings:itemsArray];
        }else{
            NSMutableArray *itemsArray = [NSMutableArray array];
            itemsArray[0] = @{@"string":@"累计为宝友鉴定 ", @"color":HEXCOLOR(0x666666), @"font":[UIFont fontWithName:kFontNormal size:12]};
            itemsArray[1] = @{@"string":@"--", @"color":HEXCOLOR(0x222222), @"font":[UIFont fontWithName:kFontBoldDIN size:20]};
            itemsArray[2] = @{@"string":@" 件商品", @"color":HEXCOLOR(0x666666), @"font":[UIFont fontWithName:kFontNormal size:12]};
            weakSelf.countLabel.attributedText = [NSString mergeStrings:itemsArray];
        }
    }];
}

#pragma mark --点击事件
- (void)checkViewClickAction{
    NSString *urlString = [self.urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [JHGrowingIO trackEventId:@"standard_banner_in"];
    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = urlString;
    [self.viewController.navigationController pushViewController:webView animated:YES];
}

/** 筛选*/
- (void)siftButtonClickAction{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    NSMutableArray *titlesArray = [NSMutableArray new];
    NSMutableArray *itemsArray = [NSMutableArray new];
    NSMutableArray *cateTypesArray = [NSMutableArray new];
    NSString *url = FILE_BASE_STRING(@"/anon/appraisal/shop/filter-items");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject)
    {
        NSArray *array = respondObject.data;
        if (array.count > 0)
        {
            for (int i = 0; i < array.count ; i++)
            {
                NSDictionary *dic = array[i];
                
                NSString *cateName = dic[@"cateName"];
                NSString *cateType = [NSString stringWithFormat:@"%@",dic[@"cateType"]];
                
                [titlesArray addObject:cateName];
                [cateTypesArray addObject:cateType];
                
                NSArray *array = dic[@"items"];
                NSMutableArray *items = [NSMutableArray new];
                
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                {
                    JHFilterBoxModel *model = [JHFilterBoxModel mj_objectWithKeyValues:obj];
                    model.isSelected = NO;
                    
                    [items addObject:model];
                }];
                
                [itemsArray addObject:items];
            }
            self.popView = [[JHFilterBoxView alloc] initWithTitles:itemsArray items:titlesArray cateTypes:cateTypesArray];
            self.popView.delegate = self;
            [self.popView show];
        }
        
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    } failureBlock:^(RequestModel * _Nullable respondObject)
    {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }];
}

#pragma JHFilterBoxViewDelegate
- (void)filterBoxView:(JHFilterBoxView *)filterBoxView clickButton:(NSMutableDictionary *)dic title:(NSString *)title{
    [JHGrowingIO trackEventId:@"screen_success" variables:@{@"material":dic[@"material"], @"category":dic[@"category"]}];
    if (self.selectBlock) {
        self.selectBlock(dic);
    }
//    if(!([title isEqualToString:@"红蓝宝"] || [title isEqualToString:@"翡翠"] || [title isEqualToString:@"和田玉"])){
        title = @"";
//    }
    if (title.length > 0) {
        self.ruleTagLabel.text = [NSString stringWithFormat:@"天天鉴宝为宝友购买%@把关标准", title];
    }else{
        self.ruleTagLabel.text = @"天天鉴宝品控鉴定介绍";
    }
    NSString *host = H5_BASE_STRING(@"/jianhuo/app/identificationIntroduced/identificationIntroduced.html");
    if (title.length > 0) {
        self.urlString = [NSString stringWithFormat:@"%@?name=%@",host,title];
    }else{
        self.urlString = host;
    }
}

- (void)configUI{
    [self addSubview:self.countLabel];
    [self addSubview:self.siftButton];
    [self addSubview:self.ruleBackView];
    [self.ruleBackView addSubview:self.moreImageView];
    [self.ruleBackView addSubview:self.ruleBackImageView];
    [self.ruleBackView addSubview:self.ruleTagLabel];
    [self.ruleBackView addSubview:self.ruleButton];
    [self.ruleBackView addSubview:self.masterButton];
    [self.ruleBackView addSubview:self.openButton];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.height.mas_equalTo(24);
    }];
    
    [self.siftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.countLabel.mas_centerY).offset(2);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(50);
    }];
    
    [self.ruleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.top.mas_equalTo(self.countLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(kScreenWidth - 24);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
    
    [self.ruleBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ruleBackView.mas_top);
        make.left.mas_equalTo(self.ruleBackView.mas_left);
    }];
    
    [self.ruleTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ruleBackView.mas_left).offset(10);
        make.top.mas_equalTo(self.ruleBackView.mas_top).offset(7);
        make.height.mas_equalTo(24);
    }];
    
    [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ruleBackView.mas_right).offset(-12);
        make.centerY.mas_equalTo(self.ruleBackView.mas_centerY);
        make.height.mas_equalTo(9);
        make.width.mas_equalTo(6);
    }];
    
    [self.ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ruleBackView.mas_left).offset(10);
        make.top.mas_equalTo(self.ruleTagLabel.mas_bottom).offset(4);
        make.height.mas_equalTo(15);
    }];
    
    [self.masterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ruleButton.mas_right).offset(12);
        make.top.mas_equalTo(self.ruleButton.mas_top);
        make.height.mas_equalTo(15);
    }];
    
    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.masterButton.mas_right).offset(12);
        make.top.mas_equalTo(self.ruleButton.mas_top);
        make.height.mas_equalTo(15);
    }];
}

- (UILabel *)countLabel{
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = HEXCOLOR(0x666666);
        NSMutableArray *itemsArray = [NSMutableArray array];
        itemsArray[0] = @{@"string":@"累计为宝友鉴定 ", @"color":HEXCOLOR(0x666666), @"font":[UIFont fontWithName:kFontNormal size:12]};
        itemsArray[1] = @{@"string":@"--", @"color":HEXCOLOR(0x222222), @"font":[UIFont fontWithName:kFontBoldDIN size:20]};
        itemsArray[2] = @{@"string":@" 件商品", @"color":HEXCOLOR(0x666666), @"font":[UIFont fontWithName:kFontNormal size:12]};
        _countLabel.attributedText = [NSString mergeStrings:itemsArray];
    }
    return _countLabel;
}

- (UIButton *)siftButton{
    if (_siftButton == nil) {
        _siftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_siftButton setTitle:@"筛选" forState:UIControlStateNormal];
        [_siftButton setImage:[UIImage imageNamed:@"appraisal_home_shaixuan"] forState:UIControlStateNormal];
        [_siftButton setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        _siftButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [_siftButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
        [_siftButton addTarget:self action:@selector(siftButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _siftButton;
}

- (UIView *)ruleBackView{
    if (_ruleBackView == nil) {
        _ruleBackView = [[UIView alloc] init];
        _ruleBackView.backgroundColor = HEXCOLOR(0xf7f4f0);
        _ruleBackView.layer.cornerRadius = 5;
        _ruleBackView.layer.borderColor = HEXCOLORA(0xe8d9c5, 0.4).CGColor;
        _ruleBackView.layer.borderWidth = 0.5;
        _ruleBackView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkViewClickAction)];
        [_ruleBackView addGestureRecognizer:tap];
    }
    return _ruleBackView;
}

- (UIImageView *)ruleBackImageView{
    if (_ruleBackImageView == nil) {
        _ruleBackImageView = [[UIImageView alloc] init];
        _ruleBackImageView.image = [UIImage imageNamed:@"appraise_home_shuiyin"];
    }
    return _ruleBackImageView;
}

- (UILabel *)ruleTagLabel{
    if (_ruleTagLabel == nil) {
        _ruleTagLabel = [[UILabel alloc] init];
        _ruleTagLabel.textColor = HEXCOLOR(0xb9855d);
        _ruleTagLabel.text = @"天天鉴宝品控鉴定介绍";
        _ruleTagLabel.font = [UIFont fontWithName:kFontBoldDIN size:16];
    }
    return _ruleTagLabel;
}

- (UIImageView *)moreImageView{
    if (_moreImageView == nil) {
        _moreImageView = [[UIImageView alloc] init];
        _moreImageView.image = [UIImage imageNamed:@"appraisal_home_right"];
    }
    return _moreImageView;
}

- (UIButton *)ruleButton{
    if (_ruleButton == nil) {
        _ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ruleButton setTitle:@"最高行业标准" forState:UIControlStateNormal];
        [_ruleButton setTitleColor:HEXCOLOR(0xb9855d) forState:UIControlStateNormal];
        _ruleButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:11];
        [_ruleButton setImage:[UIImage imageNamed:@"appraisal_home_high"] forState:UIControlStateNormal];
        [_ruleButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    }
    return _ruleButton;
}

- (UIButton *)masterButton{
    if (_masterButton == nil) {
        _masterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_masterButton setTitle:@"不同材质鉴定专家" forState:UIControlStateNormal];
        [_masterButton setTitleColor:HEXCOLOR(0xb9855d) forState:UIControlStateNormal];
        _masterButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:11];
        [_masterButton setImage:[UIImage imageNamed:@"appraisal_home_master"] forState:UIControlStateNormal];
        [_masterButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    }
    return _masterButton;
}

- (UIButton *)openButton{
    if (_openButton == nil) {
        _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openButton setTitle:@"鉴定服务开拓者" forState:UIControlStateNormal];
        [_openButton setTitleColor:HEXCOLOR(0xb9855d) forState:UIControlStateNormal];
        _openButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:11];
        [_openButton setImage:[UIImage imageNamed:@"appraisal_home_open"] forState:UIControlStateNormal];
        [_openButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    }
    return _openButton;
}
@end

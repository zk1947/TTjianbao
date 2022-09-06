//
//  JHZeroAuctionHeadView.m
//  TTjianbao
//
//  Created by zk on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHZeroAuctionHeadView.h"
#import "JHC2CSortMenuView.h"
#import "JHC2CClassMenuView.h"
#import "JHC2CSubClassTitleScrollView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHUIFactory.h"
#import "JHAnimatedImageView.h"

@interface JHZeroAuctionHeadView ()<JHC2CSortMenuViewDelegate,JHC2CClassMenuViewDelegate,JHC2CSubClassTitleScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) JHAnimatedImageView *bgImgv;

@property (nonatomic, strong) JHC2CSortMenuView *sortMenuView;//一级排序view

//二级排序
@property (nonatomic, strong) UIView *secandBgView;
@property (nonatomic, strong) UIButton *classBtn;//分类选择按钮
@property (nonatomic, strong) JHC2CClassMenuView *classMenuView;//分类弹窗

//价格排序
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UITextField *highTF;
@property (nonatomic, strong) UITextField *lowTF;
@property (nonatomic, strong) JHCustomLine *line;
@property (nonatomic, strong) UIButton *cleanBtn1;
@property (nonatomic, strong) UIButton *cleanBtn2;

@property (nonatomic, strong) JHC2CSubClassTitleScrollView *threeClassScrollView;//三级排序

@property (nonatomic, assign) BOOL isAddClassMenuView;//是否显示分类弹窗
@property (nonatomic, assign) BOOL isSelectMenuClass;//是否选择了弹窗分类

@property (nonatomic, strong) JHZeroAuctionRequestModel *requestModel;

@property (nonatomic, assign) BOOL onlyOnce;

@property (nonatomic, assign) NSInteger levelTowID;

@end

@implementation JHZeroAuctionHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kColorFFF;
        self.requestModel.priceSortFlag = -1;
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorFFF;
        self.requestModel.priceSortFlag = -1;
        [self setupUI];
    }
    return self;
}

- (void)setHeadModel:(JHZeroAuctionModel *)headModel{
    _headModel = headModel;
    //刷新头部
    if (!_onlyOnce) {
        NSString *imageStr = [_headModel.zeroAuctionConfBo.coverImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self.bgImgv jh_setImageWithUrl:imageStr placeholder:@"newStore_detail_shopProduct_Placeholder"];
        self.classMenuView.subCateIds = _headModel.backThirdCateIds;
        _onlyOnce = YES;
    }
}

- (void)setupUI{
    
    //头部海报
    [self addSubview:self.bgImgv];
    [self.bgImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
        
    //一级排序
    [self addSubview:self.sortMenuView];
    [self.sortMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self.bgImgv.mas_bottom);
        make.size.mas_offset(CGSizeMake(kScreenWidth-24, 40));
    }];
    
    //二级分类排序 240 44 284 28 6
    [self addSubview:self.secandBgView];
    [self.secandBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.sortMenuView.mas_bottom);
        make.height.mas_offset(44);
    }];
    
    [self.secandBgView addSubview:self.classBtn];
    [self.classBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(self.secandBgView);
        make.height.mas_offset(28);
    }];
    
    //价格筛选
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.size.mas_offset(CGSizeMake(44, 24));
        make.centerY.equalTo(self.secandBgView);
    }];
    
    [self.highTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sureBtn.mas_left).offset(-5);
        make.size.mas_offset(CGSizeMake(55, 24));
        make.centerY.equalTo(self.secandBgView);
    }];
    
    [self.cleanBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.highTF.mas_right).offset(0);
        make.top.equalTo(self.highTF.mas_top).offset(0);
        make.size.mas_offset(CGSizeMake(14, 14));
    }];
    
    [self.secandBgView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.highTF.mas_left).offset(-5);
        make.size.mas_offset(CGSizeMake(6, 1));
        make.centerY.equalTo(self.secandBgView);
    }];
   
    [self.lowTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line.mas_left).offset(-5);
        make.size.mas_offset(CGSizeMake(55, 24));
        make.centerY.equalTo(self.secandBgView);
    }];
    
    [self.cleanBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lowTF.mas_right).offset(0);
        make.top.equalTo(self.lowTF.mas_top).offset(0);
        make.size.mas_offset(CGSizeMake(14, 14));
    }];
    
}

///二级分类弹窗
- (void)addSecandClassView{
    [self.classMenuView removeFromSuperview];
//    self.classMenuView.subCateIds = self.headModel.backFirstCateIds;
    [self.vc.view addSubview:self.classMenuView];
    [self.classMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vc.view).offset(285-self.vc.tableView.contentOffset.y);
        make.left.right.bottom.equalTo(self.vc.view);
    }];
}

///三级分类视图
- (void)addThreeClassView {
    [self.threeClassScrollView removeFromSuperview];
    [self addSubview:self.threeClassScrollView];
    [self.threeClassScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secandBgView.mas_bottom).offset(0);
        make.left.right.equalTo(self);
        make.height.mas_offset(40);
    }];
}

#pragma mark - JHC2CSortMenuViewDelegate 一级排序筛选
- (void)menuViewDidSelect:(JHC2CSortMenuType)sortType {
    self.requestModel.priceSortFlag = sortType;
    if (_headChooseBlock) {
        _headChooseBlock(self.requestModel);
    }
//    self.sortTypeNum = (int)sortType;
//    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - 二级分类筛选
- (void)clickSecandClassAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self addSecandClassView];
    self.classMenuView.hidden = sender.selected ? NO : YES;
    self.vc.tableView.scrollEnabled = sender.selected ? NO : YES;
}

///分类筛选 JHC2CClassMenuViewDelegate
- (void)classViewDidSelect:(JHNewStoreTypeTableCellViewModel *)subClassModel selectAllClass:(BOOL)selectAllClass dismissView:(BOOL)dismiss {
//    self.isFirstEnter = NO;
    if (dismiss) {
        self.classBtn.selected = NO;
        self.classMenuView.hidden = YES;
        self.vc.tableView.scrollEnabled = YES;
        return;
    }
    self.threeClassScrollView.subClassArray = @[];
    CGFloat time = 0;
    NSString *selectClassName = @"分类";
    if (subClassModel.cateName.length > 0) {
        self.isSelectMenuClass = YES;
        
//        self.childrenCateAllID = subClassModel.ID;
        time = 0.2;
        selectClassName = subClassModel.cateName;
        if (selectClassName.length > 5) {
            selectClassName = [NSString stringWithFormat:@"%@…",[selectClassName substringToIndex:3]];

        }
        //只有选择二级分类时判断显示三级
        if (!selectAllClass) {
            self.levelTowID = subClassModel.ID;
            [self loadChildrenCateData:subClassModel.ID];
        }
//        self.classID = [NSString stringWithFormat:@"%ld",(long)subClassModel.ID];
        
    }else{
        self.isSelectMenuClass = NO;
        
        self.threeClassScrollView.subClassArray = @[];
        [self.threeClassScrollView removeFromSuperview];
        if (self.reloadUIBlock) {
            self.reloadUIBlock(NO);
        }
        
//        //重置
//        if (self.keyword.length > 0) {
//            self.classID = @"";
//        }else{
//            self.classID = self.defaultClassID;
//            //三级分类
//            if ([self.classClickFrom intValue] != 1) {
//                [self loadChildrenCateData:[self.classID integerValue]];
//            }
//        }
    }
    //重新加载数据
//    [self.collectionView.mj_header beginRefreshing];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.classBtn.selected = NO;
        self.classMenuView.hidden = YES;
        self.vc.tableView.scrollEnabled = YES;
        if (self.isSelectMenuClass) {
            [self.classBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            [self.classBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFD70F)] forState:UIControlStateNormal];
        }else{
            [self.classBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
            [self.classBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xF2F2F2)] forState:UIControlStateNormal];
        }
        
        [self.classBtn setTitle:selectClassName forState:UIControlStateNormal];
        [self.classBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:3];

    });
    
    
    //数据传递
    switch (subClassModel.cateLevel) {
        case 0:{//全部
            self.requestModel.frontFirstCategoryId = -1;
            self.requestModel.frontSecondCategoryId = -1;
            self.requestModel.frontThirdCategoryId = -1;
        }
            break;
        case 1:{
            self.requestModel.frontFirstCategoryId = subClassModel.ID;
            self.requestModel.frontSecondCategoryId = -1;
            self.requestModel.frontThirdCategoryId = -1;
        }
            break;
        case 2:{
            self.requestModel.frontFirstCategoryId = -1;
            self.requestModel.frontSecondCategoryId = subClassModel.ID;
            self.requestModel.frontThirdCategoryId = -1;
        }
            break;
        case 3:{
            self.requestModel.frontFirstCategoryId = -1;
            self.requestModel.frontSecondCategoryId = -1;
            self.requestModel.frontThirdCategoryId = subClassModel.ID;
        }
            break;
        default:
            break;
    }
    if (_headChooseBlock) {
        _headChooseBlock(self.requestModel);
    }
}

///请求三级分类类
- (void)loadChildrenCateData:(NSInteger )classID {
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"id"] = @(classID);
    dicData[@"fromStatus"] = @"B2C";
    [JHC2CSearchResultBusiness requestSearchChildrenCateListWithParams:dicData Completion:^(NSError * _Nullable error, NSArray<JHNewStoreTypeTableCellViewModel *> * _Nullable models) {
        BOOL isAdd = NO;
        if (!error) {
            self.threeClassScrollView.subClassArray = models;
            if (models.count > 0) {
                isAdd = YES;
                [self addThreeClassView];
            }else{
                isAdd = NO;
                [self.threeClassScrollView removeFromSuperview];
            }
        }else{
            isAdd = NO;
            self.threeClassScrollView.subClassArray = @[];
            [self.threeClassScrollView removeFromSuperview];
        }
        
        if (self.reloadUIBlock) {
            self.reloadUIBlock(isAdd);
        }
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    int lengthInt = (int)range.length;
    int locationInt = (int)range.location;
    if (locationInt-lengthInt < 9-1) {//最多8位
        if (locationInt-lengthInt > 7-1) {//7
            textField.font = [UIFont systemFontOfSize:10];
        } else {
            textField.font = [UIFont systemFontOfSize:12];
        }
        if (locationInt-lengthInt < 0) {
            self.sureBtn.alpha = 0.7;
            self.sureBtn.userInteractionEnabled = NO;
        }else{
            self.sureBtn.alpha = 1;
            self.sureBtn.userInteractionEnabled = YES;
        }
        return YES;
    }
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1001) {
        if ([self.lowTF.text floatValue] > [self.highTF.text floatValue]) {
            NSString *hNum = self.lowTF.text;
            self.lowTF.text = self.highTF.text;
            self.highTF.text = hNum;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}

///价格筛选
- (void)clickSureBtnAction:(UIButton *)btn{
    [self endEditing:YES];
    self.requestModel.startPrice = self.lowTF.text.length>0 ? [self.lowTF.text floatValue] : -1;
    self.requestModel.endPrice = self.highTF.text.length>0 ? [self.highTF.text floatValue] : -1;
    if (_headChooseBlock) {
        _headChooseBlock(self.requestModel);
    }
}

- (void)cleanBtnAction:(UIButton *)btn{
    if (btn.tag == 2021) {
        self.highTF.text = @"";
    }else{
        self.lowTF.text = @"";
    }
    
    btn.hidden = YES;
    self.requestModel.startPrice = self.lowTF.text.length>0 ? [self.lowTF.text floatValue] : -1;
    self.requestModel.endPrice = self.highTF.text.length>0 ? [self.highTF.text floatValue] : -1;
    if (_headChooseBlock) {
        _headChooseBlock(self.requestModel);
    }
}

#pragma mark - JHC2CSubClassTitleScrollViewDelegate 三级分类点击
- (void)subClassTitleDidSelect:(NSInteger)selectItem{
    if (selectItem == 0) {
//        self.classID = [NSString stringWithFormat:@"%ld",(long)self.childrenCateAllID];
        self.requestModel.frontFirstCategoryId = -1;
        self.requestModel.frontSecondCategoryId = self.levelTowID;
        self.requestModel.frontThirdCategoryId = -1;
        if (_headChooseBlock) {
            _headChooseBlock(self.requestModel);
        }
    }else{
        JHNewStoreTypeTableCellViewModel *viewModel = self.threeClassScrollView.subClassArray[selectItem-1];
//        NSString *thridId = [NSString stringWithFormat:@"%ld",(long)viewModel.ID];
        self.requestModel.frontFirstCategoryId = -1;
        self.requestModel.frontSecondCategoryId = -1;
        self.requestModel.frontThirdCategoryId = viewModel.ID;
        if (_headChooseBlock) {
            _headChooseBlock(self.requestModel);
        }
    }
//    //切换标签请求数据
//    [self.collectionView.mj_header beginRefreshing];
    
}

///view 是要设置渐变字体的控件   bgVIew是view的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
-(void)textGradientview:(UIView *)view bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    CAGradientLayer* gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = view.frame;
    gradientLayer1.colors = colors;
    gradientLayer1.startPoint =startPoint;
    gradientLayer1.endPoint = endPoint;
    [bgVIew.layer addSublayer:gradientLayer1];
    gradientLayer1.mask = view.layer;
    view.frame = gradientLayer1.bounds;
}

- (void)hiddenClassAlert{
    //分类弹窗收起
    self.classBtn.selected = NO;
    self.classMenuView.hidden = YES;
    if (self.isSelectMenuClass) {
        [self.classBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [self.classBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFD70F)] forState:UIControlStateNormal];
    }
}

#pragma mark - Lazy load Methods：

///头部背景
- (JHAnimatedImageView *)bgImgv{
    if (!_bgImgv) {
        JHAnimatedImageView *imgv = [JHAnimatedImageView new];
        imgv.clipsToBounds = YES;
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgv = imgv;
    }
    return _bgImgv;
}

/// 一级排序
- (JHC2CSortMenuView *)sortMenuView{
    if (!_sortMenuView) {
        JHC2CSortMenuMode *priceMode = [[JHC2CSortMenuMode alloc] init];
        priceMode.title = @"价格";
        priceMode.isShowImg = YES;
        JHC2CSortMenuMode *endMode = [[JHC2CSortMenuMode alloc] init];
        endMode.title = @"即将截拍";
        endMode.isShowImg = NO;
        JHC2CSortMenuMode *startMode = [[JHC2CSortMenuMode alloc] init];
        startMode.title = @"马上开拍";
        startMode.isShowImg = NO;
        NSArray *menuArray = @[priceMode,endMode,startMode];
        _sortMenuView = [[JHC2CSortMenuView alloc] initWithFrame:CGRectZero menuArray:menuArray titleFont:13.0];
        _sortMenuView.delegate = self;
        _sortMenuView.selectIndex = 0;
        _sortMenuView.isPriceFirst = YES;
    }
    return _sortMenuView;
}

/// 二级排序
- (UIView *)secandBgView{
    if (!_secandBgView) {
        _secandBgView = [UIView new];
    }
    return _secandBgView;
}

- (UIButton *)classBtn{
    if (!_classBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"分类" forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xF2F2F2)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFD70F)] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        btn.contentEdgeInsets = UIEdgeInsetsMake(6, 16, 5, 16);
        [btn jh_cornerRadius:14];
        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;//设置尾部省略
        [btn addTarget:self action:@selector(clickSecandClassAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"c2c_class_down_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"c2c_class_up_icon"] forState:UIControlStateSelected];
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:13];
        _classBtn = btn;
    }
    return _classBtn;
}

- (JHC2CClassMenuView *)classMenuView{
    if (!_classMenuView) {
        _classMenuView = [[JHC2CClassMenuView alloc] init];
        _classMenuView.fromStatus = 1;
        _classMenuView.delegate = self;
        _classMenuView.hidden = YES;
    }
    return _classMenuView;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        //价格筛选
        UIButton *sureBtn = [UIButton jh_buttonWithTarget:self action:@selector(clickSureBtnAction:) addToSuperView:self.secandBgView];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        sureBtn.backgroundColor = HEXCOLOR(0xFED539);
        sureBtn.layer.masksToBounds = YES;
        sureBtn.layer.cornerRadius = 3;
        sureBtn.alpha = 0.7;
        sureBtn.userInteractionEnabled = NO;
        self.sureBtn = sureBtn;
    }
    return _sureBtn;
}

- (UITextField *)highTF{
    if (!_highTF) {
        UITextField *highTF = [UITextField jh_textFieldWithFont:12 textAlignment:NSTextAlignmentCenter textColor:HEXCOLOR(0x333333) placeholderText:@"最高价" placeholderColor:HEXCOLOR(0xBEBEBE) addToSupView:self.secandBgView];
        highTF.tag = 1001;
        highTF.delegate = self;
        highTF.layer.cornerRadius = 3.0;
        highTF.layer.borderColor = HEXCOLOR(0xCCCCCC).CGColor;
        highTF.layer.borderWidth = 0.5f;
        highTF.keyboardType = UIKeyboardTypeNumberPad;
        [highTF addTarget:self action:@selector(txtChangeEvent:) forControlEvents:UIControlEventEditingChanged];
        self.highTF = highTF;
    }
    return _highTF;
}

- (void)txtChangeEvent:(UITextField *)txtF{
    self.cleanBtn1.hidden = txtF.text.length > 0 ? NO:YES;
}

- (JHCustomLine *)line{
    if (!_line) {
        JHCustomLine *line = [JHUIFactory createLine];
        line.color = HEXCOLOR(0x333333);
        _line = line;
    }
    return _line;
}

- (UITextField *)lowTF{
    if (!_lowTF) {
        UITextField *lowTF = [UITextField jh_textFieldWithFont:12 textAlignment:NSTextAlignmentCenter textColor:HEXCOLOR(0x333333) placeholderText:@"最低价" placeholderColor:HEXCOLOR(0xBEBEBE) addToSupView:self.secandBgView];
        lowTF.tag = 1002;
        lowTF.delegate = self;
        lowTF.layer.cornerRadius = 3.0;
        lowTF.layer.borderColor = HEXCOLOR(0xCCCCCC).CGColor;
        lowTF.layer.borderWidth = 0.5f;
        lowTF.keyboardType = UIKeyboardTypeNumberPad;
        [lowTF addTarget:self action:@selector(txtChangeEvent2:) forControlEvents:UIControlEventEditingChanged];
        self.lowTF = lowTF;
    }
    return _lowTF;
}

- (void)txtChangeEvent2:(UITextField *)txtF{
    self.cleanBtn2.hidden = txtF.text.length > 0 ? NO:YES;
}

- (UIButton *)cleanBtn1{
    if (!_cleanBtn1) {
        //价格筛选
        UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cleanBtn setBackgroundImage:JHImageNamed(@"touta_clean_icon") forState:UIControlStateNormal];
        cleanBtn.hidden = YES;
        [cleanBtn addTarget:self action:@selector(cleanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cleanBtn.tag = 2021;
        [self.secandBgView addSubview:cleanBtn];
        _cleanBtn1 = cleanBtn;
    }
    return _cleanBtn1;
}

- (UIButton *)cleanBtn2{
    if (!_cleanBtn2) {
        //价格筛选
        UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cleanBtn setBackgroundImage:JHImageNamed(@"touta_clean_icon") forState:UIControlStateNormal];
        cleanBtn.hidden = YES;
        [cleanBtn addTarget:self action:@selector(cleanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cleanBtn.tag = 2022;
        [self.secandBgView addSubview:cleanBtn];
        _cleanBtn2 = cleanBtn;
    }
    return _cleanBtn2;
}

///三级分类
- (JHC2CSubClassTitleScrollView *)threeClassScrollView{
    if (!_threeClassScrollView) {
        _threeClassScrollView = [[JHC2CSubClassTitleScrollView alloc] init];
        _threeClassScrollView.showsHorizontalScrollIndicator = NO;
        _threeClassScrollView.showsHorizontalScrollIndicator = NO;
        _threeClassScrollView.classDelegate = self;
    }
    return _threeClassScrollView;
}

- (JHZeroAuctionRequestModel *)requestModel{
    if (!_requestModel) {
        _requestModel = [JHZeroAuctionRequestModel new];
        _requestModel.frontFirstCategoryId = -1;
        _requestModel.frontSecondCategoryId = -1;
        _requestModel.frontThirdCategoryId = -1;
        _requestModel.startPrice = -1;
        _requestModel.endPrice = -1;
    }
    return _requestModel;
}

@end

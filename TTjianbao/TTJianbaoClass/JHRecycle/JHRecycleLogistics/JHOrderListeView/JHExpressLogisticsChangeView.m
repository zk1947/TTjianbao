//
//  JHExpressLogisticsChangeView.m
//  TTjianbao
//
//  Created by user on 2021/6/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHExpressLogisticsChangeView.h"
#import "JHOrderListZhiFaListView.h"

@interface JHExpressLogisticsChangeView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView                   *logisticsChangeView;
@property (nonatomic, strong) UILabel                  *titleLabel;
@property (nonatomic, strong) UILabel                  *logisticsNameLabel1;
@property (nonatomic, strong) UIButton                 *chooseLogisticsBtn;
@property (nonatomic, strong) UIImageView              *chooseLogisticsBtnImageView;
@property (nonatomic, strong) JHOrderListZhiFaListView *logisticsSelectView;
@property (nonatomic, strong) UILabel                  *logisticsNameLabel2;
@property (nonatomic, strong) UITextField              *logisticsNumTextField;
@property (nonatomic, strong) UIButton                 *saveBtn;
@property (nonatomic, strong) UIButton                 *cancleBtn;
@end

@implementation JHExpressLogisticsChangeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLORA(0x000000,0.56f);
    
    _logisticsChangeView = [[UIView alloc] init];
    _logisticsChangeView.layer.cornerRadius  = 8.f;
    _logisticsChangeView.layer.masksToBounds = YES;
    _logisticsChangeView.backgroundColor = HEXCOLOR(0xFFFFFF);
    [self addSubview:_logisticsChangeView];
    [_logisticsChangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(260.f);
        make.height.mas_equalTo(312.f);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = HEXCOLOR(0x333333);
    _titleLabel.font = [UIFont fontWithName:kFontNormal size:15.f];
    _titleLabel.text = @"修改快递信息";
    [_logisticsChangeView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.logisticsChangeView.mas_centerX);
        make.top.equalTo(self.logisticsChangeView.mas_top).offset(12.f);
        make.height.mas_equalTo(22.5f);
    }];
    
    
    _logisticsNameLabel1                 = [[UILabel alloc] init];
    _logisticsNameLabel1.textAlignment   = NSTextAlignmentLeft;
    _logisticsNameLabel1.textColor       = HEXCOLOR(0x999999);
    _logisticsNameLabel1.font            = [UIFont fontWithName:kFontNormal size:12.f];
    _logisticsNameLabel1.text            = @"快递公司";
    [_logisticsChangeView addSubview:_logisticsNameLabel1];
    [_logisticsNameLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logisticsChangeView.mas_left).offset(18.f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(28.f);
        make.height.mas_equalTo(23.5f);
    }];

    UIView *chooseBackLineView             = [[UIView alloc] init];
    chooseBackLineView.layer.borderWidth   = 1.f;
    chooseBackLineView.layer.borderColor   = HEXCOLOR(0xDEDEDE).CGColor;
    chooseBackLineView.layer.cornerRadius  = 6.f;
    chooseBackLineView.layer.masksToBounds = YES;
    [_logisticsChangeView addSubview:chooseBackLineView];
    [chooseBackLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logisticsNameLabel1.mas_left);
        make.top.equalTo(self.logisticsNameLabel1.mas_bottom);
        make.right.equalTo(self.logisticsChangeView.mas_right).offset(-25.f);
        make.height.mas_equalTo(38.f);
    }];

    _chooseLogisticsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chooseLogisticsBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _chooseLogisticsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _chooseLogisticsBtn.backgroundColor     = HEXCOLOR(0xFFFFFF);
    _chooseLogisticsBtn.titleLabel.font     = [UIFont fontWithName:kFontNormal size:14.f];
    [_chooseLogisticsBtn addTarget:self action:@selector(chooseLogisticsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [chooseBackLineView addSubview:_chooseLogisticsBtn];
    [_chooseLogisticsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chooseBackLineView.mas_left).offset(10.f);
        make.centerY.equalTo(chooseBackLineView.mas_centerY);
        make.right.equalTo(chooseBackLineView.mas_right);
    }];
    
    _chooseLogisticsBtnImageView = [[UIImageView alloc] init];
    _chooseLogisticsBtnImageView.image = [UIImage imageNamed:@"jhOrder_listChannel_down"];
    [_chooseLogisticsBtn addSubview:_chooseLogisticsBtnImageView];
    [_chooseLogisticsBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(chooseBackLineView.mas_right).offset(-8.f);
        make.centerY.equalTo(chooseBackLineView.mas_centerY);
        make.height.mas_equalTo(7.f);
        make.height.mas_equalTo(3.5f);
    }];

    _logisticsNameLabel2                 = [[UILabel alloc] init];
    _logisticsNameLabel2.textAlignment   = NSTextAlignmentLeft;
    _logisticsNameLabel2.textColor       = HEXCOLOR(0x999999);
    _logisticsNameLabel2.font            = [UIFont fontWithName:kFontNormal size:12.f];
    _logisticsNameLabel2.text            = @"快递单号";
    [_logisticsChangeView addSubview:_logisticsNameLabel2];
    [_logisticsNameLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logisticsChangeView.mas_left).offset(18.f);
        make.top.equalTo(self.chooseLogisticsBtn.mas_bottom).offset(20.f);
        make.height.mas_equalTo(22.5f);
    }];
    
    
    
    UIView *textFieldBackLineView             = [[UIView alloc] init];
    textFieldBackLineView.layer.borderWidth   = 1.f;
    textFieldBackLineView.layer.borderColor   = HEXCOLOR(0xDEDEDE).CGColor;
    textFieldBackLineView.layer.cornerRadius  = 6.f;
    textFieldBackLineView.layer.masksToBounds = YES;
    [_logisticsChangeView addSubview:textFieldBackLineView];
    [textFieldBackLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logisticsNameLabel2.mas_left);
        make.top.equalTo(self.logisticsNameLabel2.mas_bottom);
        make.right.equalTo(self.logisticsChangeView.mas_right).offset(-25.f);
        make.height.mas_equalTo(38.f);
    }];
    
    _logisticsNumTextField                     = [[UITextField alloc] init];
    _logisticsNumTextField.delegate            = self;
    _logisticsNumTextField.textColor           = HEXCOLOR(0x333333);
    _logisticsNumTextField.font                = [UIFont fontWithName:kFontNormal size:14.f];
    [_logisticsChangeView addSubview:_logisticsNumTextField];
    [_logisticsNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textFieldBackLineView.mas_left).offset(10.f);
        make.centerY.equalTo(textFieldBackLineView.mas_centerY);
        make.right.equalTo(textFieldBackLineView.mas_right).offset(-10.f);
        make.height.mas_equalTo(36.f);
    }];
    
    _saveBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _saveBtn.backgroundColor     = HEXCOLOR(0xFEE100);
    _saveBtn.titleLabel.font     = [UIFont fontWithName:kFontMedium size:14.f];
    _saveBtn.layer.cornerRadius  = 20.f;
    _saveBtn.layer.masksToBounds = YES;
    [_saveBtn addTarget:self action:@selector(saveBtnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_logisticsChangeView addSubview:_saveBtn];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logisticsChangeView.mas_centerX).offset(5.f);
        make.top.equalTo(self.logisticsNumTextField.mas_bottom).offset(35.f);
        make.width.mas_equalTo(100.f);
        make.height.mas_equalTo(38.f);
    }];

    
    _cancleBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _cancleBtn.titleLabel.font     = [UIFont fontWithName:kFontMedium size:14.f];
    _cancleBtn.layer.cornerRadius  = 20.f;
    _cancleBtn.layer.masksToBounds = YES;
    _cancleBtn.layer.borderWidth   = 0.5f;
    _cancleBtn.layer.borderColor   = HEXCOLOR(0xBDBFC2).CGColor;
    [_cancleBtn addTarget:self action:@selector(cancleBtnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_logisticsChangeView addSubview:_cancleBtn];
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.logisticsChangeView.mas_centerX).offset(-5.f);
        make.centerY.equalTo(self.saveBtn.mas_centerY);
        make.width.mas_equalTo(100.f);
        make.height.mas_equalTo(38.f);
    }];
    
    
    _logisticsSelectView                     = [[JHOrderListZhiFaListView alloc] init];
    _logisticsSelectView.noBackImage         = YES;
    _logisticsSelectView.cusFont             = [UIFont fontWithName:kFontNormal size:14.f];
    _logisticsSelectView.tabColor            = HEXCOLORA(0xFFFFFF,1);
    _logisticsSelectView.txtColor            = HEXCOLOR(0x333333);
    _logisticsSelectView.backgroundColor     = HEXCOLORA(0xFFFFFF,1);
    _logisticsSelectView.layer.borderWidth   = 1.f;
    _logisticsSelectView.layer.borderColor   = HEXCOLOR(0xDEDEDE).CGColor;
    _logisticsSelectView.layer.cornerRadius  = 6.f;
    _logisticsSelectView.layer.masksToBounds = YES;
    _logisticsSelectView.hidden              = YES;
    [_logisticsChangeView addSubview:_logisticsSelectView];
    [_logisticsSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(chooseBackLineView);
        make.top.equalTo(chooseBackLineView.mas_bottom);
        make.bottom.equalTo(self.logisticsChangeView.mas_bottom).offset(-16.f);
        make.height.mas_equalTo(38.f);
    }];
    @weakify(self);
    _logisticsSelectView.didSelectedCallback = ^(NSInteger index, NSString * _Nonnull content) {
        @strongify(self);
        [self.chooseLogisticsBtn setTitle:content forState:UIControlStateNormal];
        self.chooseLogisticsBtnImageView.image = [UIImage imageNamed:@"jhOrder_listChannel_down"];
        self.logisticsSelectView.hidden = YES;
    };
}


- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    if (dataArray.count >0) {
        [_chooseLogisticsBtn setTitle:dataArray[0] forState:UIControlStateNormal];
    }
}

- (void)chooseLogisticsBtnAction:(UIButton *)btn {
    self.logisticsSelectView.arrMDataSource = self.dataArray;
    btn.selected = !btn.selected;
    self.logisticsSelectView.hidden = !btn.selected;
    if (!btn.selected) {
        _chooseLogisticsBtnImageView.image = [UIImage imageNamed:@"jhOrder_listChannel_down"];
    } else {
        _chooseLogisticsBtnImageView.image = [UIImage imageNamed:@"jhOrder_listChannel_up"];
    }
}

- (void)saveBtnBtnAction:(UIButton *)btn {
    if (self.saveBlock) {
        self.saveBlock(NONNULL_STR(self.chooseLogisticsBtn.titleLabel.text), NONNULL_STR(self.logisticsNumTextField.text));
    }
}

- (void)cancleBtnBtnAction:(UIButton *)btn {
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}


@end

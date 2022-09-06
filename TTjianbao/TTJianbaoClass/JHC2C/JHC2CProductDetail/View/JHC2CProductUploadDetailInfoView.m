//
//  JHC2CProductUploadDetailInfoView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductUploadDetailInfoView.h"
#import "JHC2CPickView.h"
#import "TZLocationManager.h"
#import <CoreLocation/CoreLocation.h>



@interface JHC2CProductUploadDetailInfoView()

@property(nonatomic, strong) UIView * titleBackView;
@property(nonatomic, strong) UILabel * titleLbl;

@property(nonatomic, strong) NSMutableArray<UIButton * > * btnArr;
@property(nonatomic, strong) NSMutableArray<UILabel * > * btnLblArr;
//@property(nonatomic, strong) UIButton * firstBtn;
//@property(nonatomic, strong) UIButton * secondBtn;
//
//@property(nonatomic, strong) UILabel * firstBtnLbl;
//@property(nonatomic, strong) UILabel * secondBtnLbl;


@property(nonatomic, strong) UIButton * priceBtn;
@property(nonatomic, strong) UILabel * priceBtnLbl;


@property(nonatomic, strong) UIButton * locationBtn;
@property(nonatomic, strong) UILabel * locationLbl;


@property(nonatomic, strong) NSArray<BackAttrRelationResponse*> * dataArr;


@end

@implementation JHC2CProductUploadDetailInfoView

- (instancetype)initWithFrame:(CGRect)frame withModelArr:(NSArray<BackAttrRelationResponse*>*)arr{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArr = arr;
        self.attDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [arr enumerateObjectsUsingBlock:^(BackAttrRelationResponse * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.attDic setValue:@"" forKey:obj.attrId];
        }];
        [self setItems];
        [self layoutItems];
//        [self updateLocation];
    }
    return self;
}

- (void)setItems{
    self.btnArr = [NSMutableArray arrayWithCapacity:0];
    self.btnLblArr = [NSMutableArray arrayWithCapacity:0];
    
    self.backgroundColor = HEXCOLOR(0xF5F5F5);
    [self addSubview:self.titleBackView];
    [self.titleBackView addSubview:self.titleLbl];
    
    for (NSInteger i = 0; i< self.dataArr.count; i++) {
        BackAttrRelationResponse *res = self.dataArr[i];
        [self getButtonWithName:res.attrName andValueText:@"请选择" andIndex:i];
    }
    
    [self addSubview:self.priceBtn];
    
//    [self addSubview:self.locationBtn];
    [self addSubview:self.jianDingBtn];

}

- (void)layoutItems{
    if (self.dataArr.count == 0) {
        self.titleLbl.attributedText = nil;
    }

    [self.titleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.mas_equalTo(self.dataArr.count == 0 ? 1:40);
    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).offset(12);
        make.centerY.equalTo(@0);
    }];
    UIButton *lastBtn = nil;
    for (int i = 0; i< self.dataArr.count; i++) {
        UIButton *btn = self.btnArr[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            if (lastBtn) {
                make.top.equalTo(lastBtn.mas_bottom);
            }else{
                make.top.equalTo(self.titleBackView.mas_bottom);
            }
            make.height.mas_equalTo(34);
        }];
        lastBtn = btn;
    }
    [self.priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        if (lastBtn) {
            make.top.equalTo(lastBtn.mas_bottom).offset(10);
        }else{
            make.top.equalTo(self.titleBackView.mas_bottom);
        }
        make.height.mas_equalTo(90);
    }];
//    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(@0).offset(-12);
//        make.top.equalTo(self.priceBtn.mas_bottom).offset(10);
//        make.height.mas_equalTo(25);
//    }];
    [self.jianDingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0).inset(12);
        make.top.equalTo(self.priceBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(154);
    }];

}

- (void)jianDingBtnActionWithSender:(UIButton*)sender{
    sender.selected = !sender.isSelected;
}

- (void)actionBtnWithSender:(UIButton*)sender{
    NSInteger index = sender.tag;
    NSString* name = self.btnLblArr[index].text;
    BackAttrRelationResponse *res = self.dataArr[index];
    NSArray<NSString*> *valArr = [res.attrValue componentsSeparatedByString:@","];
    
    JHC2CPickView * pickView = [self getPickViewWithStringArr:valArr andTitle:res.attrName andIndex:index];
    if ([valArr indexOfObject:name] != NSNotFound) {
        NSInteger rowIndex = [valArr indexOfObject:name];
        [pickView seletedRow:rowIndex];
    }
    [pickView show];
}

- (void)priceBtnAction:(UIButton*)sender{
    if (self.tapPriceBlock) {
        self.tapPriceBlock(self.price);
    }
}

- (void)pickViewSeleted:(NSInteger)seletedIndex andPickIndex:(NSInteger)pickIndex{
    BackAttrRelationResponse *res = self.dataArr[pickIndex];
    NSArray<NSString*> *valArr = [res.attrValue componentsSeparatedByString:@","];
    self.btnLblArr[pickIndex].text = valArr[seletedIndex];
    [self.attDic setValue:valArr[seletedIndex] forKey:res.attrId];
}

- (void)setAttDic:(NSMutableDictionary *)attDic{
    _attDic = attDic;
    NSArray *keysArr = attDic.allKeys;
    for (int index = 0; index < keysArr.count; index ++) {
        NSString *key = keysArr[index];
        BackAttrRelationResponse *res = self.dataArr[index];
        if ([key isEqualToString:res.attrId]) {
            self.btnLblArr[index].text = attDic[key];
        }
    }
}

- (void)setNetAttDic:(NSDictionary *)netAttDic{
    _netAttDic = netAttDic;
    NSArray *keysArr = _netAttDic.allKeys;
    for (int index = 0; index < keysArr.count; index ++) {
        NSString *key = keysArr[index];
        BackAttrRelationResponse *res = self.dataArr[index];
        int tagIndex = [_netAttDic[key] intValue];
        if (tagIndex == [res.attrId intValue]) {
            self.btnLblArr[index].text = _netAttDic[@"attrValue"];
        }
    }
}

- (void)updateLocation{
    [[TZLocationManager manager] startLocationWithGeocoderBlock:^(NSArray *geocoderArray) {
        CLPlacemark *mark =  geocoderArray.firstObject;
        NSString *locationStr = [NSString stringWithFormat:@"发货地：%@ %@", mark.addressDictionary[@"City"],mark.addressDictionary[@"SubLocality"]];
        self.locationLbl.text = locationStr;
    }];

}

#pragma mark -- <set and get>
- (UIView *)titleBackView{
    if (!_titleBackView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        _titleBackView = view;
    }
    return _titleBackView;
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        NSString *placeStr = @"详细规格 选填";
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:placeStr
                                                                                   attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x222222),
                                                                                                NSFontAttributeName:JHMediumFont(15)
                                                                                   }];
        NSRange range = [placeStr rangeOfString:@"选填"];
        [attstr setAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x999999),NSFontAttributeName:JHFont(11)} range:range];
        
        label.attributedText = attstr;
        _titleLbl = label;
    }
    return _titleLbl;
}


- (void)getButtonWithName:(NSString*)name andValueText:(NSString*)value andIndex:(NSInteger)index{
    
    UILabel *label = [UILabel new];
    label.font = JHFont(14);
    label.text = value;
    label.textColor = HEXCOLOR(0x666666);

    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = index;
    btn.backgroundColor = UIColor.whiteColor;
    UILabel *leftLbl = [UILabel new];
    leftLbl.font = JHFont(14);
    leftLbl.textColor = HEXCOLOR(0x333333);
    leftLbl.text = name;
    [btn addSubview:leftLbl];
    [leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0).offset(12);
        make.right.equalTo(@0).offset(-65);
    }];
    
    UIImageView* arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"c2c_up_arrow"]];
    [btn addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@0).offset(-15);
    }];
    
    [btn addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(arrow.mas_left).offset(-5);
    }];
    [self.btnArr addObject:btn];
    [self.btnLblArr addObject:label];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(actionBtnWithSender:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)priceBtn{
    if (!_priceBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = UIColor.whiteColor;
        UILabel *leftLbl = [UILabel new];
        NSString *placeStr = @"* 价格";
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:placeStr
                                                                                   attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x222222),
                                                                                                NSFontAttributeName:JHMediumFont(15),
                                                                                   }];
        NSRange range = NSMakeRange(0, 1);
        [attstr setAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xF23730),
                                NSFontAttributeName:JHFont(14),
                                NSBaselineOffsetAttributeName:@-2
        } range:range];

        leftLbl.attributedText = attstr;
        [btn addSubview:leftLbl];
        [leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@0).offset(12);
        }];
        
        UILabel *charLbl = [UILabel new];
        charLbl.font = [UIFont fontWithName:@"Helvetica" size:19];
        charLbl.textColor = HEXCOLOR(0x222222);
        charLbl.text = @"￥";
        [btn addSubview:charLbl];
        [charLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0).offset(12);
            make.top.equalTo(leftLbl.mas_bottom).offset(10);
        }];

        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = HEXCOLOR(0xE6E6E6);
        [btn addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0).inset(12);
            make.bottom.equalTo(@0).offset(-16);
            make.height.mas_equalTo(0.5f);
        }];
                
        [btn addSubview:self.priceBtnLbl];
        [self.priceBtnLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(charLbl);
            make.left.equalTo(charLbl.mas_right).offset(4);
        }];
        [btn addTarget:self action:@selector(priceBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        _priceBtn = btn;
    }
    return _priceBtn;
}

- (UILabel *)priceBtnLbl{
    if (!_priceBtnLbl) {
        UILabel *label = [UILabel new];
        NSAttributedString *att = [[NSAttributedString alloc] initWithString:@"请输入出价" attributes:
                                   @{NSFontAttributeName: JHFont(16), NSForegroundColorAttributeName : HEXCOLOR(0xB0B0B0)}];
        label.attributedText = att;
        _priceBtnLbl = label;
    }
    return _priceBtnLbl;
}

- (void)setPrice:(NSString *)price{
    _price = price;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:price attributes:
                               @{NSFontAttributeName: [UI getDINBoldFont:20], NSForegroundColorAttributeName : HEXCOLOR(0xF23730)}];
    if (self.priceType == 1) {
        NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc] initWithString:@" 起拍" attributes:
                                   @{NSFontAttributeName: JHBoldFont(14), NSForegroundColorAttributeName : HEXCOLOR(0xF23730)}];
        [att appendAttributedString:att1];
    }
    NSString *postStr = @"";
    if (self.postPrice.length) {
        postStr =  [NSString stringWithFormat:@" (运费￥%@)", self.postPrice];
    }else{
        postStr =  @" (包邮)";
    }
    NSMutableAttributedString *att2 = [[NSMutableAttributedString alloc] initWithString:postStr attributes:
                               @{NSFontAttributeName: JHFont(14), NSForegroundColorAttributeName : HEXCOLOR(0x333333)}];
    [att appendAttributedString:att2];
    self.priceBtnLbl.attributedText = att;
    
}

- (UIButton *)locationBtn{
    if (!_locationBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = UIColor.whiteColor;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = HEXCOLOR(0xcccccc).CGColor;
        btn.layer.cornerRadius = 12.5;
        UIImageView* leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dis_appraiserVerify"]];
        [btn addSubview:leftImageView];
        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(@0).offset(8);
        }];
        UILabel *leftLbl = [UILabel new];
        leftLbl.font = JHFont(12);
        leftLbl.textColor = HEXCOLOR(0x666666);
        leftLbl.text = @"发货地：未知";
        [btn addSubview:leftLbl];
        self.locationLbl = leftLbl;
        [leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(leftImageView.mas_right).offset(5);
            make.right.equalTo(@0).offset(-8);
        }];
        
        _locationBtn = btn;
    }
    return _locationBtn;
}

- (JHC2CProductUploadJianDingButton *)jianDingBtn{
    if (!_jianDingBtn) {
        JHC2CProductUploadJianDingButton *btn = [JHC2CProductUploadJianDingButton new];
        [btn addTarget:self action:@selector(jianDingBtnActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _jianDingBtn = btn;
    }
    return _jianDingBtn;
}


- (JHC2CPickView *)getPickViewWithStringArr:(NSArray<NSString*>*)arr andTitle:(NSString*)title andIndex:(NSInteger)index{
    JHC2CPickView* pick = [[JHC2CPickView alloc] init];
    pick.heightPicker = 240 + UI.bottomSafeAreaHeight;
    pick.arrayData_0 = arr;
    pick.title = title;
    @weakify(self);
    [pick setSureClickBlock:^(NSInteger selectedIndex) {
        @strongify(self);
        [self pickViewSeleted:selectedIndex andPickIndex:index];
    }];
    return pick;
}

@end

//
//  JHOrderConfirmHeaderTipView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
#import "JHOrderConfirmHeaderTipView.h"
#import "JHAppBusinessModelManager.h"
@interface JHOrderConfirmHeaderTipView ()
{
    UILabel *descLabel;
}
//@property(nonatomic,strong) UILabel * titlelLabel;

@property(nonatomic,strong) UILabel * titlelLabel;
@property(nonatomic,strong) UILabel * descLabel;
@property(nonatomic,strong) UIImageView *logo;
@end

@implementation JHOrderConfirmHeaderTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[CommHelp  toUIColorByStr:@"#FFFAF2"];
        _leftSpace = 7;//默认为7
    }
    return self;
}
-(void)initSubviews{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView  *back=[UIView new];
    [self addSubview:back];
    [ back  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.offset(49);
       // make.centerX.equalTo(self);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
    }];
    
    UIImageView *logo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shop_order_header_icon"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [back addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back).offset(_leftSpace);
        make.centerY.equalTo(back);
    }];
    self.logo = logo;
    
    UILabel * titlelLabel= [[UILabel alloc] init];
    titlelLabel.numberOfLines =1;
    titlelLabel.textAlignment = NSTextAlignmentLeft;
    titlelLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titlelLabel.textColor=HEXCOLOR(0xB38A50);
    titlelLabel.text = @"严选好物 值得收藏";
    titlelLabel.font=[UIFont fontWithName:kFontBoldPingFang size:13];
    [back addSubview:titlelLabel];
    [ titlelLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(back);
        make.left.equalTo(logo.mas_right).offset(5);
    }];
    self.titlelLabel = titlelLabel;
    
    UILabel *descLabel= [[UILabel alloc] init];
    descLabel.numberOfLines =1;
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descLabel.textColor=HEXCOLOR(0xB38A50);
    descLabel.text = @"专业鉴定·先鉴后发·假一赔三·售后无忧";
    descLabel.font=[UIFont fontWithName:kFontNormal size:11];
    [back addSubview:descLabel];
    [ descLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(back).offset(-_leftSpace);
        make.centerY.equalTo(back);
        //make.left.equalTo(titlelLabel.mas_right).offset(20);
    }];
    self.descLabel = descLabel;
    
}
- (void)setSubmitOrdersMode:(JHOrderDetailMode *)submitOrdersMode {
    _submitOrdersMode = submitOrdersMode;
    JHBusinessModel bModel = submitOrdersMode.directDelivery ? JHBusinessModel_SH : JHBusinessModel_De;
    @weakify(self);
    [JHAppBusinessModelManager getTitle:@"submitOrderPage" bModel:bModel block:^(NSString * _Nullable title) {
        if (!isEmpty(title)) {
            @strongify(self);
            self.descLabel.text = title;
        }
    }];
    
}

-(void)displayMarket {
    self.titlelLabel.hidden = YES;
    self.logo.hidden = YES;
    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(1, 10, 1, 10));
    }];
    self.descLabel.numberOfLines = 0;
    self.descLabel.text = @"温馨提示：1⃣️建议提前确认库存、瑕疵等细节，价格较高商品建议使用图文鉴定服务，以免引起不必要的纠纷；2⃣️受宝友集市的个人交易属性影响，所有商品均不支持七天无理由退货。";
}


//-(void)setDesc:(NSString *)desc{
//
//    _desc = desc;
//    descLabel.text = _desc;
//
//}

@end


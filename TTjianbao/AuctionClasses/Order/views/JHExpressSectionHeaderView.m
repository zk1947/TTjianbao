//
//  JHExpressSectionHeaderView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/2/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHExpressSectionHeaderView.h"
#import "TTjianbaoHeader.h"
#import "JHOrderConfirmHeaderTipView.h"
#import "JHUIFactory.h"

@interface JHExpressSectionHeaderView ()
{
    JHCustomLine *line;
}
@property (nonatomic, strong)UILabel *expressStatus1;
@property (nonatomic, strong)UIImageView *expressIndicateImage;
@property (nonatomic, strong)UILabel *expressStatus2;
@property (nonatomic, strong)UILabel *expressDesc;
@property (nonatomic, strong)UILabel *expressCompany;
@property (nonatomic, strong)UILabel *desc;
@property (nonatomic, strong)JHOrderConfirmHeaderTipView *tipView;
@property (nonatomic, strong)UIButton *pasteBtn;
@end

@implementation JHExpressSectionHeaderView
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//
//        [self setUpSubViews];
//    }
//    return self;
//}
-(void)addSelfSubViews
{
    self.contentView.backgroundColor = [UIColor clearColor];
   // self.contentView.backgroundColor = [UIColor redColor];
    [self setUpSubViews];
}
-(void)setUpSubViews{
    
    UIView *content = [[UIView alloc]init];
    content.backgroundColor = kColorFFF;
    [content yd_setCornerRadius:8 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
    [self.contentView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    _expressStatus1=[[UILabel alloc]init];
    _expressStatus1.text=@"";
    _expressStatus1.font=[UIFont fontWithName:kFontMedium size:16];
    _expressStatus1.textColor=kColor333;
    _expressStatus1.numberOfLines = 1;
    _expressStatus1.lineBreakMode = NSLineBreakByWordWrapping;
    _expressStatus1.textAlignment = NSTextAlignmentLeft;
    [content addSubview:_expressStatus1];
    [_expressStatus1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content).offset(10);
        make.left.equalTo(content).offset(10);
    }];
    
    _expressIndicateImage=[[UIImageView alloc]init];
    _expressIndicateImage.image=[UIImage imageNamed:@"order_express_jiantou"];
    _expressIndicateImage.contentMode=UIViewContentModeScaleAspectFit;
    [content addSubview:_expressIndicateImage];
    
    [_expressIndicateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_expressStatus1);
        make.left.equalTo(_expressStatus1.mas_right).offset(10);
    }];
    
    _expressStatus2=[[UILabel alloc]init];
    _expressStatus2.text=@"";
    _expressStatus2.font=[UIFont fontWithName:kFontMedium size:16];
    _expressStatus2.textColor=kColor333;
    _expressStatus2.numberOfLines = 1;
    _expressStatus2.lineBreakMode = NSLineBreakByWordWrapping;
    _expressStatus2.textAlignment = NSTextAlignmentLeft;
    [content addSubview:_expressStatus2];
    [_expressStatus2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_expressIndicateImage);
        make.left.equalTo(_expressIndicateImage.mas_right).offset(10);
    }];
    
    _expressDesc=[[UILabel alloc]init];
    _expressDesc.text=@"通常时效为1-3天";
    _expressDesc.font=[UIFont fontWithName:kFontNormal size:12];
    _expressDesc.textColor=HEXCOLOR(0x333333);
    _expressDesc.numberOfLines = 1;
    _expressDesc.lineBreakMode = NSLineBreakByWordWrapping;
    _expressDesc.textAlignment = NSTextAlignmentLeft;
    [content addSubview:_expressDesc];
    [_expressDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content).offset(10);
        make.right.equalTo(content).offset(-10);
    }];
    
     line = [JHUIFactory createLine];
    [content addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(content).offset(10);
        make.right.equalTo(content).offset(-10);
        make.height.offset(1);
        make.top.equalTo(_expressStatus1.mas_bottom).offset(8);
    }];
    
    _tipView=[[JHOrderConfirmHeaderTipView alloc]init];
    _tipView.layer.cornerRadius = 5;
    [_tipView initSubviews];
    
    [content addSubview:_tipView];
    [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_expressStatus1.mas_bottom).offset(10);
        make.left.equalTo(content).offset(8);
        make.right.equalTo(content).offset(-8);
    }];
    _tipView.hidden = YES;
    
    _expressCompany=[[UILabel alloc]init];
    _expressCompany.text=@"";
    _expressCompany.font=[UIFont fontWithName:kFontNormal size:12];
    _expressCompany.textColor=kColor666;
    _expressCompany.numberOfLines = 1;
    _expressCompany.lineBreakMode = NSLineBreakByWordWrapping;
    _expressCompany.textAlignment = NSTextAlignmentLeft;
    [content addSubview:_expressCompany];
    [_expressCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(8);
        make.left.equalTo(content).offset(10);
    }];
    
    self.pasteBtn = [[UIButton alloc] init];
    self.pasteBtn.layer.cornerRadius = 20/2;
    self.pasteBtn.layer.borderColor = [CommHelp toUIColorByStr:@"#BDBFC2"].CGColor;
    self.pasteBtn.layer.borderWidth = 0.5;
    [self.pasteBtn setTitle:@"复制" forState:UIControlStateNormal];
    [self.pasteBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
    [self.pasteBtn addTarget:self action:@selector(clickCopyBtn) forControlEvents:UIControlEventTouchUpInside];
    self.pasteBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:10.0f];
    [content addSubview: self.pasteBtn];
    
    [self.pasteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(content).offset(-10);
        make.right.equalTo(content).offset(-10);
        make.width.offset(38);
        make.height.offset(20);
    }];
}
-(void)setCellType:(JHExpressSectionType)cellType{
    
    _cellType = cellType;
    _expressStatus1.text=@"";
    _expressStatus2.text=@"";
    if (_cellType ==JHExpressSectionSellerSend) {
        _tipView.hidden = YES;
         self.pasteBtn.hidden = YES;
        _expressCompany.hidden = YES;
         line.hidden = YES;
        _expressIndicateImage.hidden = NO;
        _expressStatus1.text=@"卖家发货";
        _expressStatus2.text=@"平台收货";
    }
    else if (_cellType ==JHExpressSectionPlatAppraise) {
        _tipView.hidden = NO;
         self.pasteBtn.hidden = YES;
        _expressCompany.hidden = YES;
         line.hidden = YES;
        _expressIndicateImage.hidden = YES;
        _expressStatus1.text=@"平台查验鉴定";
        
    }
    else{
        _tipView.hidden = YES;
        self.pasteBtn.hidden = NO;
        _expressCompany.hidden = NO;
        line.hidden = NO;
        _expressIndicateImage.hidden = NO;
        _expressStatus1.text=@"平台发货";
        _expressStatus2.text=@"您的地址";
        
    }
}
-(void)setPlatSendExpressVo:(ExpressVo *)platSendExpressVo{
    
    _platSendExpressVo = platSendExpressVo;
    _expressCompany.text=[NSString stringWithFormat:@"%@ : %@",_platSendExpressVo.com,_platSendExpressVo.nu];
    
}
-(void)clickCopyBtn{
    
    NSString *str = self.platSendExpressVo.nu;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = str;
    [UITipView showTipStr:@"复制成功"];
    
}
@end

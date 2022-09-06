//
//  JHOfferPriceView.m
//  TTjianbao
//
//  Created by jiang on 2019/12/3.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHOfferPriceView.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoBussiness.h"
#import "JHUIFactory.h"
#import "JHItemMode.h"
#import "JHWebViewController.h"
#import "CommAlertView.h"
#define descString @"1、意向金是为了防止恶意出价，保证双方交易安全；\n2、买方在出价时，要支付%.0f%%出价金额作为意向金；\n3、卖方拒绝买方的出价，意向金会实时退回给买方；\n4、买方主动取消出价，意向金也会实时退回给买方；\n5、卖方同意买方的出价，意向金则作为交易支付金额的一部分先支付，买方继续支付剩下的金额。\n6、卖家同意买方出价后，买方在48小时内未支付剩下的金额视为违约，意向金不予退回。"
@interface JHOfferPriceView ()<UITextViewDelegate,UITextFieldDelegate>
{
}
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) UIView *productView;
@property(nonatomic,strong) UIView *offerView;
@property(nonatomic,strong) UIView *priceView;
@property(nonatomic,strong) UIView *introduceView;
@property(nonatomic,strong) UIView *protocolView;
@property (strong, nonatomic)  UILabel* userName;
@property (strong, nonatomic)  UILabel *sallerName;
@property (strong, nonatomic)  UIImageView *productImage;
@property (strong, nonatomic)    UITextField  *cash;
@property (strong, nonatomic)  UIImageView *sallerHeadImage;
@property (strong, nonatomic)  UILabel *allPrice;
@property (strong, nonatomic)  UILabel *desc;
@property (strong, nonatomic)  UILabel *productPrice;
@property (strong, nonatomic)  UILabel *productTitle;
@property (strong, nonatomic)  UILabel *productCode;
@property (strong, nonatomic)   UILabel *intentionPrice;
@property (strong, nonatomic)   UIButton * protocolBtn;

@end
@implementation JHOfferPriceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)]];
        
        [self initScrollview];
        [self initBottomView];
    }
    return self;
}
-(void)dismissKeyboard{
    [self endEditing:YES];
}
-(void)initScrollview{
    
    self.contentScroll=[[UIScrollView alloc]init];
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = YES;
    self.contentScroll.backgroundColor =[CommHelp toUIColorByStr:@"#f7f7f7"];
    self.contentScroll.scrollEnabled=YES;
    self.contentScroll.alwaysBounceVertical=YES;
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self);
    }];
    
    [self initProductView];
    [self initPriceView];
    [self initOfferView];
    [self initIntroduceView];
    [self initProtocolView];
    
}

-(void)initProductView{
    
    _productView=[[UIView alloc]init];
    _productView.backgroundColor=[UIColor whiteColor];
    _productView.layer.cornerRadius = 8;
    _productView.layer.masksToBounds = YES;
    [self.contentScroll addSubview:_productView];
    
    [_productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.width.offset(ScreenW-20);
    }];
    
    _sallerHeadImage=[[UIImageView alloc]initWithImage:kDefaultAvatarImage];
    _sallerHeadImage.layer.masksToBounds =YES;
    _sallerHeadImage.layer.cornerRadius =8;
    _sallerHeadImage.userInteractionEnabled=YES;
    [_productView addSubview:_sallerHeadImage];
    
    [_sallerHeadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(_productView).offset(5);
    }];
    
    _sallerName=[[UILabel alloc]init];
    _sallerName.text=@"";
    _sallerName.font=[UIFont systemFontOfSize:12];
    _sallerName.backgroundColor=[UIColor clearColor];
    _sallerName.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _sallerName.numberOfLines = 1;
    _sallerName.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _sallerName.lineBreakMode = NSLineBreakByWordWrapping;
    _sallerName.lineBreakMode = NSLineBreakByTruncatingTail;
    _sallerName.userInteractionEnabled=YES;
    [_productView addSubview:_sallerName];
    
    [_sallerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_sallerHeadImage);
        make.left.equalTo(_sallerHeadImage.mas_right).offset(10);
    }];
    
//    JHCustomLine *line = [JHUIFactory createLine];
//    [_productView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_sallerName.mas_bottom).offset(10);
//        make.height.equalTo(@1);
//        make.left.offset(15);
//        make.right.offset(0);
//
//    }];
    
    _productImage=[[UIImageView alloc]initWithImage:nil];
    _productImage.contentMode = UIViewContentModeScaleAspectFill;
    _productImage.layer.masksToBounds=YES;
    _productImage.userInteractionEnabled=YES;
    [_productView addSubview:_productImage];
    
    //    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
    // [_productImage addGestureRecognizer:tapGesture];
    
    [_productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sallerHeadImage.mas_bottom).offset(10);
        make.left.equalTo(@5);
        make.size.mas_equalTo(CGSizeMake(90, 90));
        make.bottom.equalTo(_productView).offset(-10);
    }];
    
    _productTitle=[[UILabel alloc]init];
    _productTitle.text=@"";
    _productTitle.font=[UIFont systemFontOfSize:14];
    _productTitle.textColor=[CommHelp toUIColorByStr:@"#333333"];
    _productTitle.numberOfLines = 1;
    _productTitle.textAlignment = NSTextAlignmentLeft;
    _productTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    [_productView addSubview:_productTitle];
    [_productTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_productImage);
        make.left.equalTo(_productImage.mas_right).offset(5);
        make.right.equalTo(_productView.mas_right).offset(-5);
    }];
    
    _productPrice=[[UILabel alloc]init];
    _productPrice.text=@"";
    _productPrice.font=[UIFont fontWithName:kFontBoldDIN size:15.f];
    _productPrice.textColor=[CommHelp toUIColorByStr:@"#fc4200"];
    _productPrice.numberOfLines = 1;
    _productPrice.textAlignment = NSTextAlignmentLeft;
    _productPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:_productPrice];
    
    [_productPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productTitle.mas_bottom).offset(10);
        make.left.equalTo(_productTitle);
    }];
    
    _productCode =[[UILabel alloc]init];
    _productCode.text=@"编号";
    _productCode.font=[UIFont systemFontOfSize:14];
    _productCode.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _productCode.numberOfLines = 1;
    _productCode.textAlignment = NSTextAlignmentLeft;
    _productCode.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:_productCode];
    
    [_productCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_productTitle.mas_top).offset(-10);
        make.left.equalTo(_productTitle);
    }];
    
}
-(void)initPriceView{
    
    _priceView=[[UIView alloc]init];
    _priceView.backgroundColor=[UIColor whiteColor];
    _priceView.userInteractionEnabled=YES;
    _priceView.layer.cornerRadius = 8;
    _priceView.layer.masksToBounds =YES;
    [self.contentScroll addSubview:_priceView];
    [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.top.equalTo(_productView.mas_bottom).offset(10);
        make.height.offset(45);
    }];
    
    UILabel * title=[[UILabel alloc]init];
    title.text=@"出价";
    title.font=[UIFont fontWithName:kFontMedium size:13];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=kColor333;
    title.numberOfLines = 1;
    [title setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
    title.textAlignment = UIControlContentHorizontalAlignmentRight;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_priceView addSubview:title];
    
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceView).offset(15);
        make.centerY.equalTo(_priceView);
    }];
    
    UILabel * cashIcon=[[UILabel alloc]init];
    cashIcon.text=@"¥";
    [cashIcon setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
    cashIcon.font=[UIFont systemFontOfSize:12];
    cashIcon.backgroundColor=[UIColor clearColor];
    cashIcon.textColor=kColorMainRed;
    cashIcon.numberOfLines = 1;
    cashIcon.textAlignment = UIControlContentHorizontalAlignmentRight;
    cashIcon.lineBreakMode = NSLineBreakByWordWrapping;
    [_priceView addSubview:cashIcon];
    
    [cashIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_right).offset(10);
        make.centerY.equalTo(_priceView);
    }];
    
    _cash=[[UITextField alloc]init];
    _cash.backgroundColor=[UIColor clearColor];
    _cash.tag=1;
    _cash.tintColor = [UIColor colorWithRed:1.00f green:0.40f blue:0.42f alpha:1.00f];
    _cash.returnKeyType =UIReturnKeyDone;
    _cash.textColor=kColorMainRed;
    _cash.delegate=self;
    _cash.textAlignment = NSTextAlignmentLeft;
    _cash.keyboardType = UIKeyboardTypeNumberPad;
    _cash.placeholder=@"请输入出价金额";
    _cash.font=[UIFont systemFontOfSize:13];
    [_cash addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_priceView addSubview:_cash];
    //
    [self.cash mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_priceView).offset(-10);
        make.left.equalTo(cashIcon.mas_right).offset(10);
        make.top.bottom.equalTo(_priceView);
    }];
    
}
-(void)initOfferView{
    
    _offerView=[[UIView alloc]init];
    _offerView.backgroundColor=[UIColor whiteColor];
    _offerView.userInteractionEnabled=YES;
    _offerView.layer.cornerRadius = 8;
    _offerView.layer.masksToBounds = YES;
    [self.contentScroll addSubview:_offerView];
    [_offerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    
    
}
-(void)initIntroduceView{
    _introduceView=[[UIView alloc]init];
    _introduceView.backgroundColor=[UIColor whiteColor];
    _introduceView.layer.cornerRadius = 8;
    _introduceView.layer.masksToBounds = YES;
    
    [self.contentScroll addSubview:_introduceView];
    
    [_introduceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.offerView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    
        UILabel *title=[[UILabel alloc]init];
        title.text=@"意向金说明";
        title.font=[UIFont fontWithName:kFontMedium size:13];
        title.textColor=[CommHelp toUIColorByStr:@"#333333"];
        title.numberOfLines = 1;
        title.textAlignment = NSTextAlignmentLeft;
        title.lineBreakMode = NSLineBreakByWordWrapping;
    
        [_introduceView addSubview:title];
    
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.left.equalTo(_introduceView).offset(10);
            make.right.equalTo(_introduceView).offset(-10);
        }];
        _desc=[[UILabel alloc]init];
//        desc.text=@"1、意向金是为了防止恶意出价，保证双方交易安全；\n2、买方在出价时，要支付20%商品价格作为意向金；\n3、卖方拒绝买方的出价，意向金会实时退回给买方；\n4、买方主动取消出价，意向金也会实时退回给买方；\n5、卖方同意买方的出价，意向金则作为交易支付金额的一部分先支付，买方继续支付剩下的金额。";

        _desc.font=[UIFont fontWithName:kFontNormal size:12];
        _desc.textColor=[CommHelp toUIColorByStr:@"#666666"];
        _desc.numberOfLines = 0;
        _desc.textAlignment = NSTextAlignmentLeft;
        _desc.lineBreakMode = NSLineBreakByWordWrapping;
        [_introduceView addSubview:_desc];
        [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(10);
            make.left.equalTo(_introduceView).offset(10);
            make.right.equalTo(_introduceView).offset(-10);
            make.bottom.equalTo(_introduceView).offset(-50);
        }];
    
}
-(void)initProtocolView{
    
    _protocolView = [UIView new];
    _protocolView.userInteractionEnabled=YES;
    [_protocolView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(protocolAction)]];
    [self.contentScroll addSubview:_protocolView];
    [_protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.introduceView.mas_bottom).offset(20);
        make.height.offset(20.);
        make.centerX.equalTo(self.contentScroll);
        make.bottom.equalTo(self.contentScroll);
    }];
    
    JHPreTitleLabel *label = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor666 font:[UIFont fontWithName:kFontMedium size:12] textAlignment:NSTextAlignmentLeft preTitle:@"我已同意"];
    [label setJHAttributedText:@"《原石回血交易协议》" font:[UIFont fontWithName:kFontMedium size:12] color:HEXCOLOR(0x235E96)];
    label.userInteractionEnabled = NO;
    [_protocolView addSubview:label];

    _protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_protocolBtn setImage:[UIImage imageNamed:@"order_stone_protocol_select"] forState:UIControlStateSelected];
    [_protocolBtn setImage:[UIImage imageNamed:@"order_stone_protocol_nomal"] forState:UIControlStateNormal];
    _protocolBtn.contentMode=UIViewContentModeScaleAspectFit;
    [_protocolBtn addTarget:self action:@selector(onProtocolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_protocolView addSubview:_protocolBtn];

    _protocolBtn.selected=YES;

    [_protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_protocolView.mas_left).offset(0);
        make.centerY.equalTo(_protocolView).offset(0);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(_protocolView);
        make.left.equalTo(_protocolBtn.mas_right).offset(5);
    }];
}

-(void)initBottomView {
    
    UIView * bottom=[[UIView alloc]init];
    bottom.backgroundColor=[CommHelp toUIColorByStr:@"#ffffff"];
    [self addSubview:bottom];
    
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).offset(0);
        make.height.offset(50);
        make.bottom.equalTo(self);
    }];
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"支付意向金";
    title.font=[UIFont systemFontOfSize:12];
    //    title.backgroundColor=[UIColor greenColor];
    title.textColor=kColor333;
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [bottom addSubview:title];
    
    _allPrice=[[UILabel alloc]init];
    _allPrice.text=@"";
    _allPrice.font = [UIFont fontWithName:kFontBoldDIN size:15.f];
    //    _allPrice.backgroundColor=[UIColor yellowColor];
    _allPrice.textColor=kColorMainRed;
    _allPrice.numberOfLines = 1;
    [_allPrice setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    _allPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _allPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [bottom addSubview:_allPrice];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=kColorMain;
    button.layer.cornerRadius=17;
    button.layer.masksToBounds=YES;
    [button setTitleColor:kColor333 forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:12];
    [button  setTitle:@"提交订单" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottom).offset(-10);
        make.centerY.equalTo(bottom);
        make.width.offset(142);
        make.height.offset(34);
    }];
    
    [_allPrice mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(title).offset(2);
           make.right.equalTo(button.mas_left).offset(-10);
       }];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottom);
        make.right.equalTo(_allPrice.mas_left).offset(-10);
    }];
}
-(void)initOfferSubViews:(NSArray*)titles{
    
    UIView * lastView;
    for (int i=0; i<[titles count]; i++) {
        JHItemMode * item =titles[i];
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [_offerView addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.backgroundColor=[UIColor clearColor];
        [title setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        title.numberOfLines = 1;
        title.textColor=kColor333;
        title.font=[UIFont systemFontOfSize:12.f];
        title.text=item.title;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UILabel  *desc=[[UILabel alloc]init];
        desc.backgroundColor=[UIColor clearColor];
        [desc setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        desc.numberOfLines = 1;
        desc.textColor=kColor333;
        desc.font=[UIFont systemFontOfSize:14.f];
        desc.text=item.value;;
        desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:desc];
        
        if (i==0) {
            title.textColor=kColor333;
            title.font=[UIFont fontWithName:kFontMedium size:13];
            self.intentionPrice=desc;
        }
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.top.bottom.equalTo(view);
        }];
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(view);
            make.left.equalTo(title.mas_right).offset(10);
        }];
        
        if (i!=[titles count]-1) {
            UIView * line=[[UIView alloc]init];
            line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
            [view addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(15);
                make.bottom.equalTo(view.mas_bottom).offset(0);
                make.right.equalTo(view).offset(0);
                make.height.offset(1);
            }];
        }
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_offerView);
            make.height.offset(47);
            if (i==0) {
                make.top.equalTo(_offerView).offset(0);
            }
            else{
                make.top.equalTo(lastView.mas_bottom).offset(0);
            }
            if (i==[titles count]-1) {
                make.bottom.equalTo(_offerView).offset(0);
            }
            
        }];
        
        lastView= view;
    }
}

-(void)handleOfferData:(JHStoneOfferModel*)mode{
    
     
    NSMutableArray * titles=[NSMutableArray array];
    JHItemMode * item1 =[[JHItemMode alloc]init];
    item1.title=@"意向金";
    item1.value=[NSString stringWithFormat:@"¥ %.2f",self.cash.text.floatValue*mode.intentionRate];
    [titles addObject:item1];
    
    JHItemMode * item2 =[[JHItemMode alloc]init];
  //  item2.title=[NSString stringWithFormat:@"意向金=商品价格*%.f%%",100*mode.intentionRate];
     item2.title=mode.intentionMsg;
    [titles addObject:item2];
    [self initOfferSubViews:titles];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *futureString = [NSMutableString stringWithString:textField.text];
    [futureString insertString:string atIndex:range.location];
   
    NSInteger flag = 0;
    // 这个可以自定义,保留到小数点后两位,后几位都可以
    const NSInteger limited =0;
    
    for (NSInteger i = futureString.length - 1; i >= 0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            // 如果大于了限制的就提示
            if (flag > limited) {
                return NO;
            }
            break;
        }
        
        flag++;
    }
    
    return YES;
}
- (void) textFieldDidChange:(id) sender {
    
    UITextField *_field = (UITextField *)sender;
    self.intentionPrice.text=[NSString stringWithFormat:@"¥ %.2f",_field.text.floatValue*self.stoneMode.intentionRate];
    self.allPrice.text=self.intentionPrice.text;
}
-(void)setStoneMode:(JHStoneOfferModel *)stoneMode{
    _stoneMode=stoneMode;
    [_sallerHeadImage jhSetImageWithURL:[NSURL URLWithString:_stoneMode.sellerAvatar] placeholder:kDefaultAvatarImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        
    }];
    _sallerName.text=[NSString stringWithFormat:@"卖家 %@",_stoneMode.sellerName];
    _productTitle.text=[NSString stringWithFormat:@"%@",_stoneMode.goodsTitle];
    _productPrice.text=[NSString stringWithFormat:@"¥ %@",_stoneMode.salePrice];
    _productCode.text=[NSString stringWithFormat:@"编号: %@",_stoneMode.goodsCode];
    _desc.text=[NSString stringWithFormat:descString,100*_stoneMode.intentionRate];
    JH_WEAK(self)
    [_productImage jhSetImageWithURL:[NSURL URLWithString:_stoneMode.goodsUrl] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        JH_STRONG(self)
        if (!image) {
            self.productImage.contentMode=UIViewContentModeScaleAspectFill;
        }
    }];
    
   //  self.cash.text=_stoneMode.salePrice;
    [self handleOfferData:_stoneMode];
    self.allPrice.text=self.intentionPrice.text;
    
}
-(void)setResaleFlag:(BOOL)resaleFlag{
    
//    _resaleFlag = resaleFlag;
//    [_protocolView setHidden:_resaleFlag];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField  resignFirstResponder];
    return YES;
}
-(void)onClickBtnAction:(UIButton*)sender{
    
    if (self.cash.text.floatValue>self.stoneMode.salePrice.floatValue) {
    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"您给的价格高于当前一口价！是否确认按此价格出价" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
        @weakify(self);
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
           alert.handle = ^{
               @strongify(self);
               [self offerPrice];
        };
     return;
    }
    
    [self offerPrice];
    
}
-(void)offerPrice{
    
    if (self.cash.text.floatValue<self.stoneMode.salePrice.floatValue*0.1) {
        [JHKeyWindow makeToast:@"出价金额不得小于售价的10%" duration:2 position:CSToastPositionCenter];
        return;
       }
    
    if (!_protocolBtn.selected) {
           [self makeToast:@"请阅读并同意原石回血交易协议" duration:1 position:CSToastPositionCenter];
           return;
       }
    if (self.handle) {
        self.handle([NSString stringWithFormat:@"%.2f",self.cash.text.floatValue*self.stoneMode.intentionRate]);
    }
}
- (void)protocolAction{
    JHWebViewController *web = [[JHWebViewController alloc] init];
     web.urlString = StoneRestoreProtocolURL;
    [JHRootController.homeTabController.navigationController pushViewController:web animated:YES];
}
- (void)onProtocolBtnAction:(UIButton*)button {
    button.selected=!button.selected;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}
@end


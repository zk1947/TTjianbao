//
//  JHNewOrderListCell.m
//  TTjianbao
//
//  Created by jiangchao on 2021/1/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewOrderListCell.h"
#import "JHItemMode.h"
#import "TTjianbaoHeader.h"
#import "EnlargedImage.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHGrowingIO.h"
#import "UIImage+JHColor.h"
#import "JHCommMenuView.h"
#import "YYControl.h"
#import "NSString+NTES.h"
#import "JHNewShopDetailViewController.h"

@interface JHNewOrderListCell ()
{
    UIImageView * circleIcon;
}
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UIImageView *nameArrowImage;
@property (strong, nonatomic)  YYAnimatedImageView *liveGifView;
@property (strong, nonatomic)  UIImageView *displayImage;
@property (strong, nonatomic)  UILabel* name;
@property (strong, nonatomic)  UILabel* title;
@property (strong, nonatomic)  UILabel* orderCode;
@property (strong, nonatomic)  UILabel *orderTime;
@property (strong, nonatomic)  UILabel *orderStatusLabel;
@property (strong, nonatomic)  UIView *buttonBackView;
@property (strong, nonatomic)  UILabel *price;
@property (strong, nonatomic)  NSMutableArray  <UIButton*> *buttons;
@end
@implementation JHNewOrderListCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.layer.cornerRadius = 8;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor=[UIColor whiteColor];
        
        circleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mall_like_circle_img"]];
        circleIcon.hidden = YES;
        [self.contentView addSubview:circleIcon];
        [circleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(7);
            make.size.mas_equalTo(CGSizeMake(33, 33));
            make.left.offset(15);
        }];
        
        _headImage=[[UIImageView alloc]init];
        _headImage.image=kDefaultAvatarImage;
        _headImage.layer.masksToBounds =YES;
        _headImage.layer.cornerRadius =15;
        _headImage.userInteractionEnabled=YES;
        [_headImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap:)]];
        [self.contentView addSubview:_headImage];
        
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(circleIcon);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_on_live" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        YYImage *image = [YYImage imageWithData:data];
        _liveGifView = [[YYAnimatedImageView alloc] initWithImage:image];
        _liveGifView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_liveGifView];
        _liveGifView.hidden = YES;
        
        [_liveGifView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(circleIcon);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        
        
        UIView *nameBack = [[UIView alloc]init];
        nameBack.userInteractionEnabled=YES;
        [nameBack addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap:)]];
        [self.contentView addSubview:nameBack];
        [nameBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headImage);
            make.left.equalTo(_headImage.mas_right).offset(7);
            make.height.offset(25);
        }];
        
        _name=[[UILabel alloc]init];
        _name.text=@"";
        _name.font=[UIFont systemFontOfSize:14];
        _name.textColor=[CommHelp toUIColorByStr:@"#000000"];
        _name.numberOfLines = 1;
        _name.textAlignment = NSTextAlignmentLeft;
        _name.lineBreakMode = NSLineBreakByTruncatingTail;
//        _name.userInteractionEnabled=YES;
//        [_name addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap:)]];
        [nameBack addSubview:_name];
        
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nameBack);
            make.left.equalTo(nameBack).offset(0);
            make.width.lessThanOrEqualTo(@150);
        }];
        
        _nameArrowImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addadress_choose_icon"]];
//        _nameArrowImage.userInteractionEnabled=YES;
//        [_nameArrowImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap:)]];
        [nameBack addSubview:_nameArrowImage];
        
        [_nameArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_name);
            make.size.mas_equalTo(CGSizeMake(7, 9));
            make.left.equalTo(_name.mas_right).offset(5);
            make.right.equalTo(nameBack).offset(0);
        }];
        
        
        _orderStatusLabel=[[UILabel alloc]init];
        _orderStatusLabel.text=@"";
        _orderStatusLabel.font=[UIFont systemFontOfSize:13];
        _orderStatusLabel.backgroundColor=[UIColor clearColor];
        _orderStatusLabel.textColor=kColor333;
        _orderStatusLabel.numberOfLines = 1;
        _orderStatusLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _orderStatusLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_orderStatusLabel];
        
        [_orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(_headImage);
        }];
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
        [self.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(_headImage.mas_bottom).offset(7);
            make.right.equalTo(self.contentView).offset(0);
            make.height.offset(1);
        }];
        
        _displayImage=[[UIImageView alloc]init];
        _displayImage.image=[UIImage imageNamed:@""];
        _displayImage.contentMode = UIViewContentModeScaleAspectFill;
        _displayImage.layer.masksToBounds=YES;
        _displayImage.userInteractionEnabled=YES;
        _displayImage.layer.cornerRadius =8;
        [self.contentView addSubview:_displayImage];
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
        [_displayImage addGestureRecognizer:tapGesture];
        [_displayImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.left.equalTo(_headImage);
            
        }];
        
        _price=[[UILabel alloc]init];
        _price.text=@"";
        _price.font=[UIFont fontWithName:kFontBoldDIN size:20.f];
        _price.textColor=kColor333;
        _price.numberOfLines = 1;
        _price.textAlignment = NSTextAlignmentLeft;
        _price.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_price];
        
        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_displayImage);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
        _title=[[UILabel alloc]init];
        _title.text=@"";
        _title.font=[UIFont boldSystemFontOfSize:15];
        _title.backgroundColor=[UIColor clearColor];
        _title.textColor=[CommHelp toUIColorByStr:@"#222222"];
        _title.numberOfLines = 2;
        _title.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_title];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_displayImage);
            make.right.equalTo(_price.mas_left).offset(-10);
            make.left.equalTo(_displayImage.mas_right).offset(10);
            
        }];
        
        _orderTime=[[UILabel alloc]init];
        _orderTime.text=@"";
        _orderTime.font=[UIFont systemFontOfSize:12];
        _orderTime.textColor=[CommHelp toUIColorByStr:@"#999999"];
        _orderTime.numberOfLines = 1;
        _orderTime.textAlignment = NSTextAlignmentLeft;
        _orderTime.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_orderTime];
        
        [_orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_displayImage).offset(0);
            make.left.equalTo(_displayImage.mas_right).offset(10);
            
        }];
        
        
        _buttonBackView=[[UIView alloc]init];
        [self.contentView addSubview:_buttonBackView];
        //  [_buttonBackView setBackgroundColor:[UIColor redColor]];
        [_buttonBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(0);
            make.bottom.equalTo(self.contentView).offset(0);
            make.right.equalTo(self.contentView).offset(0);
            make.height.offset(45);
        }];
        
        _buttons=[NSMutableArray array];
        UIButton * lastView;
        for (int i=0; i<buttonLimitCount; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font= [UIFont systemFontOfSize:12];
            [button setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            button.contentMode=UIViewContentModeScaleAspectFit;
            [_buttonBackView addSubview:button];
            [_buttons addObject:button];
            
            [button setHidden:YES];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(72, 30));
                make.centerY.equalTo(_buttonBackView);
                if (i==0) {
                    make.right.equalTo(_buttonBackView).offset(-10);
                }
                else{
                    make.right.equalTo(lastView.mas_left).offset(-10);
                }
            }];
            
            lastView= button;
        }
    }
    
    return self;
}

-(void)buttonPress:(UIButton*)button{
    
    if (button.tag ==JHCustomizeOrderButtonMore) {
        JHCommMenuView * menuView = [[JHCommMenuView alloc ]init];
        [JHKeyWindow addSubview:menuView];
        [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button.mas_top).offset(-5);
            make.left.equalTo(button).offset(20);
        }];
        NSMutableArray * arr = [NSMutableArray array];
        for (int i =buttonLimitCount; i<self.orderMode.customizeButtons.count; i++) {
            [arr addObject:self.orderMode.customizeButtons[i].title];
        }
        [menuView setDataArr:arr];
        @weakify(self);
        menuView.buttonHandle = ^(id obj) {
            @strongify(self);
            if (self.delegate) {
        [self.delegate buttonPress:self.orderMode.customizeButtons[[obj integerValue]+buttonLimitCount].buttonType withOrder:self.orderMode];
            }
        };
    }
    else{
        if (self.delegate) {
            [self.delegate buttonPress:button.tag withOrder:self.orderMode];
        }
    }
}
-(void)setOrderMode:(JHCustomizeOrderModel *)orderMode{
    
    _orderMode=orderMode;
    [_headImage jhSetImageWithURL:[NSURL URLWithString:_orderMode.sellerImg] placeholder:kDefaultAvatarImage];
    [_displayImage jhSetImageWithURL:[NSURL URLWithString:ThumbSmallByOrginal(_orderMode.goodsUrl)] placeholder:kDefaultCoverImage];
    _name.text=_orderMode.sellerName;
   // _title.text=_orderMode.goodsTitle;
    _orderTime.text=_orderMode.orderCreateTime;
    _price.text = @"";
    UserInfoRequestManager * manager = [UserInfoRequestManager sharedInstance];
//    NSString * url=[manager findValue:manager.orderCategoryIcons byKey:_orderMode.orderCategory];
    UIImage * image;
    for (NSString * string in manager.orderCategoryIconImages.allKeys){
        if ([_orderMode.orderCategory isEqualToString:string]) {
            image =  manager.orderCategoryIconImages[string];
        }
    }
    
   if (image) {
       if (orderMode.flashIcon) {
           NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] init];
           NSTextAttachment *attch = [[NSTextAttachment alloc] init];
           attch.image = image;
           attch.bounds = CGRectMake(0, -2,33, 16);
           NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attch];
           [attri appendAttributedString:imgStr?:[[NSAttributedString alloc] initWithString:@""]];
           
           UIImage *flashImage = [UIImage imageNamed:@"jh_flashSendOrderIcon"];
           NSTextAttachment *attch2 = [[NSTextAttachment alloc] init];
           attch2.image = flashImage;
           attch2.bounds = CGRectMake(0,-2,16, 16);
           NSAttributedString *imgStr2 = [NSAttributedString attributedStringWithAttachment:attch2];
           [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
           [attri appendAttributedString:imgStr2?:[[NSAttributedString alloc] initWithString:@""]];
           
           [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
           [attri appendAttributedString:[[NSAttributedString alloc] initWithString:_orderMode.goodsTitle?: @""]];
            _title.attributedText = attri;

       } else {
           NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] init];
           NSTextAttachment *attch = [[NSTextAttachment alloc] init];
           attch.image = image;
           attch.bounds = CGRectMake(0, -2,33, 16);
           NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attch];
           [attri appendAttributedString:imgStr?:[[NSAttributedString alloc] initWithString:@""]];
           [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
           [attri appendAttributedString:[[NSAttributedString alloc] initWithString:_orderMode.goodsTitle?: @""]];
            _title.attributedText = attri;
       }
    }
    else {
        if (orderMode.flashIcon) {
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] init];
            UIImage *flashImage = [UIImage imageNamed:@"jh_flashSendOrderIcon"];
            NSTextAttachment *attch2 = [[NSTextAttachment alloc] init];
            attch2.image = flashImage;
            attch2.bounds = CGRectMake(0,-2,16, 16);
            NSAttributedString *imgStr2 = [NSAttributedString attributedStringWithAttachment:attch2];
            [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            [attri appendAttributedString:imgStr2?:[[NSAttributedString alloc] initWithString:@""]];
            
            [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            [attri appendAttributedString:[[NSAttributedString alloc] initWithString:_orderMode.goodsTitle?: @""]];
             _title.attributedText = attri;
        } else {
            _title.text = _orderMode.goodsTitle;
        }
    }
    
    if ([_orderMode.status isEqualToString:@"waitCharge"]||
        [_orderMode.status isEqualToString:@"waitOrder"]||
        [_orderMode.orderStatus isEqualToString:@"waitpay"]||
        [_orderMode.orderStatus isEqualToString:@"waitack"]){
        _orderStatusLabel.textColor=kColorFF4200;
    }
    else{
        _orderStatusLabel.textColor=kColor333;
    }
    
    
    if (_orderMode.orderCategoryType == JHOrderCategoryPersonalCustomizeOrder) {
        if (!isEmpty(_orderMode.totalValue)) {
            NSString * string=[@"¥ " stringByAppendingString:[NSString stringWithFormat:@"%@",_orderMode.totalValue]];
            NSRange range = [string rangeOfString:@"¥"];
            _price.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:13.f] color:kColor333 range:range];
            
        }
    }
    else{
        if (!isEmpty(_orderMode.originOrderPrice)) {
            
            NSString * string=[@"¥ " stringByAppendingString:[NSString stringWithFormat:@"%@",_orderMode.originOrderPrice]];
            NSRange range = [string rangeOfString:@"¥"];
            _price.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:13.f] color:kColor333 range:range];
        }
        
    }
    if ([_orderMode.channelStatus isEqualToString:@"2"]) {
         _liveGifView.hidden = NO;
         circleIcon.hidden = NO;
    }
    else{
         _liveGifView.hidden = YES;
         circleIcon.hidden = YES;
    }
//    if (_orderMode.orderCategoryType == JHOrderCategoryMallOrder) {
//        [_nameArrowImage setHidden:NO];
//    }
//    else{
//        [_nameArrowImage setHidden:YES];
//    }
    
    [self showStatus];
    [self handleButtonsData];
    
}

-(void)showStatus{
    
    _orderStatusLabel.text=@"";
    if (_orderMode.orderCategoryType == JHOrderCategoryPersonalCustomizeOrder) {
        if (_orderMode.statusName) {
            _orderStatusLabel.text = _orderMode.statusName;
        }
    }
    else{
        
        if ([_orderMode.orderStatusString length]>0) {
            _orderStatusLabel.text=_orderMode.orderStatusString;
        }
        else{
            _orderStatusLabel.text=_orderMode.workorderDesc;
        }
    }
}
-(void)handleButtonsData{
    for (UIButton * btn in self.buttons) {
        [btn setHidden:YES];
    }
    if ([_orderMode.customizeButtons count]>0) {
        _buttonBackView.hidden= NO;
        [self setUpButtons:self.orderMode.customizeButtons];
    }
    else{
        _buttonBackView.hidden=YES;
        
    }
}
-(void)setUpButtons:(NSArray<JHCustomizeOrderButtonModel*>*)buttonArr{
    
    for (UIButton * btn in self.buttons) {
        [btn setHidden:YES];
    }
    for (int i=0; i<[buttonArr count]; i++) {
        
        if (i<=self.buttons.count-1) {
            
            UIButton*button=[self.buttons objectAtIndex:i];
            [button setHidden:NO];
            [button setTitle:buttonArr[i].title forState:UIControlStateNormal];
            CGSize titleSize=[buttonArr[i].title stringSizeWithFont: button.titleLabel.font];
            if (titleSize.width<49) {
                titleSize.width = 49;
            }
            
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(titleSize.width+20, 30));
            }];
            button.tag=buttonArr[i].buttonType;
            if  (buttonArr[i].style == 1)
            {
                button.layer.borderWidth = 0;
                UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(titleSize.width+20, 30) radius:15];
                [button setBackgroundImage:nor_image forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor clearColor]];
            }
            else if  (buttonArr[i].style == 2) {
                button.layer.borderWidth = 0;
                [button setBackgroundImage:nil forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor clearColor]];
            }
            else{
                button.layer.cornerRadius = 15.0;
                [button setBackgroundColor:[UIColor whiteColor]];
                [button setBackgroundImage:nil forState:UIControlStateNormal];
                button.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
                button.layer.borderWidth = 0.5f;
            }
            
            
        }
    }
}
-(void)setOrderRemainTime:(NSString *)orderRemainTime{
    
    _orderRemainTime=orderRemainTime;
    _orderStatusLabel.text=orderRemainTime;
}
-(void)imageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    UIImageView * imageview=(UIImageView*)gestureRecognizer.view;
    NSMutableArray * arr=[NSMutableArray arrayWithArray:@[self.orderMode.goodsUrl]];
    [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:0 result:^(NSInteger index) {
        
    }]; //使用
}
-(void)headImageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    if (self.orderMode.orderType == 0) {
        [JHRootController EnterLiveRoom:self.orderMode.channelLocalId fromString:@"dz_orderlist_in"];
    }
    else  if (self.orderMode.orderType == 1){
        ///enter UserInfo page
        [JHRootController enterUserInfoPage:self.orderMode.sellerCustomerId from:@""];
    }
    else  if (self.orderMode.orderType == 9){
        
        JHNewShopDetailViewController *vc = [[JHNewShopDetailViewController alloc]init];
        vc.customerId = self.orderMode.sellerCustomerId;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }
}
- (void)dealloc
{
    NSLog(@"cell111111 deallloc");
}
@end



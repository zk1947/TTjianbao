//
//  JHSellerOrderCollectionViewCell
//  TaoDangPuMall
//
//  Created by jiangchao on 2017/2/7.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "JHSellerOrderCollectionViewCell.h"
#import "JHItemMode.h"
#import "TTjianbaoHeader.h"
#import "EnlargedImage.h"
#import "TTjianbaoMarcoKeyword.h"

@interface JHSellerOrderCollectionViewCell ()
{
    UILabel* orderTimeLabel;
    UIView * line2;
    UILabel* cashTitle;
    UIView * line3;
}
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UIImageView *displayImage;
@property (strong, nonatomic)  UILabel* name;
@property (strong, nonatomic)  UILabel* title;
@property (strong, nonatomic)  UILabel* orderCode;
@property (strong, nonatomic)  UILabel *price;
@property (strong, nonatomic)  UILabel *orderTime;
@property (strong, nonatomic)  UILabel *orderStatusLabel;
@property (strong, nonatomic)  UILabel *goodsCountLabel;
@property (strong, nonatomic)  UIView *buttonBackView;
@property (strong, nonatomic)  NSMutableArray  <UIButton*> *buttons;
@property (strong, nonatomic)  UIView *noteView;
@property (strong, nonatomic)  UIView *processFeeView;
@property (strong, nonatomic)  UILabel*zhifaTagLabel;
@end
@implementation JHSellerOrderCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
         self.backgroundColor=[UIColor whiteColor];
        _headImage=[[UIImageView alloc]init];
        _headImage.image=kDefaultAvatarImage;
        _headImage.layer.masksToBounds =YES;
        _headImage.layer.cornerRadius =11;
        _headImage.userInteractionEnabled=YES;
        [self.contentView addSubview:_headImage];
        
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).offset(7);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.left.offset(15);
        }];
        
        _name=[[UILabel alloc]init];
        _name.text=@"";
        _name.font=[UIFont systemFontOfSize:14];
        _name.textColor=[CommHelp toUIColorByStr:@"#000000"];
        _name.numberOfLines = 1;
        _name.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _name.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_name];
         
        _orderStatusLabel=[[UILabel alloc]init];
        _orderStatusLabel.text=@"";
        _orderStatusLabel.font=[UIFont systemFontOfSize:13];
        _orderStatusLabel.backgroundColor=[UIColor clearColor];
        _orderStatusLabel.textColor=[CommHelp toUIColorByStr:@"#222222"];
        _orderStatusLabel.numberOfLines = 1;
        _orderStatusLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _orderStatusLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_orderStatusLabel];
        
        [_orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(_headImage);
            
        }];
        
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headImage);
            make.left.equalTo(_headImage.mas_right).offset(7);
            make.width.lessThanOrEqualTo(@150);
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
        _displayImage.userInteractionEnabled=YES;
        _displayImage.layer.masksToBounds=YES;
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
        [_displayImage addGestureRecognizer:tapGesture];
        [self.contentView addSubview:_displayImage];
        
        [_displayImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.left.equalTo(_headImage);
            
        }];
        
        _title=[[UILabel alloc]init];
        _title.text=@"";
        _title.font=[UIFont boldSystemFontOfSize:15];
        _title.backgroundColor=[UIColor clearColor];
        _title.textColor=[CommHelp toUIColorByStr:@"#222222"];
        _title.numberOfLines = 2;
        _title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.contentView addSubview:_title];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_displayImage);
            make.right.equalTo(self.contentView).offset(-40.f);
            make.left.equalTo(_displayImage.mas_right).offset(10);
            
        }];
        
        _zhifaTagLabel                     = [[UILabel alloc]init];
        _zhifaTagLabel.text                = @"直发";
        _zhifaTagLabel.font                = [UIFont fontWithName:kFontNormal size:10.f];
        _zhifaTagLabel.textColor           = HEXCOLOR(0xFC4200);
        _zhifaTagLabel.textAlignment       = NSTextAlignmentCenter;
        _zhifaTagLabel.layer.cornerRadius  = 3.f;
        _zhifaTagLabel.layer.masksToBounds = YES;
        _zhifaTagLabel.layer.borderWidth   = 0.5f;
        _zhifaTagLabel.layer.borderColor   = HEXCOLOR(0xFC4200).CGColor;
        _zhifaTagLabel.hidden              = YES;
        [self.contentView addSubview:_zhifaTagLabel];
        [_zhifaTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.title.mas_centerY);
            make.right.equalTo(self.contentView).offset(-10.f);
            make.width.mas_equalTo(29.f);
            make.height.mas_equalTo(15.f);
        }];
    
        
//                UIImageView *logo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_no_back"]];
//                logo.contentMode = UIViewContentModeScaleAspectFit;
//                [self addSubview:logo];
//
//                [logo mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(_title);
//                    make.bottom.equalTo(_displayImage.mas_bottom).offset(5);
//                }];
        
        _orderTime=[[UILabel alloc]init];
        _orderTime.text=@"";
        _orderTime.font=[UIFont systemFontOfSize:12];
        _orderTime.textColor=[CommHelp toUIColorByStr:@"#999999"];
        _orderTime.numberOfLines = 1;
        _orderTime.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _orderTime.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_orderTime];
        
        [_orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
            //  make.bottom.equalTo(logo.mas_top).offset(-5);
            make.bottom.equalTo(_displayImage).offset(-10);
            make.left.equalTo(_displayImage.mas_right).offset(5);
            
        }];
        
        _goodsCountLabel=[[UILabel alloc]init];
        _goodsCountLabel.text=@"";
        _goodsCountLabel.font=[UIFont fontWithName:kFontNormal size:12];
        _goodsCountLabel.textColor=kColor999;
        _goodsCountLabel.numberOfLines = 1;
        _goodsCountLabel.textAlignment = NSTextAlignmentRight;
        _goodsCountLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_goodsCountLabel];
        
        [_goodsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_orderTime);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            
        }];
        
        _processFeeView=[[UIView alloc]init];
        _processFeeView.backgroundColor=[UIColor whiteColor];
        _processFeeView.layer.masksToBounds=YES;
        [self.contentView addSubview:_processFeeView];
        [_processFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_displayImage.mas_bottom).offset(10);
            make.left.equalTo(self.contentView).offset(0);
            make.right.equalTo(self.contentView).offset(0);
        }];
        
        _noteView=[[UIView alloc]init];
        _noteView.backgroundColor=[UIColor whiteColor];
        _noteView.layer.masksToBounds=YES;
        [self.contentView addSubview:_noteView];
        [_noteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_processFeeView.mas_bottom).offset(0);
            make.left.equalTo(self.contentView).offset(0);
            make.right.equalTo(self.contentView).offset(0);
        }];
        
        line2=[[UIView alloc]init];
        line2.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
        [self.contentView addSubview:line2];
        
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(_noteView.mas_bottom).offset(10);
            make.right.equalTo(self.contentView).offset(0);
            make.height.offset(1);
        }];
        
        _orderCode=[[UILabel alloc]init];
        _orderCode.text=@"";
        _orderCode.font=[UIFont systemFontOfSize:12];
        _orderCode.backgroundColor=[UIColor clearColor];
        _orderCode.textColor=[CommHelp toUIColorByStr:@"#AAAAAA"];
        _orderCode.numberOfLines = 1;
        _orderCode.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _orderCode.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_orderCode];
        
        [_orderCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_displayImage);
            make.top.equalTo(line2.mas_bottom).offset(12);
            
        }];
        
        _price=[[UILabel alloc]init];
        _price.text=@"";
        _price.font=[UIFont fontWithName:kFontBoldDIN size:22.f];
        _price.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
        _price.numberOfLines = 1;
        _price.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _price.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_price];
        
        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_orderCode);
            make.right.equalTo(self.contentView).offset(-10);
            
        }];
        
        cashTitle=[[UILabel alloc]init];
        cashTitle.text=@"";
        cashTitle.font=[UIFont systemFontOfSize:12];
        cashTitle.textColor=[CommHelp toUIColorByStr:@"#222222"];
        cashTitle.numberOfLines = 1;
        cashTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
        cashTitle.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:cashTitle];
        
        [cashTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_price);
            make.right.equalTo(_price.mas_left).offset(-5);
            
        }];
        
        line3=[[UIView alloc]init];
        line3.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
        [self.contentView addSubview:line3];
        
        [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(_orderCode.mas_bottom).offset(12);
            make.right.equalTo(self.contentView).offset(0);
            make.height.offset(1);
            
        }];
        
        _buttonBackView=[[UIView alloc]init];
        [self.contentView addSubview:_buttonBackView];
        [_buttonBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(0);
            make.top.equalTo(line3.mas_bottom).offset(0);
            make.right.equalTo(self.contentView).offset(0);
            make.height.offset(60);
          //  make.bottom.equalTo(self);
            
        }];
        
        _buttons=[NSMutableArray array];
        UIButton * lastView;
        NSInteger buttonCount =4;
        for (int i=0; i<buttonCount; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font= [UIFont systemFontOfSize:12];
            // [button setBackgroundImage:[UIImage imageNamed:@"orderList_cell_button"] forState:UIControlStateNormal];
            button.layer.cornerRadius = 2.0;
            [button setBackgroundColor:[UIColor whiteColor]];
            button.layer.borderColor = [[CommHelp toUIColorByStr:@"#222222"] colorWithAlphaComponent:0.5].CGColor;
            button.layer.borderWidth = 0.5f;
            [button setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            button.contentMode=UIViewContentModeScaleAspectFit;
            [_buttonBackView addSubview:button];
            [_buttons addObject:button];
            
            [button setHidden:YES];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_buttonBackView);
                make.size.mas_equalTo(CGSizeMake(72, 30));
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
-(void)initProcessFeeSubViews:(NSArray*)titles{
    
    UIView * lastView;
    for (int i=0; i<[titles count]; i++) {
        
        JHItemMode * item =titles[i];
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [_processFeeView addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.backgroundColor=[UIColor clearColor];
        [title setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        title.numberOfLines = 1;
        title.textColor=kColor333;
        title.font=[UIFont systemFontOfSize:13.f];
        title.text=item.title;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UILabel  *desc=[[UILabel alloc]init];
        desc.backgroundColor=[UIColor clearColor];
        [desc setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        desc.numberOfLines = 1;
        desc.textColor=kColor333;
        desc.font=[UIFont systemFontOfSize:13.f];
        desc.text=item.value;
        desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:desc];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.top.bottom.equalTo(view);
        }];
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(view);
            make.right.equalTo(view.mas_right).offset(-10);
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
            make.left.right.equalTo(_processFeeView);
            make.height.offset(40);
            if (i==0) {
                make.top.equalTo(_processFeeView).offset(0);
            }
            else{
                make.top.equalTo(lastView.mas_bottom).offset(0);
            }
            if (i==[titles count]-1) {
                make.bottom.equalTo(_processFeeView).offset(0);
            }
            
        }];
        
        lastView= view;
    }
    
}
-(void)initNoteView{
    
    UIView * line=[[UIView alloc]init];
    line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
    [_noteView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(_noteView).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.offset(1);
        
    }];
    
    //    UILabel  * title=[[UILabel alloc]init];
    //    title.text=@"备注";
    //    title.font= [UIFont fontWithName:kFontMedium size:12];
    //    title.backgroundColor=[UIColor clearColor];
    //    title.textColor=[CommHelp toUIColorByStr:@"#333333"];
    //    title.numberOfLines = 1;
    //    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    //    title.lineBreakMode = NSLineBreakByWordWrapping;
    //    [_noteView addSubview:title];
    //
    //    [title mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(_noteView).offset(10);
    //        make.left.equalTo(_noteView).offset(15);
    //    }];
    
    UILabel * _note=[[UILabel alloc]init];
    _note.font=[UIFont fontWithName:kFontMedium size:14];
    _note.textColor=[CommHelp toUIColorByStr:@"#666666"];
    _note.numberOfLines = 0;
    _note.text =[NSString stringWithFormat:@"备注 %@",self.orderMode.complementVo.remark?:@""];
    // _desc.backgroundColor=[UIColor redColor];
    _note.preferredMaxLayoutWidth = ScreenW-25;
    _note.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _note.lineBreakMode = NSLineBreakByWordWrapping;
    [_noteView addSubview:_note];
    [_note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noteView).offset(10);
        make.left.equalTo(_noteView).offset(15);
        make.right.equalTo(_noteView.mas_right).offset(-10);
    }];
    
    UIScrollView *  _imagesScrollView=[[UIScrollView alloc]init];
    _imagesScrollView.showsHorizontalScrollIndicator = NO;
    _imagesScrollView.showsVerticalScrollIndicator = NO;
    _imagesScrollView.scrollEnabled=YES;
    // _appraisalAnchorView.userInteractionEnabled = NO;
    _imagesScrollView.alwaysBounceHorizontal = YES; // 水平
    _imagesScrollView.alwaysBounceVertical = NO;
    // [self addGestureRecognizer:_appraisalAnchorView.panGestureRecognizer];
    // self.contentScroll.delegate = self;
    [_noteView addSubview:_imagesScrollView];
    [_imagesScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_noteView);
        make.height.offset(0);
        make.top.equalTo(_note.mas_bottom).offset(0);
        make.right.equalTo(_noteView);
        make.bottom.equalTo(_noteView).offset(-10);
    }];
    
    if (self.orderMode.complementVo.pics.count>0) {
        [_imagesScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_note.mas_bottom).offset(10);
            make.height.offset(60);
        }];
        [self initImages:self.orderMode.complementVo.pics view:_imagesScrollView];
    }
}
-(void)initImages:(NSArray*)images  view:(UIScrollView*)_imagesScrollView{
    UIView * lastView;
    for (int i=0; i<images.count; i++) {
        UIImageView * view=[[UIImageView alloc]init];
        // view.backgroundColor=[CommHelp randomColor];
        view.contentMode=UIViewContentModeScaleAspectFill;
        view.layer.masksToBounds =YES;
        [view jhSetImageWithURL:[NSURL URLWithString:ThumbMiddleByOrginal(images[i])]];
        [_imagesScrollView addSubview:view];
        view.tag=i;
        view.userInteractionEnabled=YES;
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noteImageTap:)];
        [view addGestureRecognizer:tapGesture];
        float width=60;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(width);
            make.height.offset(width);
            make.top.equalTo(_imagesScrollView);
            if (i==0) {
                make.left.equalTo(_imagesScrollView).offset(10);
            }
            else{
                make.left.equalTo(lastView.mas_right).offset(5);
            }
            if (i==images.count-1) {
                make.right.equalTo(_imagesScrollView.mas_right).offset(-10);
            }
        }];
        lastView=view;
    }
}
-(void)setUpButtons:(NSArray*)buttonArr{
    
    for (UIButton * btn in self.buttons) {
        [btn setHidden:YES];
    }
    for (int i=0; i<[buttonArr count]; i++) {
        
        if (i<=self.buttons.count-1) {
            
            UIButton*button=[self.buttons objectAtIndex:i];
            [button setHidden:NO];
            [button setTitle:[[buttonArr objectAtIndex:i]objectForKey:@"buttonTitle"] forState:UIControlStateNormal];
            button.tag=[[[buttonArr objectAtIndex:i]objectForKey:@"buttonTag"] intValue];
            if (button.tag==JHOrderButtonTypeSend||
                button.tag==JHOrderButtonTypePrintCard||
                button.tag==JHOrderButtonTypeCompleteInfo) {
                [button setBackgroundColor:[CommHelp toUIColorByStr:@"#fee100"]];
                button.layer.borderWidth = 0;
            }
            else{
                button.layer.borderWidth = 0.5f;
                [button setBackgroundColor:[UIColor whiteColor]];
                // [button setBackgroundImage:[UIImage imageNamed:@"orderList_cell_button"] forState:UIControlStateNormal];
                [button setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
            }
        }
        
    }
    
}
-(void)buttonPress:(UIButton*)button{
    
    if (self.delegate) {
        [self.delegate buttonPress:button withOrder:self.orderMode];
    }
}
-(void)setOrderMode:(OrderMode *)orderMode{
    _orderMode=orderMode;
    [_headImage jhSetImageWithURL:[NSURL URLWithString:_orderMode.buyerImg] placeholder:kDefaultAvatarImage];
    [_displayImage jhSetImageWithURL:[NSURL URLWithString:ThumbSmallByOrginal(_orderMode.goodsUrl)] placeholder:kDefaultCoverImage];
    _name.text=_orderMode.buyerName;
    if (orderMode.directDelivery) {
        _zhifaTagLabel.hidden = NO;
    } else {
        _zhifaTagLabel.hidden = YES;
    }
    UserInfoRequestManager * manager = [UserInfoRequestManager sharedInstance];
    UIImage * image;
    for (NSString * string in manager.orderCategoryIconImages.allKeys){
        if ([_orderMode.orderCategory isEqualToString:string]) {
            image =  manager.orderCategoryIconImages[string];
        }
    }
    if (image) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:(_orderMode.goodsTitle?: @"")];
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = image;
        attch.bounds = CGRectMake(0, -2,33, 15);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attri insertAttributedString:string atIndex:0];
        [attri insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:1];
        _title.attributedText = attri;
    } else {
        _title.text=_orderMode.goodsTitle;
    }
    _orderCode.text=[NSString stringWithFormat:@"订单号:  %@",_orderMode.orderCode];
    _orderTime.text=_orderMode.orderCreateTime;
    if (_orderMode.goodsCount&&_orderMode.goodsCount>0){
      _goodsCountLabel.text=[NSString stringWithFormat:@"共%ld件",_orderMode.goodsCount];
    }

    [self.processFeeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.noteView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //加工服务单
    if ([_orderMode.orderCategory isEqualToString:@"processingGoods"]) {
        [self handleFeeData:_orderMode];
        cashTitle.text=@"加工费";
        _price.text=[@"¥ " stringByAppendingString:OBJ_TO_STRING(_orderMode.originOrderPrice)];
    } else if ([_orderMode.orderCategory isEqualToString:@"mallAuctionDepositOrder"]) {
        /// 保证金
        cashTitle.text=@"实付";
        _price.text=[@"¥ " stringByAppendingString:OBJ_TO_STRING(_orderMode.originOrderPrice)];
        [line2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_noteView.mas_bottom).offset(10);
        }];
    } else {
        cashTitle.text=@"实付";
        _price.text=[@"¥ " stringByAppendingString:OBJ_TO_STRING(_orderMode.originOrderPrice)];
        [line2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_noteView.mas_bottom).offset(10);
        }];
    }
    //有备注
    if (_orderMode.complementVo.remark.length>0||_orderMode.complementVo.pics.count>0 ) {
        [self initNoteView];
    }
    
    [self showStatus];
    [self handleButtonsData];
    
}
-(void)showStatus{
    
    _orderStatusLabel.text=@"";
    
//    if ([_orderMode.orderStatus isEqualToString:@"waitack"]||
//        [_orderMode.orderStatus isEqualToString:@"waitpay"]){
//        if ([CommHelp dateRemaining:_orderMode.payExpireTime]>0) {
//            _orderStatusLabel.text=[@"待付款 " stringByAppendingString:[CommHelp getHMSWithSecond:[CommHelp dateRemaining:_orderMode.payExpireTime]]];
//        }
//        else{
//            _orderStatusLabel.text=@"订单已取消";
//        }
//    }
   // else{
        
        if ([_orderMode.orderStatusString length]>0) {
            _orderStatusLabel.text=_orderMode.orderStatusString;
        }
        else{
            _orderStatusLabel.text=_orderMode.workorderDesc;
        }
   // }
}

-(void)handleButtonsData{
    
    for (UIButton * btn in self.buttons) {
        [btn setHidden:YES];
    }
    if ([_orderMode.buttons count]>0) {
        line3.hidden=NO;
        _buttonBackView.hidden= NO;
        [self setUpButtons:self.orderMode.buttons];
    }
    
    else{
        line3.hidden=YES;
        _buttonBackView.hidden=YES;
        
    }
}
-(void)setHideButtonView:(BOOL)hideButtonView{
    _hideButtonView=hideButtonView;
    if (_hideButtonView) {
        _buttonBackView.hidden=YES;
        [_buttonBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
    }
}
-(void)setIsProblem:(BOOL)isProblem{
    if (isProblem) {
        for (UIButton * btn in self.buttons) {
            [btn setHidden:YES];
        }
        NSMutableArray * buttons=[NSMutableArray array];
        [buttons addObject:@{@"buttonTitle":@"订单详情",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeOrderDetail]}];
        [buttons addObject:@{@"buttonTitle":@"问题详情",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeQuestionDetail]}];
        [self setUpButtons:buttons];
    }
}
-(void)handleFeeData:(OrderMode*)mode{
    NSMutableArray * titles=[NSMutableArray array];
    if (mode.materialCost) {
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=@"材料费";
        item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.materialCost)];
        [titles addObject:item];
    }
    if (mode.manualCost) {
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=@"手工费";
        item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.manualCost)];
        [titles addObject:item];
    }
    [self initProcessFeeSubViews:titles];
    [line2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noteView.mas_bottom).offset(0);
    }];
    
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
-(void)noteImageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    UIImageView * imageview=(UIImageView*)gestureRecognizer.view;
    NSMutableArray * arr=[NSMutableArray arrayWithArray:self.orderMode.complementVo.pics];
    [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:imageview.tag result:^(NSInteger index) {
        
    }]; //使用
}


@end




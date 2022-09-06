//
//  JHAppraiseOrderTableViewCell.m
//  TaoDangPuMall
//
//  Created by jiangchao on 2017/2/7.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "JHAppraiseOrderTableViewCell.h"
#import "TTjianbaoHeader.h"
#import "EnlargedImage.h"

@interface JHAppraiseOrderTableViewCell ()
{
    UILabel* orderTimeLabel;
}
@property (strong, nonatomic)  UIImageView *displayImage;
@property (strong, nonatomic)  UILabel* orderCode;
@property (strong, nonatomic)  UILabel *cardCode;
@property (strong, nonatomic)  UILabel *userCode;

@property (strong, nonatomic)  UILabel *price;

@property (strong, nonatomic)  UILabel *allPrice;
@property (strong, nonatomic)  UILabel *coponPrice;
@property (strong, nonatomic)  UILabel *orderTime;
@property (strong, nonatomic)  UILabel *orderStatusLabel;
@property (strong, nonatomic)  UIView *buttonBackView;
@property (strong, nonatomic)  NSMutableArray  <UIButton*> *buttons;
@property (strong, nonatomic)  UIView *noteView;
@end
@implementation JHAppraiseOrderTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _orderCode=[[UILabel alloc]init];
        _orderCode.text=@"";
        _orderCode.font=[UIFont systemFontOfSize:16];
        _orderCode.backgroundColor=[UIColor clearColor];
        _orderCode.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _orderCode.numberOfLines = 1;
        _orderCode.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _orderCode.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_orderCode];
        
        [_orderCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(8);
            make.left.offset(15);
        }];
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
        [self.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(_orderCode.mas_bottom).offset(8);
            make.right.equalTo(self.contentView).offset(0);
            make.height.offset(1);
        }];
        
        _displayImage=[[UIImageView alloc]init];
        _displayImage.image=[UIImage imageNamed:@""];
        _displayImage.contentMode = UIViewContentModeScaleAspectFill;
        _displayImage.layer.masksToBounds=YES;
        _displayImage.userInteractionEnabled=YES;
        [self.contentView addSubview:_displayImage];
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
        [_displayImage addGestureRecognizer:tapGesture];
        [_displayImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.left.equalTo(_orderCode);
        }];
        
        UILabel* cardCodeLabel=[[UILabel alloc]init];
        cardCodeLabel.text=@"宝卡号";
        cardCodeLabel.font=[UIFont systemFontOfSize:16];
        cardCodeLabel.textColor=[CommHelp toUIColorByStr:@"#777777"];
        cardCodeLabel.numberOfLines = 1;
        cardCodeLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
        cardCodeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:cardCodeLabel];
        
        [cardCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_displayImage);
            make.left.equalTo(_displayImage.mas_right).offset(5);
            
        }];
        
        _cardCode=[[UILabel alloc]init];
        _cardCode.text=@"";
        _cardCode.font=[UIFont systemFontOfSize:16];
        _cardCode.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _cardCode.numberOfLines = 1;
        _cardCode.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _cardCode.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_cardCode];
        
        [_cardCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cardCodeLabel).offset(0);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
        UILabel* userCodeLabel=[[UILabel alloc]init];
        userCodeLabel.text=@"宝友号";
        userCodeLabel.font=[UIFont systemFontOfSize:16];
        userCodeLabel.textColor=[CommHelp toUIColorByStr:@"#777777"];
        userCodeLabel.numberOfLines = 1;
        userCodeLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
        userCodeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:userCodeLabel];
        
        [userCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cardCodeLabel.mas_bottom).offset(10);
            make.left.equalTo(_displayImage.mas_right).offset(5);
            
        }];
        
        _userCode=[[UILabel alloc]init];
        _userCode.text=@"";
        _userCode.font=[UIFont systemFontOfSize:16];
        _userCode.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _userCode.numberOfLines = 1;
        _userCode.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _userCode.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_userCode];
        
        [_userCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(userCodeLabel).offset(0);
            make.right.equalTo(self.contentView).offset(-10);
            
        }];
        
        
        UILabel* allmoneyTitle=[[UILabel alloc]init];
        allmoneyTitle.text=@"金额";
        allmoneyTitle.font=[UIFont systemFontOfSize:16];
        allmoneyTitle.textColor=[CommHelp toUIColorByStr:@"#777777"];
        allmoneyTitle.numberOfLines = 1;
        allmoneyTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
        allmoneyTitle.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:allmoneyTitle];
        
        [allmoneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userCodeLabel.mas_bottom).offset(10);
            make.left.equalTo(_displayImage.mas_right).offset(5);
            
        }];
        
        _allPrice=[[UILabel alloc]init];
        _allPrice.font=[UIFont systemFontOfSize:16];
        _allPrice.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _allPrice.numberOfLines = 1;
        _allPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _allPrice.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_allPrice];
        
        [_allPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(allmoneyTitle).offset(2);
            make.right.equalTo(self.contentView).offset(-10);
            
        }];
        
        _noteView=[[UIView alloc]init];
        _noteView.backgroundColor=[UIColor whiteColor];
        _noteView.layer.masksToBounds=YES;
        [self.contentView addSubview:_noteView];
        [_noteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_displayImage.mas_bottom).offset(10);
            make.left.equalTo(self.contentView).offset(0);
            make.right.equalTo(self.contentView).offset(0);
        }];
        
        UIView * line3=[[UIView alloc]init];
        line3.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
        [self.contentView addSubview:line3];
        
        [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(_noteView.mas_bottom).offset(0);
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
            make.bottom.equalTo(self.contentView);
        }];
        
        _orderTime=[[UILabel alloc]init];
        _orderTime.font=[UIFont systemFontOfSize:14];
        _orderTime.textColor=[CommHelp toUIColorByStr:@"#888888"];
        _orderTime.numberOfLines = 1;
        _orderTime.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _orderTime.lineBreakMode = NSLineBreakByWordWrapping;
        [_buttonBackView addSubview:_orderTime];
        
        [_orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_buttonBackView).offset(0);
            make.left.equalTo(_buttonBackView).offset(10);
            
        }];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font= [UIFont systemFontOfSize:12];
        button.layer.cornerRadius = 2.0;
        [button setTitle:@"开始鉴定" forState:UIControlStateNormal];
        [button setBackgroundColor:[CommHelp toUIColorByStr:@"#fee100"]];
        button.layer.borderWidth = 0;
        [button setTitleColor:[CommHelp toUIColorByStr:@"#444444"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.contentMode=UIViewContentModeScaleAspectFit;
        [_buttonBackView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(72, 30));
            make.centerY.equalTo(_buttonBackView);
            make.right.equalTo(_buttonBackView).offset(-10);
        }];
        
    }
    
    return self;
}
-(void)initNoteView{
    
    UIView * line=[[UIView alloc]init];
    line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
    [_noteView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(_noteView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.height.offset(1);
        
    }];
    
    UILabel  * title=[[UILabel alloc]init];
    title.text=@"备注";
    title.font= [UIFont fontWithName:kFontMedium size:12];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[CommHelp toUIColorByStr:@"#333333"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_noteView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noteView).offset(10);
        make.left.equalTo(_noteView).offset(15);
    }];
    
    UILabel * _note=[[UILabel alloc]init];
    _note.font=[UIFont systemFontOfSize:12];
    _note.textColor=[CommHelp toUIColorByStr:@"#666666"];
    _note.numberOfLines = 0;
    _note.text = self.orderMode.complementVo.remark;
    // _desc.backgroundColor=[UIColor redColor];
    _note.preferredMaxLayoutWidth = ScreenW-25;
    _note.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _note.lineBreakMode = NSLineBreakByWordWrapping;
    [_noteView addSubview:_note];
    [_note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(10);
        make.left.equalTo(title);
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
            make.height.offset((ScreenW-30)/5);
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
        float width=( ScreenW-30)/5;
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

-(void)setOrderMode:(OrderMode *)orderMode{
    
    _orderMode=orderMode;
    [_displayImage jhSetImageWithURL:[NSURL URLWithString:ThumbSmallByOrginal(_orderMode.goodsUrl)]];
    _orderCode.text=[NSString stringWithFormat:@"订单编号:  %@",_orderMode.orderCode];
    _orderTime.text=_orderMode.orderCreateTime;
    _cardCode.text=_orderMode.barCode;
    _userCode.text=_orderMode.buyerName;
    _allPrice.text=[@"¥ " stringByAppendingString:OBJ_TO_STRING(_orderMode.originOrderPrice)];
    
    [self.noteView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //有备注
    if (_orderMode.complementVo.remark.length>0||_orderMode.complementVo.pics.count>0 ) {
        [self initNoteView];
    }
    
}
-(void)buttonPress:(UIButton*)button{
    
    if (self.finishBlock) {
        self.finishBlock(self.indexPath);
    }
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end



//
//  JHStoneResaleSmallCollectionViewCell.m
//  TTjianbao
//
//  Created by jiang on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneResaleSmallCollectionViewCell.h"
#import "UIImage+GIF.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoUtil.h"
@interface JHStoneResaleSmallCollectionViewCell ()
{
    UIView *statusLivingImageView;
    UIView * infoView;
    UIButton *  liveEndLabel;
    UIView * intentionView;
    UIImageView *playIcon;
}
@property (strong, nonatomic)  UIImageView *coverImage;
@property (strong, nonatomic)  UILabel* title;
@property (strong, nonatomic)  UILabel *code;
@property (strong, nonatomic)  UILabel *dealCount;
@property (strong, nonatomic)  UILabel *intentionCount;
@property (strong, nonatomic)  UILabel *price;
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel* name;
@property (strong, nonatomic)  UILabel* tagLabel;
@property (strong, nonatomic)   UIImageView *tagImage;
@end

@implementation JHStoneResaleSmallCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
          self.backgroundColor = [UIColor whiteColor];
          self.layer.cornerRadius = 4;
          self.layer.masksToBounds = YES;
        
        UIView * backView=[[UIView alloc]init];
       // backView.layer.cornerRadius = 4;
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.masksToBounds = YES;
        //        backView.layer.shadowColor = [UIColor blackColor].CGColor;
        //        backView.layer.shadowOffset = CGSizeZero;
        //        backView.layer.shadowOpacity = 0.5;
        //        backView.layer.shadowRadius = 4;
        [self.contentView addSubview:backView];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        _coverImage=[[UIImageView alloc]init];
        _coverImage.image=[UIImage imageNamed:@""];
        _coverImage.userInteractionEnabled=YES;
        _coverImage.backgroundColor=[UIColor clearColor];
       // _coverImage.layer.cornerRadius = 4;
        _coverImage.contentMode=UIViewContentModeScaleAspectFill;
        _coverImage.layer.masksToBounds = YES;
        [backView addSubview:_coverImage];
        [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(backView);
            make.height.offset((ScreenW-25) * 0.5/StoneSmallCellImageRate);
        }];
        
        playIcon=[[UIImageView alloc]init];
        playIcon.image=[UIImage imageNamed:@"stoneresale_cell_play_icon"];
        playIcon.contentMode=UIViewContentModeScaleAspectFit;
        [_coverImage addSubview:playIcon];
        
        [playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_coverImage).offset(5);
            make.right.equalTo(_coverImage.mas_right).offset(-5);
        }];
        
        //
        infoView=[[UIView alloc]init];
        infoView.layer.masksToBounds=YES;
      //  infoView.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.2f];
        infoView.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        [_coverImage addSubview:infoView];
        
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_coverImage).offset(0);
            make.left.right.equalTo(_coverImage);
            make.height.offset(30);
        }];
        
        
//        _code=[[UILabel alloc]init];
//        _code.text=@"";
//        _code.font=[UIFont fontWithName:@"PingFangSC-Regular" size:13];
//        _code.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
//        _code.numberOfLines = 1;
//        _code.textAlignment = NSTextAlignmentLeft;
//        _code.lineBreakMode = NSLineBreakByTruncatingTail;
//        [infoView addSubview:_code];
//
//        [_code mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(infoView).offset(0);
//            make.left.equalTo(infoView).offset(7);
//        }];
        
        _title=[[UILabel alloc]init];
        _title.text=@"";
        _title.font=[UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _title.textColor=kColor333;
        _title.numberOfLines = 2;
       
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        [backView addSubview:_title];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_coverImage.mas_bottom).offset(3);
            make.left.offset(7);
            make.right.offset(-5);
        }];
        
        UIView * dealView=[[UIView alloc]init];
        [infoView addSubview:dealView];
        
        [dealView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_coverImage.mas_bottom).offset(0);
            make.height.offset(30);
            make.left.offset(0);
            make.width.offset((ScreenW-25) * 0.5*0.5);
        }];
        
        UIImageView *dealLogo=[[UIImageView alloc]init];
        dealLogo.image=[UIImage imageNamed:@"stoneresale_cell_eye_icon"];
        dealLogo.contentMode=UIViewContentModeScaleToFill;
        [dealView addSubview:dealLogo];
        
        [dealLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(14, 10));
            make.centerY.equalTo(dealView);
            make.left.equalTo(dealView).offset(7);
        }];
        
        _dealCount=[[UILabel alloc]init];
        _dealCount.text=@"";
        _dealCount.font=[UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _dealCount.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
        _dealCount.numberOfLines = 1;
        _dealCount.textAlignment = NSTextAlignmentLeft;
        _dealCount.lineBreakMode = NSLineBreakByWordWrapping;
        [dealView addSubview:_dealCount];
        
        [_dealCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dealView).offset(0);
            make.left.equalTo(dealLogo.mas_right).offset(2);
            make.right.equalTo(dealView.mas_right).offset(-2);
        }];
    
        intentionView=[[UIView alloc]init];
        [infoView addSubview:intentionView];
        [intentionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_coverImage.mas_bottom).offset(0);
            make.height.offset(30);
            make.left.offset((ScreenW-25) * 0.5*0.5);
            make.width.offset((ScreenW-25) * 0.5*0.5);
        }];
        
        UIImageView *intentionLogo=[[UIImageView alloc]init];
        intentionLogo.image=[UIImage imageNamed:@"stoneresale_cell_buy_icon"];
        intentionLogo.contentMode=UIViewContentModeScaleToFill;
        [intentionView addSubview:intentionLogo];
        
        [intentionLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(11, 10));
            make.centerY.equalTo(intentionView);
            make.left.equalTo(intentionView).offset(5);
        }];
        
        _intentionCount=[[UILabel alloc]init];
        _intentionCount.text=@"";
        _intentionCount.font=[UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _intentionCount.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
        _intentionCount.numberOfLines = 1;
        _intentionCount.textAlignment = NSTextAlignmentLeft;
        _intentionCount.lineBreakMode = NSLineBreakByWordWrapping;
        [intentionView addSubview:_intentionCount];
        
        [_intentionCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(intentionLogo).offset(0);
            make.left.equalTo(intentionLogo.mas_right).offset(2);
            make.right.equalTo(intentionView.mas_right).offset(-2);
        }];
        
        _price=[[UILabel alloc]init];
        _price.text=@"";
        _price.font=[UIFont fontWithName:kFontBoldDIN size:15];
        _price.textColor=kColorMainRed;
        _price.numberOfLines = 1;
        _price.textAlignment = NSTextAlignmentLeft;
        _price.lineBreakMode = NSLineBreakByWordWrapping;
        [backView addSubview:_price];
        
        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title.mas_bottom).offset(5);
            make.left.equalTo(backView).offset(7);
            make.right.equalTo(backView.mas_right).offset(-5);
            make.height.offset(20);
        }];
        
        _headImage=[[UIImageView alloc]init];
        _headImage.image=kDefaultAvatarImage;
        _headImage.layer.masksToBounds =YES;
        _headImage.layer.cornerRadius =8;
        [backView addSubview:_headImage];
        
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_price.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.left.offset(6);
        }];
        
        _name=[[UILabel alloc]init];
        _name.text=@"ddd";
        _name.font=[UIFont fontWithName:kFontNormal size:11];
        _name.textColor=kColor666;
        _name.numberOfLines = 1;
        _name.textAlignment = NSTextAlignmentLeft;
        _name.lineBreakMode = NSLineBreakByTruncatingTail;
        [backView addSubview:_name];
        
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_headImage).offset(0);
            make.left.equalTo(_headImage.mas_right).offset(5);
            make.right.equalTo(backView.mas_right);
        }];
        
        _tagImage =  [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"stone_live_name_icon"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0,5) resizingMode:UIImageResizingModeStretch] ];
        [_coverImage addSubview:_tagImage];
        
        [_tagImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(20);
            make.top.offset(5);
            make.left.offset(5);
        }];
        _tagLabel=[[UILabel alloc]init];
        _tagLabel.text=@"";
        _tagLabel.font=[UIFont fontWithName:kFontNormal size:11];
        _tagLabel.textColor=[UIColor colorWithHexString:@"ffffff"];
        _tagLabel.numberOfLines = 1;
        _tagLabel.textAlignment = NSTextAlignmentLeft;
        _tagLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_tagImage addSubview:_tagLabel];
        
        [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_tagImage).offset(0);
            make.left.equalTo(_tagImage).offset(5);
            make.right.equalTo(_tagImage.mas_right).offset(-5);
        }];
        
    }
    return self;
}

-(void)setMode:(JHMainViewStoneResaleModel *)mode{
    _mode=mode;
    _title.text = _mode.goodsTitle;
    
    _code.text=[NSString stringWithFormat:@"编号：%@",mode.goodsCode];
    _dealCount.text=[NSString stringWithFormat:@"%@热度",mode.seekCount];
    _intentionCount.text=[NSString stringWithFormat:@"%@人出价",mode.offerCount];
   // _price.text=[NSString stringWithFormat:@"¥ %@",mode.salePrice];
    NSString * string=[@"¥ " stringByAppendingString:_mode.salePrice?:@""];
       NSRange range = [string rangeOfString:@"¥"];
       _price.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:12.f] color:kColorMainRed range:range];
    _coverImage.contentMode=UIViewContentModeScaleAspectFill;
    JH_WEAK(self)
    [_coverImage jhSetImageWithURL:[NSURL URLWithString:_mode.goodsUrl] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        JH_STRONG(self)
        if (!image) {
            self.coverImage.contentMode=UIViewContentModeScaleAspectFill;
        }
    }];
     _name.text = _mode.channelName;
    [_headImage jhSetImageWithURL:[NSURL URLWithString:mode.imgUrl]];
    if ([_mode.label length]>0) {
        _tagLabel.text=_mode.label;
        _tagImage.hidden=NO;
    }
    else{
          _tagLabel.text=@"";
          _tagImage.hidden=YES;
    }
    
    if (self.resaleFlag) {
        [infoView setHidden:YES];
        [playIcon setHidden:!_mode.isVideo];
        _name.text = _mode.saleCustomerName;
    }
    else{
        [infoView setHidden:NO];
        [playIcon setHidden:NO];
        _name.text = _mode.channelName;
        
    }
}

- (void)tapAvatar:(UIGestureRecognizer *)gest {
    if (self.clickAvatar) {
        self.clickAvatar(self.mode);
    }
}

@end

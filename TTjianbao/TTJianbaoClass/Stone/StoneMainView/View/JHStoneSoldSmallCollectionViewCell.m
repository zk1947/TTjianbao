////
////  JHStoneSoldSmallCollectionViewCell.m
////  TTjianbao
////
////  Created by jiang on 2019/12/4.
////  Copyright © 2019 YiJian Tech. All rights reserved.
////
//
//#import "JHStoneSoldSmallCollectionViewCell.h"
//#import "UIImage+GIF.h"
//#import "TTjianbaoHeader.h"
//
//@interface JHStoneSoldSmallCollectionViewCell ()
//{
//    UIView *statusLivingImageView;
//    UIView * infoView;
//    UIButton *  liveEndLabel;
//}
//@property (strong, nonatomic)  UIImageView *coverImage;
//@property (strong, nonatomic)  UIImageView *headImage;
//@property (strong, nonatomic)  UILabel* title;
//@property (strong, nonatomic)  UILabel *code;
//@property (strong, nonatomic)  UILabel *dealCount;
//@property (strong, nonatomic)  UILabel *intentionCount;
//@property (strong, nonatomic)  UILabel *price;
//@property (strong, nonatomic)  UILabel *oldPrice;
//@property (strong, nonatomic)  UILabel *buyName;
//@end
//
//@implementation JHStoneSoldSmallCollectionViewCell
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//
//        self.backgroundColor = [UIColor whiteColor];
//
//        UIView * backView=[[UIView alloc]init];
//        backView.layer.cornerRadius = 4;
//        backView.backgroundColor = [UIColor whiteColor];
//        backView.layer.masksToBounds = YES;
//        //        backView.layer.shadowColor = [UIColor blackColor].CGColor;
//        //        backView.layer.shadowOffset = CGSizeZero;
//        //        backView.layer.shadowOpacity = 0.5;
//        //        backView.layer.shadowRadius = 4;
//        [self addSubview:backView];
//
//        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
//
//        _coverImage=[[UIImageView alloc]init];
//        _coverImage.image=[UIImage imageNamed:@""];
//        _coverImage.userInteractionEnabled=YES;
//        _coverImage.backgroundColor=[UIColor clearColor];
//        _coverImage.layer.cornerRadius = 4;
//        _coverImage.contentMode=UIViewContentModeScaleAspectFill;
//        _coverImage.layer.masksToBounds = YES;
//        [backView addSubview:_coverImage];
//        [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.equalTo(backView);
//            make.height.offset((ScreenW-25) * 0.5/StoneSmallCellImageRate);
//        }];
//
//        UIImageView *playIcon=[[UIImageView alloc]init];
//        playIcon.image=[UIImage imageNamed:@"stoneresale_cell_play_icon"];
//        playIcon.contentMode=UIViewContentModeScaleAspectFit;
//        [_coverImage addSubview:playIcon];
//
//        [playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_coverImage).offset(5);
//            make.right.equalTo(_coverImage.mas_right).offset(-5);
//        }];
//
//        //
//        UIView *infoView=[[UIView alloc]init];
//        infoView.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.2f];
//        [_coverImage addSubview:infoView];
//
//        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(_coverImage).offset(0);
//            make.left.right.equalTo(_coverImage);
//            make.height.offset(30);
//        }];
//
//
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
//
//        _title=[[UILabel alloc]init];
//        _title.text=@"";
//        _title.font=[UIFont fontWithName:@"PingFangSC-Medium" size:14];
//        _title.textColor=kColor333;
//        _title.numberOfLines = 2;
//        _title.textAlignment = UIControlContentHorizontalAlignmentCenter;
//        _title.lineBreakMode = NSLineBreakByTruncatingTail;
//        [backView addSubview:_title];
//
//        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_coverImage.mas_bottom).offset(0);
//            make.left.offset(5);
//            make.right.offset(-5);
//        }];
//
//        UILabel * buyNameLabel=[[UILabel alloc]init];
//        buyNameLabel.text=@"买家:";
//        buyNameLabel.font=[UIFont fontWithName:kFontNormal size:12];
//        buyNameLabel.textColor=kColor666;
//        buyNameLabel.numberOfLines = 1;
//        buyNameLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
//        buyNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        [backView addSubview:buyNameLabel];
//        [buyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_title.mas_bottom).offset(0);
//            make.height.offset(30);
//            make.left.offset(5);
//        }];
//        _headImage=[[UIImageView alloc]init];
//        _headImage.image=[UIImage imageNamed:@""];
//        _headImage.backgroundColor=[UIColor clearColor];
//        _headImage.layer.cornerRadius = 6;
//        _headImage.contentMode=UIViewContentModeScaleAspectFill;
//        _headImage.layer.masksToBounds = YES;
//        [backView addSubview:_headImage];
//        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(buyNameLabel).offset(0);
//            make.size.mas_equalTo(CGSizeMake(12, 12));
//            make.left.equalTo(buyNameLabel.mas_right).offset(5);
//        }];
//
//        _buyName=[[UILabel alloc]init];
//        _buyName.text=@"";
//        _buyName.font=[UIFont fontWithName:kFontNormal size:12];
//        _buyName.textColor=kColor666;
//        _buyName.numberOfLines = 1;
//        _buyName.textAlignment = UIControlContentHorizontalAlignmentCenter;
//        _buyName.lineBreakMode = NSLineBreakByTruncatingTail;
//        [backView addSubview:_buyName];
//
//        [_buyName mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(buyNameLabel).offset(0);
//            make.height.offset(30);
//            make.left.equalTo(_headImage.mas_right).offset(5);
//        }];
//
//        UILabel *priceLabel=[[UILabel alloc]init];
//        priceLabel.text=@"成交价:";
//        priceLabel.font=[UIFont fontWithName:kFontNormal size:12];
//        priceLabel.textColor=kColor333;
//        priceLabel.numberOfLines = 1;
//        priceLabel.textAlignment = NSTextAlignmentLeft;
//        priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        [backView addSubview:priceLabel];
//
//        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_buyName.mas_bottom).offset(0);
//            make.left.equalTo(backView).offset(5);
//            make.height.offset(30);
//        }];
//
//        _price=[[UILabel alloc]init];
//        _price.text=@"";
//        _price.font=[UIFont fontWithName:kFontBoldDIN size:15];
//        _price.textColor=kColorMainRed;
//        _price.numberOfLines = 1;
//        _price.textAlignment = NSTextAlignmentLeft;
//        _price.lineBreakMode = NSLineBreakByWordWrapping;
//        [backView addSubview:_price];
//
//        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
//             make.centerY.equalTo(priceLabel).offset(0);
//            make.left.equalTo(priceLabel.mas_right).offset(5);
//        }];
//
//        _oldPrice=[[UILabel alloc]init];
//        _oldPrice.text=@"";
//        _oldPrice.font=[UIFont fontWithName:kFontBoldDIN size:15];
//        _oldPrice.textColor=kColor666;
//        _oldPrice.numberOfLines = 1;
//        _oldPrice.textAlignment = NSTextAlignmentLeft;
//        _oldPrice.lineBreakMode = NSLineBreakByWordWrapping;
//        [backView addSubview:_oldPrice];
//
//        [_oldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_price).offset(0);
//            make.left.equalTo(_price.mas_right).offset(5);
//        }];
//
//    }
//    return self;
//}
//
//-(void)setMode:(JHMainViewStoneResaleModel *)mode{
//    _mode=mode;
//    _title.text = _mode.goodsTitle;
//    _code.text=[NSString stringWithFormat:@"编号：%@",mode.goodsCode];
//    //    _dealCount.text=[NSString stringWithFormat:@"第%@次交易",mode.dealSequence];
//    //    _intentionCount.text=[NSString stringWithFormat:@"%@人出价",mode.seekCount];
//     self.price.text=[NSString stringWithFormat:@"¥%@",mode.salePrice];
//      NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",mode.salePrice] attributes:attribtDic];
//        _oldPrice.attributedText = attribtStr;
//
//    _coverImage.contentMode=UIViewContentModeScaleAspectFill;
//    [_coverImage jhSetImageWithURL:[NSURL URLWithString:_mode.goodsUrl] placeholderImage:kDefaultCoverImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (!image) {
//            _coverImage.contentMode=UIViewContentModeScaleAspectFill;
//        }
//    }];
//    [_headImage jhSetImageWithURL:[NSURL URLWithString:_mode.img] placeholderImage:kDefaultAvatarImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//       }];
//      _buyName.text=[NSString stringWithFormat:@"%@",_mode.offerCustomerName];
//
////    if (_mode.img) {
////        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:_mode.img] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
////            if (image) {
////                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:@"买家: "];
////                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
////                attch.image = [CommHelp circleImage:image withParam:1];
////                attch.bounds = CGRectMake(0, -2,12,12);
////                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
////               // [attri insertAttributedString:string atIndex:2];
////                [attri appendAttributedString:string];
////                [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
////                [attri appendAttributedString:[[NSAttributedString alloc] initWithString:_mode.offerCustomerName?:@""] ];
////                _buyName.attributedText = attri;
////            }
////            else{
////                 _buyName.text=[NSString stringWithFormat:@"买家：%@",_mode.offerCustomerName];
////            }
////
////        }];
////    }
////    else{
////        _buyName.text=[NSString stringWithFormat:@"买家：%@",_mode.offerCustomerName];
////    }
//}
//
//- (void)tapAvatar:(UIGestureRecognizer *)gest {
//    if (self.clickAvatar) {
//        self.clickAvatar(self.mode);
//    }
//}
//
//@end

//
//  JHStoneSoldSmallCollectionViewCell.m
//  TTjianbao
//
//  Created by jiang on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneSoldSmallCollectionViewCell.h"
#import "UIImage+GIF.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoUtil.h"
@interface JHStoneSoldSmallCollectionViewCell ()
{
    UIView *statusLivingImageView;
    UIView * infoView;
    UIButton *  liveEndLabel;
    UIView * intentionView;
}
@property (strong, nonatomic)  UIImageView *coverImage;
@property (strong, nonatomic)  UILabel* title;
@property (strong, nonatomic)  UILabel *code;
@property (strong, nonatomic)  UILabel *dealCount;
@property (strong, nonatomic)  UILabel *intentionCount;
@property (strong, nonatomic)  UILabel *price;
@property (strong, nonatomic)  UILabel *oldPrice;
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel* name;
@end

@implementation JHStoneSoldSmallCollectionViewCell
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
        
        UIImageView *playIcon=[[UIImageView alloc]init];
        playIcon.image=[UIImage imageNamed:@"stoneresale_cell_play_icon"];
        playIcon.contentMode=UIViewContentModeScaleAspectFit;
        [_coverImage addSubview:playIcon];
        
        [playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_coverImage).offset(5);
            make.right.equalTo(_coverImage.mas_right).offset(-5);
        }];
        
        //
//        UIView *infoView=[[UIView alloc]init];
//        //  infoView.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.2f];
//        infoView.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
//        [_coverImage addSubview:infoView];
//        
//        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(_coverImage).offset(0);
//            make.left.right.equalTo(_coverImage);
//            make.height.offset(30);
//        }];
        
        
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
        
//        UIView * dealView=[[UIView alloc]init];
//        [_coverImage addSubview:dealView];
//
//        [dealView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(_coverImage.mas_bottom).offset(0);
//            make.height.offset(30);
//            make.left.offset(0);
//            make.width.offset((ScreenW-25) * 0.5*0.5);
//        }];
//
//        UIImageView *dealLogo=[[UIImageView alloc]init];
//        dealLogo.image=[UIImage imageNamed:@"stoneresale_cell_eye_icon"];
//        dealLogo.contentMode=UIViewContentModeScaleToFill;
//        [dealView addSubview:dealLogo];
//
//        [dealLogo mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(14, 10));
//            make.centerY.equalTo(dealView);
//            make.left.equalTo(dealView).offset(7);
//        }];
//
//        _dealCount=[[UILabel alloc]init];
//        _dealCount.text=@"";
//        _dealCount.font=[UIFont fontWithName:@"PingFangSC-Regular" size:12];
//        _dealCount.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
//        _dealCount.numberOfLines = 1;
//        _dealCount.textAlignment = NSTextAlignmentLeft;
//        _dealCount.lineBreakMode = NSLineBreakByWordWrapping;
//        [dealView addSubview:_dealCount];
//
//        [_dealCount mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(dealView).offset(0);
//            make.left.equalTo(dealLogo.mas_right).offset(2);
//            make.right.equalTo(dealView.mas_right).offset(-2);
//        }];
//
//        intentionView=[[UIView alloc]init];
//        [_coverImage addSubview:intentionView];
//        [intentionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(_coverImage.mas_bottom).offset(0);
//            make.height.offset(30);
//            make.left.offset((ScreenW-25) * 0.5*0.5);
//            make.width.offset((ScreenW-25) * 0.5*0.5);
//        }];
//
//        UIImageView *intentionLogo=[[UIImageView alloc]init];
//        intentionLogo.image=[UIImage imageNamed:@"stoneresale_cell_buy_icon"];
//        intentionLogo.contentMode=UIViewContentModeScaleToFill;
//        [intentionView addSubview:intentionLogo];
//
//        [intentionLogo mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(11, 10));
//            make.centerY.equalTo(intentionView);
//            make.left.equalTo(intentionView).offset(5);
//        }];
//
//        _intentionCount=[[UILabel alloc]init];
//        _intentionCount.text=@"";
//        _intentionCount.font=[UIFont fontWithName:@"PingFangSC-Regular" size:12];
//        _intentionCount.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
//        _intentionCount.numberOfLines = 1;
//        _intentionCount.textAlignment = NSTextAlignmentLeft;
//        _intentionCount.lineBreakMode = NSLineBreakByWordWrapping;
//        [intentionView addSubview:_intentionCount];
//
//        [_intentionCount mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(intentionLogo).offset(0);
//            make.left.equalTo(intentionLogo.mas_right).offset(2);
//            make.right.equalTo(intentionView.mas_right).offset(-2);
//        }];
//
      UILabel *priceLable=[[UILabel alloc]init];
        priceLable.text=@"成交价";
        priceLable.font=[UIFont fontWithName:kFontNormal size:12];
        priceLable.textColor=kColor333;
        priceLable.numberOfLines = 1;
        priceLable.textAlignment = NSTextAlignmentLeft;
        priceLable.lineBreakMode = NSLineBreakByWordWrapping;
        [backView addSubview:priceLable];
        
        [priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title.mas_bottom).offset(5);
            make.left.equalTo(backView).offset(7);
            make.height.offset(20);
        }];
        
        _price=[[UILabel alloc]init];
        _price.text=@"";
        _price.font=[UIFont fontWithName:kFontBoldDIN size:17];
        _price.textColor=kColorMainRed;
        _price.numberOfLines = 1;
        _price.textAlignment = NSTextAlignmentLeft;
        _price.lineBreakMode = NSLineBreakByWordWrapping;
        [backView addSubview:_price];
        
        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title.mas_bottom).offset(5);
            make.left.equalTo(priceLable.mas_right).offset(5);
            make.height.offset(20);
        }];
        
//                _oldPrice=[[UILabel alloc]init];
//                _oldPrice.text=@"221122";
//                _oldPrice.font=[UIFont fontWithName:kFontNormal size:10];
//                _oldPrice.textColor=kColor666;
//                _oldPrice.numberOfLines = 1;
//                _oldPrice.textAlignment = NSTextAlignmentLeft;
//                _oldPrice.lineBreakMode = NSLineBreakByWordWrapping;
//                [backView addSubview:_oldPrice];
//
//                [_oldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.centerY.equalTo(_price).offset(0);
//                    make.left.equalTo(_price.mas_right).offset(5);
//                }];
        
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
    NSString * string=[@"¥ " stringByAppendingString:_mode.dealPrice?:@""];
    NSRange range = [string rangeOfString:@"¥"];
    _price.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:12.f] color:kColorMainRed range:range];
//    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",mode.salePrice] attributes:attribtDic];
//    _oldPrice.attributedText = attribtStr;
    
    _coverImage.contentMode=UIViewContentModeScaleAspectFill;
    JH_WEAK(self)
    [_coverImage jhSetImageWithURL:[NSURL URLWithString:_mode.goodsUrl] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        JH_STRONG(self)
        if (!image) {
            self.coverImage.contentMode=UIViewContentModeScaleAspectFill;
        }
    }];
    _name.text = [NSString stringWithFormat:@"买家：%@",_mode.offerCustomerName];
    [_headImage jhSetImageWithURL:[NSURL URLWithString:mode.img]];
    
#warning //TODO Jiang  0元专区不显示
    //    if (1) {
    //        [intentionView setHidden:YES];
    //    }
}

- (void)tapAvatar:(UIGestureRecognizer *)gest {
    if (self.clickAvatar) {
        self.clickAvatar(self.mode);
    }
}

@end

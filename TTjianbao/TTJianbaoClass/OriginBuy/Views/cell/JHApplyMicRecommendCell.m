//
//  JHApplyMicRecommendCell.m
//  TTjianbao
//
//  Created by jiangchao on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHApplyMicRecommendCell.h"
#import "UIImage+GIF.h"
#import "TTjianbaoHeader.h"
#import "AnimotionObject.h"
#import "JHUIFactory.h"
#import "NTESLiveLikeView.h"

@interface JHApplyMicRecommendCell ()
{
    UIView *statusBackView;
    UIView * infoView;
    UIButton *  liveEndLabel;
}
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel* name;
@property (strong, nonatomic)  UIButton *likeImage;
@property (strong, nonatomic)  UILabel* title;
@property (strong, nonatomic)  UILabel *profession;
@property (strong, nonatomic)  UILabel *location;
@property (strong, nonatomic)  UILabel *gradeL;
@property (strong, nonatomic)  UILabel *authContent;
@property (strong, nonatomic)  UILabel *status;
@property (strong, nonatomic)  UILabel *onlineCount;
@property (strong, nonatomic)  UIImageView *coverImage;
@property (strong, nonatomic)   UIImageView *playingImage;
@property (strong, nonatomic)   UIImageView *restoreImage;
@property (strong, nonatomic)   UIImageView *redPacketImage;
@property (strong, nonatomic)   UIView *tagsBackView;

@end

@implementation JHApplyMicRecommendCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView * backView=[[UIView alloc]init];
        backView.layer.cornerRadius = 4;
        backView.backgroundColor = [UIColor clearColor];
        backView.layer.masksToBounds = YES;
        backView.layer.shadowColor = [UIColor blackColor].CGColor;
        backView.layer.shadowOffset = CGSizeZero;
        backView.layer.shadowOpacity = 0.5;
        backView.layer.shadowRadius = 0;
        [self.contentView addSubview:backView];
        
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        _coverImage=[[UIImageView alloc]init];
        _coverImage.image=[UIImage imageNamed:@""];
        _coverImage.userInteractionEnabled=YES;
        _coverImage.backgroundColor=[UIColor clearColor];
        _coverImage.layer.cornerRadius = 4;
        _coverImage.contentMode=UIViewContentModeScaleAspectFill;
        _coverImage.layer.masksToBounds = YES;
        [backView addSubview:_coverImage];
        
        [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(backView);
            
        }];
        
        //   home_video_list_title_back
        //
        UIImageView *infoView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_video_list_bottom_back"]];
        infoView.layer.masksToBounds = YES;
        [_coverImage addSubview:infoView];
        
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_coverImage).offset(0);
            make.left.right.equalTo(_coverImage);
            make.height.offset(50);
        }];
        
        _headImage=[[UIImageView alloc]init];
        _headImage.image=[UIImage imageNamed:@""];
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius = 6;
        _headImage.userInteractionEnabled=YES;
        _headImage.layer.borderColor = [UIColor whiteColor].CGColor;
        _headImage.layer.borderWidth = 1.f;
        [infoView addSubview:_headImage];
        
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(infoView).offset(-8);
            make.size.mas_equalTo(CGSizeMake(12, 12));
            make.left.offset(4);
        }];
        
//        _restoreImage=[[UIImageView alloc]init];
//        _restoreImage.image=[UIImage imageNamed:@"mall_smallcell_restonei_img"];
//        _restoreImage.contentMode=UIViewContentModeScaleToFill;
//        [infoView addSubview:_restoreImage];
//
//        [_restoreImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(18, 53));
//            make.centerY.equalTo(_headImage);
//            make.right.equalTo(infoView.mas_right).offset(-5);
//        }];
        
//        UIImageView *likeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_buy_like"]];
//        likeImage.contentMode = UIViewContentModeScaleAspectFit;
//        [infoView addSubview:likeImage];
//        [likeImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(infoView).offset(-9);
//            make.bottom.equalTo(infoView).offset(-13);
//            make.size.mas_equalTo(CGSizeMake(18, 19));
//        }];
        
        _name=[[UILabel alloc]init];
        _name.text=@"";
        _name.font=[UIFont fontWithName:kFontNormal size:8];
        _name.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
        _name.numberOfLines = 1;
        _name.textAlignment = NSTextAlignmentLeft;
        _name.lineBreakMode = NSLineBreakByTruncatingTail;
        [infoView addSubview:_name];
        
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headImage).offset(0);
            make.left.equalTo(_headImage.mas_right).offset(2);
            make.right.equalTo(infoView.mas_right).offset(-2);
        }];
        
        
//        UIImageView *locationLogo=[[UIImageView alloc]init];
//        locationLogo.image=[UIImage imageNamed:@"icon_buy_address"];
//        locationLogo.contentMode=UIViewContentModeScaleToFill;
//        [infoView addSubview:locationLogo];
//
//        [locationLogo mas_makeConstraints:^(MASConstraintMaker *make) {
//            // make.size.mas_equalTo(CGSizeMake(9, 11));
//            make.centerY.equalTo(_headImage).offset(8);
//            make.top.equalTo(_name.mas_bottom).offset(1);
//            make.left.equalTo(_headImage.mas_right).offset(5);
//        }];
//
//        _location=[[UILabel alloc]init];
//        _location.text=@"";
//        _location.font=[UIFont fontWithName:@"PingFangSC-Regular" size:9];
//        _location.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
//        _location.numberOfLines = 1;
//        _location.textAlignment = NSTextAlignmentLeft;
//        _location.lineBreakMode = NSLineBreakByWordWrapping;
//        [infoView addSubview:_location];
//
//        [_location mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(locationLogo).offset(0);
//            make.left.equalTo(locationLogo.mas_right).offset(2);
//        }];
//
        _title=[[UILabel alloc]init];
      //  _title.text=@"翡翠翡翠翡翠翡翠翡翠";
        _title.font=[UIFont fontWithName:kFontMedium size:9];
        _title.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
        _title.numberOfLines = 1;
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        [infoView addSubview:_title];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_headImage.mas_top).offset(-5);
            make.left.equalTo(infoView).offset(4);
            make.right.equalTo(infoView).offset(-4);
        }];
        
        //
        //        UIImageView *titleBack=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_video_list_bottom_back"]];
        //             titleBack.layer.masksToBounds = YES;
        //        [_coverImage addSubview:titleBack];
        //
        //        [titleBack mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(_coverImage).offset(0);
        //            make.left.right.equalTo(_coverImage);
        //            make.height.offset(50);
        //        }];
        
        statusBackView = [[UIView alloc] init];
        statusBackView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        statusBackView.layer.cornerRadius = 5;
        [_coverImage addSubview:statusBackView];
        
        [statusBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
            make.top.equalTo(_coverImage).offset(8);
          //  make.left.equalTo(_title);
             make.left.equalTo(_coverImage).offset(4);
        }];
        _playingImage=[[UIImageView alloc]init];
        _playingImage.contentMode=UIViewContentModeScaleAspectFit;
        [statusBackView addSubview:_playingImage];
        
        [_playingImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusBackView);
            make.left.equalTo(statusBackView).offset(5);
            make.size.mas_equalTo(CGSizeMake(5, 5));
        }];
        _status=[[UILabel alloc]init];
        _status.text=@"直播中";
        _status.font=[UIFont fontWithName:kFontNormal size:5];
        _status.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
        _status.numberOfLines = 1;
        _status.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _status.lineBreakMode = NSLineBreakByWordWrapping;
        [statusBackView addSubview:_status];
        
        [_status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusBackView);
            make.left.equalTo(_playingImage.mas_right).offset(2);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor whiteColor];
        [statusBackView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(statusBackView).offset(3);
            make.bottom.equalTo(statusBackView).offset(-3);
            make.left.equalTo(_status.mas_right).offset(3);
            make.width.offset(.5);
        }];
        
        _onlineCount=[[UILabel alloc]init];
        _onlineCount.text=@"";
        _onlineCount.font=[UIFont fontWithName:kFontNormal size:5];
        _onlineCount.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
        _onlineCount.numberOfLines = 1;
        _onlineCount.textAlignment = NSTextAlignmentLeft;
        _onlineCount.lineBreakMode = NSLineBreakByWordWrapping;
        [statusBackView addSubview:_onlineCount];
        
        [statusBackView addSubview:_onlineCount];
        [_onlineCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.mas_right).offset(3);
            make.right.equalTo(statusBackView.mas_right).offset(-5);
            make.centerY.equalTo(statusBackView);
            make.height.equalTo(statusBackView);
        }];
        
//        _redPacketImage=[[UIImageView alloc]init];
//        _redPacketImage.image=[UIImage imageNamed:@"mall_redPacket_icon"];
//        _redPacketImage.contentMode=UIViewContentModeScaleToFill;
//        [self.coverImage addSubview:_redPacketImage];
//
//        [_redPacketImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(28, 34));
//            make.top.equalTo(self.coverImage.mas_top).offset(10);
//            make.right.equalTo(self.coverImage.mas_right).offset(-10);
//        }];
        
    }
    return self;
}

-(void)setLiveRoomMode:(JHLiveRoomMode *)liveRoomMode{
    
    _liveRoomMode=liveRoomMode;
    _name.text=_liveRoomMode.anchorName;
    //  _profession.text=_liveRoomMode.anchorTitle;
    _location.text=_liveRoomMode.location;
    //    _title.text=_liveRoomMode.title;
    
    
    NSShadow *shadow = [[NSShadow alloc] init];
   // shadow.shadowBlurRadius = 2;//阴影半径，默认值3
   // shadow.shadowColor = [CommHelp toUIColorByStr:@"#666666"];;
   // shadow.shadowOffset = CGSizeMake(1, 1);//阴影偏移量，x向右偏移，y向下偏移，默认是（0，-3）
    NSAttributedString * attributedText = [[NSAttributedString alloc] initWithString:_liveRoomMode.title?:@"" attributes:@{NSShadowAttributeName:shadow}];
    _title.attributedText = attributedText;
    
    _restoreImage.hidden= YES;
    _redPacketImage.hidden=_liveRoomMode.hasRedPacket?NO:YES;
    if (!_redPacketImage.hidden) {
        [_redPacketImage.layer addAnimation:[AnimotionObject shakeAnimalGroup] forKey:@"shake"];
    }
    
    [_headImage jhSetImageWithURL:[NSURL URLWithString:liveRoomMode.anchorIcon] placeholder:kDefaultAvatarImage];
    
    _coverImage.contentMode=UIViewContentModeScaleAspectFill;
    JH_WEAK(self)
    [_coverImage jhSetImageWithURL:[NSURL URLWithString:liveRoomMode.smallCoverImg] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        JH_STRONG(self)
        if (!image) {
            self.coverImage.contentMode=UIViewContentModeScaleAspectFill;
        }
    }];
    
    if ([_liveRoomMode.status integerValue]==2) {
        
        [liveEndLabel setHidden:YES];
        _playingImage.image = [UIImage imageNamed:@"icon_buy_living"];
        _status.text=@"直播中";
        _onlineCount.text = [NSString stringWithFormat:@"%@热度",_liveRoomMode.watchTotal];
        [_status mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusBackView);
            make.left.equalTo(_playingImage.mas_right).offset(5);
        }];
    }
    
    else  if ([_liveRoomMode.status integerValue]==1){
        _onlineCount.text = [NSString stringWithFormat:@"%@热度",_liveRoomMode.watchTotal];
        _status.text=@"回放";
        _playingImage.image = [UIImage imageNamed:@""];
        [_status mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusBackView);
            make.left.equalTo(statusBackView).offset(5);
        }];
    }
    else {
        
        _onlineCount.text = [NSString stringWithFormat:@"%@热度",_liveRoomMode.watchTotal];
        _status.text=@"直播结束";
        _playingImage.image = [UIImage imageNamed:@""];
        [_status mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusBackView);
            make.left.equalTo(statusBackView).offset(5);
        }];
        
    }
}

@end

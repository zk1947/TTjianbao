//
//  JHMallSmallCollectionViewCell.m
//  TaodangpuAuction
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "JHMallSmallCollectionViewCell.h"
#import "UIImage+GIF.h"
#import "TTjianbaoHeader.h"
#import "AnimotionObject.h"

@interface JHMallSmallCollectionViewCell ()
{
    UIView *statusLivingImageView;
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
@property (strong, nonatomic)  UIButton *onlineCount;
@property (strong, nonatomic)  UIImageView *coverImage;
@property (strong, nonatomic)   UIImageView *playingImage;
@property (strong, nonatomic)   UIImageView *restoreImage;
@property (strong, nonatomic)   UIImageView *redPacketImage;
@property (strong, nonatomic)   UIView *tagsBackView;

@end

@implementation JHMallSmallCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
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
      
        _content=[[UIView alloc]init];
        _content.backgroundColor=[UIColor clearColor];
        [_coverImage addSubview:_content];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_coverImage);
        }];
        
        
        //
        UIImageView *infoView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_video_list_title_back"]];
          infoView.layer.masksToBounds = YES;
        [_coverImage addSubview:infoView];
        
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_coverImage).offset(0);
            make.left.right.equalTo(_coverImage);
            make.height.equalTo(self.coverImage).offset(63);
        }];
        
        _headImage=[[UIImageView alloc]init];
        _headImage.image=[UIImage imageNamed:@""];
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius = 15;
        _headImage.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar:)];
        [_headImage addGestureRecognizer:tap];
        [infoView addSubview:_headImage];
        
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(infoView).offset(7);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.offset(6);
        }];
        
        _restoreImage=[[UIImageView alloc]init];
        _restoreImage.image=[UIImage imageNamed:@""];
        _restoreImage.contentMode=UIViewContentModeScaleToFill;
        [infoView addSubview:_restoreImage];
        
        [_restoreImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(18, 53));
            make.centerY.equalTo(_headImage);
             make.right.equalTo(infoView.mas_right).offset(-5);
        }];
        
      
        
        _name=[[UILabel alloc]init];
        _name.text=@"";
        _name.font=[UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _name.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
        _name.numberOfLines = 1;
        _name.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _name.lineBreakMode = NSLineBreakByTruncatingTail;
        [infoView addSubview:_name];
        
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headImage).offset(-9);
            make.left.equalTo(_headImage.mas_right).offset(7);
            make.right.equalTo(_restoreImage.mas_left).offset(-5);
        }];
        
        
        UIImageView *locationLogo=[[UIImageView alloc]init];
        locationLogo.image=[UIImage imageNamed:@"new_home_location"];
        locationLogo.contentMode=UIViewContentModeScaleToFill;
        [infoView addSubview:locationLogo];
        
        [locationLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(9, 11));
            make.centerY.equalTo(_headImage).offset(11);
            make.left.equalTo(_headImage.mas_right).offset(5);
        }];
        
        _location=[[UILabel alloc]init];
        _location.text=@"";
        _location.font=[UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _location.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
        _location.numberOfLines = 1;
        _location.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _location.lineBreakMode = NSLineBreakByWordWrapping;
        [infoView addSubview:_location];
        
        [_location mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(locationLogo).offset(-1);
            make.left.equalTo(locationLogo.mas_right).offset(2);
            
        }];
        //
        UIImageView *titleBack=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_video_list_bottom_back"]];
             titleBack.layer.masksToBounds = YES;
        [_coverImage addSubview:titleBack];
        
        [titleBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_coverImage).offset(0);
            make.left.right.equalTo(_coverImage);
        }];
        
        _title=[[UILabel alloc]init];
        _title.text=@"";
        _title.font=[UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _title.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
        _title.numberOfLines = 1;
        _title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        [_coverImage addSubview:_title];
        
        
        _onlineCount = [UIButton buttonWithType:UIButtonTypeCustom];
        _onlineCount.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _onlineCount.backgroundColor = HEXCOLORA(0x000000, 0.7);
        _onlineCount.userInteractionEnabled = NO;
        [_onlineCount setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        _onlineCount.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _onlineCount.layer.cornerRadius = 2;
        _onlineCount.layer.masksToBounds = YES;
        
        [_coverImage addSubview:_onlineCount];
        
        
        
        
        statusLivingImageView = [[UIView alloc] init];
        statusLivingImageView.backgroundColor = kGlobalThemeColor;
        statusLivingImageView.layer.cornerRadius = 2;
        [_coverImage addSubview:statusLivingImageView];
        
        [statusLivingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.bottom.equalTo(_coverImage).offset(-10);
            make.left.equalTo(_title);
        }];
        
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(statusLivingImageView.mas_top).offset(-5);
            make.left.equalTo(titleBack).offset(11);
            make.right.equalTo(titleBack).offset(-10);
        }];
        
        [_onlineCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(statusLivingImageView.mas_right).offset(0);
            make.centerY.equalTo(statusLivingImageView);
            make.height.equalTo(statusLivingImageView);
        }];
        
        _playingImage=[[UIImageView alloc]init];
        _playingImage.contentMode=UIViewContentModeScaleAspectFit;
        [statusLivingImageView addSubview:_playingImage];
        
        [_playingImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusLivingImageView);
            make.left.equalTo(statusLivingImageView).offset(5);
            make.size.mas_equalTo(CGSizeMake(12, 13));
        }];
        
        _status=[[UILabel alloc]init];
        _status.text=@"直播中";
        _status.font=[UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _status.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _status.numberOfLines = 1;
        _status.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _status.lineBreakMode = NSLineBreakByWordWrapping;
        [statusLivingImageView addSubview:_status];
        
        [_status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusLivingImageView);
            make.right.equalTo(statusLivingImageView.mas_right).offset(-5);
            make.left.equalTo(_playingImage.mas_right).offset(0);
        }];
        
        _redPacketImage=[[UIImageView alloc]init];
        _redPacketImage.image=[UIImage imageNamed:@"mall_redPacket_icon"];
        _redPacketImage.contentMode=UIViewContentModeScaleToFill;
        [self.coverImage addSubview:_redPacketImage];
        
        [_redPacketImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(31, 40));
            make.bottom.equalTo(self.title.mas_top).offset(-10);
            make.right.equalTo(self.coverImage.mas_right).offset(-10);
        }];
        
        
        
        liveEndLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        liveEndLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        liveEndLabel.backgroundColor = HEXCOLORA(0x000000, 0.7);
        liveEndLabel.userInteractionEnabled = NO;
        [liveEndLabel setTitleColor:kGlobalThemeColor forState:UIControlStateNormal];
        liveEndLabel.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        liveEndLabel.layer.borderColor = kGlobalThemeColor.CGColor;
        liveEndLabel.layer.borderWidth = 1;
        liveEndLabel.layer.cornerRadius = 2;
        liveEndLabel.layer.masksToBounds = YES;
        [liveEndLabel setImage:[UIImage imageNamed:@"icon_mall_little_backplay"] forState:UIControlStateNormal];
        
        [_coverImage addSubview:liveEndLabel];
        
        [liveEndLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.equalTo(statusLivingImageView);
        }];
        
        
        
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
    shadow.shadowBlurRadius = 2;//阴影半径，默认值3
    shadow.shadowColor = [CommHelp toUIColorByStr:@"#666666"];;
    shadow.shadowOffset = CGSizeMake(1, 1);//阴影偏移量，x向右偏移，y向下偏移，默认是（0，-3）
    NSAttributedString * attributedText = [[NSAttributedString alloc] initWithString:_liveRoomMode.title?:@"" attributes:@{NSShadowAttributeName:shadow}];
    _title.attributedText = attributedText;
    
    _restoreImage.hidden=YES;
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
    //    _status.text=[NSString stringWithFormat:@"直播中  %@热度",_liveRoomMode.watchTotal];
    //    _gradeL.text=[NSString stringWithFormat:@"满意度%@%%",_liveRoomMode.grade];
    
    //    NSMutableString * string =[NSMutableString stringWithCapacity:10];
    //
    //    for (int i = 0; i < [_liveRoomMode.tags count]; ++i) {
    //        [string  appendString:[NSString stringWithFormat:@"%@  ",[_liveRoomMode.tags[i] objectForKey:@"tagName"]]];
    //    }
    //    _authContent.text=[NSString stringWithFormat:@"%@",string];
    
    if ([_liveRoomMode.status integerValue]==2) {
        
        [statusLivingImageView setHidden:NO];
        [liveEndLabel setHidden:YES];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"playingGif" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage* gifImage = [UIImage sd_imageWithGIFData:data];
        _playingImage.image = gifImage;
        [_onlineCount setTitle:[NSString stringWithFormat:@"%@热度",_liveRoomMode.watchTotal] forState:UIControlStateNormal];
    }
    
    else  if ([_liveRoomMode.status integerValue]==1){
        [_onlineCount setTitle:[NSString stringWithFormat:@"%@热度",_liveRoomMode.watchTotal] forState:UIControlStateNormal];
        [liveEndLabel setImage:[UIImage imageNamed:@"icon_mall_backplay"] forState:UIControlStateNormal];
        
        [liveEndLabel setTitle:@" 回放" forState:UIControlStateNormal];
        [statusLivingImageView setHidden:YES];
        [liveEndLabel setHidden:NO];
    }
    else {
        
        [liveEndLabel setTitle:@"直播结束" forState:UIControlStateNormal];
        [statusLivingImageView setHidden:YES];
        [liveEndLabel setHidden:NO];
        [_onlineCount setTitle:[NSString stringWithFormat:@"%@热度",_liveRoomMode.watchTotal] forState:UIControlStateNormal];
        [liveEndLabel setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }
}

- (void)tapAvatar:(UIGestureRecognizer *)gest {
    if (self.clickAvatar) {
        self.clickAvatar(self.liveRoomMode);
    }
}

@end

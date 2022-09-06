//
//  JHMallLittleCollectionViewCell.m
//  TTjianbao
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "JHMallLittleCollectionViewCell.h"
#import "TTjianbaoHeader.h"
#import "AnimotionObject.h"
#import "JHUIFactory.h"
#import "NTESLiveLikeView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"

@interface JHMallLittleCollectionViewCell ()
{
    UIView *statusBackView;
    UIView * infoView;
    UIButton *  liveEndLabel;
}
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel* name;
/** 活动图标*/
@property (nonatomic, strong) UIImageView *activeImageView;
@property (strong, nonatomic)  UILabel* title;    //标题
@property (nonatomic, strong)  YYLabel *tagLabel;   //连麦中标识
@property (strong, nonatomic)  UILabel *profession;
@property (strong, nonatomic)  YYLabel *location;   //位置
@property (strong, nonatomic)  UILabel *gradeL;
@property (strong, nonatomic)  UILabel *authContent;
@property (strong, nonatomic)  UILabel *status;
@property (strong, nonatomic)  UILabel *onlineCount;
@property (strong, nonatomic)  UIImageView *coverImage;
@property (strong, nonatomic)  YYAnimatedImageView *playingImage;
@property (strong, nonatomic)  UIImageView *restoreImage;
@property (strong, nonatomic)  UIImageView *redPacketImage;
@property (strong, nonatomic)  UIImageView *tagImage;
@property (strong, nonatomic)  UILabel *tagContent;
@property (nonatomic, strong) UIView *rankView;  //排名视图
@property (nonatomic, strong) UIImageView *rankLogoImageView;  //排名视图
@property (nonatomic, strong) UILabel *rankLabel;  //排名视图

@property (nonatomic, strong) UIView *livingStatusView;  //直播中黄色背景图
@end

@implementation JHMallLittleCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView * backView=[[UIView alloc]init];
        backView.layer.cornerRadius = 5;
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
        _coverImage.layer.cornerRadius = 5;
        _coverImage.contentMode=UIViewContentModeScaleAspectFill;
        _coverImage.layer.masksToBounds = YES;
        [backView addSubview:_coverImage];
        
        [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(backView);
            
        }];
        
        _tagImage=[[UIImageView alloc]init];
        _tagImage.image=[UIImage imageNamed:@""];
        _tagImage.contentMode=UIViewContentModeScaleAspectFit;
        _tagImage.backgroundColor = [UIColor clearColor];
        [self.coverImage addSubview:_tagImage];
        
        [_tagImage mas_makeConstraints:^(MASConstraintMaker *make) {
            // make.size.mas_equalTo(CGSizeMake(30, 240));
            make.width.offset(20);
            make.top.bottom.equalTo(self.coverImage);
            make.right.equalTo(self.coverImage.mas_right).offset(0);
        }];
        
        _tagContent=[[UILabel alloc]init];
        _tagContent.text=@"";
        
        _tagContent.textColor=kColorFFF;
        _tagContent.numberOfLines = 0;
        _tagContent.font=[UIFont fontWithName:kFontMedium size:13];
        _tagContent.textAlignment = NSTextAlignmentCenter;
        _tagContent.lineBreakMode = NSLineBreakByWordWrapping;
        [_tagImage addSubview:_tagContent];
      //  [UILabel changeLineSpaceForLabel:_tagContent WithSpace:2];
        
        [_tagContent mas_makeConstraints:^(MASConstraintMaker *make) {
            // make.top.equalTo(_tagImage).offset(10);
            make.centerY.equalTo(_tagImage);
            make.centerX.equalTo(_tagImage);
        }];
        
        _content=[[UIView alloc]init];
        _content.backgroundColor=[UIColor clearColor];
        [_coverImage addSubview:_content];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_coverImage);
        }];
        
        
        
        //   home_video_list_title_back
        //
        UIImageView *infoView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_video_list_bottom_back_new"]];
        infoView.layer.masksToBounds = YES;
        [_coverImage addSubview:infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_coverImage).offset(0);
            make.left.right.equalTo(_coverImage);
            make.height.offset(73.f);
        }];
        
        _headImage=[[UIImageView alloc]init];
        _headImage.image=[UIImage imageNamed:@""];
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius = 14;
        _headImage.userInteractionEnabled=YES;
        _headImage.layer.borderColor = [UIColor whiteColor].CGColor;
        _headImage.layer.borderWidth = 1.f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar:)];
        [_headImage addGestureRecognizer:tap];
        [infoView addSubview:_headImage];
        
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(infoView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(28, 28));
            make.left.offset(8);
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
        _name.font=[UIFont fontWithName:kFontMedium size:12];
        _name.textColor=HEXCOLOR(0xffffff);
        [infoView addSubview:_name];
        
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headImage.mas_top).offset(-2);
            make.left.equalTo(_headImage.mas_right).offset(5);
            make.height.mas_equalTo(16);
            make.right.mas_lessThanOrEqualTo(infoView.mas_right).offset(-58);
        }];
        
        _location=[[YYLabel alloc]init];
        _location.text=@"";
        _location.font=[UIFont fontWithName:kFontNormal size:10];
        _location.textColor= HEXCOLOR(0xffffff);
        _location.backgroundColor = HEXCOLORA(0x6e6e6e, 0.6);
        _location.textContainerInset = UIEdgeInsetsMake(0, 4, 0, 4);
        _location.layer.cornerRadius = 2;
        _location.clipsToBounds = YES;
        [infoView addSubview:_location];
        
        [_location mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.name.mas_centerY);
            make.left.equalTo(self.name.mas_right).offset(4);
            make.height.mas_equalTo(14);
            make.width.mas_lessThanOrEqualTo(48);
        }];
        
        _title=[[UILabel alloc]init];
        _title.text=@"";
        _title.font=[UIFont fontWithName:kFontNormal size:11];
        _title.textColor= HEXCOLOR(0xffffff);
        [infoView addSubview:_title];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_name.mas_left);
            make.top.equalTo(_name.mas_bottom);
            make.height.mas_equalTo(15);
            make.right.equalTo(infoView.mas_right).offset(-10);
        }];
        
        YYLabel *tagLabel = [[YYLabel alloc] init];
        tagLabel.text = @"";
        tagLabel.font = [UIFont fontWithName:kFontNormal size:10];
        tagLabel.textColor = HEXCOLOR(0x222222);
        tagLabel.backgroundColor = HEXCOLOR(0xf5d295);
        tagLabel.layer.cornerRadius = 3;
        tagLabel.clipsToBounds = YES;
        tagLabel.textContainerInset = UIEdgeInsetsMake(0, 4, 0, 4);
        _tagLabel = tagLabel;
        [_coverImage addSubview:_tagLabel];
        
        [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.bottom.equalTo(infoView.mas_top).offset(20.f);
            make.height.mas_equalTo(17);
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
        statusBackView.backgroundColor = HEXCOLORA(0x6e6e6e, 0.6);
        statusBackView.layer.cornerRadius = 3;
        statusBackView.clipsToBounds = YES;
        [_coverImage addSubview:statusBackView];
        
        [statusBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@16);
            make.top.equalTo(_coverImage).offset(8);
            make.left.equalTo(_coverImage).offset(8);
        }];
        
        _livingStatusView = [[UIView alloc] init];
        _livingStatusView.backgroundColor = HEXCOLOR(0xffd70f);
        [statusBackView addSubview:_livingStatusView];
        
        [_livingStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(statusBackView.mas_left);
            make.top.mas_equalTo(statusBackView.mas_top);
            make.bottom.mas_equalTo(statusBackView.mas_bottom);
        }];
        
        _playingImage=[[YYAnimatedImageView alloc]init];
        _playingImage.contentMode=UIViewContentModeScaleAspectFit;
        _playingImage.image = [UIImage imageNamed:@"mall_home_list_living.webp"];
        [_livingStatusView addSubview:_playingImage];
        
        [_playingImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_livingStatusView.mas_centerY);
            make.left.equalTo(_livingStatusView.mas_left).offset(3);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        _status=[[UILabel alloc]init];
        _status.text=@"直播";
        _status.font=[UIFont fontWithName:kFontMedium size:10];
        _status.textColor= kColor333;
        _status.numberOfLines = 1;
        _status.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _status.lineBreakMode = NSLineBreakByWordWrapping;
        [_livingStatusView addSubview:_status];
        
        [_status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_livingStatusView.mas_centerY);
            make.left.equalTo(_playingImage.mas_right).offset(3);
            make.right.mas_equalTo(_livingStatusView.mas_right).offset(-3);
        }];
        
        _onlineCount=[[UILabel alloc]init];
        _onlineCount.text=@"";
        _onlineCount.font=[UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _onlineCount.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
        _onlineCount.numberOfLines = 1;
        _onlineCount.clipsToBounds = YES;
        _onlineCount.textAlignment = NSTextAlignmentLeft;
        _onlineCount.lineBreakMode = NSLineBreakByWordWrapping;
        [statusBackView addSubview:_onlineCount];
        
        [statusBackView addSubview:_onlineCount];
        [_onlineCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_livingStatusView.mas_right).offset(3);
            make.right.equalTo(statusBackView.mas_right).offset(-3);
            make.centerY.equalTo(statusBackView);
            make.height.equalTo(statusBackView);
        }];
        
        /** 添加排名视图*/
        _rankView = [[UIView alloc] init];
        _rankView.backgroundColor = HEXCOLORA(0xde2d12, 0.64);
        _rankView.layer.cornerRadius = 3;
        _rankView.clipsToBounds = YES;
        [_coverImage addSubview:_rankView];
        
        _rankLogoImageView = [[UIImageView alloc] init];
        _rankLogoImageView.image = [UIImage imageNamed:@"custmoize_fire_logo"];
        [_rankView addSubview:_rankLogoImageView];
        
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.font = [UIFont fontWithName:kFontNormal size:11];
        _rankLabel.textColor = [UIColor whiteColor];
        _rankLabel.text = @"";
        [_rankView addSubview:_rankLabel];
        
        [_rankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(statusBackView.mas_left);
            make.top.mas_equalTo(statusBackView.mas_bottom).offset(8);
            make.height.mas_equalTo(18);
        }];
        
        [_rankLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_rankView.mas_left).offset(5);
            make.centerY.mas_equalTo(_rankView.mas_centerY);
        }];
        
        [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_rankLogoImageView.mas_right).offset(5);
            make.centerY.mas_equalTo(_rankView.mas_centerY);
            make.right.mas_equalTo(_rankView.mas_right).offset(-5);
        }];
        
        _redPacketImage=[[UIImageView alloc]init];
        _redPacketImage.image=[UIImage imageNamed:@"mall_redPacket_icon"];
        _redPacketImage.contentMode=UIViewContentModeScaleToFill;
        [self.coverImage addSubview:_redPacketImage];
        
        [_redPacketImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(31, 40));
            make.top.equalTo(self.coverImage.mas_top).offset(8);
            make.right.equalTo(self.coverImage.mas_right).offset(-8);
        }];
        
        _activeImageView = [[UIImageView alloc] init];
        _activeImageView.contentMode=UIViewContentModeScaleAspectFit;
        _activeImageView.clipsToBounds = YES;
        _activeImageView.hidden = YES;
        _activeImageView.backgroundColor = [UIColor clearColor];
        [_activeImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfoRequestManager sharedInstance].activityIcon]];
//        _activeImageView.image = [UIImage imageNamed:@"activity_1111"];
        [self.coverImage addSubview:_activeImageView];
        
        [_activeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.coverImage.mas_top);
            make.right.equalTo(self.coverImage.mas_right).offset(-10);
            //size自适应
            make.width.equalTo(@37);
            make.height.equalTo(@48);
        }];
        /** 活动标签提到最上面*/
        [_activeImageView bringSubviewToFront:self.coverImage];
        
    }
    return self;
}

-(void)setLiveRoomMode:(JHLiveRoomMode *)liveRoomMode{
    
    _liveRoomMode=liveRoomMode;
    _name.text=_liveRoomMode.anchorName;
    _location.text = _liveRoomMode.location? : @"未知";
    
    NSString *string = @"";
    if ([liveRoomMode.canCustomize isEqualToString:@"1"]) {
        string = [string stringByAppendingString:@"支持定制"];
    }
    if (liveRoomMode.connectingFlag) {
        if (string.length > 0) {
            string = [string stringByAppendingString:@" | "];
        }
        string = [string stringByAppendingString:@"连麦中"];
    }
    /** 设置logo状态*/
    if (string.length > 0) {
        _tagLabel.textContainerInset = UIEdgeInsetsMake(0, 4, 0, 4);
    }else{
        _tagLabel.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    _tagLabel.text = string;
    _tagContent.text = @"";
    JH_WEAK(self)
    [_tagImage jhSetImageWithURL:[NSURL URLWithString:_liveRoomMode.tagUrl?:@""] placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        JH_STRONG(self)
        if ([self.liveRoomMode.tagContent length]>0) {
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            style.maximumLineHeight = 15;
            style.minimumLineHeight = 15;
            style.alignment = NSTextAlignmentCenter;
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.liveRoomMode.tagContent];
            [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.liveRoomMode.tagContent.length)];
            self.tagContent.attributedText = attrString;
            [self.tagContent sizeToFit];
        }
    }];
    
    NSShadow *shadow = [[NSShadow alloc] init];
   // shadow.shadowBlurRadius = 2;//阴影半径，默认值3
   // shadow.shadowColor = [CommHelp toUIColorByStr:@"#666666"];;
   // shadow.shadowOffset = CGSizeMake(1, 1);//阴影偏移量，x向右偏移，y向下偏移，默认是（0，-3）
    NSAttributedString * attributedText = [[NSAttributedString alloc] initWithString:_liveRoomMode.title?:@"" attributes:@{NSShadowAttributeName:shadow}];
    _title.attributedText = attributedText;
    
    _restoreImage.hidden = YES;
    _redPacketImage.hidden= _liveRoomMode.hasRedPacket ? NO : YES;
    if (_redPacketImage.hidden) {
        _activeImageView.hidden = [UserInfoRequestManager sharedInstance].showActivityFlag ? NO : YES;
    }else{
        _activeImageView.hidden = YES;
    }
    if (!_redPacketImage.hidden) {
        [_redPacketImage.layer addAnimation:[AnimotionObject shakeAnimalGroup] forKey:@"shake"];
    }
    
    [_headImage jhSetImageWithURL:[NSURL URLWithString:liveRoomMode.anchorIcon] placeholder:kDefaultAvatarImage];
    
    _coverImage.contentMode=UIViewContentModeScaleAspectFill;
    [_coverImage jhSetImageWithURL:[NSURL URLWithString:liveRoomMode.smallCoverImg] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (!image) {
            JH_STRONG(self)
            self.coverImage.contentMode=UIViewContentModeScaleAspectFill;
        }
    }];

    if ([_liveRoomMode.status integerValue]==2) {
        _playingImage.image = [YYImage imageNamed:@"mall_home_list_living.webp"];
        _status.text=@"直播";
        _onlineCount.text = [NSString stringWithFormat:@"%@热度",_liveRoomMode.watchTotalString];
        _livingStatusView.backgroundColor = HEXCOLOR(0xffd70f);
        _status.textColor = HEXCOLOR(0x333333);
   
        [_status mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_livingStatusView.mas_centerY);
            make.left.equalTo(_playingImage.mas_right).offset(3);
            make.right.mas_equalTo(_livingStatusView.mas_right).offset(-3);
        }];
    }
    
    else  if ([_liveRoomMode.status integerValue]==1){
        _onlineCount.text = [NSString stringWithFormat:@"%@热度",_liveRoomMode.watchTotalString];
        _status.text=@"回放";
        _livingStatusView.backgroundColor = HEXCOLOR(0x808ba3);
        _status.textColor = HEXCOLOR(0xffffff);
        _playingImage.image = [UIImage imageNamed:@"custmoize_review_logo"];
   
        [_status mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_livingStatusView.mas_centerY);
            make.left.equalTo(_playingImage.mas_right).offset(3);
            make.right.mas_equalTo(_livingStatusView.mas_right).offset(-3);
        }];
    }
    else {
        
        _onlineCount.text = [NSString stringWithFormat:@"%@热度",_liveRoomMode.watchTotalString];
        _status.text=@"直播结束";
        _livingStatusView.backgroundColor = HEXCOLOR(0x808ba3);
        _status.textColor = HEXCOLOR(0xffffff);
        _playingImage.image = [UIImage imageNamed:@""];
        [_status mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_livingStatusView.mas_centerY);
            make.left.equalTo(_playingImage.mas_left);
            make.right.mas_equalTo(_livingStatusView.mas_right).offset(-3);
        }];
    }
    if (liveRoomMode.customizedFlag && [_liveRoomMode.status integerValue] != 2) {//定制
        _onlineCount.text = [NSString stringWithFormat:@""];
        _status.text=@"休息中";
        _livingStatusView.backgroundColor = HEXCOLOR(0x808ba3);
        _status.textColor = HEXCOLOR(0xffffff);
        _playingImage.image = [UIImage imageNamed:@""];
        [_status mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_livingStatusView.mas_centerY);
            make.left.equalTo(_playingImage.mas_left);
            make.right.mas_equalTo(_livingStatusView.mas_right).offset(-3);
        }];
    }
    
    if ([_liveRoomMode.watchTotalString isEqualToString:@"0"] || (liveRoomMode.customizedFlag && [_liveRoomMode.status integerValue] != 2)) {
        _onlineCount.text = @"";
        [_onlineCount mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_livingStatusView.mas_right);
            make.right.equalTo(statusBackView.mas_right);
        }];
    }else{
        [_onlineCount mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_livingStatusView.mas_right).offset(3);
            make.right.equalTo(statusBackView.mas_right).offset(-3);
        }];
    }
    
    //回收直播
    if ([liveRoomMode.recycleFlag boolValue] && [_liveRoomMode.status integerValue] != 2) {
        _onlineCount.text = @"";
        _status.text = @"休息中";
        _livingStatusView.backgroundColor = HEXCOLOR(0x808ba3);
        _status.textColor = HEXCOLOR(0xffffff);
        _playingImage.image = [UIImage imageNamed:@""];
        [_status mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_livingStatusView.mas_centerY);
            make.left.equalTo(_playingImage.mas_left);
            make.right.mas_equalTo(_livingStatusView.mas_right).offset(-3);
        }];
        [_onlineCount mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_livingStatusView.mas_right);
            make.right.equalTo(statusBackView.mas_right);
        }];
    }
    
    /** 显示排名*/
    if (liveRoomMode.activityRank.length > 0) {
        _rankLabel.text = liveRoomMode.activityRank;
        _rankView.hidden = NO;
    }else{
        _rankView.hidden = YES;
    }
}

- (void)tapAvatar:(UIGestureRecognizer *)gest {
    if (self.clickAvatar) {
        self.clickAvatar(self.liveRoomMode);
    }
}

@end

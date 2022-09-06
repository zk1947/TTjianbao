//
//  JHAudienceConnectView.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/15.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "JHAudienceConnectView.h"
#import "ChannelMode.h"
#import "UIView+NTES.h"
#import "NTESDataManager.h"
#import "NIMAvatarImageView.h"
#import "NTESLiveManager.h"
#import "UIImage+GIF.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoBussiness.h"
#import "UIView+CornerRadius.h"
#import "UIImage+JHColor.h"
@interface JHAudienceConnectView()

@property (nonatomic, strong) UIImageView *bar;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *anchorAvatar;
@property (nonatomic, strong) UIImageView *audienceAvatar;

@property (nonatomic, strong) UILabel *waitingNumLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation JHAudienceConnectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

      //  _bar =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_rect_black"]];
         _bar =  [[UIImageView alloc] init];
        _bar.backgroundColor = [CommHelp toUIColorByStr:@"#ffffff"];
        _bar.frame= CGRectMake(0, 0, frame.size.width, 255.f);
        _bar.userInteractionEnabled=YES;
        _bar.layer.masksToBounds = YES;
         [_bar yd_setCornerRadius:8.f corners:UIRectCornerTopLeft | UIRectCornerTopRight];
         [self addSubview:_bar];
        
        
        UIView *topView =  [[UIView alloc] init];
        // topView.frame = CGRectMake(0,0,375,50);
        topView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        topView.layer.cornerRadius = 0;
        topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
        topView.layer.shadowOffset = CGSizeMake(0,1);
        topView.layer.shadowOpacity = 1;
        topView.layer.shadowRadius = 5;
        [_bar addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((_bar)).offset(0);
            make.left.right.equalTo(_bar);
            make.height.offset(50);
            
        }];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = kColor333;
        _titleLabel.text=@"排队中";
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15.f];
        [topView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          //  make.top.equalTo((_bar)).offset(15);
            make.center.equalTo(topView);
        }];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"new_appraisal_close"] forState:UIControlStateNormal ];
         closeButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:closeButton];

        
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel);
            make.right.equalTo(topView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
//        UIImageView *line =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connect_line"]];
//
//        [_bar addSubview:line];
//
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo((_titleLabel.mas_bottom)).offset(15);
//            make.width.equalTo(_bar);
//            make.height.offset(1);
//        }];
        
        UIImageView *gifImageView = [[UIImageView alloc]init ];
        gifImageView.contentMode=UIViewContentModeScaleAspectFit;
        [_bar addSubview:gifImageView];
        
        [gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((_titleLabel.mas_bottom)).offset(10);
            make.centerX.equalTo(_bar);
            make.size.mas_equalTo(CGSizeMake(100, 100));
            
        }];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"waitconnect_an" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage* gifImage = [UIImage sd_imageWithGIFData:data];
        gifImageView.image = gifImage;
        
        _anchorAvatar = [[UIImageView alloc]init ];
        _anchorAvatar.image=kDefaultAvatarImage;
        _anchorAvatar.layer.masksToBounds =YES;
        _anchorAvatar.layer.cornerRadius =30;
        _anchorAvatar.layer.borderWidth = 1;
        _anchorAvatar.layer.borderColor = HEXCOLOR(0xFEE100).CGColor;
        [_bar addSubview:_anchorAvatar];
        
        [_anchorAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(gifImageView);
            make.right.equalTo(gifImageView.mas_left).offset(-20);
            make.height.width.equalTo(@60);

        }];
        
        _audienceAvatar = [[UIImageView alloc] init];
        _audienceAvatar.layer.masksToBounds =YES;
        _audienceAvatar.layer.cornerRadius =30;
        _audienceAvatar.layer.borderWidth = 1;
        _audienceAvatar.layer.borderColor = HEXCOLOR(0xFEE100).CGColor;
        [_bar addSubview:_audienceAvatar];
        _audienceAvatar.image=kDefaultAvatarImage;
        [_audienceAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerY.equalTo(gifImageView);
            make.left.equalTo(gifImageView.mas_right).offset(20);
            make.height.width.equalTo(@60);
            
        }];
        
        _waitingNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _waitingNumLabel.font = [UIFont fontWithName:kFontNormal size:13.f];
          _waitingNumLabel.textAlignment = NSTextAlignmentCenter;
        _waitingNumLabel.text=@"";
        [_waitingNumLabel setTextColor:HEXCOLOR(0x333333)];
        [_bar addSubview:_waitingNumLabel];
        
        [_waitingNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo((_bar));
            make.top.equalTo(_anchorAvatar.mas_bottom).offset(15);
         
        }];
        
//        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _timeLabel.font = [UIFont systemFontOfSize:15.f];
//
//        [_timeLabel setTextColor:HEXCOLOR(0x999999)];
//        [_bar addSubview:_timeLabel];
//
//        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo((_audienceAvatar));
//            make.top.equalTo(_audienceAvatar.mas_bottom).offset(15);
//
//        }];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // [_cancelButton setBackgroundImage:[UIImage imageNamed:@"connect_press"] forState:UIControlStateNormal ];
        [_cancelButton setTitle:@"取消排队" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [_cancelButton setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        _cancelButton.tag = 1;
        UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(120, 38) radius:19];
        [_cancelButton setBackgroundImage:nor_image forState:UIControlStateNormal];
      //  _cancelButton.layer.cornerRadius = 15.0;
        //  [_cancelButton setBackgroundColor:[UIColor whiteColor]];
       // _cancelButton.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
       // _cancelButton.layer.borderWidth = 0.5f;
        //  _cancelButton.contentMode=UIViewContentModeScaleAspectFit;
        [_cancelButton addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bar addSubview:_cancelButton];
        
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo((_anchorAvatar));
            make.top.equalTo(_waitingNumLabel.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(120, 38));
        }];
        
        UIButton  *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setTitle:@"逛逛直播购物" forState:UIControlStateNormal];
        backBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        backBtn.tag = 2;
        [backBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        backBtn.layer.cornerRadius = 19.0;
        [backBtn setBackgroundColor:[UIColor whiteColor]];
        backBtn.layer.borderColor = [CommHelp toUIColorByStr:@"#bdbfc2"].CGColor;
        backBtn.layer.borderWidth = 0.5f;
        //  _cancelButton.contentMode=UIViewContentModeScaleAspectFit;
        [backBtn addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bar addSubview:backBtn];
               
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo((_audienceAvatar));
            make.top.equalTo(_waitingNumLabel.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(120, 38));
        }];
        
         [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setChannel:(ChannelMode *)channel{
    
    _channel=channel;
    [_anchorAvatar jhSetImageWithURL:[NSURL URLWithString:_channel.anchorIcon ] placeholder:kDefaultAvatarImage];
    User *user = [UserInfoRequestManager sharedInstance].user;
    [_audienceAvatar jhSetImageWithURL:[NSURL URLWithString:user.icon] placeholder:kDefaultAvatarImage];
}
- (void)setType:(NIMNetCallMediaType)type
{
    _type = type;
    NSString *connect = @"";
    switch (type) {
        case NIMNetCallMediaTypeVideo:
            connect = @"视频";
            break;
        case NIMNetCallMediaTypeAudio:
            connect = @"音频";
            break;
        default:
            break;
    }
    _titleLabel.text = [NSString stringWithFormat:@"已申请与主播%@连线", connect];
    [_titleLabel sizeToFit];
}

- (void)setRoomId:(NSString *)roomId
{
//    [self.avatar nim_setImageWithURL:nil placeholderImage:[NTESDataManager sharedInstance].defaultUserAvatar];
//    NIMChatroom *chatroom = [[NTESLiveManager sharedInstance] roomInfo:roomId];
//    [_nameLabel setText:chatroom.creator];
//    [_nameLabel sizeToFit];
//    __weak typeof(self) weakSelf = self;
//    [[NTESLiveManager sharedInstance] anchorInfo:chatroom.roomId handler:^(NSError *error, NIMChatroomMember *anchor) {
//        [weakSelf.avatar nim_setImageWithURL:nil placeholderImage:[NTESDataManager sharedInstance].defaultUserAvatar];
//        [weakSelf.nameLabel setText:anchor.roomNickname];
//        [weakSelf.nameLabel sizeToFit];
//        [weakSelf setNeedsLayout];
//    }];
}

- (void)onTapBackground:(UIButton *)button
{
      [JHGrowingIO trackEventId:JHTracklive_identifywait_closebtn variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
      [self dismiss];
}
- (void)close
{
    //[JHGrowingIO trackEventId:JHLiveRoomMicCloseClick];
  
    [self dismiss];
   
}

- (void)onTouchButton:(UIButton *)button
{
      
    if (button.tag == 1) {
        [JHGrowingIO trackEventId:JHTracklive_identifywait_cancelbtn variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        if ([self.delegate respondsToSelector:@selector(onCancelConnect:)]) {
            [self.delegate onCancelConnect:button];
        }
    }
   if (button.tag == 2) {
      if ([self.delegate respondsToSelector:@selector(onBackSourceMall:)]) {
              [self.delegate onBackSourceMall:button];
             [JHGrowingIO trackEventId:JHLiveRoomMicBackMallClick];
          }
   }
    [self dismiss];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.bar.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom = self.height;
    }];
}

- (void)dismiss
{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)setWaitNum:(NSInteger)waitNum andWaitTime:(float)time{

    _waitingNumLabel.text=[NSString stringWithFormat:@"前面排队%ld人,大概需要%.0lf分钟",waitNum-1,time/60];
   // _timeLabel.text=[NSString stringWithFormat:@"大概需要%.0lf分钟",time/60];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bar.bottom = self.height;

//    CGFloat buttonSpacing = 65.f;
//    self.cancelButton.width = self.width - 2 * buttonSpacing;
//
//    CGFloat top = 10;
//    CGFloat titleAndAvatarSpacing = 14;
//    CGFloat avatarAndNameSpacing  = 2;
//    CGFloat nameAndButtonSpacing  = 10;
//
//    self.titleLabel.top = top;
//    self.titleLabel.centerX = self.width * .5f;
//    self.avatar.top = self.titleLabel.bottom + titleAndAvatarSpacing;
//    self.avatar.centerX = self.width * .5f;
//    self.nameLabel.top = self.avatar.bottom + avatarAndNameSpacing;
//    self.nameLabel.centerX = self.width * .5f;
//    self.cancelButton.top  = self.nameLabel.bottom + nameAndButtonSpacing;
//    self.cancelButton.centerX = self.width * .5f;
}

@end

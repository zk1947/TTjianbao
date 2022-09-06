//
//  JHMallWatchTrackCollectionViewCell.m
//  TTjianbao
//
//  Created by jiang on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallWatchTrackCollectionViewCell.h"
#import "UIImage+GIF.h"
#import "TTjianbaoHeader.h"

@interface JHMallWatchTrackCollectionViewCell ()
{
    UIView *statusLivingImageView;
}
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel* title;
@property (strong, nonatomic)  UILabel *status;
@property (strong, nonatomic)   UIImageView *playingImage;
@property (strong, nonatomic)   UILabel *followCount;
@property (strong, nonatomic)   UIButton * followBtn;
@end

@implementation JHMallWatchTrackCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       // self.backgroundColor = [UIColor whiteColor];
      //  self.backgroundColor = [CommHelp randomColor];
        
        UIView *back = [[UIView alloc] init];
        back.layer.cornerRadius = 8;
        back.layer.masksToBounds = YES;
        back.backgroundColor = [CommHelp  toUIColorByStr:@"#ffffff"];
        [self.contentView addSubview:back];
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
        
        UIImageView *circleImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mall_like_circle_img"]];
        [self.contentView addSubview:circleImage];
        
        [circleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
            make.size.mas_equalTo(CGSizeMake(63, 63));
            make.centerX.equalTo(self.contentView);
        }];
        
        _headImage=[[UIImageView alloc]init];
        _headImage.image=kDefaultCoverImage;
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius = 27;
        _headImage.userInteractionEnabled=YES;
        //        _headImage.layer.borderColor = [[CommHelp toUIColorByStr:@"#fee100"] colorWithAlphaComponent:1.0].CGColor;
        [circleImage addSubview:_headImage];
        
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(54, 54));
            make.center.equalTo(circleImage);
        }];
        
        statusLivingImageView = [[UIView alloc] init];
        statusLivingImageView.backgroundColor =[[CommHelp toUIColorByStr:@"#000000"] colorWithAlphaComponent:.6];
        [_headImage addSubview:statusLivingImageView];
        
        [statusLivingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@18);
            make.bottom.equalTo(_headImage.mas_bottom).offset(0);
            make.left.right.equalTo(_headImage);
        }];
        
        //        _playingImage=[[UIImageView alloc]init];
        //        _playingImage.contentMode=UIViewContentModeScaleAspectFit;
        //        [statusLivingImageView addSubview:_playingImage];
        //
        //        [_playingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.centerY.equalTo(statusLivingImageView);
        //            make.left.equalTo(statusLivingImageView).offset(10);
        //            make.size.mas_equalTo(CGSizeMake(15, 17));
        //        }];
        
        _status=[[UILabel alloc]init];
        _status.text=@"直播中";
        _status.font=[UIFont fontWithName:kFontNormal size:8];
        _status.textColor=kColorMain;
        _status.numberOfLines = 1;
        _status.textAlignment = NSTextAlignmentCenter;
        _status.lineBreakMode = NSLineBreakByWordWrapping;
        [statusLivingImageView addSubview:_status];
        
        [_status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusLivingImageView);
            make.right.equalTo(statusLivingImageView.mas_right).offset(0);
            make.left.equalTo(statusLivingImageView.mas_left).offset(0);
        }];
        
        _title=[[UILabel alloc]init];
        _title.text=@"";
        _title.font=[UIFont fontWithName:kFontMedium size:14];
        _title.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _title.numberOfLines = 1;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(circleImage.mas_bottom).offset(10);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
           
          //  make.centerX.equalTo(circleImage);
        }];
        
        UIView *followBack = [[UIView alloc] init];
        [self.contentView addSubview:followBack];
        [followBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.height.offset(20);
            make.top.equalTo(_title.mas_bottom).offset(5);
        }];
        
        UIImageView *icon=[[UIImageView alloc]init];
        icon.image=[UIImage imageNamed:@"mall_track_follow_icon"];
        icon.contentMode=UIViewContentModeScaleToFill;
        [followBack addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8,9));
             make.centerY.equalTo(followBack);
             make.left.equalTo(followBack).offset(0);
        }];
        
        _followCount=[[UILabel alloc]init];
        _followCount.text=@"12345";
        _followCount.font=[UIFont fontWithName:kFontNormal size:10];
        _followCount.textColor=[CommHelp toUIColorByStr:@"#666666"];
        _followCount.numberOfLines = 1;
        _followCount.textAlignment = NSTextAlignmentCenter;
        _followCount.lineBreakMode = NSLineBreakByTruncatingTail;
        [followBack addSubview:_followCount];
        [_followCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(followBack);
            make.left.equalTo(icon.mas_right).offset(5);
            make.right.equalTo(followBack).offset(0);
        }];
        
        
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followBtn.backgroundColor=kColorMain;
        _followBtn.layer.cornerRadius=13;
        _followBtn.layer.masksToBounds=YES;
        _followBtn.layer.borderColor = kColorMain.CGColor;
        _followBtn.layer.borderWidth = 0.5;
        [_followBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        _followBtn.titleLabel.font=[UIFont fontWithName:kFontNormal size:14];
        [_followBtn  setTitle:@"关注" forState:UIControlStateNormal];
        [_followBtn  setTitle:@"已关注" forState:UIControlStateSelected];
        _followBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_followBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_followBtn];
        [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-15);
            make.centerX.equalTo(self.contentView);
            make.width.offset(60);
            make.height.offset(26);
        }];
        
    }
    return self;
}
-(void)setLiveRoomMode:(JHLiveRoomMode *)liveRoomMode{
    
    _liveRoomMode=liveRoomMode;
    _title.text=_liveRoomMode.anchorName;
    _followCount.text=[NSString stringWithFormat:@"%ld人关注",(long)_liveRoomMode.recommendCount ];
    [_headImage jhSetImageWithURL:[NSURL URLWithString:liveRoomMode.smallCoverImg] placeholder:kDefaultCoverImage];
    
    if ([_liveRoomMode.status integerValue]==2) {
        _status.text=@"直播中";
        _status.textColor=kColorMain;
        
    }
    else  if ([_liveRoomMode.status integerValue]==4){
        _status.text=@"回放";
        _status.textColor=kColorEEE;
    }
    else{
        _status.text=@"回放";
        _status.textColor=kColorEEE;
    }
    
    if (_liveRoomMode.isFollow ) {
        self.followBtn.backgroundColor=[CommHelp toUIColorByStr:@"#FFFFFF"] ;
        self.followBtn.layer.borderColor = [CommHelp toUIColorByStr:@"#BDBFC2"].CGColor;
        self.followBtn.layer.borderWidth = 0.5;
        self.followBtn.selected=YES;
    }
    else{
        self.followBtn.backgroundColor=kColorMain;
        self.followBtn.layer.borderColor = kColorMain.CGColor;
        self.followBtn.layer.borderWidth = 0.5;
        self.followBtn.selected=NO;
        
    }
}

-(void)onClickBtnAction:(UIButton*)button{
    
    if (self.buttonClick) {
        self.buttonClick([NSNumber numberWithInteger:self.cellIndex]);
          }
    
}

@end


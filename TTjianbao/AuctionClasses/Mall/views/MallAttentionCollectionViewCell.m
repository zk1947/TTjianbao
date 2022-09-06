//
//  MallAttentionCollectionViewCell.h
//  TTjianbao
//
//  Created by jiang on 2019/8/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "MallAttentionCollectionViewCell.h"
#import "UIImage+GIF.h"
#import "TTjianbaoHeader.h"

@interface MallAttentionCollectionViewCell ()
{
    UIView *statusLivingImageView;
}
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel* title;
@property (strong, nonatomic)  UILabel *status;
@property (strong, nonatomic)   UIImageView *playingImage;
@property (strong, nonatomic)   UIImageView *restoreImage;
@end

@implementation MallAttentionCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       // self.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [CommHelp randomColor];
        
        UIImageView *circleImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mall_like_circle_img"]];
        [self.contentView addSubview:circleImage];
        
        [circleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.size.mas_equalTo(CGSizeMake(58, 58));
            make.centerX.equalTo(self.contentView);
        }];
        
        _headImage=[[UIImageView alloc]init];
        _headImage.image=kDefaultAvatarImage;
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius = 25;
        _headImage.userInteractionEnabled=YES;
        //        _headImage.layer.borderColor = [[CommHelp toUIColorByStr:@"#fee100"] colorWithAlphaComponent:1.0].CGColor;
        [circleImage addSubview:_headImage];
        
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
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
        _title.font=[UIFont fontWithName:kFontNormal size:11];
        _title.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _title.numberOfLines = 1;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(circleImage.mas_bottom).offset(5);
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
           
          //  make.centerX.equalTo(circleImage);
        }];
        
        _restoreImage=[[UIImageView alloc]init];
        _restoreImage.image=[UIImage imageNamed:@"mall_follow_can_resale"];
        _restoreImage.contentMode=UIViewContentModeScaleToFill;
        [self.contentView addSubview:_restoreImage];
        
        [_restoreImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25,16));
            make.top.equalTo(circleImage);
            make.right.equalTo(circleImage.mas_right).offset(2);
        }];
        
    }
    return self;
}
-(void)setLiveRoomMode:(JHLiveRoomMode *)liveRoomMode{
    
    _liveRoomMode=liveRoomMode;
    _title.text=_liveRoomMode.anchorName;
    
    [_headImage jhSetImageWithURL:[NSURL URLWithString:liveRoomMode.smallCoverImg] placeholder:kDefaultAvatarImage];
    
    _restoreImage.hidden=YES;
    
    if ([_liveRoomMode.status integerValue]==2) {
        
        //        NSString *path = [[NSBundle mainBundle] pathForResource:@"home_list_new_play" ofType:@"gif"];
        //        NSData *data = [NSData dataWithContentsOfFile:path];
        //        UIImage* gifImage = [UIImage sd_imageWithGIFData:data];
        //        _playingImage.image = gifImage;
        //        [_playingImage mas_updateConstraints:^(MASConstraintMaker *make) {
        //            make.size.mas_equalTo(CGSizeMake(15, 17));
        //        }];
        // _headImage.layer.borderWidth = 1.0f;
        _status.text=@"直播中";
        _status.textColor=kColorMain;
        
    }
    else  if ([_liveRoomMode.status integerValue]==4){
        //        _status.text=@"回看";
        //            _playingImage.image = [UIImage imageNamed:@"mall_playback_icon"];
        //            _status.textColor=[CommHelp toUIColorByStr:@"#d5d5d5"];
        //        [_playingImage mas_updateConstraints:^(MASConstraintMaker *make) {
        //            make.size.mas_equalTo(CGSizeMake(12, 13));
        //        }];
        //            _headImage.layer.borderWidth = 0;
        _status.text=@"回放";
        _status.textColor=kColorEEE;
    }
    else{
        //         _status.text=@"回看";
        //           _playingImage.image = [UIImage imageNamed:@"mall_playback_icon"];
        //            _status.textColor=[CommHelp toUIColorByStr:@"#d5d5d5"];
        //        [_playingImage mas_updateConstraints:^(MASConstraintMaker *make) {
        //           make.size.mas_equalTo(CGSizeMake(12, 13));
        //        }];
        //         _headImage.layer.borderWidth = 0;
        
        _status.text=@"回放";
        _status.textColor=kColorEEE;
    }
}

@end


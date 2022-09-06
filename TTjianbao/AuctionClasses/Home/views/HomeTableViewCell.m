//
//  HomeTableViewCell.h
//  TTjianbao
//
//  Created by jiangchao on 2018/12/9.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "UIImage+GIF.h"
#import "TTjianbaoHeader.h"

#define cellRate (float) 201/345
@interface HomeTableViewCell ()
{
    UIView *statusLivingImageView;
    UIView *statusLiveEndImageView;
    UIView * infoView;
    UILabel *  liveEndLabel;
}
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel* name;
@property (strong, nonatomic)  UIButton *likeImage;
@property (strong, nonatomic)  UILabel* title;
@property (strong, nonatomic)  UILabel *profession;
@property (strong, nonatomic)  UILabel *gradeL;
@property (strong, nonatomic)  UILabel *authContent;
@property (strong, nonatomic)  UILabel *status;
@property (strong, nonatomic)  UILabel *onlineCount;
@property (strong, nonatomic)  UIImageView *coverImage;
@property (strong, nonatomic)   UIImageView *playingImage;
@property (strong, nonatomic)   UIView *tagsBackView;
@end

@implementation HomeTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _coverImage = [[UIImageView alloc]init];
        _coverImage.image = [UIImage imageNamed:@""];
        _coverImage.userInteractionEnabled = YES;
        _coverImage.layer.cornerRadius = 5;
        _coverImage.contentMode=UIViewContentModeScaleAspectFill;
        _coverImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_coverImage];
        [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView).offset(15);
            make.height.offset((ScreenW-30)*cellRate);
        }];
        
        infoView = [[UIView alloc]init];
        [self.contentView addSubview:infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(_coverImage.mas_bottom);
        }];
        
        _headImage = [[UIImageView alloc]init];
        _headImage.image = [UIImage imageNamed:@""];
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius = 25;
        _headImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar:)];
        [_headImage addGestureRecognizer:tap];
        [infoView addSubview:_headImage];
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(infoView).offset(5);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.left.offset(15);
        }];
        
        _name = [[UILabel alloc]init];
        _name.text = @"";
        _name.font = [UIFont boldSystemFontOfSize:16];
        _name.textColor = [CommHelp toUIColorByStr:@"#000000"];
        _name.numberOfLines = 1;
        _name.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _name.lineBreakMode = NSLineBreakByWordWrapping;
        [infoView addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headImage).offset(-7);
            make.left.equalTo(_headImage.mas_right).offset(7);
        }];
        
        UIImageView *professionLogo = [[UIImageView alloc]init];
        professionLogo.image = [UIImage imageNamed:@"appraisal_video_auth"];
        professionLogo.contentMode = UIViewContentModeScaleAspectFit;
        [infoView addSubview:professionLogo];
        [professionLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.centerY.equalTo(_name);
            make.left.equalTo(_name.mas_right).offset(15);
        }];
        
        _profession = [[UILabel alloc]init];
        _profession.text = @"";
        _profession.font = [UIFont systemFontOfSize:14];
        _profession.textColor = [CommHelp toUIColorByStr:@"#666666"];
        _profession.numberOfLines = 1;
        _profession.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _profession.lineBreakMode = NSLineBreakByWordWrapping;
        [infoView addSubview:_profession];
        [_profession mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(professionLogo);
            make.left.equalTo(professionLogo.mas_right).offset(5);
            //             make.right.equalTo(self).offset(-5);
        }];
        
        _authContent = [[UILabel alloc]init];
        _authContent.text=@"鉴定范围：";
        _authContent.font = [UIFont systemFontOfSize:14];
        _authContent.textColor = [CommHelp toUIColorByStr:@"#666666"];
        _authContent.numberOfLines = 1;
        _authContent.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _authContent.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_authContent];
        [_authContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headImage).offset(15);
            make.left.equalTo(_headImage.mas_right).offset(7);
        }];
        
        UIImageView *titleBack=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_video_list_bottom_back"]];
        [_coverImage addSubview:titleBack];
        
        [titleBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_coverImage).offset(0);
            make.left.right.equalTo(_coverImage);
            make.height.offset(53);
        }];
        
        _title = [[UILabel alloc]init];
        _title.text = @"";
        _title.font = [UIFont systemFontOfSize:17];
        _title.textColor = [CommHelp toUIColorByStr:@"#ffffff"];
        _title.numberOfLines = 2;
        _title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        [titleBack addSubview:_title];
        
        UIImageView *onlineImage = [[UIImageView alloc]init];
        onlineImage.image = [UIImage imageNamed:@"home_user_logo"];
        [onlineImage setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [onlineImage setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        onlineImage.contentMode = UIViewContentModeScaleAspectFit;
        [titleBack addSubview:onlineImage];
        [onlineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            // make.centerY.equalTo(_title);
            make.bottom.equalTo(titleBack.mas_bottom).offset(-15);
            make.right.equalTo(titleBack.mas_right).offset(-15);
        }];
        
        _onlineCount = [[UILabel alloc]init];
        _onlineCount.text = @"";
        [_onlineCount setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_onlineCount setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _onlineCount.font = [UIFont systemFontOfSize:12];
        _onlineCount.textColor = [UIColor whiteColor];
        _onlineCount.numberOfLines = 1;
        _onlineCount.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _onlineCount.lineBreakMode = NSLineBreakByWordWrapping;
        [titleBack addSubview:_onlineCount];
        [_onlineCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(onlineImage);
            make.right.equalTo(onlineImage.mas_left).offset(-5);
        }];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(titleBack.mas_bottom).offset(-10);
            make.left.equalTo(titleBack).offset(11);
            make.right.equalTo(_onlineCount.mas_left).offset(-5);
        }];
        
        statusLivingImageView = [[UIView alloc] init];
        statusLivingImageView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        statusLivingImageView.layer.cornerRadius = 2;
        statusLivingImageView.alpha = 0.8;
        [_coverImage addSubview:statusLivingImageView];
        [statusLivingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@22);
            make.top.equalTo(_coverImage).offset(8);
            make.right.equalTo(_coverImage.mas_right).offset(-8);
        }];
        
        _playingImage = [[UIImageView alloc]init];
        _playingImage.contentMode = UIViewContentModeScaleAspectFit;
        [statusLivingImageView addSubview:_playingImage];
        [_playingImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusLivingImageView);
            make.left.equalTo(statusLivingImageView).offset(5);
            make.size.mas_equalTo(CGSizeMake(15, 17));
        }];
        
        _status = [[UILabel alloc]init];
        _status.text = @"鉴定中";
        _status.font = [UIFont systemFontOfSize:12];
        _status.textColor = [CommHelp toUIColorByStr:@"#fee100"];
        _status.numberOfLines = 1;
        _status.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _status.lineBreakMode = NSLineBreakByWordWrapping;
        [statusLivingImageView addSubview:_status];
        
        [_status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusLivingImageView);
            make.right.equalTo(statusLivingImageView.mas_right).offset(-5);
            make.left.equalTo(_playingImage.mas_right).offset(5);
        }];
        
        statusLiveEndImageView = [[UIImageView alloc]init];
        statusLiveEndImageView = [[UIView alloc] init];
        statusLiveEndImageView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        statusLiveEndImageView.layer.cornerRadius = 2;
        statusLiveEndImageView.alpha = 0.8;
        [_coverImage addSubview:statusLiveEndImageView];
        statusLiveEndImageView.contentMode = UIViewContentModeScaleAspectFit;
        [statusLiveEndImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@22);
            //            make.width.equalTo(@40);
            make.top.equalTo(_coverImage).offset(8);
            make.right.equalTo(_coverImage.mas_right).offset(-8);
        }];
        
        liveEndLabel = [[UILabel alloc]init];
        liveEndLabel.text = @"在线回看";
        liveEndLabel.font = [UIFont systemFontOfSize:12];
        liveEndLabel.textColor = [CommHelp toUIColorByStr:@"#999999"];
        liveEndLabel.numberOfLines = 1;
        liveEndLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
        liveEndLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [statusLiveEndImageView addSubview:liveEndLabel];
        [liveEndLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusLiveEndImageView);
            make.right.equalTo(statusLiveEndImageView.mas_right).offset(-5);
            make.left.equalTo(statusLiveEndImageView).offset(5);
        }];
        
//        UIView * line=[[UIView alloc]init];
//        line.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
//        //        line.alpha=0.7;
//        [self addSubview:line];
//
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.equalTo(self).offset(15);
//            make.bottom.equalTo(self).offset(0);
//            make.right.equalTo(self).offset(-15);
//            make.height.offset(1);
//        }];
        
    }
    return self;
}

-(void)setLiveRoomMode:(JHLiveRoomMode *)liveRoomMode{
    _liveRoomMode = liveRoomMode;
    _name.text = _liveRoomMode.anchorName;
    _profession.text = _liveRoomMode.anchorTitle;
    //    _title.text=_liveRoomMode.title;
    
    if (_liveRoomMode.title) {
        
        //        NSShadow *shadow = [[NSShadow alloc] init];
        //        shadow.shadowBlurRadius = 2;//阴影半径，默认值3
        //        shadow.shadowColor = [CommHelp toUIColorByStr:@"#666666"];;
        //        shadow.shadowOffset = CGSizeMake(1, 1);//阴影偏移量，x向右偏移，y向下偏移，默认是（0，-3）
        //        NSAttributedString * attributedText = [[NSAttributedString alloc] initWithString:_liveRoomMode.title attributes:@{NSShadowAttributeName:shadow}];
        //        _title.attributedText = attributedText;
        
        _title.text = _liveRoomMode.title;
    }
    
    _onlineCount.text=[NSString stringWithFormat:@"%@人",_liveRoomMode.watchTotal];
    [_headImage jhSetImageWithURL:[NSURL URLWithString:liveRoomMode.anchorIcon] placeholder:kDefaultAvatarImage];
    
    _coverImage.contentMode = UIViewContentModeScaleAspectFill;
    JH_WEAK(self)
    [_coverImage jhSetImageWithURL:[NSURL URLWithString:liveRoomMode.coverImg] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        JH_STRONG(self)
        if (!image) {
            self.coverImage.contentMode=UIViewContentModeScaleAspectFit;
        }
    }];

    //    _status.text=[NSString stringWithFormat:@"直播中  %@热度",_liveRoomMode.watchTotal];
    //    _gradeL.text=[NSString stringWithFormat:@"满意度%@%%",_liveRoomMode.grade];
    
    NSMutableString * string =[NSMutableString stringWithCapacity:10];
    
    for (int i = 0; i < [_liveRoomMode.tags count]; ++i) {
        [string  appendString:[NSString stringWithFormat:@"%@  ",[_liveRoomMode.tags[i] objectForKey:@"tagName"]]];
    }
    _authContent.text=[NSString stringWithFormat:@"%@",string];
    
    if ([_liveRoomMode.status integerValue] == 2) {
        
        [statusLivingImageView setHidden:NO];
        [statusLiveEndImageView setHidden:YES];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"home_list_new_play" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage* gifImage = [UIImage sd_imageWithGIFData:data];
        _playingImage.image = gifImage;
        
    }
    else  if ([_liveRoomMode.status integerValue] == 4){
        
        liveEndLabel.text=@"休息中";
        [statusLivingImageView setHidden:YES];
        [statusLiveEndImageView setHidden:NO];
        
    }
    else{
        
        liveEndLabel.text=@"在线回看";
        [statusLivingImageView setHidden:YES];
        [statusLiveEndImageView setHidden:NO];
    }
}

- (void)tapAvatar:(UIGestureRecognizer *)gest {
    if (self.clickAvatar) {
        self.clickAvatar(self.liveRoomMode);
    }
}
@end



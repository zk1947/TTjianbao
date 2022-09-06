//
//  JHLiveEndPageAnchorView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/6/20.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "JHLiveEndPageAnchorView.h"
#import "ChannelMode.h"
#import "TTjianbaoHeader.h"

#define cellRate (float) 201/345
#define videoRate (float) 240/320
#define topImageRate (float) 200/345
#import "UIImage+GIF.h"
@interface JHLiveEndPageAnchorView ()
{
    UIView *statusLivingImageView;
    UIButton * liveBtn;
    UIButton * appraisalBtn;
}
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel *status;
@property (strong, nonatomic)  UILabel *onlineCount;
@property (strong, nonatomic)  UIImageView *coverImage;
@property (strong, nonatomic)   UIImageView *playingImage;
@property (strong, nonatomic)   UIView *tagsBackView;
@end
@implementation JHLiveEndPageAnchorView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        [self setUp];
    }
    return self;
}
-(void)setUp{
    
    [self addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * backView=[[UIView alloc]init];
    backView.layer.cornerRadius = 2;
    backView.backgroundColor = [UIColor clearColor];
    //    backView.layer.masksToBounds = NO;
    //    backView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    backView.layer.shadowOffset = CGSizeZero;
    //    backView.layer.shadowOpacity = 0.5;
    //    backView.layer.shadowRadius = 2;
    backView.userInteractionEnabled=NO;
    [self addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(self).offset(15);
        //        make.right.equalTo(self).offset(-15);
        //        make.top.equalTo(self).offset(5);
        //        make.height.offset((ScreenW-30)*cellRate);
        make.edges.equalTo(self);
    }];
    
    _coverImage=[[UIImageView alloc]init];
    _coverImage.image=[UIImage imageNamed:@""];
    _coverImage.layer.cornerRadius = 5;
    _coverImage.contentMode=UIViewContentModeScaleAspectFill;
    _coverImage.layer.masksToBounds = YES;
    [backView addSubview:_coverImage];
    
    [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(self).offset(15);
        //        make.right.equalTo(self).offset(-15);
        //        make.top.equalTo(self).offset(15);
        //        make.height.offset((ScreenW-30)*cellRate);
        make.edges.equalTo(backView);
        
    }];
    
    statusLivingImageView = [[UIView alloc] init];
    statusLivingImageView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    statusLivingImageView.layer.cornerRadius = 2;
    statusLivingImageView.alpha=0.8;
    [_coverImage addSubview:statusLivingImageView];
    
    [statusLivingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@22);
        make.top.equalTo(_coverImage).offset(8);
        make.left.equalTo(_coverImage).offset(7);
    }];
    
    _content=[[UIView alloc]init];
    _content.backgroundColor=[UIColor clearColor];
    _content.layer.masksToBounds=YES;
    _content.layer.cornerRadius = 2;
    
    [_coverImage addSubview:_content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        // make.edges.equalTo(_coverImage);
        make.left.equalTo(statusLivingImageView);
        make.bottom.offset(-5);
        make.top.equalTo(statusLivingImageView.mas_bottom).offset(5);
        make.width.offset(135);
        make.height.offset(((ScreenW-20)*topImageRate-32)*122/156.);
    }];
    
    _playingImage=[[UIImageView alloc]init];
    _playingImage.contentMode=UIViewContentModeScaleAspectFit;
    [statusLivingImageView addSubview:_playingImage];
    
    [_playingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(statusLivingImageView);
        make.left.equalTo(statusLivingImageView).offset(5);
        make.size.mas_equalTo(CGSizeMake(15, 17));
    }];
    
    _status=[[UILabel alloc]init];
    _status.text=@"";
    _status.font=[UIFont systemFontOfSize:12];
    _status.textColor=[CommHelp toUIColorByStr:@"#fee100"];
    _status.numberOfLines = 1;
    _status.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _status.lineBreakMode = NSLineBreakByWordWrapping;
    [statusLivingImageView addSubview:_status];
    
    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(statusLivingImageView);
        make.right.equalTo(statusLivingImageView.mas_right).offset(-5);
        make.left.equalTo(statusLivingImageView).offset(25);
    }];
    
    
    
    
    _onlineCount=[[UILabel alloc]init];
    _onlineCount.text=@"";
    [_onlineCount setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_onlineCount setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    _onlineCount.font=[UIFont systemFontOfSize:12];
    _onlineCount.textColor=[UIColor whiteColor];
    _onlineCount.numberOfLines = 1;
    _onlineCount.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _onlineCount.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_onlineCount];
    
    [_onlineCount mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(statusLivingImageView);
        make.left.equalTo(statusLivingImageView.mas_right).offset(10);
    }];
    
    appraisalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [appraisalBtn setTitle:@"观看直播" forState:UIControlStateNormal];
    appraisalBtn.tag=2;
    appraisalBtn.titleLabel.font= [UIFont boldSystemFontOfSize:15];
    appraisalBtn.layer.cornerRadius = 2.0;
    [appraisalBtn setBackgroundColor:[CommHelp toUIColorByStr:@"#fee100"]];
    [appraisalBtn setTitleColor:[CommHelp toUIColorByStr:@"#000000"] forState:UIControlStateNormal];
    [appraisalBtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    appraisalBtn.contentMode=UIViewContentModeScaleAspectFit;
    
    [self addSubview:appraisalBtn];
    
    [appraisalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(108, 40));
        make.bottom.equalTo(self).offset(-8);
        make.right.equalTo(self.mas_right).offset(-8);
    }];
    
}
-(void)setLiveRoomMode:(ChannelMode *)liveRoomMode{
    
    _liveRoomMode=liveRoomMode;
    
    _onlineCount.text=[NSString stringWithFormat:@"%ld热度",(long)_liveRoomMode.watchTotal];
    _coverImage.contentMode=UIViewContentModeScaleAspectFill;
    JH_WEAK(self)
    [_coverImage jhSetImageWithURL:[NSURL URLWithString:liveRoomMode.coverImg] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        JH_STRONG(self)
        if (!image) {
            self.coverImage.contentMode=UIViewContentModeScaleAspectFit;
        }
    }];
    
    
    if ([_liveRoomMode.status integerValue]==2) {
        
        _status.text=@"鉴定中";
        _status.textColor=[CommHelp toUIColorByStr:@"#fee100"];
        [_status mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(statusLivingImageView).offset(25);
        }];
        [_playingImage setHidden:NO];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"home_list_new_play" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage* gifImage = [UIImage sd_imageWithGIFData:data];
        _playingImage.image = gifImage;
        
//        [appraisalBtn setHidden:NO];
//        [liveBtn setHidden:NO];
//
//        if (_liveRoomMode.canAppraise==1) {
//            [appraisalBtn setHidden:NO];
//        }
//        else{
//            [appraisalBtn setHidden:YES];
//        }
        
    }
    
    else{
        _status.text=@"休息中";
        _status.textColor=[CommHelp toUIColorByStr:@"#999999"];
        [_status mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(statusLivingImageView).offset(5);
        }];
        [_playingImage setHidden:YES];
        [appraisalBtn setHidden:YES];
        [liveBtn setHidden:YES];
    }
}
-(void)buttonPress:(UIButton*)button{
    if (self.clickButton) {
        self.clickButton(button, self.liveRoomMode);
    }
}
@end


//#import "JHLiveEndPageAnchorView.h"
//#define cellRate (float) 201/345
//#define videoRate (float) 240/320
//#define topImageRate (float) 200/345
//#import "UIImage+GIF.h"
//@interface JHLiveEndPageAnchorView ()
//{
//    UIView *statusLivingImageView;
//    UIButton * liveBtn;
//    UIButton * appraisalBtn;
//    
//}
//@property (strong, nonatomic)  UIImageView *headImage;
//@property (strong, nonatomic)  UILabel *status;
//@property (strong, nonatomic)  UILabel *name;
//@property (strong, nonatomic)   UIImageView *playingImage;
//
//@end
//@implementation JHLiveEndPageAnchorView
//
//- (instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if(self){
//        
//        [self addTarget:self action:@selector(press) forControlEvents:UIControlEventTouchUpInside];
//        [self setUp];
//    }
//    return self;
//}
//-(void)setUp{
//    
//    _headImage=[[UIImageView alloc]init];
//    _headImage.image=kDefaultAvatarImage;
//    _headImage.layer.masksToBounds =YES;
//    _headImage.layer.cornerRadius =35;
//    [self addSubview:_headImage];
//    
//    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self).offset(5);
//        make.size.mas_equalTo(CGSizeMake(70,70));
//        make.centerX.equalTo(self);
//    }];
//   
//    _name=[[UILabel alloc]init];
//    _name.text=@"dfddf";
//    _name.font=[UIFont boldSystemFontOfSize:12];
//    _name.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
//    _name.numberOfLines = 1;
//    _name.textAlignment = UIControlContentHorizontalAlignmentLeft;
//    _name.lineBreakMode = NSLineBreakByTruncatingTail;
//    [self addSubview:_name];
//    
//    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerX.equalTo(_headImage).offset(0);
//        make.top.equalTo(_headImage.mas_bottom).offset(15);
//    }];
//    
//    statusLivingImageView = [[UIView alloc] init];
//    statusLivingImageView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
//    statusLivingImageView.layer.cornerRadius = 2;
//    statusLivingImageView.alpha=0.8;
//    [self addSubview:statusLivingImageView];
//    
//    [statusLivingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.height.equalTo(@20);
//        // make.width.equalTo(@44);
//        make.centerX.equalTo(self);
//         make.top.equalTo(_headImage.mas_bottom).offset(-10);
//    }];
//    
//    _playingImage=[[UIImageView alloc]init];
//    _playingImage.contentMode=UIViewContentModeScaleAspectFit;
//    [statusLivingImageView addSubview:_playingImage];
//    
//    [_playingImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(statusLivingImageView);
//        make.left.equalTo(statusLivingImageView).offset(5);
//        make.size.mas_equalTo(CGSizeMake(5,5));
//    }];
//    
//    _status=[[UILabel alloc]init];
//    _status.text=@"直播中";
//    _status.font=[UIFont systemFontOfSize:9];
//    _status.textColor=[CommHelp toUIColorByStr:@"#fee100"];
//    _status.numberOfLines = 1;
//    _status.textAlignment = UIControlContentHorizontalAlignmentCenter;
//    _status.lineBreakMode = NSLineBreakByWordWrapping;
//    [statusLivingImageView addSubview:_status];
//    
//    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(statusLivingImageView);
//        make.right.equalTo(statusLivingImageView.mas_right).offset(-5);
//        make.left.equalTo(_playingImage.mas_right).offset(5);
//    }];
//}
//-(void)setMode:(ChannelMode *)mode{
//    _mode=mode;
//}
//-(void)press{
//    if (self.block) {
//        self.block(self.mode);
//    }
//}
//@end




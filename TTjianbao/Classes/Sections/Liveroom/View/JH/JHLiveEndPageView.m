//
//  JHLiveEndPageView.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/10.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHLiveEndPageView.h"
#import "NIMAvatarImageView.h"
#import "NTESLiveManager.h"
#import "JHLiveEndPageAnchorView.h"
#import "ChannelMode.h"
#import "TTjianbaoHeader.h"

#define topImageRate (float) 200/345
@interface JHLiveEndPageView ()
@property (weak, nonatomic) IBOutlet NIMAvatarImageView *avatar;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UILabel *liveDuring;

@property (weak, nonatomic) IBOutlet UIButton *careofBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *careTotopHeight;
@property (weak, nonatomic) IBOutlet UIView *forbidView;

@property (weak, nonatomic) IBOutlet UILabel *forbidReason;

@end


@implementation JHLiveEndPageView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.forbidView.hidden = YES;
    [_avatar nim_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"LOGO"]];
    _careofBtn.hidden = YES;
    
    _careofBtn.layer.cornerRadius = 2;
    _careofBtn.layer.masksToBounds = YES;
    
    _okBtn.layer.cornerRadius = 2;
    _okBtn.layer.masksToBounds = YES;
    _okBtn.layer.borderColor = kGlobalThemeColor.CGColor;
    _okBtn.layer.borderWidth = 1;
    _okBtn.hidden=YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLiveDuring:) name:NotificationNameLiveDuring object:nil];

}
-(void)setupRecommendAnchourView:(NSArray *)channels{

    UIView * recommend=[[UIView alloc]init];
   // recommend.backgroundColor=[UIColor redColor];
    [self addSubview:recommend];
    [recommend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.equalTo(_careofBtn.mas_bottom).offset(10);
    }];

    UILabel  *title=[[UILabel alloc]init];
    title.font=[UIFont boldSystemFontOfSize:14];
    title.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    title.text=@"推荐";
    [recommend addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(recommend).offset(5);
    }];
   
    if (channels.count>0) {
        JHLiveEndPageAnchorView * view=[[JHLiveEndPageAnchorView alloc]init];
        JH_WEAK(self)
        view.clickButton = ^(UIButton * _Nonnull button, ChannelMode * _Nonnull mode) {
            JH_STRONG(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(didPressAnchorView:)]) {
                [self.delegate didPressAnchorView:mode];
            }
        };
        [view setLiveRoomMode:channels[0]];
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(recommend).offset(10);
            make.right.equalTo(recommend).offset(-10);
            make.top.equalTo(recommend).offset(30);
            make.height.offset((ScreenW-20)*topImageRate);
            make.bottom.equalTo(recommend).offset(-10);
        }];
    }
    return;
    
//    NSInteger margin = 10;
//    float imaWidth=(ScreenW-margin*5)/4;
//    float imaHeight=110;
//    UIView * lastView ;
//    for (int i=0; i<channels.count; i++) {
//        ChannelMode * mode=channels[i];
//        JHLiveEndPageAnchorView * view =[[JHLiveEndPageAnchorView alloc]init];
//        view.mode=mode;
//        [recommend addSubview:view];
//        JH_WEAK(self)
//        view.block = ^(ChannelMode * _Nonnull mode) {
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didPressAnchorView:)]) {
//                [weakSelf.delegate didPressAnchorView:mode];
//            }
//        };
//     //   view.backgroundColor=[CommHelp randomColor];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.width.offset(imaWidth);
//            make.height.offset(imaHeight);
//            if (i/4==0) {
//                make.top.equalTo(recommend.mas_top).offset(30);
//            }
//            else{
//                make.top.equalTo(recommend.mas_top).offset(imaHeight+30+10);
//            }
//            if (i%4 == 0) {
//                make.left.offset(margin);
//
//            }else{
//                make.left.equalTo(lastView.mas_right).offset(margin);
//            }
//            if (i%4 == 3) {
//                make.right.offset(-margin);
//            }
//            if (i == channels.count-1){
//                make.bottom.equalTo(recommend.mas_bottom).offset(-10);
//            }
//        }];
//
//        lastView= view;
//    }
}
- (void)setMember:(NIMChatroomMember *)member {
    _nickName.text = member.roomNickname;

}

- (IBAction)careOffAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didPressCareOffButton:)]) {
        [_delegate didPressCareOffButton:sender];
    }
}

- (IBAction)backAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didPressBackButton)]) {
        [_delegate didPressBackButton];
    }
}


- (void)setModel:(JHAnchorInfoModel *)model {
    [_avatar nim_setImageWithURL:[NSURL URLWithString:model.appraiserImg] placeholderImage:kDefaultAvatarImage];
    _nickName.text = model.appraiserName;
    _careofBtn.selected = model.isFollow;
    _careofBtn.hidden = model.isFollow;
    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAnchor) {
        _careofBtn.hidden = YES;
    }

    if ([model.customerId isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId]) {
        _careofBtn.hidden = YES;
    }

}


- (void)updateLiveDuring:(NSNotification *)noti {
    NSInteger second = [[noti object] integerValue];
    
    _liveDuring.text = [NSString stringWithFormat:@"直播时长：%@",[CommHelp getHMSWithSecond:second]];
    
}


- (void)forbidLiveWithReason:(NSString *)reason {
    if (reason && reason.length>0) {
        self.endLabel.hidden = YES;
        self.liveDuring.hidden = YES;
        self.careTotopHeight.constant = 80;
        self.forbidView.hidden = NO;
        self.forbidReason.text = reason;
    }

}

@end

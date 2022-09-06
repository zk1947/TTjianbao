//
//  TTjianbao
//
//  Created by jiangchao on 2019/2/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHHomeHeaderAnchorView.h"
#import "TTjianbaoHeader.h"
#import <UIImage+WebP.h>
#import "JHLiveStatusView.h"
#import "UIView+CornerRadius.h"
#import "UIImage+GIF.h"
#import "JHOnlineAppraiseHeader.h"
#import "UIView+JHShadow.h"

#define kImageRate (float) 82./117.5

@interface JHHomeHeaderAnchorView ()
{
    UIView *backView;
    
}
@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UILabel *status;
@property (strong, nonatomic) UILabel *onlineCount;
@property (strong, nonatomic) UIImageView *coverImage;
@property (strong, nonatomic) UIImageView *playingImage;
@property (strong, nonatomic) UIView *tagsBackView;
@property (strong, nonatomic) UILabel* name;
@property (strong, nonatomic) UIImageView *professionLogo;
@property (strong, nonatomic) UILabel *profession;

///直播状态view --- TODO lihui
@property (strong, nonatomic) YYAnimatedImageView *liveStatusView;
@property (nonatomic, strong) UILabel *restLabel;

@property (nonatomic, strong) NSMutableArray <UILabel *>*tagLabels;


@end
@implementation JHHomeHeaderAnchorView

- (NSMutableArray<UILabel *> *)tagLabels {
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = UIColor.whiteColor;
        [self setUp];
    }
    return self;
}
-(void)setUp {
    backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.userInteractionEnabled = NO;
    
    _coverImage                 = [[UIImageView alloc] init];
    _coverImage.image           = [UIImage imageNamed:@""];
    _coverImage.contentMode     = UIViewContentModeScaleAspectFill;
    _coverImage.layer.masksToBounds = YES;
    _coverImage.clipsToBounds   = YES;
    
    YYAnimatedImageView *statusView = [[YYAnimatedImageView alloc] initWithImage:[YYImage imageNamed:@"mall_home_bannar_living.webp"]];
    statusView.contentMode = UIViewContentModeScaleAspectFit;
    _liveStatusView = statusView;
    
    _restLabel = [[UILabel alloc] init];
    _restLabel.backgroundColor = HEXCOLORA(0xFFFFFF, .15);
    _restLabel.text = @"休息中";
    _restLabel.font = [UIFont fontWithName:kFontNormal size:10.];
    _restLabel.textAlignment = NSTextAlignmentCenter;
    _restLabel.textColor = kColorFFF;
    _restLabel.layer.cornerRadius = 1.f;
    _restLabel.layer.masksToBounds = YES;
    
    _name = [[UILabel alloc] init];
    _name.text = @"";
    _name.font = [UIFont fontWithName:kFontNormal size:13.];
    _name.textColor = kColor333;
    _name.numberOfLines = 1;
    _name.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _name.lineBreakMode = NSLineBreakByTruncatingTail;
    [_name setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_name setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    UIImageView *professionLogo = [[UIImageView alloc]init];
    professionLogo.image = [UIImage imageNamed:@"appraise_home_cert"];
    professionLogo.contentMode = UIViewContentModeScaleAspectFit;
    _professionLogo = professionLogo;
    
    _profession = [[UILabel alloc] init];
    _profession.text = @"认证鉴定师";
    _profession.font = [UIFont fontWithName:kFontNormal size:9.];
    _profession.textColor = kColor999;
    _profession.numberOfLines = 1;
    _profession.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _profession.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self.contentView addSubview:backView];
    [backView addSubview:_coverImage];
    [_coverImage addSubview:_liveStatusView];
    [_coverImage addSubview:_restLabel];
    
    [backView addSubview:_name];
    [backView addSubview:_professionLogo];
    [backView addSubview:_profession];
    for (int i = 0; i < 2; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:kFontNormal size:9.];
        label.textColor = HEXCOLOR(0xB9855D);
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 3.f;
        label.layer.borderColor = HEXCOLOR(0xB9855D).CGColor;
        label.layer.borderWidth = .5f;
        [backView addSubview:label];
        [self.tagLabels addObject:label];
    }
    [self makeLayouts];
}

- (void)makeLayouts {
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    
    [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView).offset(0);
        make.left.equalTo(backView).offset(.5);
        make.right.equalTo(backView).offset(-.5);
        make.height.offset(82.*smallImageRate);
//        make.height.offset(smallImageWidth*kImageRate);
    }];
    
    [_liveStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.coverImage).offset(5.);
        make.size.mas_equalTo(CGSizeMake(16., 16.));
    }];
    
    [_restLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.coverImage).offset(5.);
        make.size.mas_equalTo(CGSizeMake(36., 16.));
    }];

    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_coverImage.mas_bottom).offset(3.5);
        make.left.equalTo(_coverImage).offset(7.);
    }];
    
    [_professionLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(11., 13.));
        make.centerY.equalTo(_name);
        make.left.equalTo(_name.mas_right).offset(5.);
    }];
     
    [_profession mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.professionLogo);
        make.left.equalTo(self.professionLogo.mas_right).offset(2.5);
        make.right.equalTo(backView).offset(-5);
    }];
    
    UILabel *tempLabel = nil;
    for (int i = 0; i < self.tagLabels.count; i ++) {
        UILabel *label = self.tagLabels[i];
        if (tempLabel == nil) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.name);
                make.top.equalTo(self.name.mas_bottom).offset(1.5);
                make.height.mas_equalTo(13.);
                make.width.mas_lessThanOrEqualTo((smallImageWidth - 15)/2.);
            }];
        }
        else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempLabel.mas_right).offset(7.);
                make.centerY.equalTo(tempLabel);
                make.height.mas_equalTo(tempLabel);
                make.width.mas_lessThanOrEqualTo((smallImageWidth - 15)/2.);
            }];
        }
        tempLabel = label;
    }
    
    [self layoutIfNeeded];
    [self.coverImage yd_setCornerRadius:5. corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    
    backView.layer.cornerRadius = 5.;
    backView.layer.borderWidth = .5f;
    backView.layer.borderColor = HEXCOLOR(0xEDEDED).CGColor;
    backView.layer.shadowColor = HEXCOLOR(0x000000).CGColor;
    backView.layer.shadowOffset = CGSizeMake(0,3);
    backView.layer.shadowOpacity = .04f;
    backView.layer.shadowRadius = 3.f;
    // 单边阴影 顶边
}

-(void)setLiveRoomMode:(JHLiveRoomMode *)liveRoomMode {
    _liveRoomMode = liveRoomMode;
    _name.text = _liveRoomMode.anchorName;
    _profession.text = _liveRoomMode.anchorAuthInfo;
    [_coverImage jhSetImageWithURL:[NSURL URLWithString:liveRoomMode.smallCoverImg] placeholder:kDefaultCoverImage];
    
    ///设置直播状态
    BOOL isLiving = ([_liveRoomMode.status integerValue] == 2);
    _liveStatusView.hidden = !isLiving;
    _restLabel.hidden = isLiving;
    int tagCount = (int)liveRoomMode.appraiserTags.count;
    if (tagCount > 0) {
        if (tagCount < self.tagLabels.count) {
            for (int i = tagCount; i < self.tagLabels.count; i ++) {
                UILabel *label = self.tagLabels[i];
                [label.layer cancelCurrentImageRequest];
                label.hidden = YES;
            }
        }
        for (int i = 0; i < tagCount; i ++) {
            UILabel *label = self.tagLabels[i];
            label.hidden = NO;
            label.text = [NSString stringWithFormat:@" %@ ", [liveRoomMode.appraiserTags[i] isNotBlank] ? liveRoomMode.appraiserTags[i] : @""];
        }
    }
}

-(void)buttonPress:(UIButton*)button{
    if (self.clickButton) {
        self.clickButton(button, self.liveRoomMode);
    }
}
@end


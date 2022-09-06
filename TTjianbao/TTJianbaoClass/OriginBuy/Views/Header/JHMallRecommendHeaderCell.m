//
//  JHMallRecommendHeaderCell.m
//  TTjianbao
//
//  Created by lihui on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallRecommendHeaderCell.h"
#import "JHLiveStatusView.h"
#import "UIImageView+JHWebImage.h"
#import "JHLiveRoomMode.h"
#import "UIView+JHGradient.h"
#import "TTjianbaoMarcoUI.h"
#import "UIImage+GIF.h"

@interface JHMallRecommendHeaderCell ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) YYLabel *addressLabel;
@property (strong, nonatomic)   UIImageView *tagImage;
@property (strong, nonatomic)   UILabel *tagContent;
@property (nonatomic, strong) YYLabel *tagLabel;

@property (nonatomic, strong) UIView *rankView;  //排名视图
@property (nonatomic, strong) UIImageView *rankLogoImageView;  //排名视图
@property (nonatomic, strong) UILabel *rankLabel;  //排名视图

@property (nonatomic, strong) UIView *statusBackView;  //直播
@property (nonatomic, strong) UIView *livingStatusView;  //直播中黄色背景图
@property (strong, nonatomic)  YYAnimatedImageView *playingImage;
@property (strong, nonatomic)  UILabel *status;
@property (strong, nonatomic)  UILabel *onlineCount;

@end

@implementation JHMallRecommendHeaderCell

- (void)setImageModel:(JHLiveRoomMode *)imageModel {
    if (!imageModel) {
        return;
    }

    _imageModel = imageModel;
    _addressLabel.text = imageModel.location? : @"未知";

    NSString *string = @"";
    if ([imageModel.canCustomize isEqualToString:@"1"]) {
        string = [string stringByAppendingString:@"支持定制"];
    }
    if (imageModel.connectingFlag) {
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
    
    [_bgImageView jhSetImageWithURL:[NSURL URLWithString:_imageModel.smallCoverImg] placeholder:kDefaultCoverImage];
    
    [_iconImageView jhSetImageWithURL:[NSURL URLWithString:_imageModel.anchorIcon] placeholder:kDefaultAvatarImage];
    _titleLabel.text = _imageModel.title;
    _nameLabel.text = _imageModel.anchorName?:@"暂无昵称";
     _tagContent.text = @"";

    JH_WEAK(self)
    [_tagImage jhSetImageWithURL:[NSURL URLWithString:_imageModel.tagUrl?:@""] placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        JH_STRONG(self)
        if ([self.imageModel.tagContent length]>0) {
              NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
              style.maximumLineHeight = 15;
              style.minimumLineHeight = 15;
              style.alignment = NSTextAlignmentCenter;
              NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.imageModel.tagContent];
              [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.imageModel.tagContent.length)];
              self.tagContent.attributedText = attrString;
              [self.tagContent sizeToFit];
          }
    }];
    
    if ([imageModel.status integerValue] == 2) {
        _playingImage.image = [YYImage imageNamed:@"mall_home_list_living.webp"];
        _status.text=@"直播";
        _onlineCount.text = [NSString stringWithFormat:@"%@热度",imageModel.watchTotalString];
        _livingStatusView.backgroundColor = HEXCOLOR(0xffd70f);
        _status.textColor = HEXCOLOR(0x333333);
        [_status mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_livingStatusView.mas_centerY);
            make.left.equalTo(_playingImage.mas_right).offset(5);
            make.right.mas_equalTo(_livingStatusView.mas_right).offset(-5);
        }];
    }else if ([imageModel.status integerValue]==1){
        _onlineCount.text = [NSString stringWithFormat:@"%@热度",imageModel.watchTotalString];
        _status.text=@"回放";
        _livingStatusView.backgroundColor = HEXCOLOR(0x808ba3);
        _status.textColor = HEXCOLOR(0xffffff);
        _playingImage.image = [UIImage imageNamed:@"custmoize_review_logo"];
        [_status mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_livingStatusView.mas_centerY);
            make.left.equalTo(_playingImage.mas_right).offset(5);
            make.right.mas_equalTo(_livingStatusView.mas_right).offset(-5);
        }];
    }
    else {
        
        _onlineCount.text = [NSString stringWithFormat:@"%@热度",imageModel.watchTotalString];
        _status.text=@"直播结束";
        _livingStatusView.backgroundColor = HEXCOLOR(0x808ba3);
        _status.textColor = HEXCOLOR(0xffffff);
        _playingImage.image = [UIImage imageNamed:@""];
        [_status mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_livingStatusView.mas_centerY);
            make.left.equalTo(_playingImage.mas_left);
            make.right.mas_equalTo(_livingStatusView.mas_right).offset(-5);
        }];
    }
    
    if (imageModel.customizedFlag && [imageModel.status integerValue] != 2) {//定制
        _onlineCount.text = [NSString stringWithFormat:@""];
        _status.text=@"休息中";
        _livingStatusView.backgroundColor = HEXCOLOR(0x808ba3);
        _status.textColor = HEXCOLOR(0xffffff);
        _playingImage.image = [UIImage imageNamed:@""];
        [_status mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_livingStatusView.mas_centerY);
            make.left.equalTo(_playingImage.mas_left);
            make.right.mas_equalTo(_livingStatusView.mas_right).offset(-5);
        }];
    }
    
    if ([imageModel.watchTotalString isEqualToString:@"0"] || (imageModel.customizedFlag && [imageModel.status integerValue] != 2)) {
        _onlineCount.text = @"";
        [_onlineCount mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_livingStatusView.mas_right);
            make.right.equalTo(self.statusBackView.mas_right);
        }];
    }else{
        [_onlineCount mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_livingStatusView.mas_right).offset(5);
            make.right.equalTo(self.statusBackView.mas_right).offset(-5);
        }];
    }
    
    /** 显示排名*/
    if (imageModel.activityRank.length > 0) {
        _rankLabel.text = imageModel.activityRank;
        _rankView.hidden = NO;
    }else{
        _rankView.hidden = YES;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
        self.layer.cornerRadius = 8.0f;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        [self initViews];
        [self.imageView removeFromSuperview];
        [self.coverView removeFromSuperview];
    }
    return self;
}

- (void)initViews {
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:kDefaultCoverImage];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView = bgImage;
    
    _tagImage=[[UIImageView alloc]init];
    _tagImage.image=[UIImage imageNamed:@""];
    _tagImage.contentMode=UIViewContentModeScaleAspectFit;
    _tagImage.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:_tagImage];
    
    [_tagImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(20);
        make.top.bottom.equalTo(_bgImageView);
        make.right.equalTo(_bgImageView.mas_right);
    }];
    
    _tagContent=[[UILabel alloc]init];
    _tagContent.textColor=kColorFFF;
    _tagContent.numberOfLines = 0;
    _tagContent.font=[UIFont fontWithName:kFontMedium size:13];
    _tagContent.textAlignment = NSTextAlignmentCenter;
   // _tagContent.backgroundColor = [UIColor blackColor];
    _tagContent.lineBreakMode = NSLineBreakByWordWrapping;
    [_tagImage addSubview:_tagContent];
    
    [_tagContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tagImage);
        make.centerX.equalTo(_tagImage);
    }];
    
    UIView *steamView = [[UIView alloc] init];
    steamView.backgroundColor = [UIColor clearColor];
    _steamView = steamView;
    //steamView.hidden = YES;
    
    
    UIView *bgView = [[UIView alloc] init];
    
    _statusBackView = [[UIView alloc] init];
    _statusBackView.backgroundColor = HEXCOLORA(0x6e6e6e, 0.6);
    _statusBackView.layer.cornerRadius = 3;
    _statusBackView.clipsToBounds = YES;
    
    _livingStatusView = [[UIView alloc] init];
    _livingStatusView.backgroundColor = HEXCOLOR(0xffd70f);
    
    _playingImage=[[YYAnimatedImageView alloc]init];
    _playingImage.contentMode=UIViewContentModeScaleAspectFit;
    _playingImage.image = [YYImage imageNamed:@"mall_home_list_living.webp"];
    
    _onlineCount=[[UILabel alloc]init];
    _onlineCount.text=@"";
    _onlineCount.font=[UIFont fontWithName:@"PingFangSC-Regular" size:10];
    _onlineCount.textColor= HEXCOLOR(0xffffff);
    _onlineCount.numberOfLines = 1;
    _onlineCount.clipsToBounds = YES;
    _onlineCount.textAlignment = NSTextAlignmentLeft;
    _onlineCount.lineBreakMode = NSLineBreakByWordWrapping;
    
    /** 添加排名视图*/
    _rankView = [[UIView alloc] init];
    _rankView.backgroundColor = HEXCOLORA(0xde2d12, 0.64);
    _rankView.layer.cornerRadius = 3;
    _rankView.clipsToBounds = YES;

    
    _rankLogoImageView = [[UIImageView alloc] init];
    _rankLogoImageView.image = [UIImage imageNamed:@"custmoize_fire_logo"];
    [_rankView addSubview:_rankLogoImageView];
    
    _rankLabel = [[UILabel alloc] init];
    _rankLabel.font = [UIFont fontWithName:kFontNormal size:11];
    _rankLabel.textColor = [UIColor whiteColor];
    _rankLabel.text = @"";
    [_rankView addSubview:_rankLabel];
    
    _status=[[UILabel alloc]init];
    _status.text=@"直播中";
    _status.font=[UIFont fontWithName:@"PingFangSC-Regular" size:10];
    _status.textColor= kColor333;
    _status.numberOfLines = 1;
    _status.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _status.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    YYLabel *tagLabel = [[YYLabel alloc] init];
    tagLabel.text = @"";
    tagLabel.font = [UIFont fontWithName:kFontNormal size:10];
    tagLabel.textColor = HEXCOLOR(0x222222);
    tagLabel.backgroundColor = HEXCOLOR(0xf5d295);
    tagLabel.layer.cornerRadius = 3;
    tagLabel.clipsToBounds = YES;
    _tagLabel = tagLabel;
    
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    iconImage.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView = iconImage;
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"暂无昵称";
    nameLabel.font = [UIFont fontWithName:kFontNormal size:12];
    nameLabel.textColor = HEXCOLOR(0xffffff);
    _nameLabel = nameLabel;

    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂无标题";
    label.font = [UIFont fontWithName:kFontMedium size:11];
    label.textColor = HEXCOLORA(0xffffff,0.85);
    label.lineBreakMode = NSLineBreakByCharWrapping;
    _titleLabel = label;
    
    YYLabel *addressLabel = [[YYLabel alloc]init];
    addressLabel.text=@"";
    addressLabel.font=[UIFont fontWithName:kFontNormal size:10];
    addressLabel.textColor= HEXCOLOR(0xffffff);
    addressLabel.backgroundColor = HEXCOLORA(0x6e6e6e, 0.6);
    addressLabel.textContainerInset = UIEdgeInsetsMake(0, 4, 0, 4);
    addressLabel.layer.cornerRadius = 2;
    addressLabel.clipsToBounds = YES;
    _addressLabel = addressLabel;
    
    [self addSubview:bgImage];
    [self addSubview:steamView];
    [self addSubview:self.statusBackView];
    [self.statusBackView addSubview:self.livingStatusView];
    [self.livingStatusView addSubview:self.playingImage];
    [self.livingStatusView addSubview:self.status];
    [self.statusBackView addSubview:self.onlineCount];
    [self addSubview:self.rankView];
    [self.rankView addSubview:self.rankLogoImageView];
    [self.rankView addSubview:self.rankLabel];
    [self addSubview:bgView];
    [self addSubview:label];
    [self addSubview:tagLabel];
    [self addSubview:iconImage];
    [self addSubview:nameLabel];
    [self addSubview:addressLabel];
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [steamView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.statusBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@16);
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(8);
    }];
    
    [_livingStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.statusBackView.mas_left);
        make.top.mas_equalTo(self.statusBackView.mas_top);
        make.bottom.mas_equalTo(self.statusBackView.mas_bottom);
    }];
    
    [_playingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_livingStatusView.mas_centerY);
        make.left.equalTo(_livingStatusView.mas_left).offset(3);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_livingStatusView.mas_centerY);
        make.left.equalTo(_playingImage.mas_right).offset(3);
        make.right.mas_equalTo(_livingStatusView.mas_right).offset(-3);
    }];
    
    [_onlineCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_livingStatusView.mas_right).offset(3);
        make.right.equalTo(self.statusBackView.mas_right).offset(-3);
        make.centerY.equalTo(self.statusBackView);
        make.height.equalTo(self.statusBackView);
    }];
    
    [_rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.statusBackView.mas_left);
        make.top.mas_equalTo(self.statusBackView.mas_bottom).offset(10);
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
        
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_left);
        make.bottom.equalTo(self.iconImageView.mas_top).offset(-8);
        make.height.mas_equalTo(18);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_top).offset(-2);
        make.left.equalTo(_iconImageView.mas_right).offset(5);
        make.height.mas_equalTo(16);
        make.right.mas_lessThanOrEqualTo(self.mas_right).offset(-58);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) { make.centerY.equalTo(_nameLabel.mas_centerY);
        make.left.equalTo(_nameLabel.mas_right).offset(4);
        make.height.mas_equalTo(14);
        make.width.mas_lessThanOrEqualTo(48);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.top.equalTo(_nameLabel.mas_bottom);
        make.height.mas_equalTo(15);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(73.f);
    }];
    
    [bgView layoutIfNeeded];
    [bgView jh_setGradientBackgroundWithColors:@[HEXCOLORA(0x000000, .0f), HEXCOLORA(0x000000, .8f)] locations:@[@0, @0.5, @1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    [_iconImageView layoutIfNeeded];
    _iconImageView.layer.cornerRadius = _iconImageView.height/2.f;
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconImageView.layer.borderWidth = 1.f;
    
    
    
    
}

@end

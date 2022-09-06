//
//  JHSQUserInfoView.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQUserInfoView.h"
#import "YYControl.h"
#import "JHSQManager.h"
#import "JHSQMedalView.h"
#import "JHUserInfoViewController.h"
#import "JHSQHomePageController.h"
//#import "UIImageView+JHWebImage.h"
//#import "TTjianbaoMarcoUI.h"
//#import "TTjianbaoUtil.h"


@interface JHSQUserInfoView ()

@property (nonatomic, strong) YYControl *contentControl; //整体容器视图
@property (nonatomic, strong) YYControl *userContainer; //显示用户信息<头像+昵称> 事件单独处理
@property (nonatomic, strong) UIImageView *circleIcon;
@property (nonatomic, strong) UIImageView *avatarIcon; //头像
@property (nonatomic, strong) YYAnimatedImageView *liveGifView; //直播中图标
@property (nonatomic, strong) UILabel *nameLabel; //用户名
@property (nonatomic, strong) UILabel *descLabel; //发布时间 (如果是直播间，这里显示粉丝数 desc字段)
@property (nonatomic, strong) UIButton *moreButton; //更多
@property (nonatomic, strong) JHSQMedalView *metalView;///勋章view
///显示审核中状态
@property (nonatomic, strong) UILabel *checkLabel;

///显示编辑审核中状态
@property (nonatomic, strong) UILabel *editCheckLabel;

@end

@implementation JHSQUserInfoView

+ (CGFloat)viewHeight {
    return 65.0;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    if (!_contentControl) {
        _contentControl = [YYControl new];
        _contentControl.exclusiveTouch = YES;
        @weakify(self);
        _contentControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            @strongify(self);
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:self];
                if (CGRectContainsPoint(self.bounds, p)) {
                    //点击用户头像+昵称后面的空白处
                    if (self.postData.item_type == JHPostItemTypeLiveRoom) {
                        if ([self.postData.publisher.room_id isNotBlank]) {
                            [JHRootController EnterLiveRoom:self.postData.publisher.room_id fromString:JHFromSQHomeFeedList];
                        }
                    } else {
                        [JHRouterManager pushPostDetailWithItemType:self.postData.item_type itemId:self.postData.item_id pageFrom:self.pageFrom scrollComment:0];
                    }
                }
            }
        };
    }
    
    if (!_userContainer) {
        _userContainer = [YYControl new];
        _userContainer.exclusiveTouch = YES;
        @weakify(self);
        _userContainer.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            @strongify(self);
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:self];
                if (CGRectContainsPoint(self.bounds, p)) {
                    if (self.clickUserInfoBlock) {
                        self.clickUserInfoBlock();
                    }
                }
            }
        };
    }
    
    if (!_circleIcon) {
        _circleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mall_like_circle_img"]];
    }
    
    if (!_avatarIcon) {
        _avatarIcon = [[UIImageView alloc] init];
        _avatarIcon.clipsToBounds = YES;
        _avatarIcon.sd_cornerRadius = @(17.0);
        _avatarIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    if (!_liveGifView) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_on_live" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        YYImage *image = [YYImage imageWithData:data];
        _liveGifView = [[YYAnimatedImageView alloc] initWithImage:image];
        _liveGifView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    //认证鉴定师、主播、商家认证图标
    
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:13] textColor:kColor333];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    if (!_metalView) {
        _metalView = [JHSQMedalView new];
    }
    
    if (!_descLabel) {
        _descLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:11] textColor:kColor999];
    }
    
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"sq_icon_more"] forState:UIControlStateNormal];
        _moreButton.contentMode = UIViewContentModeScaleAspectFit;
        @weakify(self);
        [[_moreButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [JHNotificationCenter postNotificationName:UIKeyboardWillHideNotification object:nil];
            @strongify(self);
            if (self.clickMoreBlock) {
                self.clickMoreBlock();
            }
        }];
    }
    
    if (!_checkLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"审核中";
        label.font = [UIFont fontWithName:kFontNormal size:11];
        label.textColor = kColor999;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 10.f;
        label.layer.borderColor = [kColorEEE CGColor];
        label.layer.borderWidth = .5f;
        label.layer.masksToBounds = YES;
        _checkLabel = label;
        label.hidden = YES;
    }
    
    [_contentControl addSubview:_circleIcon];
    [_contentControl addSubview:_avatarIcon];
    [_contentControl addSubview:_liveGifView];
    [_contentControl addSubview:_nameLabel];
    [_contentControl addSubview:_metalView];
    [_contentControl addSubview:_descLabel];
    [_contentControl addSubview:_moreButton];
    [_contentControl addSubview:_checkLabel];
    [_contentControl addSubview:self.editCheckLabel];
    [_contentControl addSubview:_userContainer];
    [self addSubview:_contentControl];
    
    //布局
    _contentControl.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _circleIcon.sd_layout
    .topSpaceToView(_contentControl, 15)
    .leftSpaceToView(_contentControl, 10)
    .widthIs(38).heightEqualToWidth();
    
    _avatarIcon.sd_layout
    .centerXEqualToView(_circleIcon)
    .centerYEqualToView(_circleIcon)
    .widthIs(34).heightEqualToWidth();
    
    _liveGifView.sd_layout
    .rightEqualToView(_circleIcon)
    .bottomEqualToView(_circleIcon)
    .widthIs(17).heightEqualToWidth();
    
    _moreButton.sd_layout
    .rightSpaceToView(_contentControl, 6)
    .centerYEqualToView(_contentControl)
    .widthIs(30).heightIs(30);
    
    self.editCheckLabel.sd_layout
    .rightSpaceToView(_moreButton, 0)
    .centerYEqualToView(_moreButton)
    .widthIs(65).heightIs(20);
    
    _checkLabel.sd_layout
    .rightSpaceToView(_contentControl, 6)
    .centerYEqualToView(_contentControl)
    .widthIs(45).heightIs(20);
    
    _nameLabel.sd_layout
    .topEqualToView(_circleIcon)
    .leftSpaceToView(_circleIcon, 8)
    .heightIs(20)
    .minHeightIs(20)
    .autoWidthRatio(0);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:130];
    
    _metalView.sd_layout
    .leftSpaceToView(_nameLabel, 5)
    .centerYEqualToView(_nameLabel)
    .rightSpaceToView(_moreButton, 10)
    .heightIs(15.0);
    
    _descLabel.sd_layout
    .leftSpaceToView(_circleIcon, 8)
    .topSpaceToView(_nameLabel, 2)
    .heightIs(16)
    .widthIs(150);
    
    _userContainer.sd_layout
    .leftSpaceToView(_contentControl, 0)
    .topSpaceToView(_contentControl, 0)
    .bottomSpaceToView(_contentControl, 0);
}

- (void)setPostData:(JHPostData *)postData {
    _postData = postData;
    
    JHPublisher *publisher = postData.publisher;

    //头像
    if(_postData.recommend_type == 3) {///关注的版块显示版块
        [_avatarIcon jhSetImageWithURL:[NSURL URLWithString:_postData.plate_info.image]
                                     placeholder:kDefaultCoverImage];
    } else {
        [_avatarIcon jhSetImageWithURL:[NSURL URLWithString:publisher.avatar]
                                     placeholder:kDefaultCoverImage];
    }
    switch (_postData.recommend_type) {
        case 2:
        {
            _descLabel.text = @"关注的人";
        }
            break;
        
        case 3:
        {
            _descLabel.text = @"关注的版块";
        }
            break;
        default:
        {
            //显示发布时间
            _descLabel.text = ([_postData.publish_time isNotBlank] ? _postData.publish_time : @"");
        }
            break;
    }
    //用户名
    
    _nameLabel.text = ([publisher.user_name isNotBlank] ? publisher.user_name : @"");
    
    //认证鉴定师、主播、商家认证图标
    _metalView.tagArray = postData.publisher.levelIcons;
    
    _metalView.sd_layout.leftSpaceToView(_nameLabel, 5);
    [_metalView updateLayout];
    [_metalView layoutIfNeeded];
    _metalView.hidden = (postData.recommend_type == 3);
    [_userContainer setupAutoWidthWithRightView:_nameLabel rightMargin:(postData.publisher.levelIcons.count * 35 + 10)];
    
    //区分直播间和其他帖子
    if (postData.item_type == JHPostItemTypeLiveRoom) {
        _circleIcon.hidden = YES;
        _liveGifView.hidden = YES;
        //显示粉丝数信息
        NSString *fansNumStr = [CommHelp convertNumToWUnitString:publisher.fans_num existDecimal:YES];
        _descLabel.text = [NSString stringWithFormat:@"%@粉丝", fansNumStr];
        
    } else {
        //圆圈
        _circleIcon.hidden = !(publisher.is_live && publisher.room_id.integerValue > 0);
        //直播状态
        _liveGifView.hidden = !(publisher.is_live && publisher.room_id.integerValue > 0);
        switch (_postData.recommend_type) {
            case 2:
            {
                _descLabel.text = @"关注的人";
            }
                break;
            
            case 3:
            {
                _descLabel.text = @"关注的版块";
                _nameLabel.text = _postData.plate_info.name;
            }
                break;
            default:
            {
                //显示发布时间
                _descLabel.text = ([_postData.publish_time isNotBlank] ? _postData.publish_time : @"");
            }
                break;
        }
    }
    
    id vc = JHRootController.currentViewController;
    NSLog(@"JHRootController.homeTabController ----- %@", JHRootController.homeTabController.selectedViewController);
    if ([vc isMemberOfClass:[JHUserInfoViewController class]] &&
        postData.show_status == JHPostDataShowStatusChecking) {
        ///个人主页帖子处于审核中状态
        _checkLabel.hidden = NO;
        _moreButton.hidden = YES;
    }
    else if ([JHRootController.homeTabController.selectedViewController isMemberOfClass:[JHSQHomePageController class]] &&
             postData.show_status == JHPostDataShowStatusChecking &&
             postData.is_self) {
        _checkLabel.hidden = NO;
        _moreButton.hidden = YES;
    }
    else if (postData.item_type == JHPostItemTypeAD ||
            postData.item_type == JHPostItemTypeTopic ||
            postData.item_type == JHPostItemTypeLiveRoom) {
        _moreButton.hidden = YES;
        _checkLabel.hidden = YES;
    }
    else {
        _moreButton.hidden = NO;
        _checkLabel.hidden = YES;
    }
    
    self.editCheckLabel.hidden = !(_postData.is_self && _postData.is_edit_check && (_pageType == JHPageTypeUserInfo || _pageType == JHPageTypeUserInfoLikeTab || _pageType == JHPageTypeUserInfoPublishTab));
}

- (UILabel *)editCheckLabel {
    if(!_editCheckLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"修改审核中";
        label.font = [UIFont fontWithName:kFontNormal size:11];
        label.textColor = kColor999;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 10.f;
        label.layer.borderColor = [kColorEEE CGColor];
        label.layer.borderWidth = .5f;
        label.layer.masksToBounds = YES;
        label.hidden = YES;
        _editCheckLabel = label;
    }
    return _editCheckLabel;
}

@end

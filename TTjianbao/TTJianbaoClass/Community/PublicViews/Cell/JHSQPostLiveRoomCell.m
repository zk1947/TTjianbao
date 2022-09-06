//
//  JHSQPostLiveRoomCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQPostLiveRoomCell.h"
#import "JHSQHelper.h"
#import "JHSQModel.h"
#import "JHSQUserInfoView.h"
#import "JHGemmologistViewController.h"
#import "UIView+CornerRadius.h"
#import "UIImage+GIF.h"
#import "YYKit.h"

@interface JHSQPostLiveRoomCell ()
@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) JHSQUserInfoView *userInfoView;

@property (nonatomic, strong) UILabel *descLabel; //直播描述
@property (nonatomic, strong) UIImageView *liveImgView; //直播预览图
@property (nonatomic, strong) UIView *bottomLine;

///底部黄色view
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) YYAnimatedImageView *liveIcon;
@property (nonatomic, strong) UILabel *liveLabel;
@property (nonatomic, strong) UILabel *liveDescLabel;

@end

@implementation JHSQPostLiveRoomCell

+ (CGFloat)viewHeight {
    return (ScreenW - 20);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    CGFloat viewHeight = [[self class] viewHeight];
    
    //0
    if (!_contentControl) {
        _contentControl = [YYControl new];
        _contentControl.clipsToBounds = YES;
        _contentControl.exclusiveTouch = YES;
        [self.contentView addSubview:_contentControl];
        @weakify(self);
        _contentControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            @strongify(self);
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:self];
                if (CGRectContainsPoint(self.bounds, p)) {
                    [self handleClickEvent];
                }
            }
        };
    }
    
    //1 用户信息栏
    _userInfoView = [[JHSQUserInfoView alloc] initWithFrame:CGRectZero];
    @weakify(self);
    _userInfoView.clickUserInfoBlock = ^{
        @strongify(self);
        [self handleClickUserInfoEvent];
    };
    _userInfoView.clickMoreBlock = ^{
        @strongify(self);
        [self handleClickMoreEvent];
    };
    
    //3 直播描述
    _descLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:16.f] textColor:kColor333];
    
    //4 直播预览动图
    _liveImgView = [UIImageView new];
    _liveImgView.clipsToBounds = YES;
    _liveImgView.backgroundColor = HEXCOLOR(0x1F1F1F);
    _liveImgView.clipsToBounds = YES;
    _liveImgView.sd_cornerRadius = @(8.f);
    _liveImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    //拉流视图
    _stearmView = [[UIView alloc]init];
    _stearmView.backgroundColor = [UIColor clearColor];
    _stearmView.layer.masksToBounds = YES;
    _stearmView.layer.cornerRadius = 8.f;
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = kColorMain;
    _bottomView.clipsToBounds = YES;
    [_bottomView yd_setCornerRadius:8.f corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    
    YYImage *image = [YYImage imageNamed:@"icon_pic.gif"];
    _liveIcon = [[YYAnimatedImageView alloc] initWithImage:image];
    _liveIcon.contentMode = UIViewContentModeScaleAspectFit;
    [_bottomView addSubview:_liveIcon];
    
    _liveLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:15] textColor:kColor333];
    _liveLabel.text = @"点击进入购物直播间";
    [_bottomView addSubview:_liveLabel];
    
    _liveDescLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:10] textColor:kColor333];
    _liveDescLabel.textAlignment = NSTextAlignmentCenter;
    _liveDescLabel.text = @"平台已为宝友把关0件";
    [_bottomView addSubview:_liveDescLabel];
    
    //5 底部分割线
    _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomLine.backgroundColor = kColorF5F6FA;
    
    [_contentControl sd_addSubviews:@[_userInfoView, _descLabel, _liveImgView,_stearmView, _bottomView, _bottomLine]];
    
    //----布局----
    _contentControl.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView);
    
    _userInfoView.sd_layout
    .topEqualToView(_contentControl)
    .leftEqualToView(_contentControl)
    .rightEqualToView(_contentControl)
    .heightIs([JHSQUserInfoView viewHeight]);
    
    _descLabel.sd_layout
    .topSpaceToView(_userInfoView, 0)
    .leftSpaceToView(_contentControl, 10)
    .rightSpaceToView(_contentControl, 10)
    .heightIs(18);
    
    _liveImgView.sd_layout
    .topSpaceToView(_descLabel, 10)
    .leftSpaceToView(_contentControl, 10)
    .widthIs(viewHeight)
    .heightIs(viewHeight);
    
    _bottomView.sd_layout
    .leftSpaceToView(_contentControl, 10)
    .rightSpaceToView(_contentControl, 10)
    .bottomEqualToView(_liveImgView)
    .heightIs(70);
    
    [_liveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView).offset(10);
        make.top.equalTo(self.bottomView).offset(15);
        make.size.mas_equalTo(CGSizeMake(135.f, 21.f));
    }];
    
    [_liveIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.liveLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.liveLabel);
        make.size.mas_equalTo(CGSizeMake(15.f, 15.f));
    }];
    
    [_liveDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.liveLabel.mas_bottom).offset(5);
        make.left.right.equalTo(self.bottomView);
        make.height.mas_equalTo(14.f);
    }];
    
    [_stearmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_liveImgView);
    }];
    
    _bottomLine.sd_layout
    .leftSpaceToView(_contentControl, 0)
    .rightSpaceToView(_contentControl, 0)
    .topSpaceToView(_liveImgView, 15)
    .heightIs(10);
    
    [_contentControl setupAutoHeightWithBottomViewsArray:@[_bottomLine] bottomMargin:0];
    [self setupAutoHeightWithBottomViewsArray:@[_contentControl, _bottomLine] bottomMargin:0];
}

- (void)setPostData:(JHPostData *)postData {
    _postData = postData;
    
    _userInfoView.postData = postData;
    
    _descLabel.text = postData.title;
    
    [_liveImgView jhSetImageWithURL:[NSURL URLWithString:postData.image] placeholder:kDefaultCoverImage];
}

- (void)setOrderCount:(NSString *)orderCount {
    _orderCount = orderCount;
    if ([orderCount isNotBlank]) {
        _liveDescLabel.text = [NSString stringWithFormat:@"平台已为宝友把关 %@ 件", orderCount];
    }
}

#pragma mark -
#pragma mark - 点击事件
//NSLog(@"点击进入直播间");
- (void)handleClickEvent {
//    JHPublisher *publisher = _postData.publisher;
//    if ([publisher.room_id isNotBlank]) {
//        [JHRootController EnterLiveRoom:publisher.room_id fromString:JHFromSQHomeFeedList];
//    }
    ///369神策埋点:直播间点击  只有推荐列表有直播间!!!
    JHTrackLiveRoomModel *model = [[JHTrackLiveRoomModel alloc] init];
    model.page_position = @"社区推荐";
    model.channel_id = _postData.publisher.room_id;
    model.channel_name = _postData.publisher.channel_name;
    model.anchor_id = _postData.publisher.user_id;
    model.anchor_nick_name = _postData.publisher.user_name;
    model.anchor_role = @(_postData.publisher.role).stringValue;
    [JHTracking trackClickLiveRoom:model];
    
    [JHRootController toNativeVC:_postData.target.componentName withParam:_postData.target.params from:JHFromSQHomeFeedList];
}

//NSLog(@"点击用户信息");
- (void)handleClickUserInfoEvent {
    JHPublisher *publisher = _postData.publisher;
    [JHRouterManager pushUserInfoPageWithUserId:publisher.user_id publisher:publisher from:JHFromSQHomeFeedList roomId:publisher.room_id];
}

//NSLog(@"点击点点点");
- (void)handleClickMoreEvent {
    @weakify(self);
    [JHBaseOperationView creatSQOperationView:self.postData Block:^(JHOperationType operationType) {
        @strongify(self);
        [JHBaseOperationAction operationAction:operationType operationMode:self.postData bolck:^{
            //成功
            if (self.operationAction) {
                NSNumber *type=[NSNumber numberWithInteger:operationType];
                self.operationAction(type, self.postData);
            }
        }];
    }];
}

@end

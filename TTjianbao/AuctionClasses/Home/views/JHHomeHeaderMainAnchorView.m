//
//  TTjianbao
//
//  Created by jiangchao on 2019/2/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHHomeHeaderMainAnchorView.h"
#import "TTjianbaoHeader.h"
#import "JHOnlineLivingStatusView.h"

#define topImageRate (float) 198./351.

@interface JHHomeHeaderMainAnchorView ()
{
    UIButton *celebrateTag;
    BOOL activeTheme;
}

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UIImageView *coverImage;
@property (strong, nonatomic) UIView *tagsBackView;
///直播状态view --- TODO lihui
@property (strong, nonatomic) JHOnlineLivingStatusView *statusView;
@property (nonatomic, strong) UILabel *restLabel;

@end
@implementation JHHomeHeaderMainAnchorView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.clipsToBounds = YES;
        self.backgroundColor = kColorFFF;
        [self setUp];
    }
    return self;
}

-(void)setUp{
    UIView * backView = [[UIView alloc] init];
    backView.backgroundColor = kColorFFF;
    backView.layer.cornerRadius = 2;
    backView.userInteractionEnabled = NO;
    _backView = backView;

    _coverImage = [[UIImageView alloc]init];
    _coverImage.image = [UIImage imageNamed:@""];
    _coverImage.layer.cornerRadius = 5.f;
    _coverImage.contentMode = UIViewContentModeScaleAspectFill;
    _coverImage.layer.masksToBounds = YES;
    
    _content = [[UIView alloc]init];
    _content.backgroundColor = [UIColor clearColor];
    _content.layer.masksToBounds = YES;
    _content.layer.cornerRadius = 5.f;
    
    ///不需要布局 该view自动布局 ----- MARK： TODO lihui
    JHOnlineLivingStatusView *statusView = [[JHOnlineLivingStatusView alloc] init];
    _statusView = statusView;
    statusView.hidden = YES;
    
    _restLabel = [[UILabel alloc] init];
    _restLabel.text = @"休息中";
    _restLabel.backgroundColor = HEXCOLORA(0xFFFFFF, .15);
    _restLabel.font = [UIFont fontWithName:kFontNormal size:10.];
    _restLabel.textAlignment = NSTextAlignmentCenter;
    _restLabel.textColor = kColorFFF;
    _restLabel.layer.cornerRadius = 1.f;
    _restLabel.layer.masksToBounds = YES;
        
    [self addSubview:backView];
    [backView addSubview:_coverImage];
    [_coverImage addSubview:_content];
    [_coverImage addSubview:_statusView];
    [_coverImage addSubview:_restLabel];
    ///布局
    [self makeLayouts];
    [self drawCelebrateTag];
}

- (void)makeLayouts {
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 12, 0, 12));
    }];

    [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backView);
    }];
    
    [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.coverImage).offset(8.);
        make.height.mas_equalTo(16);
    }];
    
    [_restLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.coverImage).offset(8.);
        make.size.mas_equalTo(CGSizeMake(36., 16.));
    }];
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusView);
        make.bottom.offset(-5);
        make.top.equalTo(self.statusView.mas_bottom).offset(5);
        make.width.offset(135);
        make.height.offset(((ScreenW-24)*topImageRate-32)*122/156.);
    }];
}

- (void)drawCelebrateTag {
    [celebrateTag setHidden:YES];
    if(activeTheme) {
        if(!celebrateTag) {
            celebrateTag = [UIButton buttonWithType:UIButtonTypeCustom];
            [celebrateTag setImage:[UIImage imageNamed:@"celebrate_appraise_mark"] forState:UIControlStateNormal];
            [_coverImage addSubview:celebrateTag];
            [celebrateTag setHidden:YES];
            [celebrateTag mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_coverImage);
                make.right.equalTo(_coverImage).offset(4-10);
                make.size.mas_equalTo(CGSizeMake(40, 45));
            }];
        }
        [celebrateTag setHidden:NO];
    }
}
    
-(void)setLiveRoomMode:(JHLiveRoomMode *)liveRoomMode {
    _liveRoomMode = liveRoomMode;
    //周年庆标签
    [self drawCelebrateTag];
    [_coverImage jhSetImageWithURL:[NSURL URLWithString:liveRoomMode.coverImg] placeholder:kDefaultCoverImage];
    
    ///设置直播状态
    if ([_liveRoomMode.status integerValue] == 2) {
        ///直播中
        [_statusView configWatchCount:_liveRoomMode.watchTotalString];
        _statusView.hidden = NO;
        _restLabel.hidden = YES;
    }
    else {
        _restLabel.hidden = NO;
        _statusView.hidden = YES;
    }
}

- (void)refreshThemeView:(BOOL)isActiveTheme
{
    activeTheme = isActiveTheme;
    [self drawCelebrateTag];
}

-(void)buttonPress:(UIButton*)button{
    if (self.clickButton) {
        self.clickButton(button, self.liveRoomMode);
    }
}

@end


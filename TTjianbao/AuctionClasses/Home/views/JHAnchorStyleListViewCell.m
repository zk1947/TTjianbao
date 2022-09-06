//
//  JHAnchorStyleListViewCell.m
//  TTjianbao
//
//  Created by Donto on 2020/7/6.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAnchorStyleListViewCell.h"
#import <UIColor+YYAdd.h>
#import "TTjianbaoMarcoUI.h"
#import "UIImageView+JHWebImage.h"
#import "NSString+AttributedString.h"
#import <UIImage+webP.h>
#import "JHGrowingIO.h"
#import "JHNimNotificationManager.h"
@interface JHAnchorStyleListViewCell ()

@property (nonatomic, strong) UIView *backContentView;

@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UIButton *liveButton;
@property (nonatomic, strong) UIImageView *liveIconView;
@property (nonatomic, strong) UIButton *remindButton;
@property (nonatomic, strong) UILabel *remindLable;
@property (nonatomic, strong) UIButton *applyButton;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) CAGradientLayer *applyGradientLayer;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *vImageView;
@property (nonatomic, strong) UILabel *authenLabel;

@end

@implementation JHAnchorStyleListViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addContentViews];
    }
    return self;
}

- (void)addContentViews {
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;

    UIView *backContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height - 5)];
    backContentView.backgroundColor = UIColor.whiteColor;
    backContentView.layer.cornerRadius = 8;
    _backContentView = backContentView;
    
    UIImageView *profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width*131/175)];
    [self setCornerRadius:profileImageView Corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    _profileImageView = profileImageView;
    
    UILabel *nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, profileImageView.bottom+10, width - 10, 21)];
    nickNameLabel.textColor = [UIColor colorWithRGB:0X111111];
    nickNameLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    _nickNameLabel = nickNameLabel;

    UIImageView *vImageView = [UIImageView new];
    vImageView.image = [UIImage imageNamed:@"icon_right_yellow"];
    
    UILabel *authenLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, profileImageView.bottom+10, width - 10, 21)];
    authenLabel.textColor = kColor666;
    authenLabel.font = [UIFont systemFontOfSize:11];
    _authenLabel = authenLabel;
    
    UILabel *desLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, nickNameLabel.bottom+10, width - 10, 17)];
    desLabel.textColor = [UIColor colorWithRGB:0X666666];
    desLabel.font = [UIFont systemFontOfSize:12];
    _desLabel = desLabel;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(width/2.0, desLabel.bottom + 7, 0.5, 10)];
    lineView.backgroundColor = kColorEEE;
    _lineView = lineView;
    
    UILabel *statusLabel = [[UILabel alloc]init];
    statusLabel.textColor = [UIColor colorWithRGB:0X666666];
   // statusLabel.backgroundColor = [UIColor redColor];
    statusLabel.font = [UIFont systemFontOfSize:10];
    _statusLabel = statusLabel;
    
    UILabel *gradeLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2.0+10, desLabel.bottom+5, width/2.0 - 20, 14)];
    gradeLabel.textColor = [UIColor colorWithRGB:0X666666];
    gradeLabel.font = [UIFont systemFontOfSize:10];
    gradeLabel.textAlignment = NSTextAlignmentLeft;
    _gradeLabel = gradeLabel;

    
    [backContentView addSubview:profileImageView];
    [backContentView addSubview:nickNameLabel];
    [backContentView addSubview:vImageView];
    [backContentView addSubview:authenLabel];
    [backContentView addSubview:desLabel];
    [backContentView addSubview:statusLabel];
    [backContentView addSubview:gradeLabel];
    [backContentView addSubview:self.liveButton];
    [backContentView addSubview:self.remindLable];
    [backContentView addSubview:self.remindButton];
    [backContentView.layer addSublayer:self.applyGradientLayer];
    [backContentView addSubview:self.applyButton];
    [backContentView addSubview:self.lineView];

    [self.contentView addSubview:backContentView];

    [self.liveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(5);
        make.height.mas_equalTo(18);

    }];
    
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(profileImageView.bottom+10);
        make.height.mas_equalTo(21);
    }];
    
    [vImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickNameLabel.mas_right).offset(5);
        make.height.width.mas_equalTo(14);
        make.centerY.equalTo(nickNameLabel);
    }];
    
    [authenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vImageView.mas_right).offset(1);
        make.height.mas_equalTo(21);
        make.centerY.equalTo(nickNameLabel);
        make.right.mas_lessThanOrEqualTo(-10);

    }];
    
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickNameLabel);
        make.height.mas_equalTo(14);
        make.top.mas_equalTo(desLabel.bottom+5);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.left.equalTo(statusLabel.mas_right).offset(8);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(0.5);
        make.centerY.equalTo(statusLabel);
    }];
    
    [gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(10);
        make.height.mas_equalTo(14);
        make.centerY.equalTo(statusLabel);
        make.right.mas_equalTo(-10);
    }];
}


- (void)setCornerRadius:(UIView *)view Corners:(UIRectCorner)corners {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

- (void)remindAction:(UIButton *)sender {
    
    if (![JHRootController isLogin]){
        [JHRootController presentLoginVC];
        return;
    }
    
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/authoptional/appraise/follow") Parameters:@{@"followCustomerId":_model.customerId,@"status":@(!_model.isFollow)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        _model.isFollow = !_model.isFollow;
        [self setFollow:_model.isFollow];
    } failureBlock:^(RequestModel *respondObject) {
    }];
    [JHGrowingIO trackEventId:JHIdentifyActivityChooseRemindClick];
}

- (void)applyAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(applyAnchor:)]) {
        [_delegate applyAnchor:_model];
    }
}

- (void)setModel:(JHRecommendAppraiserListItem *)model {
    _model = model;
    [_applyButton setTitleColor:kColor333 forState:UIControlStateNormal];
    if (model.state == 1) { // 直播中
        _statusLabel.text = [NSString stringWithFormat:@"排班：%@",model.appraiseTime];
        
        NSString *liveTitle = [NSString stringWithFormat:@"       直播中 | %ld观看   ",model.watchTotal];
        [self.liveButton setTitle:liveTitle forState:UIControlStateNormal];
        
        _gradeLabel.hidden = NO;
        _gradeLabel.text =  [NSString stringWithFormat:@"好评率： %@%%",model.grade];;
        
        NSString *string =  [NSString stringWithFormat:@"排队人数：%ld",(long)model.waitNumber];
        NSMutableAttributedString *attString =  [string attributedSubString:@(model.waitNumber).stringValue font:_statusLabel.font color:HEXCOLOR(0xFF4200) allColor:_statusLabel.textColor allfont:_statusLabel.font];
        _statusLabel.attributedText = attString;
        
        if (model.canAppraise) {
            [_applyButton setTitle:@"申请鉴定" forState:UIControlStateNormal];
            _applyButton.enabled = YES;
            _applyGradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:254/255.0 green:225/255.0 blue:0/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:194/255.0 blue:66/255.0 alpha:1.0].CGColor];
        }
        else {
            [_applyButton setTitle:@"暂停申请" forState:UIControlStateNormal];
            _applyGradientLayer.colors = @[(__bridge id)[UIColor colorWithRGB:0XEEEEEE].CGColor, (__bridge id)[UIColor colorWithRGB:0XEEEEEE].CGColor];
            [_applyButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
            _applyButton.enabled = NO;
        }
        _applyButton.hidden = _applyGradientLayer.hidden = !(model.state == 1);

        _lineView.hidden = NO;
    }
    else {
        _statusLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"排班：%@",model.appraiseTime]];
       NSString *liveTitle = @"   休息中   ";
       [self.liveButton setTitle:liveTitle forState:UIControlStateNormal];
        _gradeLabel.hidden = YES;
        _lineView.hidden = YES;

    }
    
    _nickNameLabel.text = model.name?:@"";
    _authenLabel.text = @"认证鉴定师";
    _applyButton.hidden = _applyGradientLayer.hidden = !(model.state == 1);
    _liveIconView.hidden = !(model.state == 1);
    _desLabel.text = [NSString stringWithFormat:@"擅长：%@",model.appraiserTag];
    [self.profileImageView jhSetImageWithURL:[NSURL URLWithString:model.smallCoverImg]];
    [self setFollow:model.isFollow];
    
    JHMicWaitMode *micModel = [JHNimNotificationManager sharedManager].micWaitMode;
    if (micModel.isWait && [micModel.waitChannelLocalId isEqualToString:_model.channelId]) {
        [_applyButton setTitle:@"排队中" forState:UIControlStateNormal];
        _applyButton.enabled = NO;
        _applyGradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:254/255.0 green:225/255.0 blue:0/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:194/255.0 blue:66/255.0 alpha:1.0].CGColor];
        
    }
}

- (void)setFollow:(BOOL)isFollow {
    UILabel *remindLable = self.remindLable;
    if(!isFollow){
        remindLable.textColor = kGlobalThemeColor;
        remindLable.layer.cornerRadius = 8;
        remindLable.font = [UIFont systemFontOfSize:10];
        remindLable.text = @"提醒";
        remindLable.layer.cornerRadius = 8.0;
        remindLable.layer.borderColor = kGlobalThemeColor.CGColor;
        remindLable.layer.borderWidth = 1;
    }
    else {
        remindLable.textColor = [UIColor colorWithRGB:0XEEEEEE];
        remindLable.layer.cornerRadius = 8;
        remindLable.font = [UIFont systemFontOfSize:10];
        remindLable.text = @"已关注";
        remindLable.layer.cornerRadius = 8.0;
        remindLable.layer.borderColor = [UIColor colorWithRGB:0XEEEEEE].CGColor;
        remindLable.layer.borderWidth = 1;
    }
}

- (UIButton *)liveButton {
    if (!_liveButton) {
        UIButton *liveButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 0, 18)];
        liveButton.backgroundColor = [UIColor colorWithRGB:0X000000 alpha:0.4];
        [liveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        liveButton.userInteractionEnabled = NO;
        liveButton.layer.cornerRadius = 9;
        liveButton.titleLabel.font = [UIFont systemFontOfSize:10];

        NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_home_living" ofType:@"webp"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *webpImage = [UIImage sd_imageWithWebPData:data];
        
        UIImageView *liveIconView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 2, 14, 14)];
        liveIconView.image = webpImage;
        _liveIconView = liveIconView;
        [liveButton addSubview:liveIconView];
        _liveButton = liveButton;
    }
    return _liveButton;
}

- (UILabel *)remindLable {
    if (!_remindLable) {
        UILabel *remindLable = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 45, 5, 40, 16)];
        remindLable.textColor = kGlobalThemeColor;
        remindLable.layer.cornerRadius = 8;
        remindLable.font = [UIFont systemFontOfSize:10];
        remindLable.text = @"提醒";
        remindLable.textAlignment = NSTextAlignmentCenter;
        remindLable.layer.cornerRadius = 8.0;
        remindLable.layer.borderColor = kGlobalThemeColor.CGColor;
        remindLable.layer.borderWidth = 1;
        _remindLable = remindLable;
    }
    return _remindLable;
}

- (UIButton *)remindButton {
    if (!_remindButton) {
        UIButton *remindButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 55, 0, 50, 26)];
        [remindButton addTarget:self action:@selector(remindAction:) forControlEvents:UIControlEventTouchUpInside];

        _remindButton = remindButton;
    }
    return _remindButton;
}

- (UIButton *)applyButton {
    if (!_applyButton) {
        UIButton *applyButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 70,self.profileImageView.height - 30 , 65, 25)];
        [applyButton setTitleColor:kColor333 forState:UIControlStateNormal];
        applyButton.layer.cornerRadius = 12.5;
        applyButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _applyButton = applyButton;
        [applyButton setTitle:@"申请鉴定" forState:UIControlStateNormal];
        [applyButton addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyButton;
}


- (CAGradientLayer *)applyGradientLayer {
    if (!_applyGradientLayer) {
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = self.applyButton.frame;
        gl.startPoint = CGPointMake(0, 0.5);
        gl.endPoint = CGPointMake(1, 0.5);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:254/255.0 green:225/255.0 blue:0/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:194/255.0 blue:66/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        gl.cornerRadius = 12.5;
        gl.masksToBounds = YES;
        _applyGradientLayer = gl;
    }
    return _applyGradientLayer;
}

@end

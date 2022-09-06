//
//  NTESLDView.m
//  NTESLiveDetectPublicDemo
//
//  Created by Ke Xu on 2019/10/14.
//  Copyright © 2019 Ke Xu. All rights reserved.
//

#import "NTESLiveDetectView.h"
#import <Masonry.h>
#import "LDDemoDefines.h"
#import "UIImageView+NTESLDGif.h"
#import "NTESDottedLineProgress.h"
#import "UIColor+NTESLiveDetect.h"
#import "JHCountDownBarView.h"

#define DegreesToRadian(x) (M_PI * (x) / 180.0)

@interface NTESLiveDetectView ()

@property (nonatomic, strong) UILabel *actionsText;
@property (nonatomic, strong) UIImageView *frontImage;
@property (nonatomic, strong) UIImageView *actionImage;
@property (nonatomic, strong) UIView *actionIndexView;
@property (nonatomic, assign) NSUInteger actionsCount; /// 已完成的动作个数
@property (nonatomic, copy) NSArray *imageArray; /// 动图数组
@property (nonatomic, copy) NSArray *musicArray; /// 音频数组
@property (nonatomic, copy) NSString *actions; /// 动作序列
@property (nonatomic, copy) NSArray *indexViewArray; /// 底部进度标识view组
@property (nonatomic, strong) AVAudioPlayer *player; /// 音频播放组件
@property (nonatomic, strong) JHCountDownBarView *progressView;

// 头部标题
@property (nonatomic, strong) UILabel  *navTitleLabel;

@property (nonatomic, strong) UILabel *detectExceptionLabel;

@property (nonatomic, copy) NSString *statusText;

@property (nonatomic, strong) UILabel *fuzzyImage;

@end

@implementation NTESLiveDetectView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.actionsCount = 0;
        self.imageArray = @[@"", @"turn-right", @"turn-left", @"open-mouth", @"open-eyes"];
        self.musicArray = @[@"", @"turn-right", @"turn-left", @"open-mouth", @"open-eyes"];
        
        [self customInitSubViews];
    }
    return self;
}

- (void)customInitSubViews {
    [self __initActionsText];
    [self __initImageView];
    [self __initActivityIndicator];
    [self __initDetectExceptionLabel];
}

- (void)showActionTips:(NSString *)actions {
    self.actions = actions;
    DLog(@"-----actions:%@", self.actions);
    [self __initActionIndexView];
    [self __initFrontImage];
    [self __initActionImage];
    [self __initActionsText];
    [self showFrontImage];
    [self.progressView startAnimation];
}

- (void)changeTipStatus:(NSDictionary *)infoDict {
    NSLog(@"%@=======",infoDict);
    NSString *value = [infoDict objectForKey:@"exception"];
    [self showCameraExceptionLabel:value];
    infoDict = [infoDict objectForKey:@"action"];
    NSNumber *key = [[infoDict allKeys] firstObject];
    BOOL actionStatus = [[infoDict objectForKey:key] boolValue];
    if (actionStatus) {
        // 完成某个动作
        self.actionsCount++;
        // 显示下一个动作
        if (self.actionsCount < self.actions.length) {
            NSString *action = [self.actions substringWithRange:NSMakeRange(self.actionsCount, 1)];
            [self showActionImage:[self.imageArray objectAtIndex:[action integerValue]]];
            [self showActionIndex:self.actionsCount-1];
            [self playActionMusic:[self.musicArray objectAtIndex:[action integerValue]]];
        }
    }
    
    switch ([key intValue]) {
        case 0:
            self.statusText = @"请正对手机屏幕";
            break;
        case 1:
            self.statusText = @"慢慢右转头";
            break;
        case 2:
            self.statusText = @"慢慢左转头";
            break;
        case 3:
            self.statusText = @"张张嘴";
            break;
        case 4:
            self.statusText = @"眨眨眼";
            break;
        case -1:
            break;
        default:
            break;
    }
    
    self.actionsText.text = self.statusText;
}

- (void)showCameraExceptionLabel:(NSString *)value {
    if (value.length) {
        NSString *statusText = @"";
        switch ([value intValue]) {
            case 1:
                statusText = @"保持面部在框内";
                break;
            case 2:
                statusText = @"环境光线过暗";
                break;
            case 3:
                statusText = @"环境光线过亮";
                break;
            case 4:
                statusText = @"请勿抖动手机";
                break;
            default:
                statusText = @"";
                break;
        }
        self.detectExceptionLabel.text = statusText;
        self.fuzzyImage.hidden = NO;
        return;
    } else {
        self.detectExceptionLabel.text = @"";
        self.fuzzyImage.hidden = YES;
    }
}

- (void)__initActionsText {
    self.actionsText = [[UILabel alloc] init];
    self.actionsText.font = JHMediumFont(18);
    self.actionsText.textColor = UIColor.blackColor;
    self.actionsText.numberOfLines = 1;
    [self addSubview:self.actionsText];
    
    [self.actionsText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(30.f);
        make.height.mas_equalTo(25.f);
    }];
    
    self.progressView = [[JHCountDownBarView alloc] init];
    self.progressView.time = 30.f;
    [self addSubview:self.progressView];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.actionsText);
        make.right.mas_equalTo(-15.f);
        make.size.mas_equalTo(40.f);
    }];

}

/**
 菊花
 */
- (void)__initActivityIndicator {
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicator setColor: UIColorFromHex(0xFFF7B500)];
    [self addSubview:_activityIndicator];
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@300);
        make.height.equalTo(@300);
    }];
}

- (void)__initDetectExceptionLabel {
    self.detectExceptionLabel = [[UILabel alloc] init];
    self.detectExceptionLabel.font = [UIFont systemFontOfSize:14.f];
    self.detectExceptionLabel.textColor = HEXCOLOR(0xFFFFD70F);
    [self addSubview:self.detectExceptionLabel];
    [self.detectExceptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cameraImage.mas_top).mas_offset(15.f);
        make.centerX.equalTo(self.cameraImage);
        make.height.mas_equalTo(20.f);
    }];
}

- (void)__initImageView {
    self.cameraImage = [[UIImageView alloc] init];
    self.cameraImage.layer.cornerRadius = imageViewWidth*0.5;
    self.cameraImage.clipsToBounds = YES;
    [self addSubview:self.cameraImage];
    [self.cameraImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.actionsText.mas_bottom).mas_equalTo(30.f);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(imageViewWidth);
        make.height.mas_equalTo(imageViewHeight);
    }];
}

- (void)__initActionIndexView {
    // 正面不算入动作序列
    int indexNumber = (int)self.actions.length - 1;
    self.actionIndexView = [[UIView alloc] init];
    [self addSubview:self.actionIndexView];
    [self.actionIndexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(UI.bottomSafeAreaHeight+10.f));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(24.f);
    }];
    
    CGFloat width = 24;
    CGFloat margin = 12;
    CGFloat leftPadding = (SCREEN_WIDTH-width *indexNumber- margin*(indexNumber-1))*0.5;
    NSMutableArray *indexViews = [NSMutableArray array];
    for (int i=0; i<indexNumber; i++) {
        UILabel *actionIndexLabel = [[UILabel alloc] init];
        actionIndexLabel.backgroundColor = UIColorFromHex(0xFFEDEDED);
        actionIndexLabel.textColor = UIColorFromHex(0xFFFFFF);
        actionIndexLabel.textAlignment = NSTextAlignmentCenter;
        actionIndexLabel.text = @"";
        actionIndexLabel.font = JHMediumFont(16);
        actionIndexLabel.layer.cornerRadius = 12;
        actionIndexLabel.layer.masksToBounds = YES;
        CGFloat x = leftPadding+(margin+width)*i;
        actionIndexLabel.frame = CGRectMake(x, 0, width, width);
        if (i == 0) {
            actionIndexLabel.text = @"1";
            actionIndexLabel.backgroundColor = UIColorFromHex(0xFFFFD70F);
        }
        
        [self.actionIndexView addSubview:actionIndexLabel];
        [indexViews addObject:actionIndexLabel];
    }
    self.indexViewArray = [indexViews copy];
}

- (void)showActionIndex:(NSUInteger)index {
    for (int i=0; i<index; i++) {
        UILabel *indexLabel = (UILabel *)self.indexViewArray[i];
        indexLabel.text = @"";
        indexLabel.backgroundColor = UIColorFromHex(0xFFEDEDED);
    }
    
    UILabel *currentIndexLabel = (UILabel *)self.indexViewArray[index];
    currentIndexLabel.backgroundColor = UIColorFromHex(0xFFFFD70F);
    currentIndexLabel.text = [NSString stringWithFormat:@"%d", (int)(index+1)];
}

- (void)__initFrontImage {
    self.frontImage = [[UIImageView alloc] init];
    self.frontImage.image = [UIImage imageNamed:@"pic_front"];
    [self addSubview:self.frontImage];
    [self.frontImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.actionIndexView.mas_top).offset(-12.f);
        make.centerX.equalTo(self);
        make.width.equalTo(@(130));
        make.height.equalTo(@(130));
    }];
}

- (void)__initActionImage {
    self.actionImage = [[UIImageView alloc] init];
    [self addSubview:self.actionImage];
    [self.actionImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.frontImage);
    }];
}

- (void)showActionImage:(NSString *)imageName {
    // 0——正面，1——右转，2——左转，3——张嘴，4——眨眼
    self.frontImage.hidden = YES;
    self.actionImage.hidden = NO;
    NSString *gifImagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"gif"];
    NSURL *gifImageUrl = [NSURL fileURLWithPath:gifImagePath];
    [self.actionImage yh_setImage:gifImageUrl];
}

- (void)playActionMusic:(NSString *)musicName {
    // 0——正面，1——右转，2——左转，3——张嘴，4——眨眼
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:musicName withExtension:@"wav"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    if (self.player) {
        [self.player prepareToPlay];
    }

    if ([self.LDViewDelegate respondsToSelector:@selector(playActionMusic:)]) {
        [self.LDViewDelegate playActionMusic:self.player];
    }
}

- (void)showFrontImage {
    self.frontImage.hidden = NO;
    self.actionImage.hidden = YES;
}

- (void)doBack {
    if ([self.LDViewDelegate respondsToSelector:@selector(backBarButtonPressed)]) {
        [self.LDViewDelegate backBarButtonPressed];
    }
}

@end


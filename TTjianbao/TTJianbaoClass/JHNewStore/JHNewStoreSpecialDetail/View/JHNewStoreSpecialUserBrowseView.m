//
//  JHNewStoreSpecialUserBrowseView.m
//  TTjianbao
//
//  Created by liuhai on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreSpecialUserBrowseView.h"
#import "UICountingLabel.h"
#import <UIImage+webP.h>
#import "JHNewStoreHeadPortraitBubbleView.h"

@interface JHNewStoreSpecialUserBrowseView ()

@property(nonatomic, strong) UICountingLabel *countLabel;

@property(nonatomic, strong) UIImageView *liveIconView;

@property(nonatomic, strong) UIImage *webpImage;

@property(nonatomic, strong) JHNewStoreHeadPortraitBubbleView * bubbleView;

@end

@implementation JHNewStoreSpecialUserBrowseView
- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"newStoreSpecialUserBgImage"]];
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.countLabel = [[UICountingLabel alloc] init];
    self.countLabel.font = JHDINBoldFont(18);
    self.countLabel.textColor = HEXCOLOR(0x222222);
    [self addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.left.mas_equalTo(12);
    }];
    self.countLabel.format = @"%d";
    
    
    UILabel *deslabel = [[UILabel alloc] init];
    deslabel.text = @"人看过";
    deslabel.textColor = HEXCOLOR(0x666666);
    deslabel.font = JHFont(11);
    [self addSubview:deslabel];
    [deslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(21);
        make.left.mas_equalTo(self.countLabel.mas_right);
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"userBrowseCountBall" ofType:@"webp"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.webpImage = [UIImage sd_imageWithWebPData:data];
    
    self.liveIconView = [[UIImageView alloc]init];
    [self addSubview:self.liveIconView];
    [self.liveIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(deslabel.mas_bottom).offset(-3);
        make.left.mas_equalTo(deslabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(50, 45));
    }];
    
    self.bubbleView = [[JHNewStoreHeadPortraitBubbleView alloc] initWithFrame:CGRectMake(kScreenWidth-200-24, 14, 200, 26)];
    [self addSubview:self.bubbleView];
    [self.bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-12);
        make.top.mas_equalTo(14);
        make.size.mas_equalTo(CGSizeMake(200, 26));
    }];
}
- (void)resetHeaderViewWithUserModel:(JHNewStoreSpecialShowUser *)model{
    [self.countLabel countFromCurrentValueTo:model.num withDuration:2];
    self.liveIconView.image = self.webpImage;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.liveIconView.image = nil;
    });
    [self.bubbleView setDataArr_loc:model.showUserResponses];
}
@end

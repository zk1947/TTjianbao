//
//  JHReporterCard.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/11.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHReporterCard.h"
#import "NIMAvatarImageView.h"
#import "UMengManager.h"
#import "NSString+AttributedString.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoBussiness.h"
#import "JHBaseOperationView.h"

@interface JHReporterCard ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet NIMAvatarImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userNick;
@property (weak, nonatomic) IBOutlet NIMAvatarImageView *anchorAvatar;

@property (weak, nonatomic) IBOutlet UILabel *anchorNick;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextView *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTitle;

@end


@implementation JHReporterCard

- (void)awakeFromNib {

    [super awakeFromNib];
    self.coverImg.layer.cornerRadius = 10;
    self.coverImg.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
   // [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAlert)]];
}

- (IBAction)shareAction:(id)sender {
    User *user = [UserInfoRequestManager sharedInstance].user;
//    [[UMengManager shareInstance] showShareWithTarget:nil title:@"天天鉴宝评估报告" text:@"甭管在哪儿买的宝，天天鉴宝上鉴一下才放心！" thumbUrl:nil webURL:[NSString stringWithFormat:@"%@id=%@&uname=%@&icon=%@",[UMengManager shareInstance].shareReporterUrl,self.model.appraiseRecordId, user.name, user.icon] type:ShareObjectTypeReport object:self.model.Id];
    JHShareInfo* info = [JHShareInfo new];
    info.title = @"天天鉴宝评估报告";
    info.desc = @"甭管在哪儿买的宝，天天鉴宝上鉴一下才放心！";
    info.shareType = ShareObjectTypeReport;
    info.url = [NSString stringWithFormat:@"%@id=%@&uname=%@&icon=%@",[UMengManager shareInstance].shareReporterUrl,self.model.appraiseRecordId, user.name, user.icon];
    [JHBaseOperationView showShareView:info objectFlag:self.model.Id]; //TODO:Umeng share
}

- (void)setModel:(JHRecorderModel *)model {
    _model = model;
    _priceLabel.attributedText = [model.appraisePriceStr?[NSString stringWithFormat:@"%@%@",([CommHelp isAvailablePrice:model.appraisePrice]?@"¥":@""), model.appraisePriceStr]:@" " formatePriceFontSize:44. color:kGlobalThemeColor];
        if (!model.appraisePriceStr || [model.appraisePriceStr isEqualToString:@"0"]) {
        self.priceTitle.hidden = YES;
        self.priceLabel.hidden = YES;
        self.priceLabel.text = @"";
    }else {
        self.priceTitle.hidden = NO;
        self.priceLabel.hidden = NO;
    }
    
    if (![CommHelp isAvailablePrice:model.appraisePrice]) {
        _priceLabel.text = model.appraisePriceStr;
        _priceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18.];
        _priceTitle.hidden = YES;
        
    }

    
    _desLabel.attributedText = [model.content attributedFontSize:14 color:HEXCOLOR(0x666666) lineSpace:3];
    _postLabel.text = model.anchorDesc;
    _anchorNick.text = model.anchorName;
    _userNick.text = model.name;
    [_userAvatar nim_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:kDefaultAvatarImage];
    [_anchorAvatar nim_setImageWithURL:[NSURL URLWithString:model.anchorIcon] placeholderImage:kDefaultAvatarImage];
    [_coverImg jhSetImageWithURL:[NSURL URLWithString:model.chartlet] placeholder:kDefaultCoverImage];

}
- (IBAction)closeAction:(id)sender {
    [self hiddenAlert];
}


- (void)showAlert {
    CGRect rect = self.frame;
    rect.origin.y = ScreenH;
    self.frame = rect;
    rect.origin.y = ScreenH - rect.size.height;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
}

- (void)hiddenAlert {
    CGRect rect = self.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

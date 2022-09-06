//
//  JHPlateListView.m
//  TTjianbao
//
//  Created by lihui on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlateListView.h"
#import <UIImageView+WebCache.h>
#import "JHPlatelistModel.h"
#import "TTjianbao.h"
#import "JHPlateDetailController.h"

static CGFloat const iconHeight = (55.f);

@interface JHPlateListView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation JHPlateListView
- (void)setShowLine:(BOOL)showLine {
    _showLine = showLine;
    _lineView.hidden = !showLine;
}

- (void)setPlateInfo:(JHPlateListData *)plateInfo {
    if (!plateInfo) {
        return;
    }
    
    _plateInfo = plateInfo;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_plateInfo.image] placeholderImage:kDefaultCoverImage];
    _titleLabel.text = [_plateInfo.channel_name isNotBlank] ? _plateInfo.channel_name : @"暂无名称";
    _detailLabel.text = [_plateInfo.desc isNotBlank] ? _plateInfo.desc : @"暂无简介";
    NSInteger line = [self rowsOfString:_plateInfo.desc withFont:[UIFont fontWithName:kFontNormal size:13.f] withWidth:(ScreenW - 122 - 30 - 55.f)];
    if (line == 1) {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self.iconImageView);
            make.bottom.equalTo(self.iconImageView.mas_centerY);
        }];
        
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.bottom.equalTo(self.iconImageView);
            make.height.mas_equalTo(20.f);
        }];
    }
    else {
        [_detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.right.equalTo(self).offset(-10);
            make.bottom.equalTo(self.iconImageView).offset(3);
        }];
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.detailLabel.mas_top).offset(-5);
            make.left.right.equalTo(self.detailLabel);
        }];
    }
    
    [self layoutIfNeeded];
}

///进入板块主页
- (void)enterPlateHomePage {
    if (self.plateInfo && [self.plateInfo.channel_id integerValue] > 0) {
        JHPlateDetailController *vc = [[JHPlateDetailController alloc] init];
        vc.plateId = self.plateInfo.channel_id;
        vc.plateName = self.plateInfo.channel_name;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        [JHGrowingIO trackEventId:@"recommend_channel_roll_more_enter" variables:@{@"index" : @(self.plateInfo.index)}];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterPlateHomePage)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)initViews {
    _iconImageView = [[UIImageView alloc] initWithImage:kDefaultCoverImage];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.layer.cornerRadius = 8.f;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.clipsToBounds = YES;
    
    _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:15] textColor:kColor333];
    
    _detailLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:13.f] textColor:kColor666];
    _detailLabel.text = @"暂无简介";
    _detailLabel.numberOfLines = 2;
    _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kColorEEE;
    line.hidden = YES;
    _lineView = line;
    
    [self addSubview:_iconImageView];
    [self addSubview:_titleLabel];
    [self addSubview:_detailLabel];
    [self addSubview:_lineView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(iconHeight, iconHeight));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.iconImageView);
        make.bottom.equalTo(self.iconImageView.mas_centerY);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.iconImageView);
        make.height.mas_equalTo(20.f);
    }];
        
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(.5f);
        make.bottom.equalTo(self);
    }];
}

-(NSInteger)rowsOfString:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat)width {
    if (!text || text.length == 0) {
        return 0;
    }
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,width,MAXFLOAT));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    return lines.count;
}

@end

//
//  JHRecommendTopicListView.m
//  TTjianbao
//
//  Created by lihui on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecommendTopicListView.h"
#import "JHTopicDetailController.h"
#import "JHSQModel.h"

#define iconHeight  15.f

@interface JHRecommendTopicListView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *imgTagView;

@property (nonatomic, strong) UIView *lineView;
@end

@implementation JHRecommendTopicListView

- (void)setShowLine:(BOOL)showLine {
    _showLine = showLine;
    _lineView.hidden = !showLine;
}

- (void)setTopicInfo:(JHTopicInfo *)topicInfo {
    if (!topicInfo) {
        return;
    }
        
    _topicInfo = topicInfo;
    _titleLabel.text = [_topicInfo.title isNotBlank] ? _topicInfo.title : @"暂无名称";
    
    NSString *scanNum = [CommHelp convertNumToWUnitString:_topicInfo.scan_num existDecimal:YES];
    NSString *commentNum = [CommHelp convertNumToWUnitString:_topicInfo.comment_num existDecimal:YES];
    NSString *contentNum = [CommHelp convertNumToWUnitString:_topicInfo.content_num existDecimal:YES];

    _detailLabel.text = [NSString stringWithFormat:@"%@阅读 · %@评论 · %@篇内容", scanNum, commentNum, contentNum];
    if([topicInfo.tag_url length] > 0 && topicInfo.tag_type > JHTopicTagTypeDefault && topicInfo.tag_type < JHTopicTagTypeCount) {
        [_imgTagView setHidden:NO];
        [_imgTagView jhSetImageWithURL:[NSURL URLWithString:topicInfo.tag_url]];
        if(topicInfo.tag_type == JHTopicTagTypeRecommand || topicInfo.tag_type == JHTopicTagTypeAward) {
            [_imgTagView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(24);
            }];
        }
        else {
            [_imgTagView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(14);
            }];
        }
    }
    else
    {
        [_imgTagView setHidden:YES];
    }
}

///进入话题首页
- (void)enterTopicHomePage {
    if (self.topicInfo && [self.topicInfo.ID integerValue] > 0) {
        JHTopicDetailController *vc = [[JHTopicDetailController alloc] init];
        vc.topicId = self.topicInfo.ID;
        vc.pageFrom = JHFromHomeCommunity;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterTopicHomePage)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)initViews {
    _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dis_videoBaby"]];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:15] textColor:kColor333];
    _titleLabel.text = @"年货节攻略";
    
    _imgTagView = [[UIImageView alloc] init];
    _imgTagView.contentMode = UIViewContentModeScaleAspectFill;
    _imgTagView.clipsToBounds = YES;
    _imgTagView.hidden = YES;

    _detailLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:13.f] textColor:kColor666];
    _detailLabel.text = @"0阅读 · 0评论 · 0篇内容";
    _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kColorEEE;
//    line.hidden = YES;
    _lineView = line;
    
    [self addSubview:_iconImageView];
    [self addSubview:_titleLabel];
    [self addSubview:_imgTagView];
    [self addSubview:_detailLabel];
    [self addSubview:_lineView];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(30);
        make.right.mas_lessThanOrEqualTo(-39);
    }];
    
    [_imgTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
        make.height.width.mas_equalTo(14);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(iconHeight, iconHeight));
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.bottom.equalTo(self).offset(-10);
    }];
        
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(.5f);
    }];
}
@end

//
//  JHPublishTopicDetailTableCell.m
//  TTjianbao
//
//  Created by jesee on 17/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPublishTopicDetailTableCell.h"
#import "JHPreTitleLabel.h"
#import "UIImageView+JHWebImage.h"
#import "NSString+Common.h"

#define kMarginHX 15
#define kTopicImageSize 45
#define kTopicDefaultImage [UIImage imageNamed:@"publish_create_topic_img"]

@interface JHPublishTopicDetailTableCell ()
{
    UIImageView* topicImageView;
    JHPreTitleLabel* titleLabel;
    UILabel* subtitleLabel;
    UIImageView* tagImageView;
}

@property (nonatomic, weak) UIView *bgView;

@end

@implementation JHPublishTopicDetailTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = HEXCOLOR(0xFFFFFF);
        _bgView = [UIView jh_viewWithColor:HEXCOLOR(0xFFFFFF) addToSuperview:self.contentView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kMarginHX);
            make.right.equalTo(self.contentView).offset(0 - kMarginHX);
            make.top.bottom.equalTo(self.contentView);
        }];
        
        [self drawSubviews];
    }
    return self;
}

- (void)drawNewTopicView:(NSString*)text
{
    [topicImageView setImage:kTopicDefaultImage];
    titleLabel.text = text;
    subtitleLabel.text = @"新话题 点击创建";
}

- (void)drawSubviews
{
    topicImageView = [[UIImageView alloc] initWithImage:kTopicDefaultImage];
    topicImageView.layer.cornerRadius = 8.0;
    topicImageView.layer.masksToBounds = YES;
    [self.bgView addSubview:topicImageView];
    [topicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(0);
        make.top.equalTo(self.bgView).offset(0);
        make.size.mas_offset(kTopicImageSize);
        make.bottom.equalTo(self.bgView).offset(-15);
    }];
    
    titleLabel = [JHPreTitleLabel new];
    titleLabel.preTitle = @"#";
    titleLabel.textColor = HEXCOLOR(0x333333);
    titleLabel.font = JHMediumFont(15);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topicImageView.mas_right).offset(10);
        make.top.equalTo(topicImageView).offset(1);
        make.height.mas_offset(21);
        make.width.mas_lessThanOrEqualTo(ScreenW - kTopicImageSize - 50);
    }];
    
    subtitleLabel = [UILabel new];
    subtitleLabel.textColor = HEXCOLOR(0x999999);
    subtitleLabel.font = JHFont(12);
    subtitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgView addSubview:subtitleLabel];
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(5);
        make.bottom.equalTo(topicImageView).offset(-1);
        make.right.equalTo(self.bgView);
    }];
    
    tagImageView = [[UIImageView alloc] initWithImage:kTopicDefaultImage];
    tagImageView.contentMode = UIViewContentModeScaleAspectFit;
    tagImageView.layer.cornerRadius = 2.0;
    tagImageView.layer.masksToBounds = YES;
    [self.bgView addSubview:tagImageView];
    tagImageView.hidden = YES;
    [tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right).offset(10);
        make.centerY.equalTo(titleLabel);
        make.height.mas_offset(16);
    }];
}
    
  
#pragma mark - update data
- (void)updateData:(JHPublishTopicDetailModel*)model
{
    tagImageView.hidden = YES;
    if(model.isNewTopic)
    {
        [self drawNewTopicView:model.title];
    }
    else
    {
        [topicImageView jhSetImageWithURL:[NSURL URLWithString:model.image ? : @""] placeholder:kTopicDefaultImage];
        titleLabel.text = model.title;
        subtitleLabel.text = model.subtitle;
        if (![NSString isEmpty:model.tag_url]) {
            tagImageView.hidden = NO;
            JH_WEAK(self)
            [tagImageView jhSetImageWithURL:[NSURL URLWithString:model.tag_url] placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
                JH_STRONG(self)
                if (image.size.height>0) {
                    [self->tagImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(image.size.width/image.size.height*16);
                    }];
                }
            }];
            [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_lessThanOrEqualTo(ScreenW - kTopicImageSize - 50);
            }];
        }else{
            [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_lessThanOrEqualTo(ScreenW - kTopicImageSize - 50 - 50);
            }];
        }
        
    }
}

@end

//
//  JHCommunityNewCell.m
//  TTjianbao
//
//  Created by YJ on 2021/1/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHCommunityNewCell.h"
#import "TTJianBaoColor.h"
#import "UILabel+LabelHeightAndWidth.h"

#define HEADER_WIDTH  45
#define CONTENT_DEFAULTE   @"【图片】"

@interface JHCommunityNewCell ()

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *contentLabel;


@end

@implementation JHCommunityNewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = USELECTED_COLOR;
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 15, 0, 15));
        }];
        
    }
    return self;
}

- (void)setModel:(JHChatModel *)model
{
    NSString *timeStr = model.create_time;
    CGFloat time_width = [UILabel getWidthWithTitle:timeStr font:[UIFont fontWithName:kFontNormal size:12.0f]];
    self.timeLabel.text = timeStr;
    self.timeLabel.frame = CGRectMake(ScreenW - 15*2 - 10 - time_width, 10, time_width, 20);
    self.titleLabel.frame = CGRectMake(10*2 + HEADER_WIDTH , 10, ScreenW - 15*2 - (10*2 + HEADER_WIDTH + 10*2 + time_width), 20);
    if ([model.type intValue] == 0)
    {
        self.contentLabel.text = model.content;
    }
    else if ([model.type intValue] == 1)
    {
        self.contentLabel.text = CONTENT_DEFAULTE;
    }
    
    //[self.headerImageView setImageWithURL:[NSURL URLWithString:model.from_user_info.avatar] placeholder:kDefaultAvatarImage];
    //self.titleLabel.text = model.from_user_info.user_name;
    
    NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
    if ([model.from_user_info.code intValue] == [customerId intValue])
    {
        [self.headerImageView setImageWithURL:[NSURL URLWithString:model.to_user_info.avatar] placeholder:kDefaultAvatarImage];
        self.titleLabel.text = model.to_user_info.user_name;

    }
    else
    {
        [self.headerImageView setImageWithURL:[NSURL URLWithString:model.from_user_info.avatar] placeholder:kDefaultAvatarImage];
        self.titleLabel.text = model.from_user_info.user_name;
    }
    
}

- (UIView *)bgView
{
    if (!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = 8.0f;
        _bgView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UIImageView *)headerImageView
{
    if (!_headerImageView)
    {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, HEADER_WIDTH, HEADER_WIDTH)];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
        _headerImageView.clipsToBounds = YES;
        _headerImageView.layer.cornerRadius = HEADER_WIDTH/2;
        [self.bgView addSubview:_headerImageView];
    }
    return _headerImageView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = LIGHTGRAY_COLOR;
        _timeLabel.font = [UIFont fontWithName:kFontNormal size:12.0f];
        [self.bgView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = B_COLOR;
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15.0f];
        [self.bgView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = GRAY_COLOR;
        _contentLabel.font = [UIFont fontWithName:kFontNormal size:12.0f];
        [self.bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.bottom.offset(-10);
            make.left.offset(10*2 + HEADER_WIDTH);
            make.right.offset(-10);
            make.height.mas_equalTo(17);
        }];
    }
    return _contentLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

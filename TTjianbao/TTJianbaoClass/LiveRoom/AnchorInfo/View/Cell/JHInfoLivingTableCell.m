//
//  JHInfoLivingTableCell.m
//  TTjianbao
//
//  Created by jesee on 19/7/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHInfoLivingTableCell.h"
#import "YYKit/YYKit.h"

@interface JHInfoLivingTableCell ()
{
    UIImageView* imgHeader; //bg
    UIImageView* imgAvatar;
    UIImageView* imgView;
    UILabel* titleLabel;
    UITextView* infoLabel;
}
@end

@implementation JHInfoLivingTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self drawAnchorHeaderSubviews];
    }
    return self;
}

- (void)drawAnchorHeaderSubviews
{
    //bg header
    imgHeader = [[UIImageView alloc] init];//
    imgHeader.layer.cornerRadius = 8;
    imgHeader.layer.masksToBounds = YES;
    imgHeader.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *image = [UIImage imageNamed:@"room_left_liveroom_bg"];
    [imgHeader setImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 10, 0) resizingMode:UIImageResizingModeStretch]];
//    [imgHeader setImage:[UIImage imageNamed:@"room_left_liveroom_bg"]];
    [self.contentView addSubview:imgHeader];
    [imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    imgView = [[UIImageView alloc] init];
    [imgView setImage:[UIImage imageNamed:@"icon_anchor_living"]];
    [imgHeader addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(16);
        make.size.mas_equalTo(CGSizeMake(17, 14));
    }];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.font = JHMediumFont(16);
    titleLabel.textColor = HEXCOLOR(0x333333);
    titleLabel.text = @"直播介绍";
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [imgHeader addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(5);
        make.top.equalTo(imgView).offset(-3);
        make.height.mas_equalTo(20);
    }];
    //介绍
    infoLabel = [[UITextView alloc] init];
    infoLabel.font = JHFont(13);
    infoLabel.textColor = HEXCOLOR(0x666666);
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.contentInset = UIEdgeInsetsMake(-7, 0, 0, 0);
    infoLabel.scrollEnabled = NO;
    infoLabel.userInteractionEnabled = NO;
    [imgHeader addSubview:infoLabel];
}

//- (void)addSeeMoreButton
//{
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"... 展开"];
//    
//    YYTextHighlight *hlText = [YYTextHighlight new];
//    [hlText setColor:HEXCOLOR(0x666666)];
//    hlText.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//        [self clickMoreEvent];
//    };
//    
//    [text setColor:HEXCOLOR(0x666666) range:[text.string rangeOfString:@"..."]];
//    [text setColor:HEXCOLOR(0x408FFE) range:[text.string rangeOfString:@"展开"]];
//    [text setTextHighlight:hlText range:[text.string rangeOfString:@"展开"]];
//    text.font = JHFont(13);
//    
//    YYLabel *seeMore = [YYLabel new];
//    seeMore.attributedText = text;
//    [seeMore sizeToFit];
//    
//    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.size alignToFont:text.font alignment:YYTextVerticalAlignmentCenter];
//    infoLabel.truncationToken = truncationToken;
//}

- (void)updateData:(NSString*)txt roleType:(NSInteger)roleType
{
    if(roleType >= 9)
    {
        titleLabel.text = @"定制师介绍";
        [imgView setImage:[UIImage imageNamed:@"liveroom_customize_anchor"]];
        [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView).offset(16);
            make.size.mas_equalTo(23);
        }];
        [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(5);
            make.top.equalTo(imgView).offset(0);
            make.height.mas_equalTo(22);
        }];
    }
    else
    {
        titleLabel.text = @"直播介绍";
        [imgView setImage:[UIImage imageNamed:@"icon_anchor_living"]];
        [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView).offset(16);
            make.size.mas_equalTo(CGSizeMake(17, 14));
        }];
        [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(5);
            make.top.equalTo(imgView).offset(-3);
            make.height.mas_equalTo(20);
        }];
    }
    if([txt length] > 0)
    {
        infoLabel.text = txt;
        [infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView).offset(0);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.mas_equalTo(imgView.mas_bottom).offset(6);
            make.bottom.equalTo(self.contentView).offset(-13);
        }];
    }
    else
    {
        infoLabel.text = @"暂无直播间介绍~";
        [infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView).offset(0);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.mas_equalTo(imgView.mas_bottom).offset(6);
            make.bottom.equalTo(self.contentView).offset(-13);
        }];
    }
}

#pragma mark - event
- (void)pressExtenseButton
{
    
}
//点击展开
- (void)clickMoreEvent
{
    CGFloat textHeight = ceilf([infoLabel.text heightForFont:infoLabel.font width:ScreenW - 20]);
//    _textHeight = textHeight;
//    infoLabel.numberOfLines = 0;
    [infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView).offset(0);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.mas_equalTo(imgView.mas_bottom).offset(6);
        make.bottom.equalTo(self.contentView).offset(-13);
    }];
    if(self.actionBlock)
    {
        self.actionBlock(@(textHeight));
    }
}
@end

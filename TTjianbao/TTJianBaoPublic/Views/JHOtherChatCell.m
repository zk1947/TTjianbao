//
//  JHOtherChatCell.m
//  TTjianbao
//
//  Created by YJ on 2021/1/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHOtherChatCell.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "UIView+CornerRadius.h"
#import "TTJianBaoColor.h"
#import "UIView+AnyCorners.h"
#import "UIImage+ImgSize.h"
#import "UIImageView+WebCache.h"
#import "JHPhotoBrowserManager.h"
#import "PPStickerDataManager.h"
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"
#import "YYAnimatedImageView.h"
#import "MBProgressHUD.h"

#define PADDING 15
#define HEADER_WIDTH  40
#define CONTENT_FONT [UIFont fontWithName:kFontNormal size:15.0f]

@interface JHOtherChatCell()

@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) YYLabel *contentLabel;
@property (strong, nonatomic) UIView *bgView;
//@property (strong, nonatomic) UIImageView *picImageView;
@property (strong, nonatomic) YYAnimatedImageView *picImageView;
@property (strong, nonatomic) UIImageView *cornerImageView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (copy,   nonatomic) NSString *imageUrl;//原图
@property (copy,   nonatomic) NSString *mediumUrl;//中图
@property (copy,   nonatomic) NSString *thumbUrl;//缩略图

@end

@implementation JHOtherChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = USELECTED_COLOR;
        
        self.bgView = [[UIView alloc] init];
        [self.contentView addSubview:self.bgView];
        
    }
    return self;
}

- (void)setModel:(JHChatModel *)model
{
    CGFloat MAX_WIDTH = ScreenW - HEADER_WIDTH*2 - PADDING*2 - 10*2 - 10*2;
    NSString *timeStr = model.create_time;
    CGFloat top_pad = 0;
    if (timeStr.length > 0)
    {
        top_pad = 45;
        CGFloat time_width = [UILabel getWidthWithTitle:timeStr font:[UIFont systemFontOfSize:11.0f]];
        self.timeLabel.frame = CGRectMake((ScreenW - time_width - 10*2)/2, 20, time_width + 10*2, 15);
        self.timeLabel.text = model.create_time;
    }
    
    self.headerImageView.frame = CGRectMake(PADDING, 10 + top_pad, HEADER_WIDTH, HEADER_WIDTH);
    [self.headerImageView setImageWithURL:[NSURL URLWithString:model.from_user_info.avatar] placeholder:kDefaultAvatarImage];

    if ([model.type integerValue] == 0)
    {
        //文字消息
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.cornerImageView.hidden = NO;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.content attributes:@
        {NSFontAttributeName:CONTENT_FONT, NSForegroundColorAttributeName: B_COLOR}];

        NSError *error;
        NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
        NSArray *arrayOfAllMatches = [dataDetector matchesInString:model.content options:NSMatchingReportProgress range:NSMakeRange(0, model.content.length)];

        @weakify(self);
        for (NSTextCheckingResult *match in arrayOfAllMatches)
        {
            [text setTextHighlightRange:match.range color:[UIColor blueColor] backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect)
            {
                @strongify(self);
                NSString *url = [model.content substringWithRange:match.range];
                if (self.block)
                {
                    self.block(url);
                }
            }];
        }

        [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:text font:CONTENT_FONT];

        self.contentLabel.attributedText = text;

        CGSize maxSize = CGSizeMake(MAX_WIDTH, MAXFLOAT);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:text];
        self.contentLabel.textLayout = layout;
        CGFloat introWidth = layout.textBoundingSize.width;
        CGFloat introHeight = layout.textBoundingSize.height;
        
        self.bgView.frame = CGRectMake(PADDING + HEADER_WIDTH + 10, 10 + top_pad, introWidth + 20, introHeight + 10*2);
        self.cornerImageView.frame = CGRectMake(PADDING + HEADER_WIDTH + 10 - 7, 10 + top_pad, 7, 40);
        
        UIRectCorner corners = UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight;
        [self.bgView setBorderWithCornerRadius:6 borderWidth:0 borderColor:[UIColor clearColor] type:corners];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.offset(5);
            make.bottom.offset(-5);
            make.left.offset(10);
            make.right.offset(-10);
        }];
        
    }
    else if ([model.type intValue] == 1)
    {
        //图片
        self.bgView.backgroundColor = USELECTED_COLOR;
        self.cornerImageView.hidden = YES;
        
        self.imageUrl = model.image_url;
        self.mediumUrl = model.image_medium;
        self.thumbUrl = model.image_thumb;
        
        CGSize size = [UIImage getImageSizeWithURL:model.image_thumb];
        
        [MBProgressHUD showHUDAddedTo:self.picImageView animated:YES];
        
        [self.picImageView jhSetImageWithURL:[NSURL URLWithString:model.image_thumb] placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error)
         {
            [MBProgressHUD hideHUDForView:self.picImageView animated:YES];
        }];
        
        //[self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.image_thumb] placeholderImage:nil];
        
        CGFloat image_width = size.width;
        CGFloat image_height = size.height;
                 
        if (image_width < image_height)
        {
            MAX_WIDTH = (ScreenW  - HEADER_WIDTH*2 - PADDING*2 - 10*2 - 10*2)/2;
        }
 
        if (image_width >= MAX_WIDTH)
        {
            CGFloat scale = (MAX_WIDTH/image_width);
            CGFloat height = image_height*scale;
            self.bgView.frame = CGRectMake(PADDING + HEADER_WIDTH + 5,  10 + top_pad, MAX_WIDTH,  height);
        }
        else
        {
            self.bgView.frame = CGRectMake(PADDING + HEADER_WIDTH + 5, 10 + top_pad, image_width,  image_height);
        }
         
        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.offset(0);
            make.bottom.offset(0);
            make.left.offset(0);
            make.right.offset(0);
        }];
    }
}

+ (CGFloat)heightWithModel:(JHChatModel *)model
{
    NSString *timeStr = model.create_time;
    CGFloat top_pad = 0;
    if (timeStr.length > 0)
    {
        top_pad = 45;
    }
    
    CGFloat MAX_WIDTH = ScreenW - HEADER_WIDTH*2 - PADDING*2 - 10*2 - 10*2;
    if ([model.type integerValue] == 0)
    {
        //文字消息
        CGSize size = [JHOtherChatCell getSizeWithString:model.content];
        return size.height + 10*4 + top_pad;
    }
    else if ([model.type intValue] == 1)
    {
        //图片
        CGSize size = [UIImage getImageSizeWithURL:model.image_thumb];
        CGFloat image_width = size.width;
        CGFloat image_height = size.height;

        if (image_width < image_height)
        {
            MAX_WIDTH = (ScreenW  - HEADER_WIDTH*2 - PADDING*2 - 10*2 - 10*2)/2;
        }

        if (image_width >= MAX_WIDTH)
        {
            CGFloat scale = (MAX_WIDTH/image_width);
            CGFloat height = image_height*scale;
            return 10*2 + height + top_pad;
        }
        else
        {
            return 10*2 + image_height + top_pad;
        }
    }

    return 0;;
}

+ (CGSize)getSizeWithString:(NSString *)content
{
    CGFloat MAX_WIDTH = ScreenW - HEADER_WIDTH*2 - PADDING*2 - 10*2 - 10*2;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:content attributes:@
    {NSFontAttributeName:CONTENT_FONT, NSForegroundColorAttributeName: B_COLOR}];

    NSError *error;
    NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    NSArray *arrayOfAllMatches = [dataDetector matchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length)];

    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        [text setTextHighlightRange:match.range color:[UIColor blueColor] backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect)
        {

        }];
    }

    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:text font:CONTENT_FONT];
    
    CGSize maxSize = CGSizeMake(MAX_WIDTH, MAXFLOAT);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:text];

    CGSize size = layout.textBoundingSize;
    return size;
}


- (UIImageView *)headerImageView
{
    if (!_headerImageView)
    {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.layer.cornerRadius = HEADER_WIDTH/2;
        _headerImageView.clipsToBounds = YES;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_headerImageView];
    }
    return _headerImageView;
}
- (YYLabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = CONTENT_FONT;
        [_contentLabel setTextAlignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = BLACK_COLOR;
        [self.bgView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (YYAnimatedImageView *)picImageView
{
    if (!_picImageView)
    {
        _picImageView = [[YYAnimatedImageView alloc] init];
        _picImageView.backgroundColor = [UIColor clearColor];
        _picImageView.contentMode = UIViewContentModeScaleAspectFit;
        _picImageView.clipsToBounds = YES;
        _picImageView.layer.cornerRadius = 8.0f;
        _picImageView.userInteractionEnabled = YES;
        [_picImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicImageView)]];
        [self.bgView addSubview:_picImageView];
    }
    return _picImageView;
}
- (void)tapPicImageView
{
    [JHPhotoBrowserManager showPhotoBrowserThumbImages:@[self.thumbUrl] mediumImages:@[self.mediumUrl] origImages:@[self.imageUrl] sources:@[self.picImageView] currentIndex:0 canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleZoom];

}

- (UIImageView *)cornerImageView
{
    if (!_cornerImageView)
    {
        _cornerImageView = [[UIImageView alloc] init];
        _cornerImageView.hidden = YES;
        _cornerImageView.image = [UIImage imageNamed:@"white_corner"];
        [self.contentView addSubview:_cornerImageView];
    }
    return _cornerImageView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.layer.cornerRadius = 15/2;
        _timeLabel.layer.backgroundColor = TIMEBG_COLOR.CGColor;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:11.0f];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
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

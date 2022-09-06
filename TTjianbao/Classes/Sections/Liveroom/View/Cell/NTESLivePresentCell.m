//
//  NTESLivePresentCell.m
//  TTjianbao
//
//  Created by chris on 16/3/30.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLivePresentCell.h"
#import "NTESPresent.h"
#import "NIMAvatarImageView.h"
#import "M80AttributedLabel.h"
#import "NTESDataManager.h"
#import "UIImageView+JHWebImage.h"
#import "NTESPresentAttachment.h"
#import "NTESLiveManager.h"
#import "UIView+NTES.h"

@interface NTESLivePresentCell(){
    NIMMessage *_message;
}

@property (nonatomic,strong) UIImageView *backgroundImageView;

@property (nonatomic,strong) NIMAvatarImageView *avatar;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) M80AttributedLabel *contentLabel;

@property (nonatomic,strong) UIImageView *presentImageView;

@property (nonatomic,strong) M80AttributedLabel *countLabel;
@end

@implementation NTESLivePresentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.alpha = 0.0;
        [self.contentView addSubview:self.backgroundImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.avatar];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.presentImageView];
        [self.contentView addSubview:self.countLabel];
    }
    return self;
}

- (void)refreshWithPresentMessage:(NIMMessage *)message
{
    if ([message isKindOfClass:[NSNull class]]) {
        return;
    }
    
    _message = message;
    
    NTESDataUser *user = [[NTESDataManager sharedInstance] infoByUser:message.from withMessage:message];
    [self.avatar nim_setImageWithURL:[NSURL URLWithString:user.avatarUrlString] placeholderImage:user.avatarImage];
    
    self.nameLabel.text = user.showName;
    CGSize size = [self.nameLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    self.nameLabel.size = size;
    
    NIMCustomObject *object = message.messageObject;
    NTESPresentAttachment *attachment = object.attachment;
    
    NSDictionary *presents = [NTESLiveManager sharedInstance].presents;
    NTESPresent  *present  = presents[@(attachment.presentType).stringValue];
    NSString *name = present.name;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"送了%@",name]];
    [attrString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:11.f],NSForegroundColorAttributeName:HEXCOLOR(0xffffff)} range:NSMakeRange(0, 2)];
    [attrString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:11.f],NSForegroundColorAttributeName:HEXCOLOR(0x6aa1d9)} range:NSMakeRange(attrString.length - name.length, name.length)];
    [self.contentLabel setAttributedText:attrString];
    size = [self.contentLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    self.contentLabel.size = size;
    
    self.presentImageView.image = [UIImage imageNamed:present.icon];
    [self.presentImageView sizeToFit];
    
    NSString *count = [NSString stringWithFormat:@"x%zd",attachment.count];
    attrString = [[NSMutableAttributedString alloc] initWithString:count];
    [attrString addAttributes:@{
                                NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f],
                                NSForegroundColorAttributeName:HEXCOLOR(0x238efa),
                                NSStrokeColorAttributeName:[UIColor whiteColor],
                                NSStrokeWidthAttributeName:@(-5.0f)
                                } range:NSMakeRange(0, 1)];

    [attrString addAttributes:@{
                                    NSFontAttributeName:[UIFont boldSystemFontOfSize:22.f],
                                    NSForegroundColorAttributeName:HEXCOLOR(0x238efa),
                                    NSStrokeColorAttributeName:[UIColor whiteColor],
                                    NSStrokeWidthAttributeName:@(-5.0f)
                               } range:NSMakeRange(1, count.length-1)];
    [self.countLabel setAttributedText:attrString];
    size = [self.countLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    self.countLabel.size = size;
}

- (void)show
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    
    self.contentView.right = 0;
    [self setNeedsLayout];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.alpha = 1.0;
        self.contentView.left = 0;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:1.0];
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(cellDidHide:message:)]) {
            [self.delegate cellDidHide:self message:_message];
        }
    }];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.avatar.left = 10.f;
    self.avatar.bottom = self.height;
    
    self.nameLabel.left = 48.f;
    self.nameLabel.bottom = self.height - 18.f;
    
    self.contentLabel.left = 48.f;
    self.contentLabel.top  = self.nameLabel.bottom - 4.f;
    
    self.presentImageView.left = 105;
    self.presentImageView.bottom = self.height - 7.f;
    
    CGFloat left = 13.f;
    self.backgroundImageView.width  = self.presentImageView.right - left;
    self.backgroundImageView.bottom = self.height - 2.f;
    self.backgroundImageView.left   = left;
    
    self.countLabel.left = self.backgroundImageView.right + 5.f;
    self.countLabel.bottom = self.height - 6.f;

    
}

#pragma mark - Get
- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
        _backgroundImageView.image = [[UIImage imageNamed:@"icon_live_present_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
    }
    return _backgroundImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:8.f];
        _nameLabel.textColor = HEXCOLOR(0xb4b3b2);
    }
    return _nameLabel;
}

- (NIMAvatarImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    }
    return _avatar;
}

- (M80AttributedLabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.backgroundColor = [UIColor clearColor];
    }
    return _contentLabel;
}

- (UIImageView *)presentImageView
{
    if (!_presentImageView) {
        _presentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _presentImageView;
}

- (M80AttributedLabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _countLabel.backgroundColor = [UIColor clearColor];
    }
    return _countLabel;
}

@end

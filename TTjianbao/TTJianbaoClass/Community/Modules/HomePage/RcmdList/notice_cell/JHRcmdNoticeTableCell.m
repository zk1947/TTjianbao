//
//  JHRcmdNoticeTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/11/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRcmdNoticeTableCell.h"
#import "TTjianbaoHeader.h"
#import "BannerMode.h"

@interface JHRcmdNoticeTableCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UIView *bottomLine;


@end

@implementation JHRcmdNoticeTableCell

- (void)setNoticeInfo:(BannerCustomerModel *)noticeInfo {
    if (!noticeInfo) {
        return;
    }
    _noticeInfo = noticeInfo;
    
    _noticeLabel.text = [_noticeInfo.title isNotBlank]
    ? _noticeInfo.title
    : @"暂无内容";
}

- (void)setShowLine:(BOOL)showLine {
    _showLine = showLine;
    _bottomLine.hidden = !_showLine;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"community_icon_notice"]];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds = YES;
    [self.contentView addSubview:_iconImageView];
    
    _noticeLabel = [[UILabel alloc] init];
    _noticeLabel.text = @"暂无公告";
    _noticeLabel.font = [UIFont fontWithName:kFontNormal size:14];
    _noticeLabel.textColor = kColor333;
    _noticeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_noticeLabel];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = kColorF5F6FA;
    [self.contentView addSubview:_bottomLine];
    
    _iconImageView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .centerYEqualToView(self.contentView)
    .widthIs(24).heightIs(16);
    
    _noticeLabel.sd_layout
    .leftSpaceToView(_iconImageView, 15)
    .rightSpaceToView(self.contentView, 13)
    .bottomEqualToView(self.contentView)
    .topEqualToView(self.contentView);
    
    _bottomLine.sd_layout
    .leftSpaceToView(self.contentView, 49.f)
    .rightSpaceToView(self.contentView, 10)
    .bottomEqualToView(self.contentView)
    .heightIs(1.f);
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

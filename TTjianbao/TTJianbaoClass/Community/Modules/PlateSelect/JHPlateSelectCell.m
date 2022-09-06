//
//  JHPlateSelectCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlateSelectCell.h"
#import "JHPlateSelectModel.h"

@interface JHPlateSelectCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation JHPlateSelectCell

+ (CGFloat)cellHeight {
    return 75.0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyleEnabled = NO;
        [self configUI];
    }
    return self;
}

- (void)configUI {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.clipsToBounds = YES;
        _iconView.sd_cornerRadius = @(8.0);
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:15.0] textColor:kColor333];
    }
    
    if (!_descLabel) {
        _descLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12.0] textColor:kColor999];
    }
    
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithTitle:@"选择" titleColor:kColor333];
        _selectButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _selectButton.layer.borderWidth = 0.5;
        _selectButton.layer.borderColor = [HEXCOLOR(0xBDBFC2) CGColor];
        _selectButton.userInteractionEnabled = NO;
    }
    
    [self.contentView sd_addSubviews:@[_iconView, _titleLabel, _descLabel, _selectButton]];
    
    //布局
    _iconView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .centerYEqualToView(self.contentView)
    .widthIs(45.0)
    .heightEqualToWidth();
    
    _selectButton.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .centerYEqualToView(self.contentView)
    .widthIs(56)
    .heightIs(30);
    _selectButton.sd_cornerRadiusFromHeightRatio = @(0.5);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_iconView, 10)
    .rightSpaceToView(_selectButton, 10)
    .topEqualToView(_iconView)
    .heightIs(22);
    
    _descLabel.sd_layout
    .leftSpaceToView(_iconView, 10)
    .rightSpaceToView(_selectButton, 10)
    .bottomEqualToView(_iconView)
    .heightIs(18);
}

- (void)setCurData:(JHPlateSelectData *)curData {
    _curData = curData;
    
    [_iconView jhSetImageWithURL:[NSURL URLWithString:curData.channel_image]
                               placeholder:kDefaultCoverImage];
    
    _titleLabel.text = curData.channel_name;
    
    JHPlateSelectDataStats *stats = curData.channel_stats;
    NSString *scanStr = [CommHelp convertNumToWUnitString:stats.scan_num existDecimal:YES];
    NSString *commentStr = [CommHelp convertNumToWUnitString:stats.comment_num existDecimal:YES];
    NSString *contentNumStr = [CommHelp convertNumToWUnitString:stats.content_num existDecimal:YES];
    NSString *descStr = [NSString stringWithFormat:@"%@阅读·%@评论·%@篇内容", scanStr, commentStr, contentNumStr];
    
    _descLabel.text = descStr;
}

@end

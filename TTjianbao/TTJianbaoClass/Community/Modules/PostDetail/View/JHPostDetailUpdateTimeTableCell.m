//
//  JHPostDetailUpdateTimeTableCell.m
//  TTjianbao
//
//  Created by lihui on 2021/1/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPostDetailUpdateTimeTableCell.h"

@interface JHPostDetailUpdateTimeTableCell ()

@property (nonatomic, strong) UILabel *updateLabel;

@end

@implementation JHPostDetailUpdateTimeTableCell

- (void)setUpdateTime:(NSString *)updateTime {
    if ([updateTime isNotBlank]) {
        _updateTime = updateTime;
        _updateLabel.text = [NSString stringWithFormat:@"此内容于%@修改", _updateTime];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    _updateLabel = [[UILabel alloc] init];
    _updateLabel.textColor = kColor999;
    _updateLabel.numberOfLines = 1;
    _updateLabel.font = [UIFont fontWithName:kFontNormal size:12];
    [self.contentView addSubview:_updateLabel];
    [_updateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView);
    }];
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

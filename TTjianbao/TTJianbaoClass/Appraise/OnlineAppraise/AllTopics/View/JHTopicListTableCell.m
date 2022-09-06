//
//  JHTopicListTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHTopicListTableCell.h"
#import "JHOnlineAppraiseModel.h"

@interface JHTopicListTableCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@end

@implementation JHTopicListTableCell

- (void)setAppraiseModel:(JHOnlineAppraiseModel *)appraiseModel {
    if (!appraiseModel) {
        return;
    }
    _appraiseModel = appraiseModel;
    [_iconImageView jh_setImageWithUrl:appraiseModel.bg_img];
    _nameLabel.text = [_appraiseModel.name isNotBlank] ? _appraiseModel.name : @"暂无标题";
    _descLabel.text = [_appraiseModel.desc isNotBlank] ? _appraiseModel.desc : @"暂无描述~";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self intSubViews];
    }
    return self;
}

- (void)intSubViews {
    UIImageView *img = [[UIImageView alloc] initWithImage:kDefaultCoverImage];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.layer.cornerRadius = 49.f/2;
    img.clipsToBounds = YES;
    img.layer.masksToBounds = YES;
    _iconImageView = img;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"暂无昵称";
    nameLabel.font = [UIFont fontWithName:kFontNormal size:15.];
    nameLabel.textColor = kColor222;
    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLabel = nameLabel;

    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"暂无描述~";
    descLabel.font = [UIFont fontWithName:kFontNormal size:13.];
    descLabel.textColor = kColor999;
    descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _descLabel = descLabel;
    
    [self.contentView addSubview:img];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:descLabel];

    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(49., 49.));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(8.);
        make.right.equalTo(self.contentView).offset(-10.);
        make.top.equalTo(self.iconImageView);
        make.height.mas_equalTo(49./2);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.iconImageView);
        make.height.mas_equalTo(49./2);
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

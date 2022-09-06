//
//  JHLiveRoomListViewCell.m
//  TTjianbao
//
//  Created by 于岳 on 2020/7/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomListViewCell.h"
@interface JHLiveRoomListViewCell()
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong) UIView *lineView;
@end
@implementation JHLiveRoomListViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEXCOLORA(0x000000, .9);;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    [self iconImageView];
    [self titleLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.hidden = YES;
    self.lineView.backgroundColor = HEXCOLOR(0x5A5A5A);
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}
-(void)setModel:(JHLiveRoomListViewCellModel *)model
{
    self.iconImageView.image = [UIImage imageNamed:model.icon];
    self.titleLabel.text = model.title;
}
- (void)showBottomLine:(BOOL)isShow{
    self.lineView.hidden = !isShow;
}
-(UIImageView *)iconImageView
{
    if(!_iconImageView)
    {
        _iconImageView = [UIImageView new];
        [self.contentView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _iconImageView;
}
-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).with.offset(3);
            make.centerY.equalTo(self.iconImageView);
        }];
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:12.0];
        _titleLabel.textColor = HEXCOLOR(0xffffff);
    }
    return _titleLabel;
}
@end

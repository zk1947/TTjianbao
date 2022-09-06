//
//  JHCommMenuCell.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCommMenuCell.h"
@interface JHCommMenuCell()
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong) UIView *lineView;
@end
@implementation JHCommMenuCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}
- (void)configUI
{
   // [self iconImageView];
    [self titleLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.hidden = YES;
    self.lineView.backgroundColor = HEXCOLOR(0xffffff);
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}
-(void)setTitleString:(NSString *)titleString{
    
    self.titleLabel.text = titleString;
}
- (void)showBottomLine:(BOOL)isShow{
    self.lineView.hidden = !isShow;
}
//-(UIImageView *)iconImageView
//{
//    if(!_iconImageView)
//    {
//        _iconImageView = [UIImageView new];
//        [self.contentView addSubview:_iconImageView];
//        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@10);
//            make.centerY.equalTo(self.contentView);
//        }];
//    }
//    return _iconImageView;
//}
-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:12.0];
        _titleLabel.textColor = HEXCOLOR(0xffffff);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.center.equalTo(self.contentView);
               }];
    }
    return _titleLabel;
}
@end


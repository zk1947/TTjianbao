//
//  JHPlateListTableViewCell.m
//  TTjianbao
//
//  Created by wangjianios on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlateListTableViewCell.h"
#import "JHPlateListModel.h"

@interface JHPlateListTableViewCell ()

@property (nonatomic, weak) UIImageView *iconView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *descLabel;

@end

@implementation JHPlateListTableViewCell

- (void)dealloc
{
    NSLog(@"JHPlateListTableViewCell dealloc🔥");
}

-(void)addSelfSubViews
{
    _iconView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_iconView jh_cornerRadius:8];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10.f);
        make.width.height.mas_equalTo([JHPlateListTableViewCell cellHeight] - 20);
    }];
    
    _titleLabel = [UILabel jh_labelWithFont:18 textColor:RGB515151 addToSuperView:self.contentView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView).offset(7);
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-40);
    }];
    
    _descLabel = [UILabel jh_labelWithFont:13 textColor:RGB153153153 addToSuperView:self.contentView];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconView).offset(-7);
        make.left.equalTo(self.titleLabel);
    }];
    
    UIImageView *icon = [UIImageView jh_imageViewWithImage:@"my_center_switch_push" addToSuperview:self.contentView];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
}

- (void)setModel:(JHPlateListData *)model
{
    if(model)
    {
        _model = model;
        [_iconView jh_setImageWithUrl:_model.image];
        _titleLabel.text = _model.channel_name;
        _descLabel.text = [NSString stringWithFormat:@"%@阅读·%@评论·%@篇内容", [self getNumStringWithNum:_model.scan_num], [self getNumStringWithNum:_model.comment_num], [self getNumStringWithNum:_model.content_num]];
    }
}

-(NSString *)getNumStringWithNum:(NSString *)numStr
{
    CGFloat num = numStr.floatValue;
    
    if(num < 10000)
    {
        return numStr;
    }
    else
    {
        return [NSString stringWithFormat:@"%.1fw",num / 10000.0];
    }
}

+ (CGFloat)cellHeight
{
    return 80.f;
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

//
//  JHGemmologistCommentCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGemmologistCommentCell.h"
#import "UIImageView+WebCache.h"
#import "JHUserInfoViewController.h"
@interface JHGemmologistCommentCell()
/** 头像*/
@property (nonatomic, strong) UIImageView *iconImageView;
/** 名字*/
@property (nonatomic, strong) UILabel *nameLabel;
/** 时间*/
@property (nonatomic, strong) UILabel *timeLabel;
/** label合集*/
@property (nonatomic, strong) UIView *labelsView;
/** label合集*/
@property (nonatomic, strong) NSMutableArray *labelArray;
/** 评论 文字*/
@property (nonatomic, strong) UILabel *commentLabel;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView;
@end
@implementation JHGemmologistCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

- (void)setModel:(JHEvaluationModel *)model{
    _model = model;
    for (UILabel *label in self.labelArray) {
        label.hidden = YES;
    }
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:kDefaultAvatarImage];
    self.nameLabel.text = model.customerName;
    self.timeLabel.text = [model.createTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    self.commentLabel.text = model.commentContent;
    NSInteger count = model.commentTagList.count > 6 ? 6 : model.commentTagList.count;
    for (int i = 0; i < count; i++) {
        UILabel *label = self.labelArray[i];
        label.hidden = NO;
        NSDictionary *dic = model.commentTagList[i];
        label.text = dic[@"tagName"];
    }
    CGFloat height = ((count - 1) / 3 + 1) * 38.f;
    [self.labelsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (void)configUI{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.labelsView];
    [self.contentView addSubview:self.commentLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.width.height.mas_equalTo(38);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.iconImageView.mas_top);
        make.height.mas_equalTo(18);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.height.mas_equalTo(16);
    }];
    
    [self.labelsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(12);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(0);
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.labelsView.mas_bottom).offset(2);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.commentLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.layer.cornerRadius = 19;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.backgroundColor = [UIColor redColor];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.right + 10, self.iconImageView.top, 150, 18)];
        _nameLabel.text = @"";
        _nameLabel.textColor = RGB(51, 51, 51);
        _nameLabel.font = [UIFont fontWithName:kFontMedium size:13];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom, 150, 16)];
        _timeLabel.text = @"";
        _timeLabel.textColor = RGB(153, 153, 153);
        _timeLabel.font = [UIFont fontWithName:kFontNormal size:11];
    }
    return _timeLabel;
}

- (UIView *)labelsView{
    if (_labelsView == nil) {
        _labelsView = [[UIView alloc] init];
        _labelsView.backgroundColor = [UIColor whiteColor];
        
        CGFloat labelWidth = floorf((kScreenWidth - 63 - 20 - 15) / 3.f);
        for (int i = 0; i < 6; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = kColorF5F6FA;
            label.layer.cornerRadius = 8;
            label.clipsToBounds = YES;
            label.textColor = kColor333;
            label.font = [UIFont fontWithName:kFontNormal size:13];
            label.frame = CGRectMake((labelWidth + 10) * (i % 3), 38 * (i / 3), labelWidth, 28);
            label.textAlignment = NSTextAlignmentCenter;
            [_labelsView addSubview:label];
            [self.labelArray addObject:label];
        }
    }
    return _labelsView;
}

- (UILabel *)commentLabel{
    if (_commentLabel == nil) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.text = @"";
        _commentLabel.textColor = kColor333;
        _commentLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _commentLabel.numberOfLines = 0;
    }
    return _commentLabel;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kColorF5F6FA;
    }
    return _lineView;
}

- (NSMutableArray *)labelArray{
    if (_labelArray == nil) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

@end

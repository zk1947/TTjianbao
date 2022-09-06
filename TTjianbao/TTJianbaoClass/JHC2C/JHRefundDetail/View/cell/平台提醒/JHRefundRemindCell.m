//
//  JHRefundRemindCell.m
//  TTjianbao
//
//  Created by hao on 2021/5/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRefundRemindCell.h"

@interface JHRefundRemindCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *remindLabel;

@end

@implementation JHRefundRemindCell

#pragma mark - UI
- (void)setupViews{
    //标题
    [self.backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.backView).offset(10);
    }];
    //说明
    [self.backView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.backView).offset(10);
        make.right.equalTo(self.backView).offset(-10);
    }];
    [self.backView addSubview:self.remindLabel];
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.backView).offset(10);
        make.right.bottom.equalTo(self.backView).offset(-10);
    }];
    
}
#pragma mark - LoadData
- (void)bindViewModel:(id)dataModel{
    JHRefundOperationListModel *listModel = dataModel;

    self.contentLabel.text = listModel.text1;
    if (listModel.text2.length > 0) {
        self.remindLabel.text = [NSString stringWithFormat:@"* %@",listModel.text2];
    }else{
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backView).offset(-10);
        }];
    }
}

#pragma mark - Action

#pragma mark - Delegate

#pragma mark - Lazy
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _titleLabel.text = @"平台提醒";
    }
    return _titleLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXCOLOR(0x666666);
        _contentLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (UILabel *)remindLabel{
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] init];
        _remindLabel.textColor = HEXCOLOR(0xF40C0C);
        _remindLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _remindLabel.numberOfLines = 0;
    }
    return _remindLabel;
}

@end

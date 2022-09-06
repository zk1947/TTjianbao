//
//  JHRecycleOrderPursueCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderPursueCell.h"
#import "JHRecycleOrderPursueModel.h"

@interface JHRecycleOrderPursueCell()
/** 载体*/
@property (nonatomic, strong) UIView *backView;

@end
@implementation JHRecycleOrderPursueCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = HEXCOLOR(0xf5f6fa);
        [self configUI];
    }
    return self;
}

//- (void)setFirstCellUI {
//    self.tagImageView.image = [UIImage imageNamed:@"recycle_logistics_finish"];
//    self.lineTopView.hidden = YES;
//}
//
//- (void)setLastCellUI {
//    self.tagImageView.image = [UIImage imageNamed:@"recycle_logistics_ing"];
//    self.lineBottomView.hidden = YES;
//}

- (void)setModel:(JHRecycleOrderPursueModel *)model {
    _model = model;
    self.timeLabel.text = model.optTime;
    self.statusLabel.text = model.recycleNodeDesc;
    self.desLabel.text = model.recycleNodeText;
}

- (void)configUI {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.timeLabel];
    [self.backView addSubview:self.lineTopView];
    [self.backView addSubview:self.lineBottomView];
    [self.backView addSubview:self.tagImageView];
    [self.backView addSubview:self.statusLabel];
    [self.backView addSubview:self.desLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(20);
        make.left.mas_equalTo(self.backView).offset(20);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(32);
    }];
    
    [self.lineTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_right).offset(16);
        make.top.mas_equalTo(self.backView);
        make.bottom.mas_equalTo(self.timeLabel.mas_top);
        make.width.mas_equalTo(2);
    }];
    
    [self.lineBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_right).offset(16);
        make.top.mas_equalTo(self.timeLabel.mas_bottom);
        make.bottom.mas_equalTo(self.backView);
        make.width.mas_equalTo(2);
    }];
    
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeLabel);
        make.centerX.mas_equalTo(self.lineTopView);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel);
        make.left.mas_equalTo(self.lineTopView.mas_right).offset(16);
        make.right.mas_equalTo(self.backView).offset(-12);
        make.height.mas_equalTo(16);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusLabel.mas_bottom);
        make.left.mas_equalTo(self.lineTopView.mas_right).offset(16);
        make.right.mas_equalTo(self.backView).offset(-12);
        make.bottom.mas_equalTo(self.backView).offset(-10);
    }];
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _backView;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x999999);
        _timeLabel.font = [UIFont fontWithName:kFontMedium size:11];
        _timeLabel.text = @"2020-12-17\n12:12:29";
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.numberOfLines = 2;
    }
    return _timeLabel;
}

- (UIView *)lineTopView {
    if (_lineTopView == nil) {
        _lineTopView = [[UIView alloc] init];
        _lineTopView.backgroundColor = HEXCOLOR(0xeeeeee);
    }
    return _lineTopView;
}


- (UIView *)lineBottomView {
    if (_lineBottomView == nil) {
        _lineBottomView = [[UIView alloc] init];
        _lineBottomView.backgroundColor = HEXCOLOR(0xeeeeee);
    }
    return _lineBottomView;
}

- (UIImageView *)tagImageView {
    if (_tagImageView == nil) {
        _tagImageView = [[UIImageView alloc] init];
        _tagImageView.image = [UIImage imageNamed:@"recycle_logistics_ed"];
    }
    return _tagImageView;
}

- (UILabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = HEXCOLOR(0x999999);
        _statusLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _statusLabel.text = @"交易成功";
    }
    return _statusLabel;
}

- (UILabel *)desLabel {
    if (_desLabel == nil) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textColor = HEXCOLOR(0x999999);
        _desLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _desLabel.text = @"";
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
}

@end

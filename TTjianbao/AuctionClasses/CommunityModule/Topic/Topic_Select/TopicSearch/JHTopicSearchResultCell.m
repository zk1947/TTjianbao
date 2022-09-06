//
//  JHTopicSearchResultCell.m
//  TTjianbao
//
//  Created by wuyd on 2019/7/31.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTopicSearchResultCell.h"
#import "CTopicModel.h"
#import "TTjianbaoHeader.h"

@interface JHTopicSearchResultCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *createLabel;
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation JHTopicSearchResultCell

+ (CGFloat)cellHeight {
    return 50.0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyleEnabled:YES];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_iconView];
    }
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:15.0] textColor:kColor333];
        [self.contentView addSubview:_titleLabel];
    }
    
    if (!_createLabel) {
        _createLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:15.0] textColor:kColor999];
        _createLabel.text = @"创建话题";
        _createLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_createLabel];
        _createLabel.hidden = YES;
    }
    
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = kColorCellLine;
        [self.contentView addSubview:_bottomLine];
    }
    
    //布局
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.0);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    [_createLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(60, [[self class] cellHeight]));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(10.0);
        make.right.equalTo(_createLabel.mas_left).offset(-10.0);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo([[self class] cellHeight]);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setCurData:(CTopicData *)curData {
    _curData = curData;
    
    _iconView.image = [UIImage imageNamed:(curData.needCreate ? @"topic_icon_needCreate" : @"topic_icon_noNeedCreate")];
    
    _titleLabel.text = curData.title;
    _titleLabel.textColor = curData.needCreate ? [UIColor colorWithHexString:@"FF4000"] : kColor333;
    
    _createLabel.hidden = !curData.needCreate;
    
    //更新布局
//    if (curData.needCreate) {
//        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(_createLabel.mas_left).offset(-10);
//        }];
//
//    } else {
//        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView).offset(-15.0);
//        }];
//    }
}

@end

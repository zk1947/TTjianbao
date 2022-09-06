//
//  JHTopicListUnSelectCCell.m
//  TTjianbao
//
//  Created by wuyd on 2019/7/30.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTopicListUnSelectCCell.h"
#import "TTjianbaoHeader.h"

@interface JHTopicListUnSelectCCell ()
@property (nonatomic, strong) UIImageView *uncheckImgView;
@property (nonatomic, strong) UILabel *uncheckLabel;
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation JHTopicListUnSelectCCell

+ (CGSize)ccellSize {
    return CGSizeMake(ScreenWidth, 50.0);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        if (!_uncheckImgView) {
            _uncheckImgView = [UIImageView new];
            _uncheckImgView.image = [UIImage imageNamed:@"topic_icon_uncheck"];
            [self.contentView addSubview:_uncheckImgView];
        }
        
        if (!_uncheckLabel) {
            _uncheckLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:15.0] textColor:kColor666];
            _uncheckLabel.text = @"不选择话题";
            [self.contentView addSubview:_uncheckLabel];
        }
        
        if (!_bottomLine) {
            _bottomLine = [UIView new];
            _bottomLine.backgroundColor = kColorCellLine;
            [self.contentView addSubview:_bottomLine];
        }
        
        //布局
        [_uncheckImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.0);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(13.0, 13.0));
        }];
        
        [_uncheckLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.uncheckImgView.mas_right).offset(10.0);
            make.centerY.equalTo(self.contentView);
        }];
        
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth-30.0, 0.5));
        }];
    }
    return self;
}

@end

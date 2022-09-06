//
//  JHGoodsDetailCommentHeaderView.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsDetailCommentHeaderView.h"
//#import "TTjianbaoBussiness.h"
#import "TTjianbaoHeader.h"

@interface JHGoodsDetailCommentHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation JHGoodsDetailCommentHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:14] textColor:kColor333];
    _gradeLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:10] textColor:kColor666];
    _lineView = [UIView new];
    _lineView.backgroundColor = kColorCellLine;
    
    [self sd_addSubviews:@[_titleLabel, _gradeLabel, _lineView]];
    
    _titleLabel.sd_layout
    .topEqualToView(self)
    .bottomEqualToView(self)
    .leftSpaceToView(self, 10)
    .autoWidthRatio(0);
    
    _gradeLabel.sd_layout
    .topEqualToView(self)
    .bottomEqualToView(self)
    .leftSpaceToView(_titleLabel, 5)
    .autoWidthRatio(0);
    
    _lineView.sd_layout
    .bottomEqualToView(self)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(0.5);
    
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:180];
    [_gradeLabel setSingleLineAutoResizeWithMaxWidth:120];
}

- (void)setTitleStr:(NSString *)titleStr gradeStr:(NSString *)gradeStr {
    _titleLabel.text = titleStr;
    _gradeLabel.text = gradeStr;
}

@end

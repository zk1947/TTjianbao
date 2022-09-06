//
//  JHLotteryCategoryCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryCategoryCell.h"
#import "JHLotteryCategoryCellModel.h"
#import "TTjianbaoMarcoUI.h"
#import "UIView+SDAutoLayout.h"
#import "YDCategoryKit/YDCategoryKit.h"
#import "UIImageView+JHWebImage.h"

@interface JHLotteryCategoryCell ()
@property (nonatomic, strong) UIView *container;    //背景
@property (nonatomic, strong) UIImageView *imgView; //活动图标
@property (nonatomic, strong) UILabel *dateLabel;   //日期
@property (nonatomic, strong) UIView *stateView;    //状态背景
@property (nonatomic, strong) UILabel *stateLabel;  //状态：进行中、即将开始等
@end

@implementation JHLotteryCategoryCell

+ (CGSize)cellSize {
    return CGSizeMake(126, 60);
}

- (void)initializeViews {
    [super initializeViews];
    
    _container = [UIView new];
    _container.backgroundColor = kColorF5F6FA;
    _container.clipsToBounds = YES;
    _container.sd_cornerRadius = @(4);
    
    //日期
    _dateLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:12] textColor:kColor999];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    
    //状态
    _stateView = [UIView new];
    _stateView.clipsToBounds = YES;
    _stateView.sd_cornerRadiusFromHeightRatio = @(0.5);
    
    _stateLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:10] textColor:[UIColor whiteColor]];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    //_stateLabel.sd_cornerRadiusFromHeightRatio = @(0.5);
    //_stateLabel.yd_contentInsets = UIEdgeInsetsMake(0, 4, 0, 4);
    [_stateView addSubview:_stateLabel];
    
    //图标
    _imgView = [UIImageView new];
    _imgView.clipsToBounds = YES;
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    
    [_container sd_addSubviews:@[_dateLabel, _stateView, _imgView]];
    [self.contentView addSubview:_container];
    
    //布局
    _container.sd_layout.spaceToSuperView(UIEdgeInsetsMake(10, 0, 10, 0));
    
    _imgView.sd_layout
    .rightEqualToView(_container)
    .centerYEqualToView(_container)
    .heightRatioToView(_container, 1)
    .widthEqualToHeight();
    
    _dateLabel.sd_layout
    .topSpaceToView(_container, 13)
    .leftSpaceToView(_container, 0)
    .rightSpaceToView(_imgView, 0)
    .heightIs(17);
    
    _stateView.sd_layout
    .topSpaceToView(_dateLabel, 2)
    .centerXEqualToView(_dateLabel)
    .heightIs(15);
    
    _stateLabel.sd_layout
    .topEqualToView(_stateView)
    .leftSpaceToView(_stateView, 4)
    .heightIs(15)
    .autoWidthRatio(0);
    
    [_stateLabel setSingleLineAutoResizeWithMaxWidth:66-8]; //label横向自适应
    [_stateView setupAutoWidthWithRightView:_stateLabel rightMargin:4];
    
}

- (void)reloadData:(JXCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    JHLotteryCategoryCellModel *model = (JHLotteryCategoryCellModel *)cellModel;
    
    _dateLabel.text = model.dateStr;
    _stateLabel.text = model.stateStr;
    
    [_imgView jhSetImageWithURL:[NSURL URLWithString:model.imgUrl] placeholder:kDefaultCoverImage];
    
    if (model.isSelected) {
        _container.backgroundColor = [UIColor whiteColor];
        _container.layer.borderWidth = 2;
        _container.layer.borderColor = [UIColor colorWithHexString:@"FF9A00"].CGColor;
        
        _dateLabel.textColor = model.dateColorSelected;
        _stateView.backgroundColor = model.stateBgColorSelected;
        
    } else {
        _container.backgroundColor = kColorF5F6FA;
        _container.layer.borderWidth = 0;
        _container.layer.borderColor = [UIColor clearColor].CGColor;
        
        _dateLabel.textColor = model.dateColorNormal;
        _stateView.backgroundColor = model.stateBgColorNormal;
    }
}

@end

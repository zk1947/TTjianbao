//
//  JHTItleImageBackgroundCell.m
//  TTjianbao
//
//  Created by lihui on 2020/7/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//



#import "JHTItleImageBackgroundCell.h"
#import "JXTitleImageBackgroundCellModel.h"
#import "UIView+JHGradient.h"

@interface JHTItleImageBackgroundCell ()
@property (nonatomic, strong) CALayer *bgLayer;
@property (nonatomic, strong) UIView *bgView;

@end


@implementation JHTItleImageBackgroundCell

- (void)initializeViews {
    [super initializeViews];

    self.bgLayer = [CALayer layer];
    
    self.bgView = [[UIView alloc] init];
    [self.contentView.layer insertSublayer:self.bgLayer atIndex:0];
    [self.contentView insertSubview:self.bgView atIndex:0];
    self.bgView.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    JXTitleImageBackgroundCellModel *myCellModel = (JXTitleImageBackgroundCellModel *)self.cellModel;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CGFloat bgWidth = self.contentView.bounds.size.width;
    if (myCellModel.backgroundWidth != JXCategoryViewAutomaticDimension) {
        bgWidth = myCellModel.backgroundWidth;
    }
    CGFloat bgHeight = self.contentView.bounds.size.height;
    if (myCellModel.backgroundHeight != JXCategoryViewAutomaticDimension) {
        bgHeight = myCellModel.backgroundHeight;
    }
    self.bgLayer.bounds = CGRectMake(0, 0, bgWidth, bgHeight);
    self.bgLayer.position = self.contentView.center;
    
    self.bgView.bounds = CGRectMake(0, 0, bgWidth, bgHeight);
    self.bgView.center = self.contentView.center;

    [CATransaction commit];
}

- (void)reloadData:(JXCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    JXTitleImageBackgroundCellModel *myCellModel = (JXTitleImageBackgroundCellModel *)cellModel;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.bgLayer.borderWidth = myCellModel.borderLineWidth;
    self.bgLayer.cornerRadius = myCellModel.backgroundCornerRadius;
    self.bgView.layer.borderWidth = myCellModel.borderLineWidth;
    self.bgView.layer.cornerRadius = myCellModel.backgroundCornerRadius;
    self.bgView.layer.masksToBounds = YES;
    if (myCellModel.isSelected) {
        if (myCellModel.selectGradients == nil) {
            self.bgLayer.backgroundColor = myCellModel.selectedBackgroundColor.CGColor;
            self.bgLayer.borderColor = myCellModel.selectedBorderColor.CGColor;
            self.bgView.hidden = YES;
        }
        else {
            self.bgLayer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.f].CGColor;
            self.bgLayer.borderColor = [UIColor colorWithWhite:1 alpha:0.f].CGColor;
            self.bgView.backgroundColor = myCellModel.selectedBackgroundColor;
            self.bgView.layer.borderColor = myCellModel.selectedBorderColor.CGColor;
            [self.bgView jh_setGradientBackgroundWithColors:myCellModel.selectGradients locations:@[@0, @0.5, @1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
            self.bgView.hidden = NO;
        }
    }else {
        self.bgLayer.backgroundColor = myCellModel.normalBackgroundColor.CGColor;
        self.bgLayer.borderColor = myCellModel.normalBorderColor.CGColor;
    }
    [CATransaction commit];
}

@end

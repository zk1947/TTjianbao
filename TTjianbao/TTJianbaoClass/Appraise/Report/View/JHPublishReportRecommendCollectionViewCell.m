//
//  JHPublishReportRecommendCollectionViewCell.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPublishReportRecommendCollectionViewCell.h"
#import "JHPublishReportCollectionView.h"

@interface JHPublishReportRecommendCollectionViewCell ()

@property (nonatomic, weak) JHPublishReportCollectionView *collectionView;

@property (nonatomic, weak) UIView *lineView;

@end

@implementation JHPublishReportRecommendCollectionViewCell

- (void)addSelfSubViews {
    self.contentView.backgroundColor = UIColor.whiteColor;
    _collectionView = [JHPublishReportCollectionView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.contentView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 15, 0));
    }];
    
    _lineView = [UIView jh_viewWithColor:RGB(228, 228, 228) addToSuperview:self.contentView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    _lineView.hidden = YES;
}

- (void)setLineHidden:(BOOL)lineHidden {
    _lineView.hidden = lineHidden;
}

- (void)setRecommendArray:(NSMutableArray<JHReportRecommendLabelModel *> *)recommendArray {
    _recommendArray = recommendArray;
    self.collectionView.recommendArray = _recommendArray;
}

@end

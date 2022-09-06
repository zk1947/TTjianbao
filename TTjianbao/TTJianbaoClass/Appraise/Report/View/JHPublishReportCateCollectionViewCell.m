//
//  JHPublishReportCateCollectionViewCell.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPublishReportCateCollectionViewCell.h"
#import "JHPublishReportCollectionView.h"

@interface JHPublishReportCateCollectionViewCell ()

@property (nonatomic, weak) JHPublishReportCollectionView *collectionView;

@end

@implementation JHPublishReportCateCollectionViewCell

- (void)addSelfSubViews {
    self.contentView.backgroundColor = UIColor.whiteColor;
    _collectionView = [JHPublishReportCollectionView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.contentView];
    @weakify(self);
    _collectionView.selectBlock = ^(NSInteger index) {
        @strongify(self);
        if(self.selectBlock) {
            self.selectBlock();
        }
    };
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 15, 0));
    }];
}

- (void)setCateArray:(NSMutableArray<JHReportCateModel *> *)cateArray {
    _cateArray = cateArray;
    self.collectionView.cateArray = _cateArray;
}
@end

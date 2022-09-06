//
//  JHC2CGoodsOperationCollectionCell.m
//  TTjianbao
//
//  Created by hao on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CGoodsOperationCollectionCell.h"
#import "SDCycleScrollView.h"
#import "JHC2CGoodsListModel.h"

@interface JHC2CGoodsOperationCollectionCell ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) NSArray *operationDataArray;

@end

@implementation JHC2CGoodsOperationCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    [self.contentView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
   
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    JHC2COperatingPositionListModel *operationModel = self.operationDataArray[index];
    [JHRootController toNativeVC:operationModel.target.vc withParam:operationModel.target.params from:@""];

}

//数据绑定
- (void)bindViewModel:(id)dataModel{
    self.operationDataArray = dataModel;
    NSMutableArray *imgUrls = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.operationDataArray.count; i++) {
        JHC2COperatingPositionListModel *operationModel = self.operationDataArray[i];
        [imgUrls addObject:operationModel.imageUrl];
    }
    _scrollView.imageURLStringsGroup = imgUrls;
    
}


- (SDCycleScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[SDCycleScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.placeholderImage = kDefaultNewStoreCoverImage;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.layer.cornerRadius = 5.f;
        _scrollView.clipsToBounds = YES;
        _scrollView.autoScrollTimeInterval = 3;
        _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _scrollView.hidesForSinglePage = YES;
        _scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleJH;
        _scrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _scrollView;
}

@end

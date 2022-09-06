//
//  JHCustomWorkRecommendView.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomWorkRecommendView.h"
#import "JHCustomNewCollectionViewCell.h"
#import "JHCustomWorksViewController.h"

@interface JHCustomWorkRecommendView()<UICollectionViewDelegate, UICollectionViewDataSource>
/** 定制作品*/
@property (nonatomic, strong) UILabel *customTagLabel;
/** 查看更多*/
@property (nonatomic, strong) UIButton *seeMoreButton;
/** 数据源*/
@property (nonatomic, strong) UICollectionView *collectionView;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView;
@end
@implementation JHCustomWorkRecommendView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI{
    [self addSubview:self.customTagLabel];
    [self addSubview:self.seeMoreButton];
    [self addSubview:self.collectionView];
    [self addSubview:self.lineView];
    self.height = self.lineView.bottom;
}

#pragma mark -collectionview 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;  //每个section的Item数
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHCustomNewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCustomNewCollectionViewCell class]) forIndexPath:indexPath];
//    [cell setViewShadow];
    return cell;
}

#pragma mark -响应事件
/** 查看更多*/
- (void)moreButtonClickAction{
    JHCustomWorksViewController *customWorksVC = [[JHCustomWorksViewController alloc] init];
    [self.viewController.navigationController pushViewController:customWorksVC animated:YES];
}

#pragma mark -UI绘制
- (UILabel *)customTagLabel{
    if (_customTagLabel == nil) {
        _customTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 21)];
        _customTagLabel.text = @"定制作品";
        _customTagLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _customTagLabel.textColor = RGB515151;
    }
    return _customTagLabel;
}

- (UIButton *)seeMoreButton{
    if (_seeMoreButton == nil) {
        _seeMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _seeMoreButton.frame = CGRectMake(self.width - 110, 15, 100, 21);
//        [_seeMoreButton setImage:[UIImage imageNamed:@"icon_home_special"] forState:UIControlStateNormal];
        [_seeMoreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        _seeMoreButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_seeMoreButton setImage:[UIImage imageNamed:@"store_icon_seller_more_arrow"] forState:UIControlStateNormal];
        [_seeMoreButton setImageInsetStyle:MRImageInsetStyleRight spacing:5];
        [_seeMoreButton setTitleColor:RGB153153153 forState:UIControlStateNormal];
        _seeMoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_seeMoreButton addTarget:self action:@selector(moreButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeMoreButton;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;// 设置item的大小
        CGFloat itemW = (ScreenW - 25) / 2 ;
        layout.itemSize = CGSizeMake(itemW, itemW + 63);

        // 设置每个分区的 上左下右 的内边距
        layout.sectionInset = UIEdgeInsetsMake(0, 10 ,0, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.customTagLabel.bottom + 15, ScreenW, (itemW + 63) * 2 + 5 + 15) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[JHCustomNewCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCustomNewCollectionViewCell class])];
    }
    return _collectionView;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.bottom, self.width, 10)];
        _lineView.backgroundColor = kColorF5F6FA;
    }
    return _lineView;
}
@end

//
//  JHJHMyCenterCollectionView.m
//  TTjianbao
//
//  Created by apple on 2020/4/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMyCenterCollectionView.h"

@interface JHMyCenterCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JHMyCenterCollectionView

-(void)dealloc{
    NSLog(@"🔥%@",NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.count = 4;
    }
    return self;
}


-(void)setButtonArray:(NSMutableArray<JHMyCenterMerchantCellButtonModel *> *)buttonArray{
    _buttonArray = buttonArray;
    
    if(_buttonArray){
        [self.collectionView reloadData];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.buttonArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMyCenterCollectionViewCell *cell = [JHMyCenterCollectionViewCell dequeueReusableCellWithCollectionView:collectionView indexPath:indexPath];
    cell.model = SAFE_OBJECTATINDEX(_buttonArray, indexPath.item);
    return  cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMyCenterMerchantCellButtonModel *model = SAFE_OBJECTATINDEX(_buttonArray, indexPath.item);
    [model pushViewController];
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.count = (self.count <= 0 ? 4 : self.count);
        /** layout布局 */
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(floorl((ScreenW-20)/self.count), 70);;;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:[JHMyCenterCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMyCenterCollectionViewCell class])];
        [self addSubview:_collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _collectionView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

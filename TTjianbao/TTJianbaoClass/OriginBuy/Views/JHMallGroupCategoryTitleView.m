//
//  JHMallGroupCategoryTitleView.m
//  TTjianbao
//
//  Created by apple on 2020/7/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallGroupCategoryTitleView.h"
#import "JHCategoryTitleCell.h"
#import "JHMallCateModel.h"
#import "JHMallCateViewModel.h"
#import <YDCategoryKit/YDCategoryKit.h>

@interface JHMallGroupCategoryTitleView () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *categoryData;
@property (nonatomic, strong) NSMutableArray *vmArr;

@end

@implementation JHMallGroupCategoryTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexStr:@"#F5F6FA"];
        [self createViews];
        self.selectIndex = 1000000;
    }
    return self;
}

-(void)setData:(NSArray *)categoryData
{
    self.categoryData = categoryData;
    self.selectIndex = 1000000;
    if(self.vmArr.count > 0)
    {
        [self.vmArr removeAllObjects];        
    }
    for (JHMallCateModel *cateModel in categoryData) {
       JHMallCateViewModel *vm = [JHMallCateViewModel setViewModelWithModel:cateModel];
        [self.vmArr addObject:vm];
    }

    [self.collectionView reloadData];
}

- (void)createViews {
   
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


-(UICollectionView *)collectionView
{
    if(!_collectionView)
    {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.itemSize = CGSizeMake(49.0, 26.0);
        flow.minimumInteritemSpacing = 10.0;
        flow.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView =  [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        [self addSubview:_collectionView];
        _collectionView.backgroundColor = [UIColor colorWithHexStr:@"#F5F6FA"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[JHCategoryTitleCell class] forCellWithReuseIdentifier:@"JHCategoryTitleCell"];
    }
    return _collectionView;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHCategoryTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHCategoryTitleCell" forIndexPath:indexPath];
    JHMallCateViewModel *vm = self.vmArr[indexPath.item];
    [cell setTitleWithVm:vm];
    if (indexPath.item == self.selectIndex) {
        [cell updateTitleLabel:YES];
    }else
    {
        [cell updateTitleLabel:NO];
    }
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.vmArr.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex = indexPath.item;
    JHMallCateViewModel *vm = self.vmArr[indexPath.item];
    if(self.clickItemBlock)
    {
        self.clickItemBlock(vm, self.selectIndex);
    }
    [self.collectionView reloadData];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHMallCateViewModel *vm = self.vmArr[indexPath.item];
    return CGSizeMake(vm.cellWidth, vm.cellHeight);
}
-(NSMutableArray *)vmArr
{
    if(!_vmArr)
    {
        _vmArr = [NSMutableArray array];
    }
    return _vmArr;
}
@end

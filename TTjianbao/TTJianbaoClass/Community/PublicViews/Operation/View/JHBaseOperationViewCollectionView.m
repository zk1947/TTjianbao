//
//  JHBaseOperationViewCollectionView.m
//  TTjianbao
//
//  Created by apple on 2020/4/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseOperationViewCollectionView.h"
#import "JHOperationViewHeader.h"

@interface JHBaseOperationViewCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;



@end

@implementation JHBaseOperationViewCollectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
      //  layout.itemSize = CGSizeMake(55, 70);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(10,0,10,0);
      //  layout.minimumLineSpacing = 18;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
       
        [self addSubview:_collectionView];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.contentInset = UIEdgeInsetsMake(0,0, 0, 0);
        [_collectionView registerClass:[JHBaseOperationViewCell class] forCellWithReuseIdentifier:@"JHBaseOperationViewCell"];
        
        [_collectionView registerClass:[JHOperationViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JHOperationViewHeader"];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHBaseOperationViewCell *cell = [JHBaseOperationViewCell dequeueReusableCellWithCollectionView:collectionView indexPath:indexPath];
    if(self.dataArray.count > indexPath.item){
        cell.model = self.dataArray[indexPath.item];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.showHeader) {
          return CGSizeMake(ScreenW, operationHeaderHeight);
    }
    return CGSizeMake(0, 0);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqual:UICollectionElementKindSectionHeader]){
            JHOperationViewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"JHOperationViewHeader" forIndexPath:indexPath];
            return headerView;
        }
     return nil;
}

#pragma mark - UICollectionViewLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        CGFloat w =ScreenW/5;
        return CGSizeMake(w,operationCellHeight);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.dataArray.count > indexPath.item){
        JHBaseOperationModel *model = self.dataArray[indexPath.item];
        if(_operationBlock){
            _operationBlock(model.operationType);
        }
    }
}
-(void)setOperationType:(JHOperationType)operationType{
    _operationType = operationType;
    self.dataArray = [JHBaseOperationModel getOperationTypeArrayWith:operationType];
    [self.collectionView reloadData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

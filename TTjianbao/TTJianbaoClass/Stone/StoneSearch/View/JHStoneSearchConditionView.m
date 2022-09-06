//
//  JHStoneSearchConditionView.m
//  TTjianbao
//
//  Created by apple on 2020/2/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoneSearchConditionView.h"
#import "JHStoneSearchConditionCell.h"
#import "JHStoneSearchConditionHeader.h"
#import "JHStoneSearchConditionInputCell.h"
#import "JHStoneSearchConditionViewModel.h"
#import "JHStoneSearchConditionFooterView.h"
@interface JHStoneSearchConditionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) JHStoneSearchConditionViewModel *viewModel;

@property (nonatomic, strong) JHStoneSearchConditionSelectModel *selectedModel;

@end

@implementation JHStoneSearchConditionView

-(void)dealloc
{
    NSLog(@"🔥");
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeViewMethod:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [self.viewModel.requestCommand execute:@1];
    }
    return self;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.viewModel.tagArray.count > 0 ? 3 : 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.viewModel.priceArray.count + 1;
            break;
            
            case 1:
            return self.viewModel.dateArray.count;
            break;
            
            case 2:
            return self.viewModel.tagArray.count;
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return  [JHStoneSearchConditionHeader viewSize];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
        return CGSizeMake( [JHStoneSearchConditionHeader viewSize].width, CGFLOAT_MIN);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.item == 0) {
        return [JHStoneSearchConditionInputCell itemSize];
        
    }else {
        return [JHStoneSearchConditionCell itemSize];
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    JHStoneSearchConditionHeader *header = [JHStoneSearchConditionHeader dequeueReusableViewWithKind:UICollectionElementKindSectionHeader collectionView:collectionView indexPath:indexPath];
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        header.titleLabel.text = self.viewModel.sectionTitleArray[indexPath.section];
    }
    else
    {
        header.titleLabel.text = @"";
    }
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0 && indexPath.item == 0)
    {
        JHStoneSearchConditionInputCell *cell = [JHStoneSearchConditionInputCell dequeueReusableCellWithCollectionView:collectionView indexPath:indexPath];
        cell.lowPriceTf.text = self.viewModel.lowPrice;
        cell.heighPriceTf.text = self.viewModel.heighPrice;
        @weakify(self);
        cell.inputChangeBlock = ^(NSString * _Nonnull lowStr, NSString * _Nonnull heighStr) {
            @strongify(self);
            self.viewModel.lowPrice = lowStr;
            self.viewModel.heighPrice = heighStr;
            self.selectedModel.minPrice = lowStr;
            self.selectedModel.maxPrice = heighStr;
            [self reloadPriceItem];
        };
        return cell;
    }
    
    JHStoneSearchConditionCell *cell = [JHStoneSearchConditionCell dequeueReusableCellWithCollectionView:collectionView indexPath:indexPath];
    if(indexPath.section == 0)
    {
        JHStoneSearchConditionModel *model = self.viewModel.priceArray[indexPath.item - 1];
        NSString *string = [NSString stringWithFormat:@"%@-%@",self.selectedModel.minPrice,self.selectedModel.maxPrice];
        model.isSelected = ([model.label isEqualToString:string]);
            
        cell.model = self.viewModel.priceArray[indexPath.item - 1];
    }

   else if(indexPath.section == 1)
   {
       if(indexPath.item < self.viewModel.dateArray.count)
       {
           cell.model = self.viewModel.dateArray[indexPath.item];
       }
   }
    else
    {
        if(indexPath.item < self.viewModel.tagArray.count)
        {
            cell.model = self.viewModel.tagArray[indexPath.item];
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 2)
    {
        if(indexPath.item < self.viewModel.tagArray.count)
         {
             JHStoneSearchConditionModel *model = self.viewModel.tagArray[indexPath.item];
             model.isSelected = !model.isSelected;
             if(model.isSelected)
             {
                 [self.selectedModel.labelIdList addObject:model.ID];
             }
             else
             {
                 [self.selectedModel.labelIdList removeObject:model.ID];
             }
         }
    }
    
    if(indexPath.section == 1)
    {
        if(indexPath.item < self.viewModel.dateArray.count)
         {
             JHStoneSearchConditionModel *model = self.viewModel.dateArray[indexPath.item];
             if(model.isSelected)
             {
                 model.isSelected = NO;
                 self.selectedModel.shelveDay = @"0";
             }
             else
             {
                 for (JHStoneSearchConditionModel *m in self.viewModel.dateArray) {
                     m.isSelected = NO;
                 }
                 model.isSelected = YES;
                 self.selectedModel.shelveDay = model.ID;
             }
             
         }
    }
    
    if(indexPath.section == 0 && indexPath.item >0)
    {
        JHStoneSearchConditionModel *model = self.viewModel.priceArray[indexPath.item - 1];
        model.isSelected = !model.isSelected;
        
        NSString *maxNum = model.isSelected ? model.heighPrice : @"";
        NSString *minNum = model.isSelected ? model.lowPrice : @"";
        self.viewModel.lowPrice = minNum;
        self.viewModel.heighPrice = maxNum;
        self.selectedModel.minPrice = minNum;
        self.selectedModel.maxPrice = maxNum;
    }
    [self.collectionView reloadData];
}

-(void)reloadPriceItem
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < self.viewModel.priceArray.count; i++) {
        [array addObject:[NSIndexPath indexPathForItem:i+1 inSection:0]];
    }
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadItemsAtIndexPaths:array];
    }];
    
}
#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UIView *bgView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.width.mas_equalTo(295);
        }];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[JHStoneSearchConditionInputCell class] forCellWithReuseIdentifier:[JHStoneSearchConditionInputCell cellIdentifier]];
        [_collectionView registerClass:[JHStoneSearchConditionCell class] forCellWithReuseIdentifier:[JHStoneSearchConditionCell cellIdentifier]];
        
        [_collectionView registerClass:[JHStoneSearchConditionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[JHStoneSearchConditionHeader reuseIdentifier]];
        [bgView addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(bgView).insets(UIEdgeInsetsMake(50, 10, 50, 10));
        }];
    }
    return _collectionView;
}

-(JHStoneSearchConditionViewModel *)viewModel
{
    if(!_viewModel)
    {
        _viewModel = [JHStoneSearchConditionViewModel new];
        @weakify(self);
        [_viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self changeConditionStatus];
            [self.collectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self creatfooterViewconstraint];
            });
        }];
    }
    return _viewModel;
}

-(JHStoneSearchConditionSelectModel *)selectedModel
{
    if(!_selectedModel){
        _selectedModel = [JHStoneSearchConditionSelectModel new];
    }
    return _selectedModel;
}

-(void)creatfooterViewconstraint
{
    JHStoneSearchConditionFooterView *buttonView = [JHStoneSearchConditionFooterView new];
    [self addSubview:buttonView];
   [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.equalTo(self.collectionView);
       make.height.mas_equalTo(40.f); make.top.equalTo(self.collectionView).offset(60 + self.collectionView.contentSize.height);
   }];
    @weakify(self);
    buttonView.cancleBlock = ^{
        @strongify(self);
        [self cancleMethod];
    };
    
    buttonView.makeSureBlock = ^{
        @strongify(self);
        [self makeSuresearchData];
    };
}

-(void)makeSuresearchData
{
    NSInteger lowPrice = self.selectedModel.minPrice.floatValue;
    NSInteger heighPrice = self.selectedModel.maxPrice.floatValue;
    if (lowPrice > heighPrice) {
        NSString *tem = self.selectedModel.maxPrice;
        self.selectedModel.maxPrice = self.selectedModel.minPrice;
        self.selectedModel.minPrice = tem;
    }
    if (_selectedBlock) {
        _selectedBlock(self.selectedModel.mj_keyValues);
    }
    [self removeFromSuperview];
}

-(void)changeConditionStatus
{
    if(_selectDic)
    {
        JHStoneSearchConditionSelectModel *paramModel = [JHStoneSearchConditionSelectModel mj_objectWithKeyValues:_selectDic];
        
        self.selectedModel.minPrice = paramModel.minPrice;
        self.selectedModel.maxPrice = paramModel.maxPrice;
        self.viewModel.lowPrice = paramModel.minPrice;
        self.viewModel.heighPrice = paramModel.maxPrice;
        
        if(paramModel.shelveDay)
        {
            for (JHStoneSearchConditionModel *model in self.viewModel.dateArray) {
                if([model.ID isEqualToString:paramModel.shelveDay])
                {
                    self.selectedModel.shelveDay = model.ID;
                    model.isSelected = YES;
                }
            }
        }
        
        if(paramModel.labelIdList)
        {
            for (NSString *ID in paramModel.labelIdList) {
                for (JHStoneSearchConditionModel *model in self.viewModel.tagArray) {
                    if([model.ID isEqualToString:ID])
                    {
                        [self.selectedModel.labelIdList addObject:model.ID];
                        model.isSelected = YES;
                    }
                }
            }
        }
        
    }
}

-(void)cancleMethod
{
    [self.viewModel cancleData];
    self.selectedModel = [JHStoneSearchConditionSelectModel new];
    [self.collectionView reloadData];
}
-(void)removeViewMethod:(UIGestureRecognizer *)sender
{
    [self removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return ![touch.view isDescendantOfView:self.collectionView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

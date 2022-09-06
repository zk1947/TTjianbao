//
//  JHCustomizeStuffDetailController.m
//  TTjianbao
//
//  Created by jiangchao on 2020/12/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeStuffDetailController.h"
#import "JHCustomizeStuffDetailCell.h"
#import "UIScrollView+JHEmpty.h"
@interface JHCustomizeStuffDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <JHMeterialsCategoryModel*>*dataArray;
@end

@implementation JHCustomizeStuffDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑可定制材质";
    [self initRightButtonWithName:@"保存" action:@selector(Save)];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
    [self.view addSubview:self.collectionView];
    [self getCateAll];
}
- (void)getCateAll {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/app/appraisal/customizeSample/list-material") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
        self.dataArray = [JHMeterialsCategoryModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        [self.collectionView jh_reloadDataWithEmputyView];
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
    }];
    [SVProgressHUD show];
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(0,0, 0, 0);
        [_collectionView registerClass:[JHCustomizeStuffDetailCell class] forCellWithReuseIdentifier:@"JHCustomizeStuffDetailCell"];
    }
    return _collectionView;;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHCustomizeStuffDetailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHCustomizeStuffDetailCell" forIndexPath:indexPath];
    cell.stuffModel = self.dataArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}
#pragma mark - UICollectionViewLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        CGFloat w =(ScreenW-30)/2;
        return CGSizeMake(w,w*80./172);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHMeterialsCategoryModel * selectModel = self.dataArray[indexPath.row];
    selectModel.isSelect = !selectModel.isSelect;
   [self.collectionView reloadData];
    
}
#pragma mark - action
-(void)Save{
    
    NSMutableArray * ids = [NSMutableArray array];
    for (JHMeterialsCategoryModel *mode in self.dataArray) {
        if (mode.isSelect) {
            [ids addObject:mode.ID];
        }
    }
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/appraisal/customizeSample/save-material") Parameters:ids requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [JHKeyWindow makeToast:@"保存成功" duration:1.0 position:CSToastPositionCenter];
        if (self.saveBlock) {
            self.saveBlock();
        }
        [SVProgressHUD dismiss];
        [JHDispatch after:1.f execute:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    [SVProgressHUD show];
}
@end

//
//  JHStoneResaleLayer.m
//  TTjianbao
//
//  Created by 张坤 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoneResaleLayer.h"
#import "JHPersonTableViewCell.h"

@interface JHStoneResaleLayer()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) StoneResaleLayerBlock stoneResaleLayerBlock;
@end

@implementation JHStoneResaleLayer

#pragma mark - public method
- (void)showStoneResaleLayerWithDataSource:(NSArray *)dataSource didClickItem:(StoneResaleLayerBlock)stoneResaleLayerBlock {
    self.dataSource = dataSource;
    [self.collectionView reloadData];
    
    if (stoneResaleLayerBlock) {
        self.stoneResaleLayerBlock = stoneResaleLayerBlock;
    }
    
    [JHKeyWindow addSubview:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mainView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0.f);
        }];
        [UIView animateWithDuration:0.25f animations:^{
            [self layoutIfNeeded];
        }];
    });
}

#pragma mark - system method

-(void)dealloc {
    NSLog(@"---JHStoneResaleLayer");
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
        self.frame = JHKeyWindow.frame;
        UIButton *button = [UIButton jh_buttonWithTarget:self action:@selector(dismiss) addToSuperView:self];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _mainView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat h = (146.f+UI.bottomSafeAreaHeight);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(h);
            make.bottom.mas_equalTo(h);
        }];
        [self layoutIfNeeded];
        [_mainView jh_cornerRadius:8.f rectCorner:UIRectCornerTopLeft|UIRectCornerTopRight bounds:_mainView.bounds];
        
        UIButton *cancleButton = [UIButton jh_buttonWithImage:[UIImage imageNamed:@"stoneResale_layer_close"] target:self action:@selector(cancleMethod) addToSuperView:_mainView];
        [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15.f);
            make.right.mas_equalTo(-15.f);
        }];
        
        UILabel *titleLabel = [UILabel jh_labelWithFont:15 textColor:kColor333 addToSuperView:_mainView];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cancleButton);
            make.centerX.mas_equalTo(_mainView);
        }];
        titleLabel.text = @"原石回血";
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(5.f);
            make.bottom.mas_equalTo(-10.f);
            make.left.right.mas_equalTo(0.f);
        }];
        
        [self layoutIfNeeded];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHPersonTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHPersonTableViewCell class]) forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w =(ScreenW-20)/5;
    return CGSizeMake(w,80);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMyCellModel *model = self.dataSource[indexPath.row];
    if(self.stoneResaleLayerBlock){
        self.stoneResaleLayerBlock(model);
        [self cancleMethod];
    }
}

#pragma mark - private method

- (void)dismiss {
    [_mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_mainView.height);
    }];
    [UIView animateWithDuration:0.25f animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)cancleMethod {
    [self dismiss];
}

#pragma mark - set method

- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
      //  layout.itemSize = CGSizeMake(55, 70);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0.f;
        layout.minimumLineSpacing = 0.f;
        layout.sectionInset = UIEdgeInsetsMake(0,10,0,10);
      //  layout.minimumLineSpacing = 18;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.contentInset = UIEdgeInsetsZero;
        [_mainView addSubview:_collectionView];
        
        [_collectionView registerClass:[JHPersonTableViewCell class] forCellWithReuseIdentifier:@"JHPersonTableViewCell"];
    }
    return _collectionView;
}

@end

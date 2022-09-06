//
//  JHCustomServiceSearchResultView.m
//  TTjianbao
//
//  Created by Jesse on 2020/9/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomServiceSearchResultView.h"
#import "JHMallLittleCollectionViewCell.h"
#import "JHGrowingIO.h"

@interface JHCustomServiceSearchResultView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView* emptyImageView;
@property (nonatomic, strong) UILabel* emptyLabel;
@property (nonatomic, strong) NSArray* dataArray;
@property (nonatomic, strong) UICollectionView* resultCollectionView; //tableview
@property (nonatomic, copy) JHActionBlock clickCallback;
@end

@implementation JHCustomServiceSearchResultView

- (instancetype)init
{
    if(self = [super init])
    {
        [self showSubviews];
        [self showEmptyText];
    }
    return self;
}

- (void)reloadResultData:(NSArray*)array callback:(JHActionBlock)callback
{
    self.dataArray = array;
    self.clickCallback = callback;
    if([self.dataArray count] > 0)
    {
        [self.resultCollectionView reloadData];
        [self setResultViewHidden:NO];
    }
    else
    {
        [self setResultViewHidden:YES];
    }
}

- (void)setResultViewHidden:(BOOL)hidden
{
    self.resultCollectionView.hidden = hidden;
    self.emptyImageView.hidden = !hidden;
    self.emptyLabel.hidden = !hidden;
}

#pragma mark - content view
- (void)showSubviews
{
    [self.resultCollectionView registerClass:[JHMallLittleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class])];

    [self.resultCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewIdentifer"];
    
    [self addSubview:self.resultCollectionView];
    [self.resultCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (UICollectionView *)resultCollectionView
{
    if (!_resultCollectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 9;
        flowLayout.minimumLineSpacing = 9;// 设置item的大小
        CGFloat itemW = (ScreenWidth-33.f) / 2. ;
        flowLayout.itemSize = CGSizeMake(itemW, itemW * 249 / 171);
        // 设置每个分区的 上左下右 的内边距
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 12, 10, 12);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _resultCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _resultCollectionView.delegate = self;
        _resultCollectionView.dataSource = self;
        _resultCollectionView.showsVerticalScrollIndicator = NO;
        _resultCollectionView.showsHorizontalScrollIndicator = NO;
        _resultCollectionView.alwaysBounceVertical = YES;
        _resultCollectionView.backgroundColor = HEXCOLOR(0xF5F6FA);
    }
    return _resultCollectionView;
}

#pragma mark - collectionview 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;   //返回section数
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;  //每个section的Item数
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHMallLittleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class]) forIndexPath:indexPath];
    
    cell.liveRoomMode = self.dataArray[indexPath.item];
    return cell;
}

 - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     [collectionView deselectItemAtIndexPath:indexPath animated:YES];//取消选中
    //do something ...
     JHLiveRoomMode* model = self.dataArray[indexPath.item];
    if(self.clickCallback && [model.channelLocalId length] > 0)
    {
        self.clickCallback(model.channelLocalId);
        [JHGrowingIO trackEventId:JHTrackCustomizeListdz_search_item variables:@{@"channelLocalId":model.channelLocalId,@"index":@(indexPath.item)}];
    }
    
    
}

#pragma mark - empty page
- (void)showEmptyText
{
    [self addSubview:self.emptyImageView];
    [self addSubview:self.emptyLabel];
    
    self.emptyImageView.hidden = NO;
    [self.emptyImageView setImage:[UIImage imageNamed:@"img_default_page"]];
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-60);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    self.emptyLabel.hidden = NO;
    self.emptyLabel.text = @"暂无数据~";
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.emptyImageView.mas_centerX);
    }];
}

- (UIImageView *)emptyImageView
{
    if (!_emptyImageView)
    {
        _emptyImageView = [UIImageView new];
        _emptyImageView.contentMode = UIViewContentModeCenter;
    }
    return _emptyImageView;
}

- (UILabel *)emptyLabel
{
    if (_emptyLabel == nil)
    {
        _emptyLabel = [UILabel new];
        _emptyLabel.font = [UIFont systemFontOfSize:18];
        _emptyLabel.textColor = HEXCOLOR(0xa7a7a7);
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _emptyLabel;
}

@end

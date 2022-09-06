//
//  JHAudienceListView.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/7.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHAudienceListView.h"
#import "JHLiveAudienceCell.h"
#import "TTjianbaoHeader.h"

@interface JHAudienceListView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation JHAudienceListView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        self.collectionView.frame = self.bounds;
    }
    return self;
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return 10;
    return _dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHLiveAudienceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHLiveAudienceCell" forIndexPath:indexPath];
    NIMChatroomMember *item = self.dataList[indexPath.row];
    cell.member = item;
    
    return cell;
}

#pragma mark - get

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 5.0f;
        layout.minimumLineSpacing = 5.0f;
        CGFloat itemWidth = self.frame.size.height;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;

        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JHLiveAudienceCell class]) bundle:nil]  forCellWithReuseIdentifier:@"JHLiveAudienceCell"];
        
    }
    return _collectionView;
}

- (void)reloadData:(NSMutableArray *)array {
    self.dataList = array;
    if (array.count<showCount) {
        CGFloat ww = array.count * 40;
        CGRect frame = self.collectionView.frame;
        frame.origin.x = self.mj_w- ww;
        frame.size.width = ww;
        self.collectionView.frame = frame;
    } else {
        self.collectionView.frame = self.bounds;
    }
    [self.collectionView reloadData];
    
}

@end


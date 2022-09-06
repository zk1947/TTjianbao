//
//  JHStoreGoodsView.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreGoodsView.h"
#import "JHStoreGoodsCollectionViewCell.h"
#import "JHStoreRankListModel.h"

#define cellWidth (ScreenW - 44.f - 12 * 3) / 4

@interface JHStoreGoodsView()
@property (nonatomic, strong) UIView *listView;
@property (nonatomic, strong) NSMutableArray<JHStoreGoodsCollectionViewCell *> *listViewArray;


@end
@implementation JHStoreGoodsView

- (NSMutableArray<JHStoreGoodsCollectionViewCell *> *)listViewArray {
    if (!_listViewArray) {
        _listViewArray = [[NSMutableArray alloc] init];
    }
    return _listViewArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

//数据接收
- (void)setGoodsArray:(NSArray<JHStoreRankProductModel *> *)goodsArray {
    _goodsArray = goodsArray;
    if (goodsArray.count == 0) {
        return;
    }
    for (int i = 0; i < self.listViewArray.count; i++) {
        JHStoreGoodsCollectionViewCell *ccView = self.listViewArray[i];
        if (goodsArray.count > i) {
            ccView.model = goodsArray[i];
            ccView.hidden = NO;
        } else {
            ccView.hidden = YES;
        }
    }
}

- (void)configUI {
    JHStoreGoodsCollectionViewCell *tempView = nil;
    CGFloat space = 10.f;
    for (int i = 0; i < 4; i ++) {
        JHStoreGoodsCollectionViewCell *ccView = [[JHStoreGoodsCollectionViewCell alloc] init];
        [self.listViewArray addObject:ccView];
        [self addSubview:ccView];
        
        if (tempView == nil) {
            [ccView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(space);
                make.left.equalTo(self).offset(space);
                make.size.mas_equalTo(CGSizeMake(cellWidth, cellWidth+60));
            }];
        }
        else {
            [ccView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tempView);
                make.left.equalTo(tempView.mas_right).offset(12.);
                make.size.mas_equalTo(CGSizeMake(cellWidth, cellWidth+60));
            }];
        }
        tempView = ccView;
    }
}
@end

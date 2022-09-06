//
//  JHRecommendPlateCollectionCell.m
//  TTjianbao
//
//  Created by lihui on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRecommendPlateCollectionCell.h"
#import "JHPlateListView.h"
#import "JHPlateListModel.h"

#define LIST_HEIGHT (75.f)

@interface JHRecommendPlateCollectionCell ()

@property (nonatomic, strong) NSMutableArray <JHPlateListView *>*listViewArray;

@end

@implementation JHRecommendPlateCollectionCell

- (void)setPlateInfos:(NSArray<JHPlateListData *> *)plateInfos {
    if (!(plateInfos && plateInfos.count > 0)) {
        return;
    }
    _plateInfos = plateInfos;

    for (int i = (int)_plateInfos.count; i < self.listViewArray.count; i ++) {
        JHPlateListView *list = self.listViewArray[i];
        [list.layer cancelCurrentImageRequest];
        [list setHidden:YES];
    }
    
    for (int i = 0; i < _plateInfos.count; i ++) {
        JHPlateListView *list = self.listViewArray[i];
        list.hidden = NO;
        list.showLine = (i != _plateInfos.count-1);
        list.plateInfo = _plateInfos[i];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorF5F6FA;
        self.layer.cornerRadius = 8.f;
        self.layer.masksToBounds = YES;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    for (int i = 0; i < 3; i ++) {
        JHPlateListView *list = [[JHPlateListView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:list];
        [self.listViewArray addObject:list];
        [list mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(i*LIST_HEIGHT);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(LIST_HEIGHT);
        }];
    }
}

- (NSMutableArray<JHPlateListView *> *)listViewArray {
    if (!_listViewArray) {
        _listViewArray = [NSMutableArray array];
    }
    return _listViewArray;
}

@end

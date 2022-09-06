//
//  SearchKeyListCCell.h
//  ForkNews
//
//  Created by wuyd on 2018/5/14.
//  Copyright © 2018年 wuyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSearchKeyModel.h"

#define kCCellId_SearchHotListCCell     @"SearchHotListCCellIdentifier"
#define kCCellId_SearchHistoryListCCell @"SearchHistoryListCCellIdentifier"

@interface SearchKeyListCCell : UICollectionViewCell

@property (nonatomic, strong) CSearchKeyData *keyData;

- (void)setKeyData:(CSearchKeyData *)keyData isHot:(BOOL)isHot;

@end

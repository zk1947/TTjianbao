//
//  JHSQCustomizeCommentAssetsView.h
//  TTjianbao
//
//  Created by user on 2020/11/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSQCustomizeCommentAssetsView : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *dataArray;
@property (nonatomic,   copy) dispatch_block_t  addAlbumBlock;
@property (nonatomic,   copy) void (^deleteActionBlock)(NSInteger index);
+ (CGSize)viewSize;
@end

NS_ASSUME_NONNULL_END

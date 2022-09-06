//
//  JHDiscoverHomeFlowCollectionCell.h
//  TTjianbao
//
//  Created by mac on 2019/5/20.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHDiscoverChannelCateModel;
NS_ASSUME_NONNULL_BEGIN
typedef void (^JHHomeCollectionViewCellClickAction)(BOOL isLaud,  NSInteger index);
typedef void(^JHDiscoverHomeFlowCollectionCellClickUser)(JHDiscoverChannelCateModel* recordMode);
typedef void(^JHDiscoverHomeFlowCollectionCellDisInterestBlock)(JHDiscoverChannelCateModel* recordMode);
@interface JHDiscoverHomeFlowCollectionCell : UICollectionViewCell
@property(nonatomic,strong) JHDiscoverChannelCateModel* recordMode;

@property(nonatomic,copy) JHHomeCollectionViewCellClickAction cellClick;
@property (nonatomic, copy) JHDiscoverHomeFlowCollectionCellDisInterestBlock disInterestBlock;
@property (strong, nonatomic)  UIImageView *likeImageView;
@property (strong, nonatomic, readonly)  UIImageView *coverImage;
@property (strong, nonatomic)  UILabel *likeCountLabel;
@property(nonatomic,assign) NSInteger cellIndex;
@property(nonatomic, strong) UIView *disInterestV;
@property (nonatomic, assign) BOOL canDisInterest;//能长按出现不感兴趣
- (void)beginAnimation:(JHDiscoverChannelCateModel*)mode;
//+ (CGFloat)heightCellWithModel:(JHDiscoverChannelCateModel *)model;
//+ (CGFloat)picHeightCellWithModel:(JHDiscoverChannelCateModel *)model;
@end

NS_ASSUME_NONNULL_END

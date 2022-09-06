//
//  JHCustomerCommentCollectionViewCell.h
//  TTjianbao
//
//  Created by user on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHCusDescInProCommentImgStatus) {
    JHCusDescInProCommentImgStatus_Yellow = 0,           /// 黄色
    JHCusDescInProCommentImgStatus_GrayWithoutCenter,    /// 灰色空心
    JHCusDescInProCommentImgStatus_Gray                  /// 灰色实心
};

@interface JHCustomerCommentCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) dispatch_block_t supplementBtnActionBlock;

@property (nonatomic, copy) void(^commentClickBlock)(NSInteger index, NSArray *imgArr);

//@property (nonatomic, copy) void(^commentPictsAcitonBlock)(NSInteger index, NSArray *imgArr);

- (void)setViewModel:(id)viewModel;
- (void)reloadLineLayerFrame:(JHCusDescInProCommentImgStatus)status;
- (void)setSupplementBtnShow:(BOOL)isShow;
@end

NS_ASSUME_NONNULL_END

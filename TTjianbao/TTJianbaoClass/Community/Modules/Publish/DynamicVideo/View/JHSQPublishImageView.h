//
//  JHSQPublishImageView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSQPublishImageView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,   copy) dispatch_block_t addAlbumBlock;

@property (nonatomic,   copy) void (^deleteActionBlock)(NSInteger index);

@property (nonatomic, assign) BOOL customizeNeedThis; /// 定制二期代表作编辑等加图需要此处

@property (nonatomic, assign) CGFloat ViewHeight;

+ (CGSize)viewSize;
- (void)hiddenAddImageBtn:(int)maxImage;
@end

NS_ASSUME_NONNULL_END

//
//  JHImageViewCollectionCell.h
//  TTjianbao
//
//  Created by lihui on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHImageViewCollectionCellType) {
    JHImageViewCollectionCellTypeUpload = 0,
    JHImageViewCollectionCellTypeImage,
};

@interface JHImageViewCollectionCell : UICollectionViewCell

@property (nonatomic, assign) JHImageViewCollectionCellType cellType;
@property (nonatomic, strong) id uploadImage;
///删除图片的事件回调
@property (nonatomic, copy) void (^deleteBlock)(id img);
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong, readonly) UIImageView *imgView;

@property (nonatomic, assign) BOOL hiddenDeleteBUtton;

@end

NS_ASSUME_NONNULL_END

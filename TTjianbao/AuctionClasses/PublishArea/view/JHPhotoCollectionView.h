//
//  JHPhotoCollectionView.h
//  TTjianbao
//
//  Created by mac on 2019/6/3.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPhotoItemModel:NSObject

@property (nonatomic, strong) id image;
@property (nonatomic, assign) BOOL isVideo;//default is NO
@property (nonatomic, strong) PHAsset *asset;

@end


@interface JHPhotoCollectionView : UICollectionView

@property (nonatomic, strong)NSMutableArray <JHPhotoItemModel*>*array;
@property (nonatomic, copy) JHActionBlock addPicAction;
@property (nonatomic, copy) JHActionBlock didSelectedCell;
@property (nonatomic, assign) BOOL isShowAddCell;//default is YES;
/// 是否可以托东方排序
@property (nonatomic, assign) BOOL forbidLongPress;
@property (nonatomic, copy)NSString *addImage;


@end

NS_ASSUME_NONNULL_END

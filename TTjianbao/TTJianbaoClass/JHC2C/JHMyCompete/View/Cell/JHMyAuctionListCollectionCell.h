//
//  JHMyAuctionListCollectionCell.h
//  TTjianbao
//
//  Created by zk on 2021/9/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMyAuctionListItemModel.h"

NS_ASSUME_NONNULL_BEGIN
//@class JHNewStoreHomeGoodsProductListModel;

@class JHC2CProductBeanListModel;

typedef void(^ButtonMyActionBlock)(JHMyAuctionListItemModel *model, BOOL isPay);

@interface JHMyAuctionListCollectionCell : UICollectionViewCell
@property (nonatomic, strong) JHMyAuctionListItemModel *curData;
@property (nonatomic,   copy) void(^goToBoutiqueDetailClickBlock)(BOOL isH5,NSString *showId, NSString *boutiqueName);
@property (nonatomic, strong) UIImageView *imgView;  //背景图片,用来接收视频层,暴露出来

@property (nonatomic, copy) ButtonMyActionBlock buttonActionBlock;

@property (nonatomic,   copy) void(^deleteOutCellBlock)(BOOL isDelete);

@end

NS_ASSUME_NONNULL_END

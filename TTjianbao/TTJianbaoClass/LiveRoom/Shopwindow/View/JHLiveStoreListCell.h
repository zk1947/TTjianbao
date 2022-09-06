//
//  JHLiveStoreListCell.h
//  TTjianbao
//
//  Created by YJ on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHShopwindowGoodsListModel;
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,JHLiveStoreListCellType){
    JHLiveStoreListCellTypeUserList,            //用户列表cell
    JHLiveStoreListCellTypeSalerList_UP,        //在售列表cell
    JHLiveStoreListCellTypeSalerList_Histroy    //历史列表cell
};


@interface JHLiveStoreListCell : UITableViewCell

// 1-咨询主播  2-去支付  3-购买   4-编辑   5-下架    6-删除    7-上架   8-上架列表删除
@property (nonatomic, copy) void (^clickButtonTypeBlock) (NSInteger type);

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellType:(JHLiveStoreListCellType)type ;

- (void)setCellDataModel:(JHShopwindowGoodsListModel *)goodsModel andIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END

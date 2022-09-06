//
//  JHBaseListView.h
//  TTjianbao
//  列表基类
//  更新于 2020/12/31.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JHBaseTableViewCellProtocol <NSObject>

+ (instancetype)dequeueReusableCellWithTableView:(UITableView *)tabelView;

+ (instancetype)dequeueReusableCellWithTableView:(UITableView *)tabelView textLabelFont:(UIFont *)textLabelFont;

+ (NSString *)cellIdentifier;

///  添加布局UI
- (void)addSelfSubViews;

@optional

/// 固定行高 （不要在delegate中返回行高，直接设置tableView的rowHeight）
+ (CGFloat)cellHeight;

+ (CGFloat)cellWidth;

+ (CGSize)cellSize;

/// 大约行高 （当行高不固定时，最好实现该方法）
+ (CGFloat)cellEstimatedHeight;

@end

/// TableViewCell 基类
@interface JHWBaseTableViewCell : UITableViewCell<JHBaseTableViewCellProtocol>

@end


@protocol JHBaseCollectionViewCellProtocol <NSObject>
+ (instancetype)dequeueReusableCellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

/// 复用标识符
+ (NSString *)cellIdentifier;

/// 添加布局UI
- (void)addSelfSubViews;

@optional

+ (CGFloat)itemHeight;

+ (CGFloat)itemWidth;

+ (CGSize)itemSize;

@end

@interface JHBaseCollectionViewCell : UICollectionViewCell<JHBaseCollectionViewCellProtocol>

@end

@protocol JHBaseTableViewHeaderFooterViewProtocol <NSObject>
+ (instancetype)dequeueReusableHeaderFooterViewWithTableView:(UITableView *)tabelView;

/// 复用标识符
+ (NSString *)reuseIdentifier;

- (void)addSelfSubViews;

@optional

+ (CGFloat)viewHeight;

@end


@interface JHBaseTableViewHeaderFooterView : UITableViewHeaderFooterView<JHBaseTableViewHeaderFooterViewProtocol>

@end

@protocol JHBaseCollectionReusableViewProtocol <NSObject>

/// kind
/// UICollectionElementKindSectionHeader
/// UICollectionElementKindSectionFooter

+ (instancetype)dequeueReusableViewWithKind:(NSString *)kind
                             collectionView:(UICollectionView *)collectionView
                                  indexPath:(NSIndexPath *)indexPath;

+ (NSString *)reuseIdentifier;

- (void)addSelfSubViews;

@optional

+ (CGFloat)viewHeight;

+ (CGFloat)viewWidth;

+ (CGSize)viewSize;

@end

@interface JHBaseCollectionReusableView : UICollectionReusableView<JHBaseCollectionReusableViewProtocol>



@end


NS_ASSUME_NONNULL_END

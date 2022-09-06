//
//  JHPublishChannelTableViewCell.h
//  TTjianbao
//
//  Created by apple on 2019/7/7.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPublishChannelTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;

@end


@interface JHPublishSubCateCollectionCell : UICollectionViewCell

- (void)setImageUrl:(NSString *)imgUrl title:(NSString *)title;

@end

@interface JHPublishCollectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) NSString *title;

@end

NS_ASSUME_NONNULL_END

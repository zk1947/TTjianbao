//
//  JHMarketCommunityCollectionViewCell.h
//  TTjianbao
//
//  Created by zk on 2021/6/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMarketHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketCommunityCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSArray *hotListArray;

@end

@interface JHMarketCommunityNewsCell : UIControl

@property (nonatomic, strong) UIImageView *newsImageView;

@property (nonatomic,   copy) NSString   *imageUrl;

@property (nonatomic, strong) UILabel    *contentLable;

@property (nonatomic,   copy) NSString   *contentString;

@end

NS_ASSUME_NONNULL_END

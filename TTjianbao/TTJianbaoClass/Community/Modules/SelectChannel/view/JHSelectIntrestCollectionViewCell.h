//
//  JHSelectIntrestCollectionViewCell.h
//  TTjianbao
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHDiscoverChannelModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHSelectIntrestCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *intrestImage;
- (void)setModel:(JHDiscoverChannelModel *)intrestMode;
- (void)beginAnimation_Logo;
@end

NS_ASSUME_NONNULL_END

//
//  JHGuideTableViewCell.h
//  TTjianbao
//
//  Created by lihui on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class JHGuideModel;

typedef void(^JHGuideBlock)(JHGuideModel * _Nullable guideModel);

@interface JHGuideTableViewCell : UITableViewCell

@property (nonatomic, strong) JHGuideModel *guideModel;
@property (nonatomic, copy) JHGuideBlock guideBlock;


@end

NS_ASSUME_NONNULL_END

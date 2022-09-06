//
//  JHSearchTagsCollectionCell.h
//  TTjianbao
//
//  Created by hao on 2021/10/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSearchTagsCollectionCell : UICollectionViewCell
//删除
@property (nonatomic,   copy) JHFinishBlock clickDeleteBtnBlock;

//数据绑定
- (void)bindViewModel:(id)dataModel params:(NSDictionary* _Nullable )parmas;
@end

NS_ASSUME_NONNULL_END

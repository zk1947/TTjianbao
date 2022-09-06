//
//  JHGoodManagerListInfoAlertView.h
//  TTjianbao
//
//  Created by user on 2021/8/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHGoodManagerListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodManagerListInfoAlertView : UIView
@property(strong,nonatomic)JHFinishBlock cancleHandle;
@property(strong,nonatomic)JHFinishBlock handle;
@property(strong,nonatomic)JHFinishBlock closeBlock;
- (instancetype)initWithTitle:(NSString *)title
               cancleBtnTitle:(NSString *)cancleTitle
                 sureBtnTitle:(NSString *)completeTitle
                    itemModel:(JHGoodManagerListModel *)itemModel;
@end

NS_ASSUME_NONNULL_END

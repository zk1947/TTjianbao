//
//  JHCustomizeOrderIndicateView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/11/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeOrderIndicateView : JHOrderSubBaseView
@property (nonatomic, copy) JHFinishBlock pressActionBlock;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END

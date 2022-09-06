//
//  JHRecycleProductIllustrationView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 回收上传商品填写信息view____宝贝描述View   内函Textview
@interface JHRecycleProductIllustrationView : UIView
@property(nonatomic, strong) UITextView * textView;
@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UILabel * placeholderLbl;
@end

NS_ASSUME_NONNULL_END

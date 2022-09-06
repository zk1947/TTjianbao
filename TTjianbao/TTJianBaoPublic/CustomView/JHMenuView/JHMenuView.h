//
//  JHMenuView.h
//  TTjianbao
//
//  Created by YJ on 2021/1/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickItemBlock)(NSInteger index);

@interface JHMenuView : UIView

@property (copy, nonatomic) ClickItemBlock block;

+ (instancetype)menuViewAtPoint:(CGPoint)point;

- (void)show;

@end



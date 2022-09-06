//
//  JHC2CCollectionView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/8/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CCollectionView.h"
@interface JHC2CCollectionView()<UIGestureRecognizerDelegate>

@end

@implementation JHC2CCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
@end

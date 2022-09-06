//
//  JHMallHomeSeparateOperationView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/12/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallHomeSeparateOperationView.h"
#import "JHAnimatedImageView.h"

@interface JHMallHomeSeparateOperationView ()

/// 运营位背景图
@property (nonatomic, weak) JHAnimatedImageView *imageView;

@end


@implementation JHMallHomeSeparateOperationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.separateCount = 1;
        _imageView = [JHAnimatedImageView jh_imageViewAddToSuperview:self];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)]];
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.imageView jh_setImageWithUrl:_imageUrl];
}

/// 图片等分点击
- (void)clickImageView:(UITapGestureRecognizer *)sender {
    if(self.separateCount <= 0) {
        return;
    }
    CGPoint loc = [sender locationInView:self.imageView];
    CGSize size = [JHMallHomeSeparateOperationView viewSize];
    
    NSArray *sepaArray;
    if (!isEmpty(self.moreHotImgProportion)) {
        sepaArray = [self.moreHotImgProportion componentsSeparatedByString:@":"];
    } else {
        CGFloat w = size.width / self.separateCount;
        CGFloat x = loc.x;
        NSInteger index = x / w;
        if(_selectedIndex) {
            _selectedIndex(index);
        }
        return;
    }
    if (sepaArray.count >0) {
        NSMutableArray *sunArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < sepaArray.count; i++) {
            NSInteger fenzi = [sepaArray[i] integerValue];
            NSNumber *sumFenMu = [sepaArray valueForKeyPath:@"@sum.integerValue"];
            CGFloat fenmu = [sumFenMu floatValue];
            CGFloat proportion = [[NSString stringWithFormat:@"%.2f",fenzi / fenmu] floatValue];
            if (proportion >= 1) {
                CGFloat w = size.width / self.separateCount;
                CGFloat x = loc.x;
                NSInteger index = x / w;
                if(_selectedIndex) {
                    _selectedIndex(index);
                }
                return;
            }
            CGFloat w = size.width * proportion;
            CGFloat x = loc.x;
            NSNumber *sum = [sunArray valueForKeyPath:@"@sum.floatValue"];
            CGFloat currentW = [sum floatValue] + w;
            if (x <= currentW && _selectedIndex) {
                _selectedIndex(i);
                return;
            } else {
                [sunArray addObject:@(w)];
            }
        }
    } else {
        CGFloat w = size.width / self.separateCount;
        CGFloat x = loc.x;
        NSInteger index = x / w;
        if(_selectedIndex) {
            _selectedIndex(index);
        }
        return;
    }
}

/// 宽高比 60.f/351.f
+ (CGSize)viewSize {
    return CGSizeMake(ScreenW - 24.f, (ScreenW - 24.f) * (60.f / 355.f));
}

//#if DEBUG
//- (void)setMoreHotImgProportion:(NSString *)moreHotImgProportion {
//    _moreHotImgProportion = moreHotImgProportion;
//    if (isEmpty(self.moreHotImgProportion)) {
//        return;
//    }
//    NSArray *sepaArray = [moreHotImgProportion componentsSeparatedByString:@":"];
//    CGSize size = [JHMallHomeSeparateOperationView viewSize];
//    NSMutableArray *aaa = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 0; i<sepaArray.count; i++) {
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [self arndomColor];
//        view.userInteractionEnabled = YES;
//        [self addSubview:view];
//
//        NSNumber *sumFenMu = [sepaArray valueForKeyPath:@"@sum.integerValue"];
//        CGFloat fenmu = [sumFenMu floatValue];
//        CGFloat wwww = [sepaArray[i] floatValue]/fenmu *size.width;
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(self);
//            if (i == 0) {
//                make.left.equalTo(self.mas_left).offset(0);
//            } else {
//                NSNumber *sum = [aaa valueForKeyPath:@"@sum.floatValue"];
//                CGFloat vvvvv = [sum floatValue];
//                make.left.equalTo(self.mas_left).offset(vvvvv);
//            }
//            make.width.mas_equalTo(wwww);
//        }];
//        [aaa addObject:@(wwww)];
//        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)]];
//    }
//}
//
//- (UIColor *)arndomColor {
//    CGFloat red = arc4random_uniform(256)/ 255.0;
//    CGFloat green = arc4random_uniform(256)/ 255.0;
//    CGFloat blue = arc4random_uniform(256)/ 255.0;
//    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:0.7f];
//    return color;
//}
//
//#endif

@end

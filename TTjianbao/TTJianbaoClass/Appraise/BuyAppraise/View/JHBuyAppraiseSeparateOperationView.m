//
//  JHBuyAppraiseSeparateOperationView.m
//  TTjianbao
//
//  Created by wangjianios on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBuyAppraiseSeparateOperationView.h"
#import "JHAnimatedImageView.h"
#import "JHMallModel.h"
#import "BannerMode.h"
#import "CommHelp.h"
#import "UserInfoRequestManager.h"
@interface JHBuyAppraiseSeparateOperationView ()
/// 运营位背景图
@property (nonatomic, weak) JHAnimatedImageView *imageView;

@property (nonatomic, strong) JHMallOperateModel *model;

/// 比例划分
@property (nonatomic, copy) NSString *moreHotImgProportion;
@end

@implementation JHBuyAppraiseSeparateOperationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        _imageView = [JHAnimatedImageView jh_imageViewAddToSuperview:self];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(2, 12, 12, 12));
        }];

        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)]];
    }
    return self;
}

- (void)updateMethod {
    if(self.model) {
        [self.imageView jh_setImageWithUrl:self.model.moreHotImgUrl];
        self.moreHotImgProportion = self.model.moreHotImgProportion;
        if(self.model.width > 0 && self.model.height > 0) {
            CGFloat height = (ScreenW - 24) * (self.model.height / ((CGFloat)self.model.width));
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(14 + height);
            }];
        }
        if(self.hiddenBlock) {
            self.hiddenBlock(NO);
        }
    }
    else {
        if(self.hiddenBlock) {
            self.hiddenBlock(YES);
        }
        
    }
}

/// 图片等分点击
- (void)clickImageView:(UITapGestureRecognizer *)sender {
    if (IS_ARRAY(self.model.definiDetails) && self.model.definiDetails.count > 0) {
        NSInteger count = self.model.definiDetails.count;
        CGPoint loc = [sender locationInView:self.imageView];
        CGSize size = [JHBuyAppraiseSeparateOperationView viewSize];
        
        NSArray *sepaArray;
        if (!isEmpty(self.model.moreHotImgProportion)) {
            sepaArray = [self.model.moreHotImgProportion componentsSeparatedByString:@":"];
        } else {
            CGFloat w = size.width / count;
            CGFloat x = loc.x;
            NSInteger index = x / w;
            [self clickMethodWithIndex:index];
            [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_shopping_live_mall" params:@{@"index":@(index)} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];
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
                    CGFloat w = size.width / count;
                    CGFloat x = loc.x;
                    NSInteger index = x / w;
                    [self clickMethodWithIndex:index];
                    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_shopping_live_mall" params:@{@"index":@(index)} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];
                    return;
                }
                CGFloat w = size.width * proportion;
                CGFloat x = loc.x;
                NSNumber *sum = [sunArray valueForKeyPath:@"@sum.floatValue"];
                CGFloat currentW = [sum floatValue] + w;
                if (x <= currentW) {
                    [self clickMethodWithIndex:i];
                    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_shopping_live_mall" params:@{@"index":@(i)} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];
                    return;
                } else {
                    [sunArray addObject:@(w)];
                }
            }
        } else {
            CGFloat w = size.width / count;
            CGFloat x = loc.x;
            NSInteger index = x / w;
            [self clickMethodWithIndex:index];
            [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_shopping_live_mall" params:@{@"index":@(index)} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];
            return;
        }
    }
}

//#if DEBUG
//- (void)setMoreHotImgProportion:(NSString *)moreHotImgProportion {
//    _moreHotImgProportion = moreHotImgProportion;
//    if (isEmpty(self.moreHotImgProportion)) {
//        return;
//    }
//    NSArray *sepaArray = [moreHotImgProportion componentsSeparatedByString:@":"];
//    CGSize size = [JHBuyAppraiseSeparateOperationView viewSize];
//    NSMutableArray *aaa = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 0; i<sepaArray.count; i++) {
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [self arndomColor];
//        view.userInteractionEnabled = YES;
//        [self.imageView addSubview:view];
//
//        NSNumber *sumFenMu = [sepaArray valueForKeyPath:@"@sum.integerValue"];
//        CGFloat fenmu = [sumFenMu floatValue];
//        CGFloat wwww = [sepaArray[i] floatValue]/fenmu *size.width;
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(self.imageView);
//            if (i == 0) {
//                make.left.equalTo(self.imageView.mas_left).offset(0);
//            } else {
//                NSNumber *sum = [aaa valueForKeyPath:@"@sum.floatValue"];
//                CGFloat vvvvv = [sum floatValue];
//                make.left.equalTo(self.imageView.mas_left).offset(vvvvv);
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



- (void)clickMethodWithIndex:(NSInteger)index {
    JHMallOperateImgModel *model = self.model.definiDetails[index];
    if (model.target) {
        [JHRootController toNativeVC:model.target.vc withParam:model.target.params from:JHFromHomeSourceBuy];
    }
}
- (void)refreshData {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/anon/operation/shopAppraise-list-defini") Parameters:@{} successBlock:^(RequestModel * _Nullable respondObject) {
        self.model = [JHMallOperateModel mj_objectWithKeyValues:respondObject.data];
        [self updateMethod];
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self updateMethod];
    }];
}

/// 宽高比 70.f/351.f
+ (CGSize)viewSize {
    return CGSizeMake(ScreenW - 24.f, (ScreenW - 24.f) * (70.f / 355.f));
}

/// 宽高比 70.f/351.f
+ (CGFloat)viewHeight {
    return (ScreenW - 24.f) * (70.f / 355.f) + 12.f + 2.f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

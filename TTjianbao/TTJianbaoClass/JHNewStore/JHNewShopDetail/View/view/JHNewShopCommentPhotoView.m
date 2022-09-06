//
//  JHNewShopCommentPhotoView.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopCommentPhotoView.h"

#import "YYControl.h"
#import "UITapImageView.h"
#import "YDCategoryKit/YDCategoryKit.h"
#import "UIView+JHGradient.h"

#define kPaddingLeft    (0.0)  //左右边距
#define kPhotoVerSpace  (0)     //图片纵向间距
#define kPhotoHorSpace  (8.0)   //图片横向间距

@interface JHNewShopCommentPhotoView ()
@property (nonatomic, strong) NSMutableArray *photoViews;
@property (nonatomic, strong) UILabel *imgCountLabel; //大于4张时显示图片总数
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) CGFloat viewHeight;
@end

@implementation JHNewShopCommentPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _viewHeight = frame.size.height;
        _photoViews = [NSMutableArray new];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    CGFloat imgWH = _viewHeight;
    NSMutableArray *views = [NSMutableArray new];
    @weakify(self);
    for (NSInteger i = 0; i < 4; i++) {
        UITapImageView *imageView = [UITapImageView new];
        imageView.size = CGSizeMake(imgWH, imgWH);
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 4;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.exclusiveTouch = YES;
        imageView.hidden = YES;
        imageView.backgroundColor = UIColor.yellowColor;
        [imageView addTapBlock:^(id  _Nonnull obj) {
            @strongify(self);
            [self didClickedImageAtIndex:i];
        }];
        [views addObject:imageView];
        [self addSubview:imageView];
        
        if (i == 3) {
            self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, imgWH - 25, imgWH, 25)];
            [self.backView jh_setGradientBackgroundWithColors:@[HEXCOLORA(0x000000, 0), HEXCOLORA(0x000000, 0.5)] locations:nil startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1)];
            [imageView addSubview:self.backView];
            self.imgCountLabel.frame = CGRectMake(5, 0, imgWH - 10, 25);
            [self.backView addSubview:self.imgCountLabel];
        }
    }
    
    _photoViews = [views mutableCopy];
}

- (UILabel *)imgCountLabel {
    if (!_imgCountLabel) {
        _imgCountLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12] textColor:[UIColor whiteColor]];
        _imgCountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _imgCountLabel;
}

- (void)didClickedImageAtIndex:(NSInteger)index {
    if (self.clickPhotoBlock) {
        self.clickPhotoBlock(_photoViews, index);
    }
}

- (void)setImages:(NSArray *)images {
    _images = images;
    
    for (NSInteger i = images.count; i < _photoViews.count; i++) {
        UITapImageView *imageView = [_photoViews objectAtIndex:i];
        [imageView.layer cancelCurrentImageRequest];
        imageView.hidden = YES;
    }
    
    if (images.count == 0) {
        self.height = 0;
        return;
    }
    
    NSInteger perLineCount = [self _perLineItemCount:images]; //每行显示几张图
    CGFloat imgWH = _viewHeight;
    
    [images enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger columnIndex = idx % perLineCount;
        NSInteger rowIndex = idx / perLineCount;
        UITapImageView *imageView = [_photoViews objectAtIndex:idx];
        imageView.hidden = NO;
        [imageView.layer removeAnimationForKey:@"contents"];
        
        imageView.top = kPhotoVerSpace + (rowIndex * (imgWH + kPhotoVerSpace));
        imageView.left = kPaddingLeft + columnIndex * (imgWH + kPhotoHorSpace);
        imageView.size = CGSizeMake(imgWH, imgWH);

        [imageView jh_setImageWithUrl:obj placeHolder:@"newStore_hoder_image"];
        
        if (idx == _photoViews.count - 1) {
            *stop = YES;
        }
    }];
    
    _imgCountLabel.text = [NSString stringWithFormat:@"共%ld张", (long)images.count];
    _imgCountLabel.hidden = !(images.count > _photoViews.count);
    _backView.hidden = !(images.count > _photoViews.count);
}

//返回每行显示几张
- (NSInteger)_perLineItemCount:(NSArray *)array {
    return (array.count > 4 ? 4 : array.count);
}

@end

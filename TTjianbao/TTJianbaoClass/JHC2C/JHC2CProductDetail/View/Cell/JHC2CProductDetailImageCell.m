//
//  JHC2CProductDetailImageCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailImageCell.h"
#import "JHPostDetailEventManager.h"
#import "JHC2CProoductDetailModel.h"

@interface JHC2CProductDetailImageCell()

@property(nonatomic, strong) NSMutableArray<UIImageView*> * imageViewsArr;

/// 图片类型展示
@property(nonatomic, strong) NSMutableArray<UIImageView*> * onlyImageViewsArr;

@property(nonatomic, strong) NSMutableArray<NSString*> * imagesUrlsArr;

@property(nonatomic, strong) NSMutableArray<NSString*> * imagesOrignUrlsArr;

@property(nonatomic, assign) BOOL  hasSet;

@end

@implementation JHC2CProductDetailImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.whiteColor;
        
    }
    return self;
}

- (void)setModel:(JHC2CProoductDetailModel *)model{
    if (self.hasSet) {
        return;
    }
    _model = model;
    self.hasSet = YES;
    [self refreshItems];
    

}

    
- (void)refreshItems{
    [self.contentView removeAllSubviews];
    NSInteger count = self.model.allImages.count;
    if (!count) {return;}
    self.imageViewsArr = [NSMutableArray arrayWithCapacity:count];
    self.onlyImageViewsArr = [NSMutableArray arrayWithCapacity:0];

    
    UIView *lastView = nil;
    
    //大图部分
    for (int i = 0; i< MIN(count, 3); i++) {
        JHC2CProoductDetailImageModel *imageModel = self.model.allImages[i];
        UIImageView *imageView = [UIImageView new];
        
        if (imageModel.type) {
            [imageView jh_setImageWithUrl:imageModel.detailVideoCoverUrl];
            UIImageView *playImage = [self playImageView];
            [imageView addSubview:playImage];
            [playImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(@0);
            }];
        }else{
            [imageView jh_setImageWithUrl:imageModel.middleUrl];
            [self.imagesUrlsArr addObject:imageModel.middleUrl];
            [self.imagesOrignUrlsArr addObject:imageModel.url];
            [self.onlyImageViewsArr addObject:imageView];
        }
        [self.imageViewsArr addObject:imageView];

        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
        [imageView addGestureRecognizer:tap];
        [self.contentView addSubview:imageView];
        CGFloat scaleHeight = (kScreenWidth - 24.f);
        if (imageModel.width.length && imageModel.height.length) {
            scaleHeight =  (kScreenWidth - 24.f) * imageModel.height.floatValue / imageModel.width.floatValue;
        }
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(2);
            }else{
                make.top.equalTo(@0).offset(2);
            }
            make.left.right.equalTo(@0).inset(12);
            make.height.mas_equalTo(scaleHeight);
            if (i + 1 == count) {
                make.bottom.equalTo(@0).offset(-2);
            }
        }];
        lastView = imageView;
    }
    
    //小图区域
    if (count > 3) {
        CGFloat smallWide = (kScreenWidth - 12 * 2 - 4)/3;
        for (int i = 0; i < count - 3; i++) {
            UIImageView *imageView = [UIImageView new];
            JHC2CProoductDetailImageModel *imageModel = self.model.allImages[i+3];
            if (imageModel.type) {
                [imageView jh_setImageWithUrl:imageModel.detailVideoCoverUrl];
                UIImageView *playImage = [self playImageView];
                [imageView addSubview:playImage];
                [playImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(@0);
                }];
            }else{
                [imageView jh_setImageWithUrl:imageModel.middleUrl];
                [self.imagesUrlsArr addObject:imageModel.middleUrl];
                [self.imagesOrignUrlsArr addObject:imageModel.url];
                [self.onlyImageViewsArr addObject:imageView];

            }
            [self.imageViewsArr addObject:imageView];

            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = YES;
            imageView.clipsToBounds = YES;
            imageView.tag = i+3;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
            [imageView addGestureRecognizer:tap];
            [self.contentView addSubview:imageView];
            BOOL needChangeLine = i%3 == 0;
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (needChangeLine) {
                    make.top.equalTo(lastView.mas_bottom).offset(2);
                    make.left.equalTo(@0).inset(12);
                }else{
                    make.top.equalTo(lastView);
                    make.left.equalTo(lastView.mas_right).offset(2);
                }
                make.size.mas_equalTo(CGSizeMake(smallWide, smallWide));
                if (i + 4 == count) {
                    make.bottom.equalTo(@0).offset(-2);
                }
            }];
            lastView = imageView;
        }
    }
    

}

- (void)tapGes:(UIGestureRecognizer*)gesture{
    NSInteger index = gesture.view.tag;
    UIImageView *tarView = (UIImageView *)gesture.view;
    JHC2CProoductDetailImageModel *imageModel = self.model.allImages[index];
    if(!imageModel.type){
        [JHPostDetailEventManager browseBigImage:self.onlyImageViewsArr
                                     thumbImages:self.imagesUrlsArr
                                    mediumImages:self.imagesUrlsArr
                                    originImages:self.imagesOrignUrlsArr selectIndex:[self.onlyImageViewsArr indexOfObject:tarView]];
    }else if (imageModel.type && index < 3) {
        self.videoUrl = imageModel.url;
        self.videoView = self.imageViewsArr[index];
        if(self.playVideo){
            self.playVideo(self);
        }
    }else if (imageModel.type && index >= 3) {
        self.videoUrl = imageModel.url;
        self.videoView = self.imageViewsArr[index];
        if(self.playVideoOut){
            self.playVideoOut(self);
        }
    }
}

- (NSMutableArray<NSString *> *)imagesUrlsArr{
    if (!_imagesUrlsArr) {
        _imagesUrlsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _imagesUrlsArr;
}
- (NSMutableArray<NSString *> *)imagesOrignUrlsArr{
    if (!_imagesOrignUrlsArr) {
        _imagesOrignUrlsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _imagesOrignUrlsArr;
}


- (UIImageView *)playImageView{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sq_video_icon_play"]];
    return imageView;
}

@end

//
//  JHGoodsDetailImgCell.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsDetailImgCell.h"
#import "XHWebImageAutoSize.h"


@interface JHGoodsDetailImgCell ()

@property (nonatomic,   copy) NSString *oriImgUrl; //原图url

@end

@implementation JHGoodsDetailImgCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
//        [self setSelectionStyleEnabled:NO];
        if (!_imgView) {
            _imgView = [UITapImageView new];
            _imgView.contentMode = UIViewContentModeScaleAspectFill;
            _imgView.clipsToBounds = YES;
            
            @weakify(self);
            [_imgView addTapBlock:^(UITapImageView *_Nonnull obj) {
                @strongify(self);
                if (self.oriImgUrl && self.didClickImgBlock) {
                    self.didClickImgBlock(self.imgInfo);
                }
            }];
            [self.contentView addSubview:_imgView];
        }
        
        _imgView.sd_layout
        .topEqualToView(self.contentView)
        .leftEqualToView(self.contentView)
        .widthIs(ScreenWidth)
        .bottomEqualToView(self.contentView);
        
        [self.contentView setupAutoHeightWithBottomView:_imgView bottomMargin:0];
    }
    return self;
}

- (void)setImgInfo:(CGoodsImgInfo *)imgInfo {
    _imgInfo = imgInfo;
    
    _oriImgUrl = [imgInfo.orig_image isNotBlank] ? imgInfo.orig_image : imgInfo.url;
    NSString *urlStr = [imgInfo.url isNotBlank] ? imgInfo.url : imgInfo.orig_image;
        
    [_imgView jhSetImageWithURL:[NSURL URLWithString:urlStr]
                              placeholder:kDefaultCoverImage];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_imgView updateLayout];
    [self updateLayout];
}

@end

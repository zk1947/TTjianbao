//
//  TTjianbao
//
//  Created by wangjianios on 2020/6/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//


#import "SDVideoCropFrameCell.h"

@interface SDVideoCropFrameCell ()

@property(nonatomic,strong)UIImageView *bgImageView;

@end

@implementation SDVideoCropFrameCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.bgImageView];
    }
    return self;
}

- (UIImageView *)bgImageView {
    
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

- (void)setFrameModel:(JHVideoCropFrameModel *)frameModel {
    
    _frameModel = frameModel;
    _bgImageView.frame = self.bounds;
    self.bgImageView.image = frameModel.frameImage;
}

@end

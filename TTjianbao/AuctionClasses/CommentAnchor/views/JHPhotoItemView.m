//
//  JHPhotoItemView.m
//  TTjianbao
//
//  Created by mac on 2019/5/15.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHPhotoItemView.h"
#import "TTjianbaoBussiness.h"
#import "UIImageView+JHWebImage.h"

@interface JHPhotoItemView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation JHPhotoItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.deleteBtn];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.equalTo(self);
            make.top.equalTo(self).offset(6);
            make.trailing.equalTo(self).offset(-6);
        }];
        
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.trailing.equalTo(self).offset(-3);
            make.height.width.equalTo(@(15));
        }];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover:)];
        _imageView.tag = self.tag;
        [_imageView addGestureRecognizer:tap];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        UIButton * cancleImage=[[UIButton alloc]init];
        [cancleImage  setBackgroundImage:[UIImage imageNamed:@"cover_cancle"] forState:UIControlStateNormal];
        cancleImage.contentMode = UIViewContentModeScaleAspectFit;
        cancleImage.userInteractionEnabled=YES;
        [cancleImage addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn = cancleImage;
        _deleteBtn.alpha = 0.6;

    }
    return _deleteBtn;
}

- (void)deleteAction:(UIButton *)btn {
    if (self.deleteAction) {
        self.deleteAction(btn);
    }
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)tapCover:(UIGestureRecognizer *)gestureRecognizer {
    if (self.clickImageAction) {
    
        self.clickImageAction(gestureRecognizer.view);
    }

}

- (void)showImageUrl:(NSString *)url {
    self.imageView.tag = self.tag;
    [self.imageView jhSetImageWithURL:[NSURL URLWithString:ThumbSmallByOrginal(url)] placeholder:kDefaultCoverImage];
    self.deleteBtn.hidden = YES;
}
@end

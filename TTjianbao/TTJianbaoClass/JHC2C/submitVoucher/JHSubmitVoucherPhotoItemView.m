//
//  JHSubmitVoucherPhotoItemView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/6/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSubmitVoucherPhotoItemView.h"
#import "UserInfoRequestManager.h"
#import "UIImageView+JHWebImage.h"

@interface JHSubmitVoucherPhotoItemView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (strong, nonatomic)  UIButton *addBtn;

@end

@implementation JHSubmitVoucherPhotoItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.deleteBtn];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
              make.leading.equalTo(self).offset(5);
              make.right.equalTo(self).offset(-5);
               make.top.equalTo(self).offset(5);
               make.bottom.equalTo(self).offset(-5);
        }];

        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.trailing.equalTo(self).offset(-3);
            make.height.width.equalTo(@(15));
        }];
        
         [self addSubview:self.addBtn];
         [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
            make.top.equalTo(self).offset(5);
            make.bottom.equalTo(self).offset(-5);
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
-(UIButton*)addBtn{
    if (!_addBtn) {
        _addBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn addTarget:self action:@selector(addPhotos) forControlEvents:UIControlEventTouchUpInside];
          _addBtn.userInteractionEnabled=YES;
      //  _addBtn.backgroundColor = [UIColor redColor];
        _addBtn.layer.cornerRadius = 4.f;
        _addBtn.layer.masksToBounds = YES;
        _addBtn.layer.borderWidth = 1.f;
        _addBtn.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
//        [_addBtn setBackgroundImage:[UIImage imageNamed:@"note_add_image"]  forState:UIControlStateNormal];
        
        UIImageView *addImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arbitrament_add"]];
        addImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_addBtn addSubview:addImageView];
      
        
        UILabel *label = [UILabel jh_labelWithFont:12.f textColor:kColor999 addToSuperView:_addBtn];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"(最多6张)";

        [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_addBtn).offset(20);
            make.centerX.equalTo(_addBtn);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(addImageView.mas_bottom).offset(5);
            make.centerX.equalTo(_addBtn);
        }];
        
    }
    return _addBtn;
}
- (void)deleteAction:(UIButton *)btn {
    if (self.deleteAction) {
        self.deleteAction(btn);
    }
}
- (void)addPhotos{
    
    if (self.addAction) {
        self.addAction(nil);
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

-(void)setShowAddBtn:(BOOL)showAddBtn{
    
//     _showAddBtn=showAddBtn;
//     if(_showAddBtn){
//
//            NSLog(@"fgfgfgfgfg");
//     }
//     else{
//
//         NSLog(@"qqwqwqwqwqwqw");
//
//
//     }
}
-(void)setPhotoMode:(OrderPhotoMode *)photoMode{
    
    _photoMode=photoMode;
    if (_photoMode.showAddButton) {
        self.addBtn.hidden =NO ;
        self.imageView.hidden = YES;
        self.deleteBtn.hidden = YES;
    }
    else{
        self.addBtn.hidden = YES;
        self.imageView.hidden = NO;
        self.deleteBtn.hidden = NO;
        self.imageView.tag = self.tag;
        [self.imageView jhSetImageWithURL:[NSURL URLWithString:ThumbSmallByOrginal(photoMode.url)] placeholder:kDefaultCoverImage];
    }
}

- (void)showImageUrl:(NSString *)url {
    
    self.imageView.tag = self.tag;
    [self.imageView jhSetImageWithURL:[NSURL URLWithString:ThumbSmallByOrginal(url)] placeholder:kDefaultCoverImage];
}
@end


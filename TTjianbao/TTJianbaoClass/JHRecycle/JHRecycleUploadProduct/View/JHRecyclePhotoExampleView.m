//
//  JHRecyclePhotoExampleView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/4/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePhotoExampleView.h"
#import <SDWebImage.h>

@interface JHRecyclePhotoExampleView()

@property(nonatomic, strong) UILabel * nameLbl;
@property(nonatomic, strong) UIImageView * leftLineView;
@property(nonatomic, strong) UIImageView * rightLineView;

@end

@implementation JHRecyclePhotoExampleView

- (instancetype)initWithTitle:(NSString*)title andImageArray:(NSArray<JHRecycleUploadExampleModel*>*)arr{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setItems];
        [self layoutItems];
        [self refreshWithTitle:title andImageArray:arr];
    }
    return self;
}

- (void)setItems{
    [self addSubview:self.nameLbl];
    [self addSubview:self.leftLineView];
    [self addSubview:self.rightLineView];
}


- (void)layoutItems{
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(30);
        make.centerX.equalTo(@0);
    }];
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nameLbl.mas_left).offset(-6);
        make.centerY.equalTo(self.nameLbl);
    }];
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl.mas_right).offset(6);
        make.centerY.equalTo(self.nameLbl);
    }];
}

- (void)refreshWithTitle:(NSString*)title andImageArray:(NSArray<JHRecycleUploadExampleModel*> *)arr{
    self.nameLbl.text = title;
    
    CGFloat space = (ScreenWidth - 2 * 130)/3; ///四张图间距
    UIView *lastView  = nil;
    for (int i = 0; i<arr.count; i++) {
        BOOL isNewLine = !(i%2); ///是否换行
        JHRecycleUploadExampleModel *model = arr[i];
        UIImageView *imageView = [UIImageView new];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.baseImage.small]];
        [self addSubview:imageView];
        UILabel *label = [UILabel new];
        label.text = model.exampleDesc;
        label.font = JHFont(12);
        label.textColor = HEXCOLOR(0xF2F2F2);
        [self addSubview:label];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(130, 130));
            if (isNewLine) {
                make.left.equalTo(@0).offset(space);
                if (lastView) {
                    make.top.equalTo(lastView.mas_bottom).offset(35);
                }else{
                    make.top.equalTo(self.nameLbl.mas_bottom).offset(20);
                }
            }else{
                make.left.equalTo(lastView.mas_right).offset(space);
                make.top.equalTo(lastView);
            }
            if (i+1 >= arr.count) {
                make.bottom.equalTo(@0).offset(-30);
            }
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView);
            make.top.equalTo(imageView.mas_bottom).offset(8);
            make.width.lessThanOrEqualTo(imageView);
        }];
        lastView = imageView;
    }
    
}

- (UILabel *)nameLbl{
    if (!_nameLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.text = @"";
        label.textColor = HEXCOLOR(0xF2F2F2);
        _nameLbl = label;
    }
    return _nameLbl;
}

- (UIImageView *)leftLineView{
    if (!_leftLineView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"recycle_photo_example_left"];
        _leftLineView = view;
    }
    return _leftLineView;
}

- (UIImageView *)rightLineView{
    if (!_rightLineView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"recycle_photo_example_right"];
        _rightLineView = view;
    }
    return _rightLineView;
}
@end

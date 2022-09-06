//
//  JHRecycleArbitrationPicturesView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleArbitrationPicturesView.h"
#import "JHRecyclePhotoSeletedView.h"

static NSInteger maxDetailPictureCount = 9;

@interface JHRecycleArbitrationPicturesView()

/// 描述label
@property(nonatomic, strong) UILabel * titleLbl;

/// ※号
@property(nonatomic, strong) UIImageView * starImageView;

/// 添加图片按钮
@property(nonatomic, strong) UIButton * addBtn;

/// 添加图片按钮上层View 隐藏控制button外观
@property(nonatomic, strong) UIView * addBtnMaskView;

/// 图片数组
@property(nonatomic, strong) NSMutableArray<JHRecyclePhotoSeletedView*> * imageViewArr;

@property(nonatomic, strong) NSOperationQueue * uploadQueue;

@end

//icon_cover_close
@implementation JHRecycleArbitrationPicturesView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLbl];
    [self addSubview:self.starImageView];
    [self addSubview:self.addBtn];
}

- (void)layoutItems{
    [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(14);
        make.left.equalTo(@0).offset(12);
    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.starImageView);
        make.left.equalTo(self.starImageView.mas_right).offset(2);
    }];
    [self addSubview:self.addBtn];
    self.addBtnMaskView.hidden = self.imageViewArr.count;
    BOOL needHideAddBtn = self.imageViewArr.count >= maxDetailPictureCount; ///是否显示添加按钮
    CGFloat space = (ScreenWidth - 24 - 3 * 110)/2; ///四张图间距
    UIView *lastView  = nil;
    for (int i = 0; i<self.imageViewArr.count; i++) {
        JHRecyclePhotoSeletedView *imageView = self.imageViewArr[i];
        BOOL isNewLine = !(i%3); ///是否换行
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (isNewLine) {
                make.left.equalTo(self.starImageView);
                make.top.equalTo((lastView ? lastView : self.titleLbl).mas_bottom).offset(10);
            }else{
                make.left.equalTo(lastView.mas_right).offset(space);
                make.top.equalTo(lastView);
            }
            make.size.mas_equalTo(CGSizeMake(110, 110));
            if (needHideAddBtn && i+1 >= self.imageViewArr.count) {
                make.bottom.equalTo(@0).offset(-12);
            }
        }];
        lastView = imageView;
    }
    
    if (!needHideAddBtn) {
        BOOL isNewLine = !(self.imageViewArr.count%3);///是否换行
        [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (isNewLine) {
                make.left.equalTo(self.starImageView);
                make.top.equalTo((lastView ? lastView : self.titleLbl).mas_bottom).offset(10);
            }else{
                make.left.equalTo(lastView.mas_right).offset(space);
                make.top.equalTo(lastView);
            }
            make.size.mas_equalTo(CGSizeMake(110, 110));
            make.bottom.equalTo(@0).offset(-12);
        }];
    }else{
        [self.addBtn removeFromSuperview];
    }

}

#pragma mark -- <actions >
- (void)removePictureView:(JHRecyclePhotoSeletedView*)photoView{
    [photoView removeFromSuperview];
    [self.imageViewArr removeObject:photoView];
    [self layoutItems];
}

- (void)addProductDetailPictureWithName:(JHRecyclePhotoInfoModel *)model{
    JHRecyclePhotoSeletedView *imageView = [[JHRecyclePhotoSeletedView alloc] init];
    imageView.uploadQueue = self.uploadQueue;
    imageView.model = model;
    imageView.type = JHRecyclePhotoSeletedViewType_Arbitration;
    @weakify(self);
    [imageView setDeleteBlock:^(JHRecyclePhotoSeletedView * _Nonnull photoView) {
        @strongify(self);
        [self removePictureView:photoView];
    }];
    [self.imageViewArr addObject:imageView];
    [self addSubview:imageView];
    [self layoutItems];
    [NSNotificationCenter.defaultCenter postNotificationName:JHNotificationRecycleUploadImageInfoChanged object:nil];
}

- (void)addPicture:(UIButton*)sender{
    if (self.imageViewArr.count >= maxDetailPictureCount) {
        return;
    }
    if (self.addProductDetailBlock) {
        self.addProductDetailBlock(maxDetailPictureCount - self.imageViewArr.count);
    }
}


#pragma mark -- <set and get>

- (NSMutableArray<JHRecyclePhotoSeletedView *> *)imageViewArr{
    if (!_imageViewArr) {
        _imageViewArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageViewArr;
}
- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"上传图片：";
        _titleLbl = label;
    }
    return _titleLbl;
}

- (NSMutableArray<JHRecyclePhotoInfoModel *> *)productDetailPictureArr{
    return [self.imageViewArr jh_map:^id _Nonnull(JHRecyclePhotoSeletedView * _Nonnull obj, NSUInteger idx) {
        return obj.model;
    }];
}

- (UIImageView *)starImageView{
    if (!_starImageView) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_star"]];
        _starImageView = view;
    }
    return _starImageView;
}
- (UIButton *)addBtn{
    if (!_addBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(addPicture:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"recycle_uploadproduct_addblcak"] forState:UIControlStateNormal];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        btn.layer.cornerRadius = 5;
        
        UIView *backView = [UIView new];
        backView.userInteractionEnabled = NO;
        backView.backgroundColor = UIColor.whiteColor;
        [btn addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        self.addBtnMaskView = backView;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"recycle_uploadproduct_addblcak"];
        UILabel *label = [[UILabel alloc] init];
        label.font = JHFont(12);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HEXCOLOR(0x999999);
        label.text = @"9张图片";
        [backView addSubview:label];
        [backView addSubview:imageView];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(10);
            make.centerX.equalTo(@0);
        }];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0).offset(32);
            make.centerX.equalTo(@0);
        }];

        
        _addBtn = btn;
    }
    return _addBtn;
}

- (NSOperationQueue *)uploadQueue{
    if (_uploadQueue == nil) {
        _uploadQueue = [[NSOperationQueue alloc] init];
        _uploadQueue.maxConcurrentOperationCount = 1;
    }
    return _uploadQueue;
}

@end


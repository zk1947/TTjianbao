//
//  JHRecycleProductDetailView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleProductDetailView.h"
#import "JHRecyclePhotoSeletedView.h"

@interface JHRecycleProductDetailView()



/// 添加图片按钮
@property(nonatomic, strong) UIButton * addBtn;

/// 图片数组
@property(nonatomic, strong) NSMutableArray<JHRecyclePhotoSeletedView*> * imageViewArr;

@property(nonatomic, assign) NSInteger  maxDetailPictureCount;

@end

//icon_cover_close
@implementation JHRecycleProductDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxDetailPictureCount = 20;
        [self setItems];
        [self layoutItems];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame maxCount:(NSInteger)maxCount{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxDetailPictureCount = maxCount;
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLbl];
    [self addSubview:self.descLabel];
    [self addSubview:self.addBtn];
}

- (void)layoutItems{
    [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0).offset(12);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLbl.mas_bottom).offset(2);
        make.left.equalTo(@0).offset(12);
    }];
    [self addSubview:self.addBtn];///每次刷新如果隐藏会移除
    BOOL needHideAddBtn = self.imageViewArr.count >= self.maxDetailPictureCount; ///是否显示添加按钮
    CGFloat space = (ScreenWidth - 24 - 4 * 80)/3; ///四张图间距
    UIView *lastView  = nil;
    for (int i = 0; i<self.imageViewArr.count; i++) {
        JHRecyclePhotoSeletedView *imageView = self.imageViewArr[i];
        BOOL isNewLine = !(i%4); ///是否换行
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (isNewLine) {
                make.left.equalTo(self.titleLbl);
                make.top.equalTo((lastView ? lastView : self.descLabel).mas_bottom).offset(14);
            }else{
                make.left.equalTo(lastView.mas_right).offset(space);
                make.top.equalTo(lastView);
            }
            make.size.mas_equalTo(CGSizeMake(80, 80));
            if (needHideAddBtn && i+1 >= self.imageViewArr.count) {
                make.bottom.equalTo(@0).offset(-12);
            }
        }];
        lastView = imageView;
    }
    
    if (!needHideAddBtn) {
        BOOL isNewLine = !(self.imageViewArr.count%4);///是否换行
        [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (isNewLine) {
                make.left.equalTo(self.titleLbl);
                make.top.equalTo((lastView ? lastView : self.descLabel).mas_bottom).offset(14);
            }else{
                make.left.equalTo(lastView.mas_right).offset(space);
                make.top.equalTo(lastView);
            }
            make.size.mas_equalTo(CGSizeMake(80, 80));
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
    dispatch_async(dispatch_get_main_queue(), ^{
        JHRecyclePhotoSeletedView *imageView = [[JHRecyclePhotoSeletedView alloc] init];
        imageView.uploadQueue = self.uploadQueue;
        imageView.model = model;
        @weakify(self);
        [imageView setDeleteBlock:^(JHRecyclePhotoSeletedView * _Nonnull photoView) {
            @strongify(self);
            [self removePictureView:photoView];
        }];
        [self addSubview:imageView];
        [self.imageViewArr addObject:imageView];
        [self layoutItems];
    });
}

- (void)addProductDetailPictureWithModelArr:(NSArray<JHRecyclePhotoInfoModel *> *)modelArr{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i< modelArr.count; i++) {
            JHRecyclePhotoInfoModel *model = modelArr[i];
            JHRecyclePhotoSeletedView *imageView = [[JHRecyclePhotoSeletedView alloc] init];
            imageView.model = model;
            @weakify(self);
            [imageView setDeleteBlock:^(JHRecyclePhotoSeletedView * _Nonnull photoView) {
                @strongify(self);
                [self removePictureView:photoView];
            }];
            [self addSubview:imageView];
            [self.imageViewArr addObject:imageView];
        }
        [self layoutItems];
    });
}

- (void)addPicture:(UIButton*)sender{
    if (self.imageViewArr.count >= self.maxDetailPictureCount) {
        return;
    }
    if (self.addProductDetailBlock) {
        self.addProductDetailBlock(self.maxDetailPictureCount - self.imageViewArr.count);
    }
}


#pragma mark -- <set and get>
- (NSMutableArray<JHRecyclePhotoInfoModel *> *)productDetailPictureArr{
    return [self.imageViewArr jh_map:^id _Nonnull(JHRecyclePhotoSeletedView * _Nonnull obj, NSUInteger idx) {
        return obj.model;
    }];
}

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
        label.text = @"其他细节";
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(addPicture:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = HEXCOLOR(0xF9F9F9);
        btn.layer.cornerRadius = 5;
                
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"recycle_uploadproduct_addblcak"];
        UILabel *label = [[UILabel alloc] init];
        label.font = JHFont(12);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HEXCOLOR(0x999999);
        label.text = @"图片/视频";
        [btn addSubview:label];
        [btn addSubview:imageView];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(3);
            make.centerX.equalTo(@0);
        }];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0).offset(16);
            make.centerX.equalTo(@0);
        }];
        _addBtn = btn;
    }
    return _addBtn;
}
- (UILabel *)descLabel{
    if (!_descLabel) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.textColor = HEXCOLOR(0x999999);
        label.text = @"宝贝描述~~~";
        _descLabel = label;
    }
    return _descLabel;
}
@end

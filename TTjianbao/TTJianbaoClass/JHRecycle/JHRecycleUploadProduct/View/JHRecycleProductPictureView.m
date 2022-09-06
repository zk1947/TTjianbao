//
//  JHRecycleProductPictureView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleProductPictureView.h"
#import "JHRecyclePhotoSeletedView.h"
#import <SDWebImage.h>
#import "JHPhotoExampleViewController.h"

@interface JHRecycleProductPictureView()
@property(nonatomic, strong) UIButton *shootSampleBtn;
@property(nonatomic, strong) NSMutableArray<UIButton*> * btnArr;
@property(nonatomic, strong) NSMutableArray<UILabel*> * btnbottomLblArr;
@property(nonatomic, strong) NSMutableArray<JHRecyclePhotoSeletedView*> *seletedViewArr;

@property(nonatomic, strong) NSArray<JHRecycleUploadExampleModel *> * modelArr;
@property(nonatomic, copy) NSString *categoryId;

@end

@implementation JHRecycleProductPictureView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andExampleModelArr:(NSArray<JHRecycleUploadExampleModel *> *)modelArr{
    self = [super initWithFrame:frame];
    if (self) {
        self.modelArr = modelArr;
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.starImageView];
    [self addSubview:self.titleLbl];
    [self addSubview:self.shootSampleBtn];
    [self addSubview:self.descLabel];
    self.btnArr = [NSMutableArray arrayWithCapacity:0];
    self.btnbottomLblArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i< self.modelArr.count; i++) {
        JHRecycleUploadExampleModel *model = self.modelArr[i];
        self.categoryId = model.categoryId;
        UIButton *btn = [UIButton jh_buttonWithTarget:self action:@selector(addPicture:) addToSuperView:self];
        btn.tag = i;
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.baseImage.origin] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"recycle_uploadproduct_addwhite"] forState:UIControlStateNormal];
        [self.btnArr addObject:btn];
        UILabel *bottomLbl = [[UILabel alloc] init];
        bottomLbl.font = JHFont(12);
        bottomLbl.textColor = HEXCOLOR(0x999999);
        bottomLbl.text = model.exampleDesc;
        [self addSubview:bottomLbl];
        [self.btnbottomLblArr addObject:bottomLbl];
    }
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
    
    [self.shootSampleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.right.equalTo(@-12);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLbl.mas_bottom).offset(2);
        make.left.equalTo(@0).offset(12);
    }];
    UIView *lastView  = nil;
    for (int i = 0; i< self.btnArr.count; i++) {
        UIButton *btn = self.btnArr[i];
        UILabel *lbl = self.btnbottomLblArr[i];
        CGFloat space = (ScreenWidth - 24 - 4 * 80)/3;
        BOOL isNewLine = !(i%4); ///是否换行

        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
            if (isNewLine) {
                make.left.equalTo(@0).offset(12);
                if (i == 0) {
                    make.top.equalTo(self.descLabel.mas_bottom).offset(14);
                }else{
                    make.top.equalTo(lastView.mas_bottom).offset(37);
                }
            }else{
                make.left.equalTo(lastView.mas_right).offset(space);
                make.top.equalTo(lastView);
            }
        }];
        
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(btn.mas_bottom).offset(8);
            if (i+1 >= self.btnArr.count) {
                make.bottom.equalTo(@0).offset(-12);
            }
        }];
        lastView = btn;
    }
}

- (void)removePictureView:(JHRecyclePhotoSeletedView*)sender{
    [self.seletedViewArr removeObject:sender];
    UIButton *btn  = self.btnArr[sender.tag];
    [sender removeFromSuperview];
    btn.hidden = NO;
    if (self.delProductPictureBlock) {
        self.delProductPictureBlock(sender.tag);
    }
    [NSNotificationCenter.defaultCenter postNotificationName:JHNotificationRecycleUploadImageInfoChanged object:nil];
}

- (void)addProductPictureWithName:(JHRecyclePhotoInfoModel *)model andIndex:(NSInteger)index{
    UIButton *clickBtn = self.btnArr[index];
    clickBtn.hidden = YES;
    JHRecyclePhotoSeletedView *imageView = [[JHRecyclePhotoSeletedView alloc] init];
    imageView.uploadQueue = self.uploadQueue;
    imageView.model = model;
    imageView.tag = index;
    @weakify(self);
    [imageView setDeleteBlock:^(JHRecyclePhotoSeletedView * _Nonnull photoView) {
        @strongify(self);
        [self removePictureView:photoView];
    }];
    [self addSubview:imageView];
    [self.seletedViewArr addObject:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(clickBtn);
    }];
    [NSNotificationCenter.defaultCenter postNotificationName:JHNotificationRecycleUploadImageInfoChanged object:nil];
}

- (void)addPicture:(UIButton*)sender{
    [self.seletedViewArr enumerateObjectsUsingBlock:^(JHRecyclePhotoSeletedView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.seletedViewArr = nil;
    [self.btnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = NO;
    }];
    if (self.addProductPictureBlock) {
        self.addProductPictureBlock(sender.tag);
    }
}


#pragma mark -- <set and get>

- (NSMutableArray<JHRecyclePhotoInfoModel *> *)productPictureArr{
    return [self.seletedViewArr jh_map:^id _Nonnull(JHRecyclePhotoSeletedView * _Nonnull obj, NSUInteger idx) {
        return obj.model;
    }];
}
- (NSMutableArray<JHRecyclePhotoSeletedView *> *)seletedViewArr{
    if (!_seletedViewArr) {
        _seletedViewArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _seletedViewArr;
}

- (UIImageView *)starImageView{
    if (!_starImageView) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_star"]];
        _starImageView = view;
    }
    return _starImageView;
}
//
- (UIButton *)shootSampleBtn{
    if (!_shootSampleBtn) {
        _shootSampleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shootSampleBtn setTitleColor:HEXCOLOR(0x2F66A0) forState:UIControlStateNormal];
        [_shootSampleBtn setImage:[UIImage imageNamed:@"shootSample_icon"] forState:UIControlStateNormal];
        [_shootSampleBtn setTitle:@"拍摄示例" forState:UIControlStateNormal];
        _shootSampleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
        _shootSampleBtn.titleLabel.font = JHFont(12);
        [_shootSampleBtn addTarget:self action:@selector(didClickSampleBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shootSampleBtn;
}

- (void)didClickSampleBtn{
    
    JHPhotoExampleViewController *vc = [[JHPhotoExampleViewController alloc] init];
    vc.categoryId = self.categoryId;
    vc.showType = 2;
    [JHRootController.currentViewController presentViewController:vc animated:true completion:nil];

}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"宝贝图片";
        _titleLbl = label;
    }
    return _titleLbl;
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

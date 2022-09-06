//
//  JHC2CProductUploadNesPictureView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductUploadNesPictureView.h"
#import "JHRecycleUploadExampleModel.h"

#import "JHRecycleProductPictureView.h"
#import "JHRecyclePhotoSeletedView.h"
#import <SDWebImage.h>
#import "JHBrowserViewController.h"
#import "JHBrowserModel.h"

@interface JHC2CProductUploadNesPictureView()

@property(nonatomic, strong) NSMutableArray<UIButton*> * btnArr;
@property(nonatomic, strong) NSMutableArray<UILabel*> * btnbottomLblArr;
@property(nonatomic, strong) NSMutableArray<JHRecyclePhotoSeletedView*> *seletedViewArr;
@property(nonatomic, strong) NSArray<JHRecycleUploadExampleModel *> * modelArr;


@end

@implementation JHC2CProductUploadNesPictureView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
        self.titleLbl.hidden = YES;
        self.starImageView.hidden = YES;
        [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(@0);
            make.height.mas_equalTo(0.1);
        }];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andExampleModelArr:(NSArray<JHRecycleUploadExampleModel *> *)modelArr{
    self = [super initWithFrame:frame];
    if (self) {
        self.modelArr = modelArr;
        [self setItems];
        [self layoutItems];
        self.titleLbl.hidden = YES;
        self.starImageView.hidden = YES;
        [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(@0);
            make.height.mas_equalTo(0.1);
        }];

    }
    return self;
}

- (void)setItems{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.starImageView];
    [self addSubview:self.titleLbl];
    self.btnArr = [NSMutableArray arrayWithCapacity:0];
    self.btnbottomLblArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i< self.modelArr.count; i++) {
        JHRecycleUploadExampleModel *model = self.modelArr[i];
        UIButton *btn = [UIButton jh_buttonWithTarget:self action:@selector(addPicture:) addToSuperView:self];
        btn.tag = i;
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.baseImage.origin] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"recycle_uploadproduct_addwhite"] forState:UIControlStateNormal];
        [self.btnArr addObject:btn];
        UILabel *bottomLbl = [[UILabel alloc] init];
        NSString *placeStr = [@"*" stringByAppendingString:model.exampleDesc];
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:placeStr
                                                                                   attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x999999),
                                                                                                NSFontAttributeName:JHFont(12),
                                                                                   }];
        NSRange range = NSMakeRange(0, 1);
        [attstr setAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xF23730),
                                NSFontAttributeName:JHFont(14),
                                NSBaselineOffsetAttributeName:@-2
        } range:range];

        bottomLbl.attributedText = attstr;
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
                    make.top.equalTo(self.titleLbl.mas_bottom).offset(14);
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
    
    //添加图片预览
    imageView.tapImageBlock = ^(JHRecyclePhotoSeletedView * _Nonnull photoView) {
        JHBrowserModel *model = [[JHBrowserModel alloc] init];
        model.image = photoView.model.originalImage;
        [JHBrowserViewController showBrowser:@[model] currentIndex:0 from:[self getCurrentVC]];
    };
}

- (void)addNetProductPictureWithName:(JHIssueGoodsEditImageItemModel *)model andIndex:(NSInteger)index{
    UIButton *clickBtn = self.btnArr[index];
    clickBtn.hidden = YES;
    JHRecyclePhotoSeletedView *imageView = [[JHRecyclePhotoSeletedView alloc] init];
    imageView.uploadQueue = self.uploadQueue;
    imageView.editModel = model;
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
    
    //添加图片预览
    imageView.tapImageBlock = ^(JHRecyclePhotoSeletedView * _Nonnull photoView) {
        JHBrowserModel *model = [[JHBrowserModel alloc] init];
        model.thumbImageUrl = photoView.editModel.url;
        [JHBrowserViewController showBrowser:@[model] currentIndex:0 from:[self getCurrentVC]];
    };
}

-(UIViewController *)getCurrentVC{
 
      UIViewController *result = nil;

      UIWindow * window = [[UIApplication sharedApplication] keyWindow];
      if (window.windowLevel != UIWindowLevelNormal)  {
         NSArray *windows = [[UIApplication sharedApplication] windows];
         for(UIWindow * tmpWin in windows)  {
             if (tmpWin.windowLevel == UIWindowLevelNormal)  {
                 window = tmpWin;
                 break;
             }
         }
     }

     UIView *frontView = [[window subviews] objectAtIndex:0];
     id nextResponder = [frontView nextResponder];

     if ([nextResponder isKindOfClass:[UIViewController class]])
         result = nextResponder;
     else
         result = window.rootViewController;

    return result;
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

@end

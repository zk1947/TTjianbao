//
//  JHMyUserInfoDraftHeader.m
//  TTjianbao
//
//  Created by wangjianios on 2021/2/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyUserInfoDraftHeader.h"
#import "JHDraftBoxModel.h"

@interface JHMyUserInfoDraftHeader ()

/// 第一张草稿
@property (nonatomic, weak) UIImageView *imageView_1;

/// 第二张草稿
@property (nonatomic, weak) UIImageView *imageView_2;

/// 第三张草稿
@property (nonatomic, weak) UIImageView *imageView_3;

@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UIView *bgView;

@end


@implementation JHMyUserInfoDraftHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColor.whiteColor;
        
        _bgView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.shadowColor = RGBA(0, 0, 0, 0.1).CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0,0);
        _bgView.layer.shadowOpacity = 1;
        _bgView.layer.shadowRadius = 6;
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 15, 10, 15));
        }];
        [self jh_addTapGesture:^{
            [JHRouterManager pushDraft];
        }];
        [self addSelfSubViews];
    }
    return self;
}

- (void)addSelfSubViews {
    
    _imageView_3 = [UIImageView jh_imageViewAddToSuperview:_bgView];
    [_imageView_3 jh_cornerRadius:3 borderColor:RGB(238, 238, 238) borderWidth:0.5];
    
    _imageView_2 = [UIImageView jh_imageViewAddToSuperview:_bgView];
    [_imageView_2 jh_cornerRadius:3 borderColor:RGB(238, 238, 238) borderWidth:0.5];
    
    _imageView_1 = [UIImageView jh_imageViewAddToSuperview:_bgView];
    [_imageView_1 jh_cornerRadius:3 borderColor:RGB(238, 238, 238) borderWidth:0.5];
    
    [_imageView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.centerY.equalTo(self.bgView);
        make.width.height.mas_equalTo(60);
    }];
    
    [_imageView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView_1).offset(16);
        make.bottom.equalTo(self.imageView_1);
        make.width.height.mas_equalTo(54);
    }];
    
    
    [_imageView_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView_1).offset(32);
        make.bottom.equalTo(self.imageView_1);
        make.width.height.mas_equalTo(48);
    }];
    
    _descLabel = [UILabel jh_labelWithText:@"草稿箱" font:12 textColor:RGB(151, 151, 151) textAlignment:NSTextAlignmentLeft addToSuperView:self.bgView];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView_1.mas_right).offset(15);
        make.bottom.equalTo(self.bgView).offset(-19);
        make.height.mas_equalTo(17);
    }];
    
    UILabel *label = [UILabel jh_labelWithBoldText:@"草稿箱" font:15 textColor:RGB(51, 51, 51) textAlignment:NSTextAlignmentLeft addToSuperView:self.bgView];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descLabel);
        make.top.equalTo(self.bgView).offset(19);
        make.height.mas_equalTo(21);
    }];
    [self refresh];
}

- (void)refresh {
    NSArray *array = [JHDraftBoxModel dataArray];
    if(!IS_ARRAY(array))
    {
        return;
    }
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
    for (JHDraftBoxModel* model in array) {
        if(model.coverImageData) {
            if(IS_DATA(model.coverImageData)) {
                [images addObject:[UIImage imageWithData:model.coverImageData]];
            }
            else if(IS_STRING(model.imageData)) {
                [images addObject:model.coverImageData];
            }
        }
        else if(model.imageData){
            if(IS_DATA(model.imageData)) {
                [images addObject:[UIImage imageWithData:model.imageData]];
            }
            else if(IS_STRING(model.imageData)) {
                [images addObject:model.imageData];
            }
        }
        else if(model.imageDataArray && IS_ARRAY(model.imageDataArray) && model.imageDataArray.count >= 1) {
            for (id obj in model.imageDataArray) {
                if(obj && IS_DATA(obj)) {
                    [images addObject:[UIImage imageWithData:obj]];
                }
                else if(obj && IS_STRING(obj)) {
                    [images addObject:obj];
                }
            }
        }
    }
    NSArray *viewArray = @[_imageView_1, _imageView_2, _imageView_3];
    for (int i = 0; i < 3; i++) {
        UIImageView *view = viewArray[i];
        if(images.count > i) {
            id image = images[i];
            if(IS_IMAGE(image)) {
                view.hidden = NO;
                view.image = image;
            }
            else if(IS_STRING(image)) {
                view.hidden = NO;
                [view jh_setImageWithUrl:image];
            }
            else {
                view.hidden = YES;
                view.image = nil;
            }
        }
        else {
            view.hidden = YES;
            view.image = nil;
        }
    }
    if(images.count == 0) {
        _imageView_1.hidden = NO;
        _imageView_1.image = JHImageNamed(@"common_photo_placeholder");
    }
    _descLabel.text = [NSString stringWithFormat:@"有%@篇内容待发布",@(array.count)];
    [_descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView_1.mas_right).offset(MAX(15, 5 + (images.count * 10.f)));
    }];
}

+ (BOOL)isShowDraft {
    return ([self draftCount] > 0);
}

+ (NSInteger)draftCount {
    NSArray *array = [JHDraftBoxModel dataArray];
    if(array && IS_ARRAY(array) && array.count > 0) {
        return array.count;
    }
    return 0;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

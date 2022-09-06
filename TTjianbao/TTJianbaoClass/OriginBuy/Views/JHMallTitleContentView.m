//
//  JHMallTitleContentView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/12/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallTitleContentView.h"
#import "TTJianBaoColor.h"
#import "JHSkinManager.h"
#import "JHSkinSceneManager.h"
#import "UIImage+WebP.h"
#import <QuartzCore/QuartzCore.h>

#define FONT_SIZE  24.0f
#define FONT_SAMLL_SIZE 24.0f

@interface JHMallTitleContentView ()
@property (nonatomic,strong) YYAnimatedImageView *lcornerImageView;

@end


@implementation JHMallTitleContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat TOP_PAD = 5;
        CGFloat PAD = 3;
        CGFloat WIDHT = (ScreenW - 80 - 10 - 93 - 4*PAD)/2;
        CGFloat HEIGHT = 35;
        CGFloat CORNER_WIDTH = 26.0f;
        CGFloat CORNER_HEIGHT = 12.5f;
        
        _liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_liveButton];
//        _liveButton.frame = CGRectMake(PAD + 10, TOP_PAD, WIDHT-1, HEIGHT);
        _liveButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _liveButton.contentMode = UIViewContentModeScaleAspectFit;
        [_liveButton setTitle:@"直播购物" forState:UIControlStateNormal];
        [_liveButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        _liveButton.titleLabel.font = [UIFont fontWithName:kFontBoldPingFang size:FONT_SIZE];
        
        self.lcornerImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(WIDHT - CORNER_WIDTH/2, -CORNER_HEIGHT/2 + 3, CORNER_WIDTH, CORNER_HEIGHT)];
        self.lcornerImageView.hidden = YES;
        self.lcornerImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_liveButton addSubview:self.lcornerImageView];
        
        [_liveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(TOP_PAD);
            make.left.mas_equalTo(PAD + 10);
            make.height.mas_equalTo(HEIGHT);
        }];
        
        [self setLiveBtnStatus];
    }
    return self;
}

- (void)setLiveBtnStatus
{
    BOOL isSelected = _liveButton.isSelected;
    
    self.lcornerImageView.hidden = isSelected;

    JHSkinSceneManager *manager = [JHSkinSceneManager shareManager];
    @weakify(self)
    [RACObserve(manager, sceneTitleModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *model = x;
        if (model == nil) return;
        self.lcornerImageView.image = model.imageCornerNor;
        if (model.imageNor != nil) {
            [self.liveButton setImage:model.imageNor forState:UIControlStateNormal];
        }else {
            [self.liveButton setImage:nil forState:UIControlStateNormal];
            [self.liveButton setTitle:@"直播购物" forState:UIControlStateNormal];
            if (isSelected)
            {
                [self.liveButton setTitleColor:model.colorSel forState:UIControlStateNormal];
                self.liveButton.titleLabel.font = [UIFont fontWithName:kFontBoldPingFang size:FONT_SIZE];
            }
            else
            {
                [self.liveButton setTitleColor:model.colorNor forState:UIControlStateNormal];
                self.liveButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:FONT_SAMLL_SIZE];
            }
        }
    }];
    
//    JHSkinModel *live_model = [JHSkinManager liveShopping];
//    if (live_model.isChange)
//    {
//        NSString *imagePath = [JHSkinManager getImageFilePath:live_model.corner];
//        YYImage *image = [YYImage imageWithContentsOfFile:imagePath];
//        self.lcornerImageView.image = image;
//
//        if ([live_model.type intValue] == 0)
//        {
//            if ([JHSkinManager getImagePathExtension:live_model.name])
//            {
//                NSString *live_path = [JHSkinManager getImageFilePath:live_model.name];
//                UIImage *live_image = [UIImage sd_imageWithWebPData:[NSData dataWithContentsOfFile:live_path]];
//                [_liveButton setImage:live_image forState:UIControlStateNormal];
//            }
//            else
//            {
//                [_liveButton setImage:[JHSkinManager getTtCustomizeUnselectedImage] forState:UIControlStateNormal];
//            }
//        }
//        else if ([live_model.type intValue] == 1)
//        {
//            [_liveButton setTitle:@"直播购物" forState:UIControlStateNormal];
//            if (isSelected)
//            {
//                [_liveButton setTitleColor:COLOR_CHANGE(live_model.useName) forState:UIControlStateNormal];
//                _liveButton.titleLabel.font = [UIFont fontWithName:kFontBoldPingFang size:FONT_SIZE];
//            }
//            else
//            {
//                [_liveButton setTitleColor:COLOR_CHANGE(live_model.name) forState:UIControlStateNormal];
//                _liveButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:FONT_SAMLL_SIZE];
//            }
//        }
//    }
//    else
//    {
//        [_liveButton setTitle:@"直播购物" forState:UIControlStateNormal];
//            [_liveButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
//            _liveButton.titleLabel.font = [UIFont fontWithName:kFontBoldPingFang size:FONT_SIZE];
//    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

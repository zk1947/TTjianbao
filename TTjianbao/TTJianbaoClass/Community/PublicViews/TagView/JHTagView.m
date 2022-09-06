//
//  JHTagView.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHTagView.h"
#import "TTjianbao.h"
#import "UITapView.h"

#pragma mark -
#pragma mark - 标签配置信息
@interface JHTagConfig : NSObject
@property (nonatomic, assign) JHTagViewStyle style; //tag样式
@property (nonatomic, strong) UIColor *backgroundColor; //背景色
@property (nonatomic, strong) UIColor *titleColor; //标题字体颜色
@property (nonatomic, strong) UIImage *image; //标签图标
@property (nonatomic, assign) CGFloat cornerRadius; //标签圆角
- (instancetype)initWithStyle:(JHTagViewStyle)style;
@end

@implementation JHTagConfig

- (instancetype)initWithStyle:(JHTagViewStyle)style {
    self = [super init];
    if (self) {
        _cornerRadius = 8;
        self.style = style;
    }
    return self;
}

- (void)setStyle:(JHTagViewStyle)style {
    switch (style) {
        case JHTagViewStylePlate: {
            _backgroundColor = UIColorHex(FFFAD7);
            _titleColor = UIColorHex(FE9100);
            _image = [UIImage imageNamed:@"sq_icon_plate_tag"];
        }
            break;
        case JHTagViewStyleAppraisePlate: {
            _backgroundColor = UIColorHex(F5F6FA);
            _titleColor = UIColorHex(0x333333);
            _image = nil;
        }
            break;
        default: {
            _backgroundColor = [UIColor colorWithHexStr:@"000000" alpha:0.3];;
            _titleColor = [UIColor whiteColor];
            _image = nil;
        }
            break;
    }
}

@end


#pragma mark -
#pragma mark - JHTagView

@interface JHTagView ()
@property (nonatomic, copy) JHTagClickBlock clickBlock;

@property (nonatomic, strong) JHTagConfig *configuration;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@end


@implementation JHTagView

+ (instancetype)tagWithStyle:(JHTagViewStyle)style clickBlock:(JHTagClickBlock)clickBlock {
    
    JHTagView *view = [[JHTagView alloc] initWithFrame:CGRectZero style:style];
    view.clickBlock = clickBlock;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame style:(JHTagViewStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        _configuration = [[JHTagConfig alloc] initWithStyle:style];
        [self configUI];
        
        @weakify(self);
        self.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            @strongify(self);
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:self];
                if (CGRectContainsPoint(self.bounds, p)) {
                    if (self.clickBlock) {
                        self.clickBlock();
                    }
                }
            }
        };
    }
    return self;
}

- (void)setTagViewStyle:(JHTagViewStyle)tagViewStyle {
    _tagViewStyle = tagViewStyle;
    self.configuration.style = _tagViewStyle;
    [self configTagViewPropertys];
}

- (void)configTagViewPropertys {
    self.backgroundColor = _configuration.backgroundColor;
    _titleLabel.textColor = _configuration.titleColor;
    _iconView.image = _configuration.image;
    if (_configuration.image) {
        _iconView.sd_layout.leftSpaceToView(self, 5).widthIs(16);
    } else {
        _iconView.sd_layout.leftSpaceToView(self, 0).widthIs(0);
    }
    [self setupAutoWidthWithRightView:_titleLabel rightMargin:5];
    [self layoutIfNeeded];
}

- (void)configUI {
    self.clipsToBounds = YES;
    self.backgroundColor = _configuration.backgroundColor;
    self.sd_cornerRadius = @(_configuration.cornerRadius);
    
    _iconView = [UIImageView new];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:13] textColor:_configuration.titleColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self sd_addSubviews:@[_iconView, _titleLabel]];
    
    //布局
    _iconView.sd_layout
    .leftSpaceToView(self, 5)
    .centerYEqualToView(self)
    .widthIs(16).heightEqualToWidth();
    
    _titleLabel.sd_layout
    .leftSpaceToView(_iconView, 5)
    .centerYEqualToView(self)
    .heightIs(20);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:150]; //label横向自适应
    
}

- (void)setTitle:(NSString *)title {
    //_title = title;
    _iconView.image = _configuration.image;
    _titleLabel.text = title;
    
    [self configTagViewPropertys];
    
//    if (_configuration.image) {
//        _iconView.sd_layout.leftSpaceToView(self, 5).widthIs(16);
//    } else {
//        _iconView.sd_layout.leftSpaceToView(self, 0).widthIs(0);
//    }
    
//    [self setupAutoWidthWithRightView:_titleLabel rightMargin:5];
//    [self layoutIfNeeded];
}

@end


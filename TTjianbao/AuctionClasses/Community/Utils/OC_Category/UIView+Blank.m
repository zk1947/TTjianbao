//
//  UIView+Blank.m
//  Cooking-Home
//
//  Created by wubin on 2018/1/6.
//  Copyright © 2018年 ASYD. All rights reserved.
//

#import "UIView+Blank.h"
#import "objc/runtime.h"
#import "Masonry.h"
#import "TTjianbaoMarcoUI.h"

#pragma mark -
#pragma mark - UIView (Blank)

@implementation UIView (Blank)

static char BlankViewKey;

- (void)setBlankView:(UIBlankView *)blankView {
    [self willChangeValueForKey:@"BlankViewKey"];
    objc_setAssociatedObject(self, &BlankViewKey,
                             blankView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankViewKey"];
}

- (UIBlankView *)blankView {
    return objc_getAssociatedObject(self, &BlankViewKey);
}

- (void)configBlankType:(YDBlankType)blankType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadBlock:(void(^)(id sender))block {
    [self configBlankType:blankType hasData:hasData hasError:hasError offsetY:0 reloadBlock:block];
}

- (void)configBlankType:(YDBlankType)blankType hasData:(BOOL)hasData hasError:(BOOL)hasError offsetY:(CGFloat)offsetY reloadBlock:(void(^)(id sender))block {
    
    if (hasData) {
        if (self.blankView) {
            self.blankView.hidden = YES;
            [self.blankView removeFromSuperview];
        }
        
    } else {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (!self.blankView) {
                    self.blankView = [[UIBlankView alloc] initWithFrame:self.bounds];
                }
                self.blankView.hidden = NO;
                [self.blankContainer insertSubview:self.blankView atIndex:0];
                
                [self.blankView configWithType:blankType hasData:hasData hasError:hasError offsetY:offsetY reloadBlock:block];
            }];
        }];
    }
}

- (UIView *)blankContainer {
    UIView *blankContainer = self;
    for (UIView *aView in [self subviews]) {
        if ([aView isKindOfClass:[UITableView class]]) {
            blankContainer = aView;
        }
    }
    if (![blankContainer isKindOfClass:[UITableView class]]) {
        for (UIView *aView in [self subviews]) {
            if ([aView isKindOfClass:[UICollectionView class]]) {
                blankContainer = aView;
            }
        }
    }
    return blankContainer;
}

@end


#pragma mark -
#pragma mark - ----UIBlankView----

@interface UIBlankView ()

@property (nonatomic, assign) YDBlankType curType; //空页面类型
@property (nonatomic, strong) UIImageView *iconView; //图标
@property (nonatomic, strong) UILabel  *titleLabel, *descLabel; //标题 / 描述
@property (nonatomic, strong) UIButton *reloadButton, *actionButton;

@property (nonatomic,   copy) void(^reloadButtonBlock)(id sender); //重新加载按钮 Block

@end

@implementation UIBlankView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configWithType:(YDBlankType)blankType hasData:(BOOL)hasData hasError:(BOOL)hasError offsetY:(CGFloat)offsetY reloadBlock:(void (^)(id))block {
    _curType = blankType;
    _reloadButtonBlock = block;
    
    if (hasData) {
        [self removeFromSuperview];
        return;
    }
    self.alpha = 1.0;
    //图片
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_iconView];
    }
    //标题
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithHexString:@"a7a7a7"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    
    //文字
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.backgroundColor = [UIColor clearColor];
        _descLabel.numberOfLines = 0;
        _descLabel.font = [UIFont systemFontOfSize:14.0];
        _descLabel.textColor = kColor999;
        _descLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_descLabel];
    }
    
    //重新加载按钮
    if (!_reloadButton) {
        _reloadButton = ({
            UIButton *button = [UIButton new];
            //button.backgroundColor = [UIColor colorWithHexString:@"425063"];
            [button setBackgroundImage:[UIImage imageWithColor:kColorMain] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        [self addSubview:_reloadButton];
    }
    
    //其他按钮
    if (!_actionButton) {
        _actionButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            //button.backgroundColor = kColorMain;
            [button setBackgroundImage:[UIImage imageWithColor:kColorMain] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(actionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        [self addSubview:_actionButton];
    }
    
    NSString *imageName, *titleStr, *descStr;
    NSString *buttonTitle;
    
    if (hasError) { //加载失败
        _actionButton.hidden = YES;
        titleStr = @"网络不给力，请稍后再试";
        //descStr = @"别紧张，试试刷新页面";
        imageName = @"blank_icon_load_failed";
        buttonTitle = @"";
        
    } else { //空白数据
        _reloadButton.hidden = YES;
        switch (_curType) {
            case YDBlankTypeNone: {
                imageName = @"blank_icon_nodata";
                titleStr = @"暂无数据~";
                break;
            }
            case YDBlankTypeNoUserFollow: {
                titleStr = @"暂无数据~";
                break;
            }
            case YDBlankTypeNoUserFans: {
                titleStr = @"暂无数据~";
                break;
            }
            case YDBlankTypeNoStoreHomeList: {
                imageName = @"blank_icon_nodata";
                titleStr = @"暂无数据~";
                break;
            }
            case YDBlankTypeNoGoodsList: {
                imageName = @"blank_icon_nodata";
                titleStr = @"暂无数据~";
                break;
            }
            case YDBlankTypeNoAllTopicList: {
                imageName = @"blank_icon_nodata";
                titleStr = @"暂无数据~";
                break;
            }
            case YDBlankTypeNoAllTopicSearchList: {
                imageName = @"blank_icon_nodata";
                titleStr = @"未搜索到数据~";
                break;
            }
            case YDBlankTypeNoShopList: {
                imageName = @"blank_icon_nodata";
                titleStr = @"暂无数据~";
                break;
            }
            case YDBlankTypeNoShopSearchList: {
                imageName = @"blank_icon_nodata";
                titleStr = @"未搜索到数据~";
                break;
            }
            case YDBlankTypeNoCollectionList: {
                imageName = @"blank_icon_nodata";
                titleStr = @"您还没有收藏的宝贝，快去商城逛一逛吧～";
                _titleLabel.font = [UIFont fontWithName:kFontNormal size:12.0];
                break;
            }
            case YDBlankTypeNoSearchResult: {
                imageName = @"blank_icon_nodata";
                titleStr = @"宝贝持续上新中，去看看其他宝贝吧~";
                _titleLabel.font = [UIFont fontWithName:kFontNormal size:12.0];
                break;
            }
            case YDBlankTypeNoValidVoucherList: {
                imageName = @"blank_icon_no_voucher";
                descStr = @"无可发放代金券，\n请去创建用于个人发放的代金券";
                _descLabel.font = [UIFont fontWithName:kFontNormal size:13.0];
                break;
            }
            case YDBlankTypeNoShopWindowList: {
                imageName = @"blank_icon_nodata";
                descStr = @"没有搜到商品，看看其他的吧~";
                _descLabel.font = [UIFont fontWithName:kFontNormal size:12.0];
                break;
            }
            case YDBlankTypeNoPlateSelectList: {
                imageName = @"blank_icon_nodata";
                descStr = @"暂无数据~";
                _descLabel.font = [UIFont fontWithName:kFontNormal size:12.0];
                break;
            }
            default:
                break;
        }
    }
    
    imageName = imageName ?: @"blank_icon_nodata";
    UIImage *iconImage = [UIImage imageNamed:imageName];
    
    _iconView.image = iconImage;
    
    _titleLabel.text = titleStr;
    _titleLabel.hidden = titleStr.length <= 0;
    
    if (_curType == YDBlankTypeNoValidVoucherList) {
        //调用
        [self setText:descStr lineSpace:5.0 inLabel:_descLabel];
    } else {
        _descLabel.text = descStr;
        _descLabel.hidden = descStr.length <= 0;
    }
    
    UIButton *bottomBtn = hasError ? _reloadButton : _actionButton;
    [bottomBtn setTitle:buttonTitle forState:UIControlStateNormal];
    bottomBtn.hidden = buttonTitle.length <= 0;
    
    //布局
    if (ABS(offsetY) > 0) {
        self.frame = CGRectMake(0, offsetY, self.width, self.height);
    }
        
    [_iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_bottom).multipliedBy(0.25);
        make.size.mas_equalTo(CGSizeMake(iconImage.size.width, iconImage.size.height));
    }];
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.top.equalTo(self->_iconView.mas_bottom).offset(15);
    }];
    
    [_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self->_titleLabel);
        if (titleStr.length > 0) {
            make.top.equalTo(self->_titleLabel.mas_bottom).offset(15);
        } else {
            make.top.equalTo(self->_iconView.mas_bottom).offset(15);
        }
    }];
    
    [bottomBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(150, 44));
        if (descStr.length > 0) {
            make.top.equalTo(self->_descLabel.mas_bottom).offset(25);
        } else {
            make.top.equalTo(self->_titleLabel.mas_bottom).offset(25);
        }
    }];
}

- (void)reloadButtonClicked:(id)sender {
    self.hidden = YES;
    [self removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->_reloadButtonBlock) {
            self->_reloadButtonBlock(sender);
        }
    });
}

- (void)actionButtonClicked {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->_clickButtonBlock) {
            self->_clickButtonBlock(self->_curType);
        }
    });
}

#pragma mark -
#pragma mark - 设置文本行间距
- (void)setText:(NSString *)text lineSpace:(CGFloat)lineSpace inLabel:(UILabel *)label {
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
}

@end

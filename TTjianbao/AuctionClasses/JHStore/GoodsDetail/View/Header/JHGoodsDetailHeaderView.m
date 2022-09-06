//
//  JHGoodsDetailHeaderView.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsDetailHeaderView.h"
#import "JHGoodsDetailHeaderShopPanel.h"
#import "JHGoodsDetailEasyMenu.h"


#define kPricePanelH    (44) //价格、倒计时信息栏高度
#define kShopPanelH     (84) //店铺信息栏高度

#define kNameFont       [UIFont fontWithName:kFontMedium size:16]
#define kDescFont       [UIFont fontWithName:kFontNormal size:14]

@interface JHGoodsDetailHeaderView () <UIScrollViewDelegate>
{
    CGoodsInfo *_goodsInfo;
    CShopInfo *_shopInfo;
}

@property (nonatomic,   copy) HasVideoInfoBlock hasVideoBlock;
@property (nonatomic, strong) JHGoodsDetailHeaderCycleView *cycleView; //轮播图

@end


@implementation JHGoodsDetailHeaderView
-(void)dealloc
{
    NSLog(@"🔥");
}
+ (CGFloat)heightWithGoodsModel:(CGoodsDetailModel *)model isFill:(BOOL)isFill {
    
    CGFloat headerH = kCycleViewH + kPricePanelH;
    
    CGoodsInfo *goodsInfo = model.goodsInfo;
    
    headerH += 10;
    headerH += [[self class] __getHeightWithText:goodsInfo.name font:kNameFont color:kColor333];
    
    headerH += 10;
    
    CGFloat descHeight = [[self class] __getHeightWithText:goodsInfo.desc font:kDescFont color:kColor333];
    
    headerH += descHeight;
    headerH += 10;
    
    headerH += 10;
    headerH += kShopPanelH + [goodsInfo.safeHeadImgInfo imageHeight];
    
    headerH += [JHGoodsDetailEasyMenu menuHeight]; //悬浮导航条高度
    
    return headerH;
}

- (instancetype)initWithFrame:(CGRect)frame goodsModel:(CGoodsDetailModel *)model hasVideoBlock:(HasVideoInfoBlock)hasBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        _curModel = model;
        _goodsInfo = model.goodsInfo;
        _shopInfo = model.shopInfo;
        _hasVideoBlock = hasBlock;
        
        [self configUI];
        [self makeProperty];
    }
    return self;
}

- (void)configUI {
    _cycleView = [[JHGoodsDetailHeaderCycleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kCycleViewH)];
    //轮播图回调 <视频>
    @weakify(self);
    _cycleView.hasVideoBlock = ^(CGoodsImgInfo * _Nonnull videoInfo, UITapImageView * _Nonnull videoContainer) {
        @strongify(self);
        if (self.hasVideoBlock) {
            self.hasVideoBlock(videoInfo, videoContainer);
        }
    };
    
    _cycleView.playClickBlock = ^{
        @strongify(self);
        if (self.playClickBlock) {
            self.playClickBlock();
        }
    };
    
    _cycleView.cycleScrollEndDeceleratingBlock = ^(BOOL isVideoIndex) {
        @strongify(self);
        //self.muteButton.hidden = !isVideoIndex;
        if (self.cycleScrollEndDeceleratingBlock) {
            self.cycleScrollEndDeceleratingBlock(isVideoIndex);
        }
    };

    //加入视图
    [self sd_addSubviews:@[_cycleView]];
    _cycleView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(kCycleViewH);
    [self updateLayout];

    //静音图标
    //_muteButton = [UIButton jh_buttonWithImage:@"stone_video_mute_1" target:self action:@selector(muteMethod:) addToSuperView:self];
    //[_muteButton setImage:JHImageNamed(@"stone_video_mute_0") forState:UIControlStateSelected];
}

//赋值
- (void)makeProperty {
    _cycleView.headImgList = _goodsInfo.headImgList;
    _cycleView.payMsgList = _curModel.pay_msg;
    [self updateLayout];
}

- (void)setIsPlayEnd:(BOOL)isPlayEnd {
    _cycleView.isPlayEnd = isPlayEnd;
}

#pragma mark -
#pragma mark - private methods

+ (CGFloat)__getHeightWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    if (![text isNotBlank]) return 0;
    YYTextLayout *layout = [[self class] __layoutWithText:text font:font color:color];
    return layout.textBoundingSize.height;
}

+ (YYTextLayout *)__layoutWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    //将一个或多个连续的<br>，或者一个或多个连续的<br /> 替换成一个换行符
    if (!text) return nil;
    NSString *textStr = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    textStr = [textStr stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"\n{1,}" options:0 error:nil];
    textStr = [regular stringByReplacingMatchesInString:textStr options:0 range:NSMakeRange(0, [textStr length])
                                           withTemplate:@"\n"];

    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:textStr];
    attrText.font = font;
    attrText.color = color;
    attrText.lineSpacing = 2;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(ScreenWidth-30, CGFLOAT_MAX) text:attrText];
    return layout;
}


-(void)muteMethod:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.isMute = sender.selected;
    
    if(_muteBlock)
    {
        _muteBlock();
    }
}

-(void)setAutoPlay:(BOOL)autoPlay
{
    _autoPlay = autoPlay;
    if(!_autoPlay)
    {
        return;
    }
    
    // 第一个是视频就自动播放
    if(_goodsInfo.headImgList.count > 0)
    {
        CGoodsImgInfo *model = _goodsInfo.headImgList[0];
        //self.muteButton.hidden = (model.type != 2);
        if(model.type == 2 && self.autoPlay)
        {
            [self.cycleView playBtnClicked];
        }
    }
}
@end

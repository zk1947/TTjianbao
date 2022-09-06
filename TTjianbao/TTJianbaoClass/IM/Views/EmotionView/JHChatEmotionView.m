//
//  JHChatEmotionView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatEmotionView.h"
#import "PPEmojiPreviewView.h"
#import "PPStickerPageView.h"
#import "PPStickerDataManager.h"
#import "PPUtil.h"

static CGFloat const PPStickerTopInset = 0.0;
static CGFloat const PPStickerScrollViewHeight = 232.0;
static CGFloat const PPKeyboardPageControlTopMargin = 0.0;
static CGFloat const PPKeyboardPageControlHeight = 2.0;
static CGFloat const PPKeyboardPageControlBottomMargin = 0.0;
static CGFloat const PPKeyboardCoverButtonWidth = 50.0;
static CGFloat const PPKeyboardCoverButtonHeight = 44.0;
static CGFloat const PPPreviewViewWidth = 92.0;
static CGFloat const PPPreviewViewHeight = 232.0;

static NSString *const PPStickerPageViewReuseID = @"PPStickerPageView";

@interface JHChatEmotionView()<PPStickerPageViewDelegate, PPQueuingScrollViewDelegate, UIInputViewAudioFeedback>
@property (nonatomic, strong) NSArray<PPSticker *> *stickers;
@property (nonatomic, strong) PPQueuingScrollView *queuingScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray<PPSlideLineButton *> *stickerCoverButtons;
@property (nonatomic, strong) UIButton *sendButton;
//@property (nonatomic, strong) UIScrollView *bottomScrollableSegment;
//@property (nonatomic, strong) UIView *bottomBGView;
@property (nonatomic, strong) PPEmojiPreviewView *emojiPreviewView;

@end

@implementation JHChatEmotionView{
    NSUInteger _currentStickerIndex;
}

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _currentStickerIndex = 0;
        _stickers = [PPStickerDataManager sharedInstance].allStickers.copy;

        self.backgroundColor = [UIColor pp_colorWithRGBString:@"#F4F4F4"];
        [self addSubview:self.queuingScrollView];
        [self addSubview:self.pageControl];
//        [self addSubview:self.bottomBGView];
        [self addSubview:self.sendButton];
//        [self addSubview:self.bottomScrollableSegment];

        [self changeStickerToIndex:0];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.queuingScrollView.contentSize = CGSizeMake([self numberOfPageForSticker:[self stickerAtIndex:_currentStickerIndex]] * CGRectGetWidth(self.bounds), PPStickerScrollViewHeight);
    self.queuingScrollView.frame = CGRectMake(0, PPStickerTopInset, CGRectGetWidth(self.bounds), PPStickerScrollViewHeight);
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.queuingScrollView.frame) + PPKeyboardPageControlTopMargin, CGRectGetWidth(self.bounds), PPKeyboardPageControlHeight);
    
    self.sendButton.frame = CGRectMake(ScreenW - 70, self.height - 40, 56, 40);
}

- (CGFloat)heightThatFits
{
    CGFloat bottomInset = 0;
    if (@available(iOS 11.0, *)) {
        bottomInset = UIApplication.sharedApplication.delegate.window.safeAreaInsets.bottom;
    }
    return PPStickerTopInset + PPStickerScrollViewHeight + PPKeyboardPageControlTopMargin + PPKeyboardPageControlHeight + PPKeyboardPageControlBottomMargin + bottomInset;
}

#pragma mark - getter / setter

- (PPQueuingScrollView *)queuingScrollView
{
    if (!_queuingScrollView) {
        _queuingScrollView = [[PPQueuingScrollView alloc] init];
        _queuingScrollView.delegate = self;
        _queuingScrollView.pagePadding = 0;
        _queuingScrollView.alwaysBounceHorizontal = NO;
    }
    return _queuingScrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor pp_colorWithRGBString:@"#F5A623"];
        _pageControl.pageIndicatorTintColor = [UIColor pp_colorWithRGBString:@"#BCBCBC"];
        _pageControl.hidden = YES;
    }
    return _pageControl;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _sendButton.backgroundColor = HEXCOLOR(0xffd70f);
        _sendButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:16];
        [_sendButton jh_cornerRadius:3];
        [_sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
- (PPEmojiPreviewView *)emojiPreviewView
{
    if (!_emojiPreviewView) {
        _emojiPreviewView = [[PPEmojiPreviewView alloc] init];
    }
    return _emojiPreviewView;
}

#pragma mark - private method

- (PPSticker *)stickerAtIndex:(NSUInteger)index
{
    if (self.stickers && index < self.stickers.count) {
        return self.stickers[index];
    }
    return nil;
}

- (NSUInteger)numberOfPageForSticker:(PPSticker *)sticker
{
    if (!sticker) {
        return 0;
    }

    NSUInteger numberOfPage = (sticker.emojis.count / PPStickerPageViewMaxEmojiCount) + ((sticker.emojis.count % PPStickerPageViewMaxEmojiCount == 0) ? 0 : 1);
    return numberOfPage;
}

- (UIImage *)emojiImageWithName:(NSString *)name
{
    if (!name.length) {
        return nil;
    }

    return [UIImage imageNamed:[@"Sticker.bundle" stringByAppendingPathComponent:name]];
}

- (void)changeStickerToIndex:(NSUInteger)toIndex
{
    if (toIndex >= self.stickers.count) {
        return;
    }

    PPSticker *sticker = [self stickerAtIndex:toIndex];
    if (!sticker) {
        return;
    }

    _currentStickerIndex = toIndex;

    PPStickerPageView *pageView = [self queuingScrollView:self.queuingScrollView pageViewForStickerAtIndex:0];
    [self.queuingScrollView displayView:pageView];

}

#pragma mark - target / action

- (void)changeSticker:(UIButton *)button
{
    [self changeStickerToIndex:button.tag];
}

- (void)sendAction:(PPSlideLineButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emotionKeyboardDidClickSendButton:)]) {
        [self.delegate emotionKeyboardDidClickSendButton:self];
    }
}

#pragma mark - PPQueuingScrollViewDelegate

- (void)queuingScrollViewChangedFocusView:(PPQueuingScrollView *)queuingScrollView previousFocusView:(UIView *)previousFocusView
{
    PPStickerPageView *currentView = (PPStickerPageView *)self.queuingScrollView.focusView;
    self.pageControl.currentPage = currentView.pageIndex;
}

- (UIView<PPReusablePage> *)queuingScrollView:(PPQueuingScrollView *)queuingScrollView viewBeforeView:(UIView *)view
{
    return [self queuingScrollView:queuingScrollView pageViewForStickerAtIndex:((PPStickerPageView *)view).pageIndex - 1];
}

- (UIView<PPReusablePage> *)queuingScrollView:(PPQueuingScrollView *)queuingScrollView viewAfterView:(UIView *)view
{
    return [self queuingScrollView:queuingScrollView pageViewForStickerAtIndex:((PPStickerPageView *)view).pageIndex + 1];
}

- (PPStickerPageView *)queuingScrollView:(PPQueuingScrollView *)queuingScrollView pageViewForStickerAtIndex:(NSUInteger)index
{
    PPSticker *sticker = [self stickerAtIndex:_currentStickerIndex];
    if (!sticker) {
        return nil;
    }

    NSUInteger numberOfPages = [self numberOfPageForSticker:sticker];
    self.pageControl.numberOfPages = numberOfPages;
    if (index >= numberOfPages) {
        return nil;
    }

    PPStickerPageView *pageView = [queuingScrollView reusableViewWithIdentifer:PPStickerPageViewReuseID];
    if (!pageView) {
        pageView = [[PPStickerPageView alloc] initWithReuseIdentifier:PPStickerPageViewReuseID];
        pageView.hasReturn = true;
        pageView.delegate = self;
    }
    pageView.pageIndex = index;
    [pageView configureWithSticker:sticker];
    return pageView;
}

#pragma mark - PPStickerPageViewDelegate

- (void)stickerPageView:(PPStickerPageView *)stickerPageView didClickEmoji:(PPEmoji *)emoji
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emotionKeyboard:didClickEmoji:)]) {
        [[UIDevice currentDevice] playInputClick];
        [self.delegate emotionKeyboard:self didClickEmoji:emoji];
    }
}

- (void)stickerPageViewDidClickDeleteButton:(PPStickerPageView *)stickerPageView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emotionKeyboardDidClickDeleteButton:)]) {
        [[UIDevice currentDevice] playInputClick];
        [self.delegate emotionKeyboardDidClickDeleteButton:self];
    }
}

- (void)stickerPageView:(PPStickerPageView *)stickerKeyboard showEmojiPreviewViewWithEmoji:(PPEmoji *)emoji buttonFrame:(CGRect)buttonFrame
{
    if (!emoji) {
        return;
    }

    self.emojiPreviewView.emoji = emoji;

    CGRect buttonFrameAtKeybord = CGRectMake(buttonFrame.origin.x, PPStickerTopInset + buttonFrame.origin.y, buttonFrame.size.width, buttonFrame.size.height);
    self.emojiPreviewView.frame = CGRectMake(CGRectGetMidX(buttonFrameAtKeybord) - PPPreviewViewWidth / 2, UIScreen.mainScreen.bounds.size.height - CGRectGetHeight(self.bounds) + CGRectGetMaxY(buttonFrameAtKeybord) - PPPreviewViewHeight, PPPreviewViewWidth, PPPreviewViewHeight);

    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    if (window) {
        [window addSubview:self.emojiPreviewView];
    }
}

- (void)stickerPageViewHideEmojiPreviewView:(PPStickerPageView *)stickerKeyboard
{
    [self.emojiPreviewView removeFromSuperview];
}

#pragma mark - UIInputViewAudioFeedback

- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}


@end

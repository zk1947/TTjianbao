//
//  YDMediaCarouselUtil.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YDMediaCarouselUtil.h"

@implementation YDMediaCarouselUtil

+ (CGFloat)mediaHeight {
    return JHScaleToiPhone6(280);
}

+ (UIScrollView *)mediaScrollWithDelegate:(id)delegate {
    UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, YDMediaCarouselHeight)];
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView setBounces:YES];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setDelegate:delegate];
    return _scrollView;
}

+ (UILabel *)imageIndexLabel {
    UILabel *_imgIndexLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:10] textColor:[UIColor whiteColor]];
    _imgIndexLabel.backgroundColor = HEXCOLORA(0x333333, 0.5);
    _imgIndexLabel.textAlignment = NSTextAlignmentCenter;
    _imgIndexLabel.clipsToBounds = YES;
    _imgIndexLabel.sd_cornerRadiusFromHeightRatio = @0.5;
    return _imgIndexLabel;
}

+ (UIButton *)playButton {
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"icon_video_play"] forState:UIControlStateNormal];
    btn.userInteractionEnabled = YES;
    return btn;
}

+ (UITapImageView *)mediaImageView {
    UITapImageView *imgView = [[UITapImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, YDMediaCarouselHeight)];
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    return imgView;
}

+ (void)filterMediaList:(NSMutableArray<YDMediaData *> *)mediaList {
    if (mediaList.count == 0) {
        return;
    }
    NSMutableArray<YDMediaData *> *list = mediaList.mutableCopy;
    [list enumerateObjectsUsingBlock:^(YDMediaData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isVideo) {
            [mediaList removeObjectAtIndex:idx];
            [mediaList insertObject:obj atIndex:0];
            *stop = YES;
        }
    }];
    
//    NSMutableArray *arr = [@[ @1, @2, @3, @4]  mutableCopy];
//    for (NSNumber *tmpNum in arr) {
//           NSInteger currentIndex = [arr indexOfObject:@3];
//           while (currentIndex - 1 >= 0) {
//              [arr exchangeObjectAtIndex:currentIndex withObjectAtIndex:currentIndex - 1];
//              currentIndex--;
//          }
//    }
}


@end

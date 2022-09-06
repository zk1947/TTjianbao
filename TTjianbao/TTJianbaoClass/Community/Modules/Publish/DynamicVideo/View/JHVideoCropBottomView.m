//
//  TTjianbao
//
//  Created by wangjianios on 2020/6/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHVideoCropBottomView.h"
#import "JHVideoCropFrameView.h"
#import "UIView+Extension.h"
#import "JHVideoCropManager.h"

@interface JHVideoCropBottomView ()<SDVideoCropVideoDragDelegate>

@property(nonatomic,strong)UILabel *selectTimeLabel;
@property(nonatomic,strong)UIButton *reloadSelectButton;
@property(nonatomic,strong)JHVideoCropFrameView *cropFrameView;

@property(nonatomic,strong)JHVideoCropDataManager *dataManager;

@end

@implementation JHVideoCropBottomView

- (instancetype)initWithFrame:(CGRect)frame dataManager:(JHVideoCropDataManager *)dataManager {

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        self.dataManager = dataManager;
        [self addDataObserverAction];
        [self addSubview:self.cropFrameView];
        
        [self addSubview:self.selectTimeLabel];
    }
    return self;
}

#pragma mark - 懒加载

- (UILabel *)selectTimeLabel {
    if (_selectTimeLabel == nil) {
        _selectTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, self.width, 30)];
        int time = CMTimeGetSeconds(self.dataManager.playTimeRange.duration);
        time = MIN(time,self.dataManager.maxDuration);
        _selectTimeLabel.attributedText = [self getShadowWithText:[NSString stringWithFormat:@"已选取 %.2d:%.2d",time/60,time%60]];
        _selectTimeLabel.textColor = UIColor.whiteColor;
        _selectTimeLabel.font = [UIFont boldSystemFontOfSize:13];
        _selectTimeLabel.textAlignment = 1;
    }
    return _selectTimeLabel;
}

- (JHVideoCropFrameView *)cropFrameView {
    
    if (_cropFrameView == nil) {
        _cropFrameView = [[JHVideoCropFrameView alloc] initWithFrame:CGRectMake(0, 0, self.width, 100) dataManager:self.dataManager];
        _cropFrameView.delegate = self;
    }
    return _cropFrameView;
}

#pragma mark - 拖拽代理方法

- (void)userStartChangeVideoTimeRangeAction {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(userStartChangeVideoTimeRangeAction)]) {
        [_delegate userStartChangeVideoTimeRangeAction];
    }
}

- (void)userChangeVideoTimeRangeAction {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(userChangeVideoTimeRangeAction)]) {
        [_delegate userChangeVideoTimeRangeAction];
    }
}

- (void)userEndChangeVideoTimeRangeAction {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(userEndChangeVideoTimeRangeAction)]) {
        [_delegate userEndChangeVideoTimeRangeAction];
    }
}

#pragma mark - 数据监听观察

- (void)addDataObserverAction {
    
    [self.dataManager addObserver:self forKeyPath:@"playTimeRange" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"playTimeRange"]) {
        int time = CMTimeGetSeconds(self.dataManager.playTimeRange.duration);
        _selectTimeLabel.attributedText = [self getShadowWithText:[NSString stringWithFormat:@"已选取 %.2d:%.2d",time/60,time%60]];
    }
}

#pragma mark - 系统方法

- (void)dealloc {

    [self.dataManager removeObserver:self forKeyPath:@"playTimeRange"];
}

- (NSAttributedString *)getShadowWithText:(NSString *)text
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 4;
    shadow.shadowColor = [UIColor colorWithRed:227/255.0 green:125/255.0 blue:0/255.0 alpha:0.66];
    shadow.shadowOffset =CGSizeMake(0,1);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes: @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSShadowAttributeName: shadow}];
    return string;
}


@end

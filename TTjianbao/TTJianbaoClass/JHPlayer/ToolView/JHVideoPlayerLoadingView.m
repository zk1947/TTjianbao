//
//  JHVideoPlayerLoadingView.m
//  TTJB
//
//  Created by 王记伟 on 2021/1/15.
//

#import "JHVideoPlayerLoadingView.h"
#import "JHVideoActivityIndicator.h"

@interface JHVideoPlayerLoadingView()
@property (nonatomic, strong) JHVideoActivityIndicator *loadingView;
@property (nonatomic, strong) UIButton *retryButton;
@end

@implementation JHVideoPlayerLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.hidden = YES;
    [self addSubview:self.loadingView];
    [self addSubview:self.retryButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.loadingView.frame;
    frame.origin.x = self.frame.size.width * 0.5 - frame.size.width * 0.5;
    frame.origin.y = self.frame.size.height * 0.5 - frame.size.height * 0.5;
    self.loadingView.frame = frame;
    self.retryButton.center = self.loadingView.center;
}

- (void)startLoading {
    [self.loadingView startAnimating];
    self.hidden = NO;
    self.retryButton.hidden = YES;
}

- (void)stopLoading {
    [self.loadingView stopAnimating];
    self.hidden = YES;
}

- (void)showRetry {
    self.hidden = NO;
    self.retryButton.hidden = NO;
    [self.loadingView stopAnimating];
}

/// MARK: - Private method

- (void)_retryClicked:(id)sender {
    if (self.retryCall) {
        self.hidden = YES;
        self.retryCall();
    }
}

/// MARK: - Getter

- (JHVideoActivityIndicator *)loadingView {
    if (!_loadingView) {
        _loadingView = [[JHVideoActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, 32.0, 32.0)];
        _loadingView.lineWidth = 4;
        _loadingView.hidesWhenStopped = YES;
        _loadingView.tintColor = [UIColor whiteColor];
    }
    return _loadingView;
}

- (UIButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [[UIButton alloc] init];
        _retryButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_retryButton setTitle:@"加载失败，点击重试" forState:UIControlStateNormal];
        _retryButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_retryButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [_retryButton addTarget:self action:@selector(_retryClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_retryButton sizeToFit];
    }
    return _retryButton;
}

@end

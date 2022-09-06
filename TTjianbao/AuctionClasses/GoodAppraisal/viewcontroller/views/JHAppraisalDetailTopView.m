//
//  JHAppraisalDetailTopView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/15.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "JHAppraisalDetailTopView.h"
#import "JHVideoPlayControlView.h"
#import "TTjianbaoHeader.h"
#import "UIImageView+JHWebImage.h"

@interface  JHAppraisalDetailTopView()
{
    UIImageView  *circle2;
    UIImageView  *circle1;
    UIImageView  *liveBack;
}
@property (nonatomic, strong) UIView *topControlView; //顶部控制条
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UIImageView *topBackImageview;
@property (nonatomic, strong) UIButton *playBtn;  //播放/暂停按钮
@property (nonatomic, strong) UIButton *playQuitBtn;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@end

@implementation JHAppraisalDetailTopView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {

        [self initTopView];
        
    }
    return self;
}

- (void)initTopView {
    
    [self addSubview:self.topBackImageview];
     self.topBackImageview.alpha=0;
    [_topBackImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        
    }];
    
    [self addSubview:self.topControlView];
    [_topControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(UI.statusBarHeight);
        make.bottom.equalTo(self);
    }];
    
    circle1=[[UIImageView alloc]init];
    circle1.image=[UIImage imageNamed:@"appraisal_circle3"];
    circle1.userInteractionEnabled=YES;
    [self.topControlView addSubview:circle1];
    [circle1 mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.centerY.equalTo(self.topControlView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.equalTo(@20);
    }];
    
    circle2=[[UIImageView alloc]init];
    circle2.image=[UIImage imageNamed:@"appraisal_circle3"];
    [circle1 addSubview:circle2];
    [circle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(circle1);
    }];
    
    _headImage=[[UIImageView alloc]init];
    _headImage.image=kDefaultAvatarImage;
    _headImage.layer.masksToBounds =YES;
    _headImage.layer.cornerRadius =22.5;
    _headImage.userInteractionEnabled=YES;
    [_headImage  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(headImageTap)]];
    [circle1 addSubview:_headImage];
    
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(circle1);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    liveBack=[[UIImageView alloc]init];
    liveBack.image=[UIImage imageNamed:@"appraisal_play_back"];
    [circle1 addSubview:liveBack];
    [liveBack mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(circle1).offset(42);
        make.centerX.equalTo(circle1);
    }];
    
    [circle2 setHidden:YES ];
    [liveBack setHidden:YES];
    
    UIImageView  *logo=[[UIImageView alloc]init];
    logo.image=[UIImage imageNamed:@"appraisal_top_logo"];
    [liveBack addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(liveBack).offset(5);
        make.centerY.equalTo(liveBack);
    }];
    
    UILabel *status=[[UILabel alloc]init];
    status.text=@"直播中";
    status.font=[UIFont systemFontOfSize:9];
    status.textColor=[UIColor whiteColor];
    status.numberOfLines = 1;
    status.textAlignment = UIControlContentHorizontalAlignmentCenter;
    status.lineBreakMode = NSLineBreakByWordWrapping;
    [liveBack addSubview:status];
    
    [status mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(logo.mas_right).offset(5);
        make.centerY.equalTo(liveBack);
    }];
    
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeBtn setImage:[UIImage imageNamed:@"apprasal_topzan"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"apprasal_topzan_select"] forState:UIControlStateSelected];
    _likeBtn.contentMode=UIViewContentModeScaleAspectFit;
    [_likeBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topControlView addSubview:_likeBtn];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setImage:[UIImage imageNamed:@"appraisal_top_share"] forState:UIControlStateNormal];
    _shareBtn.contentMode=UIViewContentModeScaleAspectFit;
    [_shareBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topControlView addSubview:_shareBtn];
    
    _playQuitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playQuitBtn setImage:[UIImage imageNamed:@"appraisal_top_close"] forState:UIControlStateNormal];
    _playQuitBtn.contentMode=UIViewContentModeScaleAspectFit;
    [_playQuitBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topControlView addSubview:_playQuitBtn];
    
    [_playQuitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topControlView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.offset(-10);
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topControlView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(_playQuitBtn.mas_left).offset(-20);
    }];
    
    [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topControlView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(_shareBtn.mas_left).offset(-20);
    }];
    
}
-(UIImageView *)topBackImageview {
    
    if (!_topBackImageview) {
        _topBackImageview = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"appraisal_detail_topbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(10,5,0,5)resizingMode:UIImageResizingModeStretch] ];
    }
    return _topBackImageview;
}
- (void)onClickBtnAction:(UIButton *)btn {
    
   if (btn == _playQuitBtn) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickQuit:)]) {
            [_delegate controlViewOnClickQuit:nil];
        }
    }

    else  if (btn == _shareBtn) {

        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickShare:)]) {
            [_delegate controlViewOnClickShare:nil];
        }
    }
    else  if (btn == _likeBtn) {

        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickLike:isLike:)]) {

            if (_likeBtn.selected) {
                [_delegate controlViewOnClickLike:nil isLike:NO];
            }
            else{
                [_delegate controlViewOnClickLike:nil isLike:YES];
            }
        }
    }
}
-(UIView *)topControlView {
    
    if (!_topControlView) {
        _topControlView = [[UIView alloc] init];
        _topControlView.backgroundColor=[UIColor clearColor];
    }
    return _topControlView;
}
-(void)setAppraisalDetail:(AppraisalDetailMode *)appraisalDetail{
    
    _appraisalDetail=appraisalDetail;
    JH_WEAK(self)
    [_headImage jhSetImageWithURL:[NSURL URLWithString:_appraisalDetail.appraiser.avatar] placeholder:kDefaultAvatarImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        JH_STRONG(self)
        if ([self.appraisalDetail.appraiser.liveState boolValue]) {
            
            [self beginAnimation_headImage];
            [self beginAnimation_circle];
        }
    }];
    
    if (_appraisalDetail.isLaud ) {
        [_likeBtn setSelected:YES];
    }
    else{
        [_likeBtn setSelected:NO];
    }
    if ([_appraisalDetail.appraiser.liveState boolValue]) {
        
        [circle2 setHidden:NO ];
        [liveBack setHidden:NO];
        _headImage.layer.cornerRadius =20;
        [_headImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    
}
-(void)setTopImageAlpha:(float)topImageAlpha{
    
    self.topBackImageview.alpha=topImageAlpha;
    
}
-(void)setIsLike:(BOOL)isLike{
    
    _isLike=isLike;
    if (isLike) {
        [_likeBtn setSelected:YES];
    }
    else{
        [_likeBtn setSelected:NO];
    }
    
}

-(void)headImageTap{
    
    if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickHeadImage:)]) {
        [_delegate controlViewOnClickHeadImage:nil ];
    }
}
- (void)beginAnimation_headImage
{
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = 1.0;
    group.repeatCount = MAXFLOAT;
    CABasicAnimation *animation1 = [self scaleAnimationFrom:1 to:1.2 begintime:0];
    CABasicAnimation *animation2 = [self scaleAnimationFrom:1.2 to:1 begintime:0.5];
    
    [group setAnimations:[NSArray arrayWithObjects:animation1,animation2, nil]];
    
    [self.headImage.layer addAnimation:group forKey:@"scale"];
}

-(CABasicAnimation *)scaleAnimationFrom:(CGFloat)from to:(CGFloat)to begintime:(CGFloat)beginTime
{
    CABasicAnimation *_animation = [[CABasicAnimation alloc] init];
    [_animation setKeyPath:@"transform.scale"];
    _animation.duration = 0.5;
    _animation.beginTime = beginTime;
    _animation.removedOnCompletion = false;
    [_animation setFromValue:[NSNumber numberWithFloat:from]];
    [_animation setToValue:[NSNumber numberWithFloat:to]];
    return _animation;
}
- (void)beginAnimation_circle
{
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = 1.0;
    group.repeatCount = MAXFLOAT;
    CABasicAnimation *animation1 = [self scaleAnimationFrom:1 to:1.2 begintime:0];
    [group setAnimations:[NSArray arrayWithObjects:animation1,[self alphaAnimation], nil]];
    
    [circle2.layer addAnimation:group forKey:@"scale"];
}
-(CABasicAnimation *)alphaAnimation{
    
    CABasicAnimation *_animation = [[CABasicAnimation alloc] init];
    [_animation setKeyPath:@"opacity"];
    _animation.duration = 0.5;
    _animation.beginTime = 0;
    [_animation setFromValue:[NSNumber numberWithFloat:1]];
    [_animation setToValue:[NSNumber numberWithFloat:0]];
    
    return _animation;
    
}
@end

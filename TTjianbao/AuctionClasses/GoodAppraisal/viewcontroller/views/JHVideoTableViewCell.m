//
//  JHVideoTableViewCell.m
//  TTjianbao
//
//  Created by yaoyao on 2019/4/11.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHVideoTableViewCell.h"
#import "TTjianbaoHeader.h"
#import "NSString+AttributedString.h"

@interface JHVideoTableViewCell ()
@property(strong,nonatomic)UIImageView * circleImage;
@property(strong,nonatomic)UIImageView * animationCircle;
@property(strong,nonatomic)UIImageView * liveBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toHeaderHeight;
@property (weak, nonatomic) IBOutlet UIImageView *crowIcon;   ///大客户感知


@end

@implementation JHVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _sliderView.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
    _sliderView.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    _sliderView.minimumTrackTintColor = [UIColor whiteColor];
    _sliderView.sliderHeight = 1;
    _sliderView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar:)];
    [_avatar addGestureRecognizer:tap];
    
    [self.cellControlView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView:)]];
    _nickLabel.shadowOffset = CGSizeZero;
    _nickLabel.shadowColor = HEXCOLOR(0x666666);
    _desLabel.shadowOffset = CGSizeZero;
    _desLabel.shadowColor = HEXCOLOR(0x666666);
    if (UI.bottomSafeAreaHeight>0.0) {
        _controlToBottomHeight.constant = UI.bottomSafeAreaHeight;

        _playerToBottomHeight.constant = UI.bottomSafeAreaHeight;
        self.bottomView.backgroundColor = [UIColor blackColor];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(UI.bottomSafeAreaHeight);
        }];
    }
    
     _circleImage=[[UIImageView alloc]init];
     _circleImage.image=[UIImage imageNamed:@"appraisal_circle3"];
     [self.cellControlView addSubview:_circleImage];
     [_circleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_avatar);
        make.size.mas_equalTo(CGSizeMake(40,40));
    }];
  
    _animationCircle=[[UIImageView alloc]init];
    _animationCircle.image=[UIImage imageNamed:@"appraisal_circle3"];
    [_circleImage addSubview:_animationCircle];
    [_animationCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_circleImage);
    }];
    _liveBack=[[UIImageView alloc]init];
    _liveBack.image=[UIImage imageNamed:@"appraisal_play_back"];
    [_circleImage addSubview:_liveBack];
    [_liveBack mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_circleImage).offset(35);
        make.centerX.equalTo(_circleImage);
    }];
    
    UIImageView  *logo=[[UIImageView alloc]init];
    logo.image=[UIImage imageNamed:@"appraisal_top_logo"];
    [_liveBack addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_liveBack).offset(5);
        make.centerY.equalTo(_liveBack);
    }];
    
    UILabel *status=[[UILabel alloc]init];
    status.text=@"直播中";
    status.font=[UIFont systemFontOfSize:9];
    status.textColor=[UIColor whiteColor];
    status.numberOfLines = 1;
    status.textAlignment = UIControlContentHorizontalAlignmentCenter;
    status.lineBreakMode = NSLineBreakByWordWrapping;
    [_liveBack addSubview:status];
    
    [status mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(logo.mas_right).offset(5);
        make.centerY.equalTo(_liveBack);
    }];
    
     [_liveBack setHidden:YES];
     [_circleImage setHidden:YES ];
     [_animationCircle setHidden:YES ];

    JHLodingImageView *image = [[JHLodingImageView alloc] initWithFrame:CGRectZero];
    image.frame = CGRectMake(0,ScreenH-UI.bottomSafeAreaHeight-52,ScreenW, 2);
    [self.contentView addSubview:image];
    self.loadingView = image;

}

- (void)setModel:(AppraisalDetailMode *)model {
    _model = model;
    if (model.appraiser.avatar.length) {
        [_avatar nim_setImageWithURL:[NSURL URLWithString:model.appraiser.avatar] placeholderImage:kDefaultAvatarImage];
    }else {
        _avatar.image = kDefaultAvatarImage;
    }
    _nickLabel.text = [@"鉴定师" stringByAppendingString:model.appraiser.nick?:@""];
    _desLabel.text = model.title;
    
    [_crowIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
    }];
    
    _followBtn.hidden = model.isFollow;
    [_commentBtn setTitle:[NSString stringWithFormat:@" %@",[CommHelp changeAsset:model.comments]] forState:UIControlStateNormal];
    [_likeBtn setTitle:[NSString stringWithFormat:@" %@",model.laudsStr] forState:UIControlStateNormal];
    _likeBtn.selected = model.isLaud;
    self.trueBtn.selected = !model.appraiseResult;
    self.priceBtn.hidden = !model.appraiseResult;
    
    if (![CommHelp isAvailablePrice:model.price]) {
        if (![CommHelp isAvailablePrice:model.priceStr]) {
            [self.priceBtn setTitle:@"暂无估价" forState:UIControlStateNormal];
        } else {
            NSString *price = [NSString stringWithFormat:@"   评估价 ￥%@   ", model.priceStr];
            [self.priceBtn setAttributedTitle:[price attributedSubString:@"评估价" font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] color:[UIColor whiteColor] allColor:[UIColor whiteColor] allfont:[UIFont fontWithName:@"PingFangSC-Regular" size:12]] forState:UIControlStateNormal];
        }
    } else {
        NSString *price = [NSString stringWithFormat:@"   评估价 ￥%@   ", model.price];
        [self.priceBtn setAttributedTitle:[price attributedSubString:@"评估价" font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] color:[UIColor whiteColor] allColor:[UIColor whiteColor] allfont:[UIFont fontWithName:@"PingFangSC-Regular" size:12]] forState:UIControlStateNormal];
    }
    

    [self.coverImagView jhSetImageWithURL:[NSURL URLWithString:model.coverImg] placeholder:nil];
    self.coverImagView.contentMode = UIViewContentModeScaleAspectFill;
    [self refreshAnimation];
    
}

- (void)refreshAnimation {
    if ([_model.appraiser.liveState boolValue]) {
        [self.animationCircle setHidden:NO ];
        [self.circleImage setHidden:NO];
        [_liveBack setHidden:NO];
        [self beginAnimation];
        self.toHeaderHeight.constant = 20;
    }
    else{
        [self.animationCircle setHidden:YES ];
        [self.circleImage setHidden:YES];
        [_liveBack setHidden:YES];
        [self removeAnimation];
        self.toHeaderHeight.constant = 10;

    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)tapBackView:(UIGestureRecognizer *)gest {
    gest.view.tag = JHVideoTableViewCellClickTypeBackView;
    if (self.clickblock) {
        self.cellControlView.hidden = YES;
        self.clickblock(gest.view);
    }

}

- (void)tapAvatar:(UIGestureRecognizer *)gest {
    gest.view.tag = JHVideoTableViewCellClickTypeHeader;
    if (self.clickblock) {
        self.clickblock(gest.view);
    }

}



- (IBAction)commentAction:(UIButton *)sender {
    if (self.clickblock) {
        sender.tag = JHVideoTableViewCellClickTypeCommentList;
        self.clickblock(sender);
    }
    
}
- (IBAction)followAction:(UIButton *)sender {
    if (self.clickblock) {
        sender.tag = JHVideoTableViewCellClickTypeFollow;
        self.clickblock(sender);
    }

}
- (IBAction)likeAction:(UIButton *)sender {
    if (self.clickblock) {
        sender.tag = JHVideoTableViewCellClickTypeLike;
        self.clickblock(sender);
    }

}
- (IBAction)reportAction:(UIButton *)sender {
    if (self.clickblock) {
        sender.tag = JHVideoTableViewCellClickTypeReporter;
        self.clickblock(sender);
    }

}

- (IBAction)sayWhatAction:(UIButton *)sender {
    if (self.clickblock) {
        sender.tag = JHVideoTableViewCellClickTypeSayWhat;
        self.clickblock(sender);
    }

}

- (void)removeAnimation {
    [self.animationCircle.layer removeAllAnimations];
    [self.avatar.layer removeAllAnimations];
}

- (void)beginAnimation{
    [self beginAnimation_headImage];
    [self beginAnimation_circle];
}
- (void)beginAnimation_headImage
{
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = 1.0;
    group.repeatCount = MAXFLOAT;
    CABasicAnimation *animation1 = [self scaleAnimationFrom:1 to:1.2 begintime:0];
    CABasicAnimation *animation2 = [self scaleAnimationFrom:1.2 to:1 begintime:0.5];
    [group setAnimations:[NSArray arrayWithObjects:animation1,animation2, nil]];
    [_avatar.layer addAnimation:group forKey:@"scale"];
}
- (void)beginAnimation_circle
{
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = 1.0;
    group.repeatCount = MAXFLOAT;
    CABasicAnimation *animation1 = [self scaleAnimationFrom:1 to:1.2 begintime:0];
    [group setAnimations:[NSArray arrayWithObjects:animation1,[self alphaAnimation], nil]];
    [self.animationCircle.layer addAnimation:group forKey:@"scale"];
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

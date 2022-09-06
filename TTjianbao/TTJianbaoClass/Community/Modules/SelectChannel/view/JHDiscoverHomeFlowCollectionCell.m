//
//  JHDiscoverHomeFlowCollectionCell.m
//  TTjianbao
//
//  Created by mac on 2019/5/20.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHDiscoverHomeFlowCollectionCell.h"
#import "JHDiscoverChannelCateModel.h"
#import "CTopicDetailModel.h"

#import "UIImage+GIF.h"
#import "TTjianbaoHeader.h"
#import "CommonTool.h"
#import "JHTagAttributeLabel.h"

#define cellRate (float)  1334./750.f //240/170
@interface JHDiscoverHomeFlowCollectionCell ()
/// backView
//@property (nonatomic , weak) UIView * backView;
//coverImage是wep且网慢时，会显示默认图，staticImgView存在就是为了减少默认图展示的时间，让用户更早的看到内容
@property (strong, nonatomic)  UIImageView *staticImgView;
@property (strong, nonatomic)  UIImageView *coverImage;
//@property(nonatomic, strong) UILabel *saleLab;

@property(nonatomic, strong) UIImageView *playVideoImage;//视频或者直播中图标
@property (nonatomic, strong) UIView *liveStoreView;//直播中的tag
@property(nonatomic, strong) UIView *flagsView;

@property (strong, nonatomic)  JHTagAttributeLabel* titleLabel;
@property(nonatomic, strong) UIImageView *userImage;
@property(nonatomic, strong) UIImageView *userVerifyImage;

@property(nonatomic, strong) UILabel *userNameLab;
@property (strong, nonatomic) UIView *likeView;
@property (strong, nonatomic) UIImageView *circle;

@property (nonatomic, weak) UIButton *noInterestBtn;

//-------2.1.0 新增话题
@property (nonatomic, strong) UIView *topicMaskView;        //半透明蒙版
@property (nonatomic, strong) UIImageView *topicIcon;       //“#” 号图标
@property (nonatomic, strong) UILabel *topicTitleLabel;     //标题
@property (nonatomic, strong) UILabel *topicContentLabel;   //内容

//-------2.1.0 新增特卖
@property (nonatomic, strong) UILabel *salePriceTipLabel;    //2.1.0 新增特卖"一口价"文本
@property (nonatomic, strong) UILabel *salePriceLabel;  //2.1.0 新增特卖一口价 价格
@property (nonatomic, strong) UILabel *oriPriceLabel; //原价

//-------2.2.6 新增违规贴
@property (nonatomic, strong) UIView *banMaskView; //半透明背景
@property (nonatomic, strong) UIImageView *banIcon; //违规贴图片




@end

@implementation JHDiscoverHomeFlowCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.layer.cornerRadius = 4;
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _staticImgView = [[UIImageView alloc]init];
        _staticImgView.clipsToBounds = YES;
        [self.contentView addSubview:_staticImgView];
        
        _coverImage=[[UIImageView alloc]init];
        _coverImage.clipsToBounds = YES;
        _coverImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_coverImage];
        //_coverImage.hidden = YES;
        
        _playVideoImage = [UIImageView new];
        _playVideoImage.image = [UIImage imageNamed:@"dis_videoPlay"];
        [_coverImage addSubview:_playVideoImage];
        
        _titleLabel = [[JHTagAttributeLabel alloc]init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.numberOfLines = 0;
//        _titleLabel.text = @"天然翡翠A货精雕霸气神龙 霸气神龙霸气神龙霸…天然翡翠A货精雕霸气神龙 霸气神龙霸气神龙霸…天然翡翠A货精雕霸气神龙 霸气神龙霸气神龙霸…";
        _titleLabel.text = @"";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_titleLabel];
        
        _userImage = [UIImageView new];
        _userImage.layer.cornerRadius = 9.0f;
        _userImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_userImage];
        _userImage.userInteractionEnabled = YES;
        
        _userVerifyImage = [[UIImageView alloc]init];
        _userVerifyImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_userVerifyImage];
        
        _userNameLab=[[UILabel alloc]init];
        _userNameLab.font=[UIFont fontWithName:@"PingFangSC-Medium" size:11];
        _userNameLab.textColor=HEXCOLOR(0x666666);
        _userNameLab.text=@"喜文乐见";
        _userNameLab.textAlignment = NSTextAlignmentLeft;
        _userNameLab.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_userNameLab];
        
        _likeView=[[UIView alloc]init];
        _likeView.userInteractionEnabled=YES;
        [_likeView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_likeView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_likeView];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(Like)];
        [_likeView  addGestureRecognizer:tap];
        
        _likeImageView=[[UIImageView alloc] init];
        [_likeView addSubview:_likeImageView];
        [_likeImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_likeImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _likeImageView.image = [UIImage imageNamed:@"dis_unstroke"];
        
        _circle=[[UIImageView alloc]init];
        _circle.image=[UIImage imageNamed:@"appraisal_circle3"];
        [_likeView addSubview:_circle];
        
        [_circle setHidden:YES];
        
        _likeCountLabel=[[UILabel alloc]init];
        _likeCountLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _likeCountLabel.textColor=HEXCOLOR(0x666666);
        _likeCountLabel.numberOfLines = 1;
        _likeCountLabel.text=@"1111";
        _likeCountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _likeCountLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
        [_likeCountLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_likeCountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_likeView addSubview:_likeCountLabel];
        
        //--------------------- 下面是新增
        [self addTopicView];
        [self addSaleView];
        [self addBanView];
        
        self.disInterestV.hidden = YES;
        
        [self showTopicView:NO];
        [self showSaleView:NO];
        [self showBanView:NO];
    }
    return self;
}

//话题样式
- (void)addTopicView {
    //2.1.0新增话题类型半透明蒙版
    _topicMaskView = [[UIView alloc] init];
    _topicMaskView.clipsToBounds = YES;
    _topicMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.contentView addSubview:_topicMaskView];
    
    //2.1.0新增话题类型 “#” 号图标
    _topicIcon = [[UIImageView alloc] init];
    _topicIcon.image = [UIImage imageNamed:@"sq_icon_topic_tag"];
    [self.contentView addSubview:_topicIcon];
    
    //话题标题
    _topicTitleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:15.0] textColor:[UIColor whiteColor]];
    _topicTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_topicTitleLabel];
    
    //话题内容
    _topicContentLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontLight size:12.0] textColor:[UIColor whiteColor]];
    _topicContentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_topicContentLabel];
    
    //----布局
    [_topicMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_topicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(22.0);
    }];
    
    [_topicIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_topicTitleLabel.mas_top).offset(-10.0);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(15.0, 15.0));
    }];
    
    [_topicContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topicTitleLabel.mas_bottom).offset(10.0);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(17.0);
    }];
}

//特卖样式
- (void)addSaleView {
    //-------2.1.0 新增特卖
    _salePriceTipLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:12.0] textColor:kColor999];
    _salePriceTipLabel.text = @"一口价：";
    [self.contentView addSubview:_salePriceTipLabel];
    
    _salePriceLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontBoldDIN size:16.0] textColor:kColorMainRed];
    [self.contentView addSubview:_salePriceLabel];
    
    _oriPriceLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:10] textColor:kColor999];
    [self.contentView addSubview:_oriPriceLabel];
    
    [_salePriceTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(7.0);
        make.bottom.equalTo(self.contentView).offset(-9);
        make.size.mas_equalTo(CGSizeMake(48.0, 18.0));
    }];
    
    [_salePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_salePriceTipLabel.mas_right);
        make.centerY.equalTo(_salePriceTipLabel);
        make.width.greaterThanOrEqualTo(@(20)); //大于等于
    }];
    
    [_oriPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_salePriceLabel.mas_right).offset(2.0);
        make.right.equalTo(self.contentView.mas_right).offset(-7);
        make.centerY.equalTo(_salePriceLabel).offset(2);
    }];
    
    /**
     * 设置layout优先级
     * Content Hugging Priority: 该优先级表示一个控件抗被拉伸的优先级。优先级越高，越不容易被拉伸，默认是250。
     * Content Compression Resistance Priority: 该优先级和上面那个优先级相对应，表示一个控件抗压缩的优先级。优先级越高，越不容易被压缩，默认是750
     */
    [_salePriceLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                       forAxis:UILayoutConstraintAxisHorizontal];
    [_oriPriceLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh
                                                    forAxis:UILayoutConstraintAxisHorizontal];
}


//2.2.6 新增违规帖样式
- (void)addBanView {
    _banMaskView = [[UIView alloc] init];
    _banMaskView.clipsToBounds = YES;
    _banMaskView.backgroundColor = [UIColor colorWithHexStr:@"999999" alpha:0.7];
    [self.contentView addSubview:_banMaskView];
    
    _banIcon = [[UIImageView alloc] init];
    _banIcon.image = [UIImage imageNamed:@"cell_icon_ban"];
    _banIcon.clipsToBounds = YES;
    _banIcon.contentMode = UIViewContentModeScaleAspectFit;
    [_banMaskView addSubview:_banIcon];
    
    //----布局
    [_banMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_banIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.coverImage).insets(UIEdgeInsetsMake(0, 18, 0, 18));
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.flagsView removeAllSubviews];
    [_liveStoreView removeFromSuperview];
    _liveStoreView = nil;
}

- (void)longGes:(UILongPressGestureRecognizer *)longGes {
    if (self.canDisInterest) {
        [self.contentView addSubview:self.disInterestV];
        [self.disInterestV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.contentView);
        }];
        [self.noInterestBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_disInterestV).offset(22);
            make.right.equalTo(self->_disInterestV).offset(-22);
            make.top.equalTo(self->_disInterestV).offset((self.recordMode.picHeight - 35)/2);
            make.height.equalTo(@35);
        }];
        self.disInterestV.hidden = NO;
    }
}

-(void)Like{
    
    if ([self isLgoin]) {
        NSInteger isLaud = self.recordMode.is_like;
        
        if (self.cellClick) {
            self.cellClick(isLaud,_cellIndex);
        }
    }
}

- (void)beginAnimation:(JHDiscoverChannelCateModel*)mode
{
    self.recordMode = mode;
    if (mode.is_like == 1) {
        self.likeImageView.image=[UIImage imageNamed:@"dis_stroke"];
        [_circle setHidden:NO];
        [self beginAnimation_circle];
    }else{
        [_circle setHidden:YES];
        self.likeImageView.image=[UIImage imageNamed:@"dis_unstroke"];
    }
    
    _likeCountLabel.text = mode.like_num;
    [self beginAnimation_Logo];
}

- (void)beginAnimation_Logo
{
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = 0.6;
    group.repeatCount = 1;
    CABasicAnimation *animation1 = [self scaleAnimationFrom:1 to:0.5 begintime:0];
    CABasicAnimation *animation2 = [self scaleAnimationFrom:0.5 to:1.5 begintime:0.2];
    CABasicAnimation *animation3 = [self scaleAnimationFrom:1.5 to:1 begintime:0.4];
    [group setAnimations:[NSArray arrayWithObjects:animation1,animation2,animation3, nil]];
    [self.likeImageView.layer addAnimation:group forKey:@"scale"];
}
- (void)beginAnimation_circle
{
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = 0.6;
    group.repeatCount = 1;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    CABasicAnimation *animation1 = [self scaleAnimationFrom:1 to:1.5 begintime:0];
    [group setAnimations:[NSArray arrayWithObjects:animation1,[self alphaAnimation], nil]];
    [_circle.layer addAnimation:group forKey:@"scale"];
}

-(CABasicAnimation *)scaleAnimationFrom:(CGFloat)from to:(CGFloat)to begintime:(CGFloat)beginTime
{
    CABasicAnimation *_animation = [[CABasicAnimation alloc] init];
    [_animation setKeyPath:@"transform.scale"];
    _animation.duration = 0.2;
    _animation.beginTime = beginTime;
    _animation.removedOnCompletion = false;
    [_animation setFromValue:[NSNumber numberWithFloat:from]];
    [_animation setToValue:[NSNumber numberWithFloat:to]];
    return _animation;
    
}
-(CABasicAnimation *)alphaAnimation{
    
    CABasicAnimation *_animation = [[CABasicAnimation alloc] init];
    [_animation setKeyPath:@"opacity"];
    _animation.duration = 0.6;
    _animation.beginTime = 0;
    [_animation setFromValue:[NSNumber numberWithFloat:1]];
    [_animation setToValue:[NSNumber numberWithFloat:0]];
    return _animation;
}

- (void)setRecordMode:(JHDiscoverChannelCateModel *)recordMode {
    _recordMode = recordMode;
    [_circle setHidden:YES];
    
    //2.1.0新增
    [self showTopicView:NO];
    [self showSaleView:NO];
    
    if (recordMode.layout == 1) {//图文
        _staticImgView.backgroundColor = [UIColor whiteColor];
    } else {
        _staticImgView.backgroundColor = [UIColor blackColor];
    }
    
    NSString *staticImgUrl = [_recordMode.static_image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *coverImgUrl = [_recordMode.image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"----[recordMode.staticImg] = %@", staticImgUrl);
    NSLog(@"----[recordMode.coverImg] = %@", coverImgUrl);
    
    
    [_staticImgView setImageWithURL:[NSURL URLWithString:staticImgUrl] placeholder:[UIImage imageNamed:@"cover_default_list"]];
    
    _coverImage.contentMode = UIViewContentModeScaleAspectFill;
    
    [_coverImage jhSetImageWithURL:[NSURL URLWithString:coverImgUrl]];
    
    if ((_recordMode.item_type != 30) && (_recordMode.layout == JHSQLayoutTypeVideo || _recordMode.layout == JHSQLayoutTypeAppraisalVideo)) {
        _playVideoImage.hidden = NO;
        _playVideoImage.frame = CGRectMake(self.contentView.width-18-5, 5, 18, 18);
        [_liveStoreView removeFromSuperview];
        _liveStoreView = nil;
        
    } else if (_recordMode.layout == JHSQLayoutTypeLiveStore) {
        _playVideoImage.hidden = YES;
        [self.contentView addSubview:self.liveStoreView];
        [self.liveStoreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@22);
            make.top.equalTo(self->_coverImage).offset(5);
            make.right.equalTo(self->_coverImage.mas_right).offset(-5);
        }];
    
    } else {
        _playVideoImage.hidden = YES;
    }
    
    if (_recordMode.flag_images.count) {
        [self addFlagViews];
    }
    
    //广告位隐藏标题等，只显示图片
    if (_recordMode.layout == JHSQLayoutTypeAD) {
        _titleLabel.attributedText = nil;
        _titleLabel.text = nil;
        _titleLabel.hidden = YES;
        
        _userImage.hidden = YES;
        _userVerifyImage.hidden = YES;
        _userNameLab.hidden = YES;
        _likeImageView.hidden = YES;
        _likeCountLabel.hidden = YES;
    }
    else {
        _titleLabel.hidden = NO;
        _userImage.hidden = NO;
        _userVerifyImage.hidden = NO;
        _userNameLab.hidden = NO;
        _likeImageView.hidden = NO;
        _likeCountLabel.hidden = NO;
        
        _titleLabel.numberOfLines = _recordMode.title_row;
        _titleLabel.text = _recordMode.title?:@"";
        if ([_recordMode.content_tag isNotBlank]) {
            _titleLabel.tagTitle = _recordMode.content_tag;
        }
        else {
            _titleLabel.tagTitle = nil;
        }
                
        
        [_userImage jhSetImageWithURL:[NSURL URLWithString:_recordMode.publisher.avatar] placeholder: kDefaultAvatarImage];
        
        if (_recordMode.publisher.role == 1) {
            _userVerifyImage.hidden = NO;
            _userVerifyImage.image = [UIImage imageNamed:@"dis_appraiserVerify"];
        }else if (_recordMode.publisher.is_certification == 1) {
            _userVerifyImage.hidden = NO;
            _userVerifyImage.image = [UIImage imageNamed:@"dis_providerVerify"];
        }else {
            _userVerifyImage.hidden = YES;
        }
        
        _userNameLab.text = _recordMode.publisher.user_name;
        
        //卖场直播间不展示喜欢数
        if (_recordMode.layout == JHSQLayoutTypeLiveStore) {
            _likeImageView.hidden = YES;
            _likeCountLabel.hidden = YES;
        } else {
            _likeImageView.hidden = NO;
            _likeCountLabel.hidden = NO;
            if (_recordMode.is_like) {
                _likeImageView.image=[UIImage imageNamed:@"dis_stroke"];
            } else{
                _likeImageView.image=[UIImage imageNamed:@"dis_unstroke"];
            }
            _likeCountLabel.text = _recordMode.like_num;
        }
    }
    
    self.disInterestV.hidden = YES;
    
    //新增话题
    if (_recordMode.item_type == JHSQItemTypeTopic && _recordMode.layout == JHSQLayoutTypeTopic) {
        [self showTopicView:YES];
        _topicTitleLabel.text = _recordMode.title;
        _topicContentLabel.text = _recordMode.content;
    }
    
    //新增特卖
    if (_recordMode.saleInfo
        && [recordMode.saleInfo.price isNotBlank]
        && [self getDiffValueWithStart:recordMode.saleInfo.server_time end:recordMode.saleInfo.end_time] > 0) {
        
        [self showSaleView:YES];
        _salePriceLabel.text = recordMode.saleInfo.price;
        [_salePriceLabel sizeToFit];
        [self setOriPriceStr:recordMode.price];
    }
    
    //新增违规贴样式
    [self showBanView:(recordMode.status == 2)];
}

//设置原价
- (void)setOriPriceStr:(NSString *)oriStr {
    if (!oriStr) {return;}
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]
     initWithString:oriStr attributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:10],
                                        NSForegroundColorAttributeName:kColor999, NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                        NSStrikethroughColorAttributeName:kColor999}];
    _oriPriceLabel.attributedText = attrStr;
    [_oriPriceLabel sizeToFit];
}

//时间差
- (NSInteger)getDiffValueWithStart:(NSString *)startStr end:(NSString *)endStr {
    NSDate *startDate = [self getDateFromTimestamp:startStr];
    NSDate *endDate = [self getDateFromTimestamp:endStr];
    
    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
    return timeInterval;
}

//时间戳转日期
- (NSDate *)getDateFromTimestamp:(NSString *)timestamp {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]];
    return confromTimesp;
}

- (void)addFlagViews {
    if (!self.flagsView) {
        self.flagsView = [UIView new];
        self.flagsView.backgroundColor = [UIColor clearColor];
        [self.coverImage addSubview:self.flagsView];
    }

    [self.flagsView removeAllSubviews];
    [self.coverImage bringSubviewToFront:self.coverImage];
    
    __block CGFloat startY = 9;
    __block CGFloat maxWidth = 0;
    for (NSString *flagUrl in self.recordMode.flag_images) {
        if (flagUrl.length) {
            UIImageView *imgView = [UIImageView new];
            [imgView jhSetImageWithURL:[NSURL URLWithString:flagUrl] placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
                if (image) {
                    CGFloat width = image.size.width/image.size.height*19.0;
                    imgView.frame = CGRectMake(0, startY, width, 19);
                    startY += 19;
                    maxWidth = MAX(maxWidth, width);
                    imgView.image = image;
                }
            }];

            [self.flagsView addSubview:imgView];
        }
    }
    self.flagsView.frame = CGRectMake(0, 0, maxWidth, startY);
}

#if 1
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _staticImgView.frame = CGRectMake(0, 0, self.contentView.width, self.recordMode.picHeight);
    
    _coverImage.frame = CGRectMake(0, 0, self.contentView.width, self.recordMode.picHeight);
    
    _titleLabel.frame = CGRectMake(7, CGRectGetMaxY(_coverImage.frame)+3, self.contentView.width - 14, self.recordMode.titleHeight);
    
    _userImage.frame = CGRectMake(7, self.contentView.height - 18 - 9, 18, 18);
    
    _userVerifyImage.frame = CGRectMake(CGRectGetMaxX(_userImage.frame)-7, CGRectGetMaxY(_userImage.frame)-7, 7, 7);
    
    [_likeImageView sizeToFit];
    _likeImageView.frame = CGRectMake(3, (18 - _likeImageView.height)*0.5, _likeImageView.width, _likeImageView.height);
    
    [_likeCountLabel sizeToFit];
    _likeCountLabel.frame = CGRectMake(CGRectGetMaxX(_likeImageView.frame)+2, (18-_likeCountLabel.height)*0.5, _likeCountLabel.width+2, _likeCountLabel.height);
    
    _likeView.frame = CGRectMake(self.contentView.width - (3+_likeImageView.width+2+_likeCountLabel.width+3)-5, self.userImage.y - (20 -18)*0.5, 3+_likeImageView.width+2+_likeCountLabel.width+3, 20);
    
    
    [_circle sizeToFit];
    _circle.frame = CGRectMake(0, 0, 15, 15);
    _circle.center = _likeImageView.center;
    
    [_likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-5);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.userImage);
    }];
    [_likeImageView sizeToFit];
    [_likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeView).offset(3);
        make.centerY.equalTo(self.likeView);
        make.size.mas_equalTo(CGSizeMake(self.likeImageView.width, self.likeImageView.height));
    }];
    [_likeCountLabel sizeToFit];
    [_likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeImageView.mas_right).offset(2);
        make.right.centerY.equalTo(self.likeView);
    }];
    [_userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImage.mas_right).offset(3);
        make.centerY.equalTo(self.userImage);
        make.right.lessThanOrEqualTo(self.likeView.mas_left).offset(-3);
    }];
}
#endif

- (UIView *)disInterestV {
    if (!_disInterestV) {
        _disInterestV = [[UIView alloc]initWithFrame:self.bounds];
        _disInterestV.backgroundColor = HEXCOLORA(0xffffff, 0.7);
        
        UIButton *noInterestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [noInterestBtn setImage:[UIImage imageNamed:@"dis_noInterest"] forState:UIControlStateNormal];
        [noInterestBtn setTitle:@"  不感兴趣" forState:UIControlStateNormal];
        noInterestBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        [noInterestBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [noInterestBtn addTarget:self action:@selector(disInterest) forControlEvents:UIControlEventTouchUpInside];
        noInterestBtn.layer.cornerRadius = 17.5;
        noInterestBtn.backgroundColor = [UIColor whiteColor];
        self.noInterestBtn = noInterestBtn;
        [_disInterestV addSubview:noInterestBtn];
    
        _disInterestV.hidden = YES;
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDismissDisInterestV)];
        _disInterestV.userInteractionEnabled = YES;
        [_disInterestV addGestureRecognizer:ges];
    
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGes:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:longGes];
    }
    return _disInterestV;
}


//2.1.0 新增 - 显示/隐藏话题视图
- (void)showTopicView:(BOOL)show {
    _topicMaskView.hidden = !show;
    _topicIcon.hidden = !show;
    _topicTitleLabel.hidden = !show;
    _topicContentLabel.hidden = !show;
    
    if (show) {
        _titleLabel.attributedText = nil;
        _titleLabel.text = nil;
        _titleLabel.hidden = YES;
        
        [self showSaleView:NO];
        
        _userImage.hidden = YES;
        _userVerifyImage.hidden = YES;
        _userNameLab.hidden = YES;
        _likeImageView.hidden = YES;
        _likeCountLabel.hidden = YES;
    }
}

//2.1.0 新增 - 显示/隐藏特卖视图
- (void)showSaleView:(BOOL)show {
    _salePriceTipLabel.hidden = !show;
    _salePriceLabel.hidden = !show;
    _oriPriceLabel.hidden = !show;
    
    if (show) {
        _userImage.hidden = YES;
        _userVerifyImage.hidden = YES;
        _userNameLab.hidden = YES;
        _likeImageView.hidden = YES;
        _likeCountLabel.hidden = YES;
    }
}

//2.2.6新增 - 违规贴视图
- (void)showBanView:(BOOL)show {
    _banMaskView.hidden = !show;
    _banIcon.hidden = !show;
    [self.contentView bringSubviewToFront:_banMaskView];
}

- (UIView *)liveStoreView {
    if (!_liveStoreView) {
        _liveStoreView = [[UIView alloc] init];
        _liveStoreView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        _liveStoreView.layer.cornerRadius = 2;
        _liveStoreView.alpha=0.8;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"home_list_new_play" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        YYImage *image = [YYImage imageWithData:data];
        
        YYAnimatedImageView *playingImgView=[[YYAnimatedImageView alloc]initWithImage:image];
        playingImgView.contentMode=UIViewContentModeScaleAspectFit;
//        UIImage* gifImage = [UIImage sd_imageWithGIFData:data];
//        playingImgView.image = gifImage;
        [_liveStoreView addSubview:playingImgView];
        
        [playingImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->_liveStoreView);
            make.left.equalTo(self->_liveStoreView).offset(5);
            make.size.mas_equalTo(CGSizeMake(15, 17));
        }];
        
        UILabel *status=[[UILabel alloc]init];
        status.text=@"直播中";
        status.font=[UIFont systemFontOfSize:12];
        status.textColor=[CommHelp toUIColorByStr:@"#fee100"];
        status.numberOfLines = 1;
        status.textAlignment = UIControlContentHorizontalAlignmentCenter;
        status.lineBreakMode = NSLineBreakByWordWrapping;
        [_liveStoreView addSubview:status];
        [status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->_liveStoreView);
            make.right.equalTo(self->_liveStoreView.mas_right).offset(-5);
            make.left.equalTo(playingImgView.mas_right).offset(5);
        }];
    }
    return _liveStoreView;
}

- (void)tapDismissDisInterestV {
    self.disInterestV.hidden = YES;
}

- (void)disInterest {
    NSLog(@"点击不感兴趣");
    if ([self isLgoin]) {
        if (self.disInterestBlock) {
            self.disInterestBlock(self.recordMode);
        }
    }
}

- (BOOL)isLgoin{
    
    if (![JHRootController isLogin]) {
        NSLog(@"curr = %@ , jsd = %@", [CommonTool findNearsetViewController:self], [JHRootController currentViewController]);
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {
        }];
        
        return NO;
    }
    
    return YES;
}

@end

//
//  JHHomeCollectionViewCell.m
//  TTjianbao
//
//  Created by jiangchao on 2019/2/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHHomeCollectionViewCell.h"
#import "TTjianbaoHeader.h"

#define cellRate (float)  1334./750.f //240/170

@interface JHHomeCollectionViewCell ()
{
    UIImageView *circle;
}
@property (strong, nonatomic)  YYAnimatedImageView *coverImage;
@property (strong, nonatomic)  UIButton *apprassalProductStatus;
@property (strong, nonatomic)  UILabel* title;
//@property (strong, nonatomic)  UILabel* name;
@property (strong, nonatomic)  UILabel *quality;
@property (strong, nonatomic)  UILabel *price;
@property (strong, nonatomic)  UILabel *priceLabel;
@property (strong, nonatomic)  UIButton *likeButton;
@property (strong, nonatomic)  UIButton *lookButton;

@property (strong, nonatomic)   UIView * line;
@property (strong, nonatomic)   UIView * verticalLine;
@property (strong, nonatomic)   UIView * likeView;
@end
@implementation JHHomeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        UIView * backView=[[UIView alloc]init];
        backView.layer.cornerRadius = 4;
        backView.layer.masksToBounds = YES;
        backView.clipsToBounds = YES;
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
         _coverImage=[[YYAnimatedImageView alloc]init];
         _coverImage.layer.masksToBounds = YES;
         [backView addSubview:_coverImage];
        [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.right.offset(0);
            make.height.offset((ScreenW-25)/2*cellRate);
        }];

        _title=[[UILabel alloc]init];
        _title.font=[UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _title.backgroundColor=[UIColor clearColor];
        _title.textColor=HEXCOLOR(0x333333);
        _title.numberOfLines = 1;
        _title.text=@"";
        _title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _title.numberOfLines = 2;
        _title.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_title];
      
        _likeView=[[UIView alloc]init];
        _likeView.userInteractionEnabled=YES;
        [_likeView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_likeView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_likeView];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(Like)];
        [_likeView  addGestureRecognizer:tap];
        [_likeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(30);
            make.top.equalTo(_title.mas_bottom).offset(-2);
            make.right.equalTo(_coverImage).offset(-5);
        }];
          
        _likeImageView=[[UIImageView alloc] init];
        [_likeView addSubview:_likeImageView];
        [_likeImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_likeImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_likeView).offset(0);
            make.size.mas_equalTo(CGSizeMake(14, 14));
            make.left.equalTo(_likeView).offset(5);
        }];
        
        circle=[[UIImageView alloc]init];
        circle.image=[UIImage imageNamed:@"appraisal_circle3"];
        [_likeView addSubview:circle];
        [circle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_likeImageView);
             make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        [circle setHidden:YES];
        
        _likeCountLabel=[[UILabel alloc]init];
        _likeCountLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _likeCountLabel.backgroundColor=[UIColor clearColor];
        _likeCountLabel.textColor=HEXCOLOR(0x666666);
        _likeCountLabel.numberOfLines = 1;
        _likeCountLabel.text=@"";
        _likeCountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _likeCountLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
        [_likeCountLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_likeCountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_likeView addSubview:_likeCountLabel];
        
        [_likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_likeImageView.mas_right).offset(5);
            make.centerY.equalTo(_likeView).offset(0);
            make.right.equalTo(_likeView).offset(-5);
        }];
         
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_coverImage.mas_bottom).offset(8);
            make.left.equalTo(_coverImage).offset(5);
            make.right.equalTo(_coverImage).offset(-5);
        }];
        
        _lookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lookButton setImage:[UIImage imageNamed:@"icon_home_look_count"] forState:UIControlStateNormal];
        [_lookButton setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [_lookButton setTitle:@"4万次播放" forState:UIControlStateNormal];
        _lookButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _lookButton.userInteractionEnabled = NO;
        [self.contentView addSubview:_lookButton];
        [_lookButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(30);
            make.centerY.equalTo(_likeView).offset(0);
            make.left.equalTo(_coverImage).offset(5);
        }];

        _apprassalProductStatus=[[UIButton alloc]init];
        [_apprassalProductStatus setBackgroundImage:[UIImage imageNamed:@"home_appraisal_zhen"] forState:UIControlStateNormal];
        [_apprassalProductStatus setBackgroundImage:[UIImage imageNamed:@"home_appraisal_jia"] forState:UIControlStateSelected];
        _apprassalProductStatus.titleLabel.font=[UIFont systemFontOfSize:12];
        [_apprassalProductStatus setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_apprassalProductStatus setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateSelected];
        _apprassalProductStatus.contentMode = UIViewContentModeScaleAspectFit;
        [_coverImage addSubview:_apprassalProductStatus];
        [_apprassalProductStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_coverImage).offset(10);
            make.left.equalTo(_coverImage).offset(0);
        }];
    }
    return self;
}
-(void)setRecordMode:(AppraisalVideoRecordMode *)recordMode{

    _recordMode=recordMode;
    
    [circle setHidden:YES];
    _title.text= _recordMode.title?:_recordMode.videoTitle;
    // _name.text= [NSString stringWithFormat:@"宝友：%@",_recordMode.goodsHolder];
    _coverImage.contentMode=UIViewContentModeScaleAspectFill;
    
    NSString *coverString=_recordMode.coverImg;//  ThumbSmallByOrginal(_recordMode.coverImg);
    if ([_recordMode.coverImg hasSuffix:@"gif"]) {
        coverString=_recordMode.coverImg;
    }
    JH_WEAK(self)
    [_coverImage jhSetImageWithURL:[NSURL URLWithString: coverString] placeholder:[UIImage imageNamed:@"cover_default_list"] completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        JH_STRONG(self)
        if (!image) {
             self.coverImage.contentMode=UIViewContentModeScaleAspectFill;
       }
    }];
        
    if (_recordMode.appraiseResult == 1) {
        [_apprassalProductStatus setSelected:YES];
         [_apprassalProductStatus setTitle:@"鉴定为真" forState:UIControlStateNormal];
        _priceLabel.text=@"鉴定师估价：约";
        _price.font = [UIFont fontWithName:kFontBoldDIN size:18.f];
        _price.textColor=HEXCOLOR(0x333333);
        _price.text=[@"¥ " stringByAppendingString:_recordMode.priceStr?:@""];
        [_price mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_priceLabel).offset(2);
        }];
    }else {
        if (_recordMode.appraiseResult == 0) {
            [_apprassalProductStatus setTitle:@"鉴定为假" forState:UIControlStateNormal];
            [_apprassalProductStatus setSelected:NO];
        }else{
            [_apprassalProductStatus setTitle:@"部分为真" forState:UIControlStateNormal];
            [_apprassalProductStatus setSelected:YES];
        }
        _price.text=@"暂无估价";
        _priceLabel.text=@"鉴定师估价";
        _price.font = [UIFont systemFontOfSize:14];
        _price.textColor=HEXCOLOR(0x999999);
        [_price mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_priceLabel).offset(0);
        }];
    }
      _likeCountLabel.text=[CommHelp changeAsset:_recordMode.lauds];
    if (_recordMode.isLaud) {
      //  _likeButton.selected=YES;
           _likeImageView.image=[UIImage imageNamed:@"home_zan_select"];
    }
    else{
        //  _likeButton.selected=NO;
          _likeImageView.image=[UIImage imageNamed:@"home_zan_nomal"];
    }
    [_lookButton setTitle:[NSString stringWithFormat:@" %@次播放", recordMode.viewedTimesStr] forState:UIControlStateNormal];
}
- (void)setReporterDetailModel:(JHReporterDetailModel *)reporterDetailModel {
    
    _reporterDetailModel = reporterDetailModel;
    _title.text= _reporterDetailModel.videoTitle;
   // _name.text= [NSString stringWithFormat:@"宝友：%@",reporterDetailModel.goodsHolder];
    _coverImage.contentMode=UIViewContentModeScaleAspectFill;
    
    NSString * coverString=reporterDetailModel.videoCoverImg;//ThumbSmallByOrginal(reporterDetailModel.videoCoverImg);
    if ([_recordMode.coverImg hasSuffix:@"gif"]) {
        coverString=reporterDetailModel.videoCoverImg;
    }
    JH_WEAK(self)
    [_coverImage jhSetImageWithURL:[NSURL URLWithString:coverString] placeholder:[UIImage imageNamed:@"cover_default_list"] completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        JH_STRONG(self)
        if (!image) {
            self.coverImage.contentMode = UIViewContentModeScaleAspectFit;
        }
    }];
    
    if (reporterDetailModel.isGenuine == 1) {
          [_apprassalProductStatus setSelected:YES];
        _priceLabel.text=@"鉴定师估价：约";
        _price.font = [UIFont fontWithName:kFontBoldDIN size:18.f];
        _price.textColor=HEXCOLOR(0x333333);
        _price.text=[@"¥ " stringByAppendingString:_reporterDetailModel.appraisePriceStr?:@""];
        [_price mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_priceLabel).offset(2);
        }];
    }
    else{
           [_apprassalProductStatus setSelected:NO];
        _price.text=@"暂无估价";
        _priceLabel.text=@"鉴定师估价";
        _price.font = [UIFont systemFontOfSize:14];
        _price.textColor=HEXCOLOR(0x999999);
        [_price mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_priceLabel).offset(0);
        }];
    }
    
    if (_reporterDetailModel.isLaud) {
        _likeImageView.image=[UIImage imageNamed:@"home_zan_select"];
    }
    else{
         _likeImageView.image=[UIImage imageNamed:@"home_zan_nomal"];
    }
    
    [_lookButton setTitle:[NSString stringWithFormat:@"%@次播放", reporterDetailModel.viewedTimesStr] forState:UIControlStateNormal];
}

-(void)Report:(UIButton*)button{
    
}
-(void)Like{
    BOOL isLaud = self.recordMode.isLaud;
    if (self.cellClick) {
        self.cellClick(isLaud,_cellIndex);
    }
}
- (void)beginAnimation:(AppraisalVideoRecordMode*)mode {
    if (mode.isLaud) {
        self.likeImageView.image=[UIImage imageNamed:@"home_zan_select"];
        [circle setHidden:NO];
        [self beginAnimation_circle];
    }
    else{
         [circle setHidden:YES];
         self.likeImageView.image=[UIImage imageNamed:@"home_zan_nomal"];
    }
       
    _likeCountLabel.text=[CommHelp changeAsset:mode.lauds];
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
    [circle.layer addAnimation:group forKey:@"scale"];
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


+ (CGFloat)heightCellWithModel:(AppraisalVideoRecordMode *)model {
    CGFloat height = (ScreenW-25)/2*cellRate;
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:14]};
    CGFloat titleH = 0;
    if (model.title && model.title.length > 0) {
  
        titleH = [model.title boundingRectWithSize:CGSizeMake((ScreenW-25)/2 - 10, 50) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.height;

    }
    return height+titleH+35;
}

+ (CGFloat)heightCellWithAnchorModel:(JHReporterDetailModel *)model {
    CGFloat height = (ScreenW-25)/2*cellRate;
    
    NSDictionary *attribute =@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:14]};
    
    
    CGFloat titleH = [model.videoTitle boundingRectWithSize:CGSizeMake((ScreenW-25)/2 - 10, 50) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.height;
    return height+titleH+35;

}
@end

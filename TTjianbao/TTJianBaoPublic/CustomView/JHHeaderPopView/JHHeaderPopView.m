//
//  JHHeaderPopView.m
//  test
//
//  Created by YJ on 2020/12/15.
//  Copyright © 2020 YJ. All rights reserved.
//

#import "JHHeaderPopView.h"
#import "TTJianBaoColor.h"
#import "UIImageView+WebCache.h"
#import "JHHeaderUserInfoModel.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define POPVIEW_WIDHT  287
#define POPVIEW_HEIGHT 361
#define LEFT_PAD       15
#define HEADER_WIDTH   60

#define TIMER  0.3

NSString * const CollectionViewCellID = @"cellID";

@interface JHHeaderPopView ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    NSInteger num;
    CGFloat View_Height;
}
@property (strong, nonatomic) UIView *popView;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UITextView *introduceTextView;
@property (strong, nonatomic) UIView *bacView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;
//@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) UICollectionView *collectionView;


@end

@implementation JHHeaderPopView


- (instancetype)initWithUserInfo:(NSDictionary *)info
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3];
        
        NSString *anchorIcon = [NSString stringWithFormat:@"%@",info[@"anchorIcon"]];//头像
        NSString *anchorDesc = [NSString stringWithFormat:@"%@",info[@"anchorDesc"]];//简介
        NSString *anchorName = [NSString stringWithFormat:@"%@",info[@"anchorName"]];//昵称
        
        NSString *text = anchorDesc;
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.lineSpacing = 5;

        NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:14.0f], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.4f,NSForegroundColorAttributeName:GRAY_COLOR};
        
        CGSize size = [text boundingRectWithSize:CGSizeMake(POPVIEW_WIDHT - LEFT_PAD *2, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];
        
        CGFloat height = size.height;
        
        View_Height = 20 + HEADER_WIDTH + 14 + 22.5 + 10 + 80 + 130 ;
        CGFloat TOP_PAD = 20 + HEADER_WIDTH + 14 + 20 + 20 + 80 + 15;
        
        if (height < 80 )
        {
            View_Height = 0 + HEADER_WIDTH + 14 + 22.5 + 10 + height + 150;
            TOP_PAD = 20 + HEADER_WIDTH + 14 + 20 + 20 + height + 20;
        }
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
        
        self.popView = [[UIView alloc] init];
        self.popView.layer.cornerRadius = 5.0f;
        self.popView.clipsToBounds = YES;
        self.popView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.popView];
        
        UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(POPVIEW_WIDHT - 50, 0, 50, 50)];
        [dismissBtn setImage:[UIImage imageNamed:@"image_close"] forState:UIControlStateNormal];
        [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.popView addSubview:dismissBtn];
        
        self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((POPVIEW_WIDHT - HEADER_WIDTH)/2, 20, HEADER_WIDTH, HEADER_WIDTH)];
        anchorIcon = [anchorIcon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:anchorIcon] placeholderImage:kDefaultAvatarImage];
        self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImageView.layer.cornerRadius = HEADER_WIDTH/2;
        self.headerImageView.clipsToBounds = YES;
        [self.popView addSubview:self.headerImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_PAD, 20 + HEADER_WIDTH + 14, POPVIEW_WIDHT - LEFT_PAD*2, 22.5)];
        self.nameLabel.text = anchorName;
        self.nameLabel.font = [UIFont fontWithName:kFontNormal size:16.0f];
        self.nameLabel.textColor = BLACK_COLOR;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.popView addSubview:self.nameLabel];
        
        self.introduceTextView = [[UITextView alloc] initWithFrame:CGRectMake(LEFT_PAD, self.nameLabel.origin.y + 20 + 10, POPVIEW_WIDHT - LEFT_PAD *2, 80)];
        self.introduceTextView.editable = NO;
        self.introduceTextView.font = [UIFont fontWithName:kFontNormal size:14.0f];
        self.introduceTextView.text = text;
        //self.introduceTextView.attributedText = [self setSpaceWithText:text font:[UIFont fontWithName:kFontNormal size:14.0f] color:GRAY_COLOR];
        
        self.introduceTextView.attributedText = attributeStr;
        
        [self.popView addSubview:self.introduceTextView];
        
        self.introduceTextView.contentInset = UIEdgeInsetsMake(-5, 0, 0, 0);
        
        self.bacView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_PAD, TOP_PAD - 10, POPVIEW_WIDHT - LEFT_PAD*2, View_Height - TOP_PAD - 10)];
        self.bacView.backgroundColor = [UIColor whiteColor];
        [self.popView addSubview:self.bacView];
        
        CGFloat BANNER_WIDTH = (POPVIEW_WIDHT - LEFT_PAD*2 - 10)/2;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, POPVIEW_WIDHT - LEFT_PAD*2, View_Height - TOP_PAD - 25)];
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        [self.bacView addSubview:self.scrollView];
        
        NSMutableArray *certificatesArray = [NSMutableArray new];
        NSArray *certificates = info[@"certificates"];
        
        if (certificates != nil && ![certificates isKindOfClass:[NSNull class]] && certificates.count != 0)
        {
            [certificates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
            {
                JHHeaderUserInfoModel *model = [JHHeaderUserInfoModel mj_objectWithKeyValues:obj];
                [certificatesArray addObject:model];
            }];
            
            if (certificatesArray.count > 1)
            {
                if (certificatesArray.count%2 == 0)
                {
                    num = certificatesArray.count/2;
                }
                else
                {
                    num = certificatesArray.count/2 + 1;
                }
                
                self.pageControl.numberOfPages = num;
            }
            else
            {
                self.pageControl.numberOfPages = 0;
                num = 0;
            }
            
            self.scrollView.contentSize = CGSizeMake((POPVIEW_WIDHT - LEFT_PAD*2) * num , 0);
            
            for (int i = 0; i < certificatesArray.count; i++)
            {
                JHHeaderUserInfoModel *model = certificatesArray[i];
                //UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake((BANNER_WIDTH + 10)*i, 0, BANNER_WIDTH, View_Height - TOP_PAD - 25)];
                UIView *bannerView = [[UIView alloc] init];
                if (i < 2)
                {
                    bannerView.frame = CGRectMake((BANNER_WIDTH + 10)*i, 0, BANNER_WIDTH, View_Height - TOP_PAD - 25);
                }
                else
                {
                    bannerView.frame = CGRectMake((BANNER_WIDTH + 10)*(i-1) + BANNER_WIDTH + 2 , 0, BANNER_WIDTH, View_Height - TOP_PAD - 25);
                }
                
                [self.scrollView addSubview:bannerView];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bannerView.frame.size.width, 82)];
                imageView.backgroundColor = MLIGHTGRAY_COLOR;
                imageView.clipsToBounds = YES;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                NSString *certificateUrl = [model.img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:certificateUrl] placeholderImage:kDefaultCoverImage];
                [bannerView addSubview:imageView];
            }
            
            [self.bacView addSubview:self.pageControl];
        }
    }
    return self;
}

-(NSAttributedString *)setSpaceWithText:(NSString*)text font:(UIFont*)font color:(UIColor *)color
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;

    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.4f,NSForegroundColorAttributeName:color};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];

    return attributeStr;
}

- (void)show
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.popView.frame = CGRectMake((SCREEN_WIDTH - POPVIEW_WIDHT)/2, (SCREEN_HEIGHT - View_Height)/2, POPVIEW_WIDHT, View_Height);
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    self.popView.transform = CGAffineTransformScale(self.transform,0.1,0.1);
    [UIView animateWithDuration:TIMER delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.popView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished)
    {

    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:TIMER animations:^{
        self.popView.transform = CGAffineTransformScale(self.transform,0.1,0.1);
         self.alpha = 0;
     } completion:^(BOOL finished)
    {
         [self removeFromSuperview];
     }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isDescendantOfView:self.popView])
    {
        return NO;
    }
    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollviewW = POPVIEW_WIDHT - LEFT_PAD*2 ;
    CGFloat x = scrollView.contentOffset.x;
    //int page = (x + scrollviewW) /  scrollviewW;
    int page = x /  scrollviewW;

    if (x == 0)
    {
        page = 0;
    }
    
    self.pageControl.currentPage = page;
 }

- (UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl= [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bacView.frame.size.height - 2, POPVIEW_WIDHT- LEFT_PAD*2, 10)];
        _pageControl.currentPage = 0;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = YELLOW_COLOR;
        _pageControl.pageIndicatorTintColor = MLIGHTGRAY_COLOR;
    }
    return _pageControl;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

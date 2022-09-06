//
//  JHImageAppraisalRecordViewController.m
//  TTjianbao
//
//  Created by liuhai on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHImageAppraisalRecordViewController.h"
#import "JHUIFactory.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryTitleAttributeView.h"
#import "JXCategoryListContainerView.h"
#import "TTjianbaoBussiness.h"
#import "JHImageAppraisalFinishedViewController.h"
#import "JHImageRecordTimePickerView.h"

@interface JHImageAppraisalRecordViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate,JHImageRecordTimePickerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleAttributeView *titleCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSMutableArray *vcArr;
@property (nonatomic, strong) JHImageRecordTimePickerView * pick;
@end

@implementation JHImageAppraisalRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentIndex=0;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    self.title = @"鉴定记录";
    [self setupTitleCategoryView];
}
#pragma mark -
#pragma mark - JXCategoryView Methods

- (void)setupTitleCategoryView {
    
//    self.titleCategoryView.titles = @[@"已鉴定",@"存疑鉴定",@"已取消"];
    [self initTitleCategoryViewNum:0];
    [self.view addSubview:self.titleCategoryView];
    
    
    [self.titleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.offset(44);
        
    }];
    JXCategoryIndicatorImageView *indicatorImageView = [[JXCategoryIndicatorImageView alloc] init];
    indicatorImageView.indicatorImageView.image = [UIImage imageNamed:@"sq_category_Indicator_img_normal"];
    indicatorImageView.indicatorImageViewSize= CGSizeMake(37, 4);
    indicatorImageView.verticalMargin = 8;
    
    self.titleCategoryView.indicators = @[indicatorImageView];
    
    self.pick = [JHImageRecordTimePickerView shareManger];
    [[JHImageRecordTimePickerView shareManger] resetTime];
    self.pick.delegate = self;
    [self.view addSubview:self.pick];
    [self.pick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleCategoryView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(53);
    }];
    
    self.vcArr = [NSMutableArray array];
    JHImageAppraisalFinishedViewController *vc =  [[JHImageAppraisalFinishedViewController alloc] initWithReportType:1];
    @weakify(self);
    vc.refreshNum = ^(NSInteger count) {
        @strongify(self);
        [self initTitleCategoryViewNum:count];
    };
    [self.vcArr addObject:vc];
    JHImageAppraisalFinishedViewController *vc1 =  [[JHImageAppraisalFinishedViewController alloc]  initWithReportType:2];
    [self.vcArr addObject:vc1];
    JHImageAppraisalFinishedViewController *vc2 =  [[JHImageAppraisalFinishedViewController alloc]  initWithReportType:3];
    [self.vcArr addObject:vc2];
    
    [self.view addSubview:self.listContainerView];
    self.titleCategoryView.listContainer = self.listContainerView;
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pick.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        
    }];
    self.titleCategoryView.defaultSelectedIndex = self.currentIndex;
}
- (void)initTitleCategoryViewNum:(NSInteger)count{
    NSArray <NSString *>*mainTitles = @[@"已鉴定",@"存疑鉴定",@"已取消"];
    NSArray <NSNumber *>*counts = @[@(count)];
    NSMutableArray <NSAttributedString *>*attributedStringArray = [NSMutableArray array];
    NSMutableArray <NSAttributedString *>*selectedAttributedStringArray = [NSMutableArray array];
    for (NSInteger index = 0; index < mainTitles.count; index++) {
        [attributedStringArray addObject:[self attributedText:mainTitles[index] count:counts[index] isSelected:NO]];
        [selectedAttributedStringArray addObject:[self attributedText:mainTitles[index] count:counts[index] isSelected:YES]];
    }
    self.titleCategoryView.attributeTitles = attributedStringArray;
    self.titleCategoryView.selectedAttributeTitles = selectedAttributedStringArray;
    [self.titleCategoryView reloadData];
}
- (JXCategoryTitleAttributeView *)titleCategoryView {
    if (!_titleCategoryView) {
        _titleCategoryView = [[JXCategoryTitleAttributeView alloc]init];
        _titleCategoryView.titleFont = [UIFont fontWithName:kFontNormal size:15];
        //  self.titleCategoryView.cellSpacing = 20;
        _titleCategoryView.titleColor = kColor666;
        _titleCategoryView.titleLabelVerticalOffset = -4;
        _titleCategoryView.backgroundColor = [UIColor whiteColor];
        _titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:15];
        _titleCategoryView.titleSelectedColor = kColor333;
        _titleCategoryView.averageCellSpacingEnabled = YES; //将cell均分
        _titleCategoryView.contentEdgeInsetLeft = 50;
        _titleCategoryView.contentEdgeInsetRight = 50;
         _titleCategoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    }
    return _titleCategoryView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}

#pragma mark -
#pragma mark - JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 3;
}
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    return self.vcArr[index];
    
}

- (NSAttributedString *)attributedText:(NSString *)title count:(NSNumber *)count isSelected:(BOOL)isSelected {
    if(count && ([count integerValue] != 0)){
        NSString *countString = [[NSString alloc] initWithFormat:@" %@", count];
        if ([count integerValue] > 999) {
            countString = @"999+";
        }
        NSString *allString = [NSString stringWithFormat:@"%@%@", title, countString];
        UIColor *tintColor = nil;
        UIFont *tintFont = JHFont(15);
        if (isSelected) {
            tintColor = HEXCOLOR(0x333333);
            tintFont = JHMediumFont(15);
        }else {
            tintColor = HEXCOLOR(0x666666);
            tintFont = JHFont(15);
        }
        NSMutableAttributedString *attrubtedText = [[NSMutableAttributedString alloc] initWithString:allString attributes:@{NSFontAttributeName : tintFont, NSForegroundColorAttributeName : tintColor}];
        [attrubtedText addAttributes:@{NSFontAttributeName:JHFont(11), NSForegroundColorAttributeName : HEXCOLOR(0x999999)} range:[allString rangeOfString:countString]];
        //让数量对齐
//        [attrubtedText addAttribute:NSBaselineOffsetAttributeName value:@(([UIFont systemFontOfSize:15].lineHeight - [UIFont systemFontOfSize:12].lineHeight)/2 + (([UIFont systemFontOfSize:15].descender - [UIFont systemFontOfSize:12].descender))) range:[allString rangeOfString:countString]];
        return attrubtedText;
    }else{
        UIColor *tintColor = nil;
        UIFont *tintFont = JHFont(15);
        if (isSelected) {
            tintColor = HEXCOLOR(0x333333);
            tintFont = JHMediumFont(15);
        }else {
            tintColor = HEXCOLOR(0x666666);
            tintFont = JHFont(15);
        }
        NSMutableAttributedString *attrubtedText = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName : tintFont, NSForegroundColorAttributeName : tintColor}];
        return attrubtedText;
    }
    
}
- (void)reloadRecordData{
    for (JHImageAppraisalFinishedViewController *vc in self.vcArr) {
        [vc reloadRecordData];
    }
    
}
- (void)dealloc
{
    NSLog(@"customizedealloc")
}

@end

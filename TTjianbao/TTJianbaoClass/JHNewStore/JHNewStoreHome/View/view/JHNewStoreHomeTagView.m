//
//  JHNewStoreHomeTagView.m
//  TTjianbao
//
//  Created by user on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeTagView.h"
#import "JHNewStoreBoutiqueFlowLayout.h"
#import "UILabel+edgeInsets.h"

static const CGFloat cellSpanHorizontal = 5.f;
static const CGFloat cellSpanVertical = 10.f;
static const CGFloat btnLeft = 6.f;
static const CGFloat goodBtnLeft = 4.f;


CGSize sizeOfOneTagContentCaculate(NSString *title, CGFloat platWidth, CGFloat textFont, CGFloat plHeight, BOOL isGoods);
NSInteger indexOfLastTagContentCaculate(CGFloat platWidth, NSInteger maxRowCount, NSArray<NSString *> *histories);
CGFloat heightOfTagPlatCaculate(CGFloat platWidth, NSArray<NSString *> *histories);

/// 标签
@interface JHNewStoreBoutiqueTagCollectionCell :UICollectionViewCell
@property (nonatomic, strong) UILabel *tagNameLabel;
@property (nonatomic, assign) CGFloat tagViewNeedWidth;
@property (nonatomic, assign) CGFloat tagViewNeedHeight;

@property (nonatomic, assign) CGFloat tagTextFont;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) BOOL isGoodsInfo;

- (void)setViewModel:(NSString *)string;
@end

@implementation JHNewStoreBoutiqueTagCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {

    self.tagNameLabel = [[UILabel alloc] init];
    self.tagNameLabel.textAlignment = NSTextAlignmentCenter;
    self.tagNameLabel.edgeInsets = UIEdgeInsetsMake(0.f, btnLeft, 0.f, btnLeft);
    self.tagNameLabel.layer.borderWidth   = 0.5f;
    self.tagNameLabel.layer.cornerRadius  = 2.f;
    self.tagNameLabel.layer.masksToBounds = YES;

    [self.contentView addSubview:self.tagNameLabel];
    [self.tagNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(self.tagViewNeedHeight);
    }];
}

- (void)setViewModel:(NSString *)string {
    if (!isEmpty(string)) {
        self.tagNameLabel.hidden = NO;
        self.tagNameLabel.text = string;
    } else {
        self.tagNameLabel.hidden = YES;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _tagNameLabel.textColor = textColor;
}

- (void)setTagTextFont:(CGFloat)tagTextFont {
    _tagTextFont = tagTextFont;
    _tagNameLabel.font = [UIFont fontWithName:kFontNormal size:tagTextFont];
}

- (void)setTagViewNeedHeight:(CGFloat)tagViewNeedHeight {
    _tagViewNeedHeight = tagViewNeedHeight;
    [_tagNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(tagViewNeedHeight);
    }];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    _tagNameLabel.layer.borderColor = borderColor.CGColor;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGSize contentSize = sizeOfOneTagContentCaculate(self.tagNameLabel.text, [self needWidth], self.tagTextFont, self.tagViewNeedHeight, self.isGoodsInfo);
    attributes.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    return attributes;
}

//- (CGFloat)needWidth {
//    return ScreenWidth - 23.f*2.f - 68.f - 14.f;
//}

- (CGFloat)needWidth {
    return self.tagViewNeedWidth;
}

CGSize sizeOfOneTagContentCaculate(NSString *title, CGFloat platWidth, CGFloat textFont, CGFloat plHeight, BOOL isGoods) {
    CGSize autoSize = sizeAutoFixContentCaculate(title, [UIFont fontWithName:kFontNormal size:textFont]);
    autoSize.width  = ceil(autoSize.width); /// 文字向上取整处理，防止界面尺寸不足。
    if (autoSize.width >= cellHistoryMaxW(platWidth,isGoods)) {
        autoSize.width = cellHistoryMaxW(platWidth,isGoods);
    }
    autoSize.width   = autoSize.width + 2 * btnLeft;/// 文字离边框的距离
    autoSize.height  = plHeight;
    return autoSize;
}

CGSize sizeAutoFixContentCaculate(NSString *content, UIFont *font) {
    if (isEmpty(content)) {
        return CGSizeZero;
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:font}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2.f];
    [attString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [content length])];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CGSize constraint = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    CGSize newSize   = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [content length]), nil, constraint, nil);
    CFRelease(framesetter);
    return newSize;
}

CGFloat contentWidth(CGFloat platWidth, BOOL isGoodsInfo) {
    CGFloat sapceLeft = 0.f;
    if (isGoodsInfo) {
        sapceLeft = goodBtnLeft;
    } else {
        sapceLeft = btnLeft;
    }
    if (platWidth >= (325.f + 2*sapceLeft)) {
        platWidth = 325.f + 2*sapceLeft;
    }
    return platWidth;
}

CGFloat cellHistoryMaxW(CGFloat platWidth, BOOL isGoodsInfo){
    if (isGoodsInfo) {
        return contentWidth(platWidth, isGoodsInfo)- 2 * goodBtnLeft;
    } else {
        return contentWidth(platWidth, isGoodsInfo)- 2 * btnLeft;
        
    }
}


@end

@interface JHNewStoreHomeTagView () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *tagCollectionView;
@property (nonatomic, strong) NSMutableArray   *dataSourceArray;
- (void)setViewModel:(id)viewModel;
@end

@implementation JHNewStoreHomeTagView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)setupViews {
    [self addSubview:self.tagCollectionView];
    [self.tagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(18.f);
    }];
}

- (void)setTagViewNeedHeight:(CGFloat)tagViewNeedHeight {
    _tagViewNeedHeight = tagViewNeedHeight;
    [self.tagCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(tagViewNeedHeight);
    }];
}

- (UICollectionView *)tagCollectionView {
    if (!_tagCollectionView) {
        JHNewStoreBoutiqueFlowLayout *layout              = [[JHNewStoreBoutiqueFlowLayout alloc] init];
        layout.minimumInteritemSpacing                    = btnLeft;
        layout.minimumLineSpacing                         = btnLeft;
       /// layout约束这边必须要用estimatedItemSize才能实现自适应,使用itemSzie无效
        layout.estimatedItemSize                          = CGSizeMake(20.f, 14.f);
        layout.scrollDirection                            = UICollectionViewScrollDirectionVertical;
        layout.arrangeAlignment                           = JHArrangeAlignment_Left;
        layout.spanHorizonal                              = 5.f;
        _tagCollectionView                                = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _tagCollectionView.showsVerticalScrollIndicator   = NO;
        _tagCollectionView.backgroundColor                = [UIColor clearColor];
        _tagCollectionView.delegate                       = self;
        _tagCollectionView.dataSource                     = self;
        _tagCollectionView.showsHorizontalScrollIndicator = NO;
        _tagCollectionView.contentInset                   = UIEdgeInsetsMake(0, 0.f, 0.f, btnLeft);
        _tagCollectionView.scrollEnabled                  = NO;
        [_tagCollectionView registerClass:[JHNewStoreBoutiqueTagCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewStoreBoutiqueTagCollectionCell class])];
    }
    return _tagCollectionView;
}

#pragma mark - Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHNewStoreBoutiqueTagCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewStoreBoutiqueTagCollectionCell class]) forIndexPath:indexPath];
    cell.tagViewNeedWidth = self.tagViewNeedWidth;
    cell.tagViewNeedHeight = self.tagViewNeedHeight;
    
    cell.tagTextFont = self.tagTextFont;
    cell.borderColor = self.borderColor;
    cell.textColor   = self.textColor;
    
    [cell setViewModel:self.dataSourceArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)setViewModel:(id __nullable)viewModel {
    [self.dataSourceArray removeAllObjects];
    NSArray<NSString *> *arr = viewModel;
    if (arr && arr.count >0) {
        [self.dataSourceArray addObjectsFromArray:arr];
    }
    [self.tagCollectionView reloadData];
}


@end

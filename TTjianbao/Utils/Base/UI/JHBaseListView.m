
#import "JHBaseListView.h"

@implementation JHWBaseTableViewCell

+ (instancetype)dequeueReusableCellWithTableView:(UITableView *)tabelView {
    JHWBaseTableViewCell *cell = [tabelView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self cellIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSelfSubViews];
    }
    return cell;
}

- (void)addSelfSubViews {
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

@end

@implementation JHBaseCollectionViewCell
+ (instancetype)dequeueReusableCellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    JHBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellIdentifier] forIndexPath:indexPath];
    
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSelfSubViews];
    }
    return self;
}

- (void)addSelfSubViews {
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

@end

@implementation JHBaseTableViewHeaderFooterView
+ (instancetype)dequeueReusableHeaderFooterViewWithTableView:(UITableView *)tabelView {
    JHBaseTableViewHeaderFooterView *view = [tabelView dequeueReusableHeaderFooterViewWithIdentifier:[self reuseIdentifier]];
    if (view == nil) {
        view = [[self alloc] initWithReuseIdentifier:[self reuseIdentifier]];
        [view addSelfSubViews];
    }
    return view;
}

-(void)addSelfSubViews {
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end

@implementation JHBaseCollectionReusableView

+ (instancetype)dequeueReusableViewWithKind:(NSString *)kind collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    JHBaseCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self reuseIdentifier] forIndexPath:indexPath];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSelfSubViews];
    }
    return self;
}

- (void)addSelfSubViews {
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end

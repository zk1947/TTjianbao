

#import "UIScrollView+JHEmpty.h"
#import "UIScrollView+MJRefresh.h"
#import "JHRefreshGifHeader.h"
#import "JHRefreshNormalFooter.h"
@implementation JHEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [UIImageView jh_imageViewWithImage:@"img_default_page" addToSuperview:self];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(-60);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        _textLabel = [UILabel jh_labelWithText:@"暂无数据~" font:12 textColor:HEXCOLOR(0xa7a7a7) textAlignment:1 addToSuperView:self];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(10);
            make.centerX.equalTo(self.imageView.mas_centerX);
        }];
    }
    return self;
}


+ (CGSize)viewSize {
    return CGSizeMake(100, 120);
}

@end


@implementation UIScrollView (JHEmpty)

- (void)setJh_EmputyView:(JHEmptyView *)jh_EmputyView{
    objc_setAssociatedObject(self, @selector(jh_EmputyView), jh_EmputyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JHEmptyView *)jh_EmputyView {
    return objc_getAssociatedObject(self, _cmd);
}

- (JHEmptyView *)getEmputyView {
    
    if (self.jh_EmputyView == nil) {
        JHEmptyView *noDataView = [JHEmptyView new];
        [self addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.size.mas_equalTo([JHEmptyView viewSize]);
        }];
        self.jh_EmputyView = noDataView;
    }
    return self.jh_EmputyView;
}

- (void)jh_headerWithRefreshingBlock:(void (^)(void))headerBlock
           footerWithRefreshingBlock:(void (^)(void))footerBlock {
    if (headerBlock) {
        self.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            headerBlock();
        }];
    }
    
    if (footerBlock) {
        self.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            footerBlock();
        }];
    }
}

- (void)jh_endRefreshing {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)jh_footerStatusWithNoMoreData:(BOOL)noMoreData {
    if(noMoreData) {
        [self jh_noMoreDataStatus];
    }
    else {
        [self jh_resetNoMoreDataStatus];
    }
}

- (void)jh_noMoreDataStatus {
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)jh_resetNoMoreDataStatus {
    [self.mj_footer resetNoMoreData];
}

@end

@implementation UITableView (JHEmpty)

- (void)jh_reloadDataWithEmputyView {
    [self reloadData];
    
    if (self.mj_totalDataCount > 0) {
        self.jh_EmputyView.hidden = YES;
    }
    else {
        [self getEmputyView].hidden = NO;
    }
}

@end


@implementation UICollectionView (JHEmpty)

- (void)jh_reloadDataWithEmputyView {
    [self reloadData];
    
    if (self.mj_totalDataCount > 0) {
        self.jh_EmputyView.hidden = YES;
    }
    else{
        [self getEmputyView].hidden = NO;
    }
}

@end

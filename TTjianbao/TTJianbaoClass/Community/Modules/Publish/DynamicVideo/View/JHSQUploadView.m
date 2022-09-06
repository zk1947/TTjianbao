//
//  JHSQUploadView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/6/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQUploadView.h"
#import "JHBaseListView.h"
#import "JHSQUploadManager.h"

@interface JHSQUploadViewCell : JHWBaseTableViewCell

@property (nonatomic, weak) UIImageView *photosView;

@property (nonatomic, weak) UILabel *tipLabel;


@property (nonatomic, weak) UIProgressView *progressView;

///关闭（删除）
@property (nonatomic, weak) UIButton *closeButton;

///重试
@property (nonatomic, weak) UIButton *retryButton;

@property (nonatomic, strong) JHSQUploadModel *model;

@end

@implementation JHSQUploadViewCell

-(void)addSelfSubViews
{
    self.contentView.backgroundColor = APP_BACKGROUND_COLOR;
    _photosView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_photosView jh_cornerRadius:4];
    [_photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.width.mas_equalTo(30);
    }];
    
    _tipLabel = [UILabel jh_labelWithFont:12 textColor:RGB515151 addToSuperView:self.contentView];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photosView.mas_right).offset(8);
        make.centerY.equalTo(self.contentView);
    }];
    
    UIProgressView *progressView = [UIProgressView new];
    progressView.backgroundColor = UIColor.clearColor;
    progressView.trackTintColor = UIColor.clearColor;
    progressView.progressTintColor = RGB(255, 194, 66);
    progressView.progress = 0.0;
    [self.contentView addSubview:progressView];
    _progressView = progressView;
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(2);
    }];
   
    _closeButton = [UIButton jh_buttonWithImage:JHImageNamed(@"publish_upload_close") target:self action:@selector(closeAction) addToSuperView:self.contentView];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.contentView);
        make.width.mas_equalTo(50);
    }];
    
    _retryButton = [UIButton jh_buttonWithImage:JHImageNamed(@"publish_upload_retry") target:self action:@selector(retryAction) addToSuperView:self.contentView];
    [_retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(self.closeButton);
        make.right.equalTo(self.closeButton.mas_left);
    }];
}

-(void)closeAction
{
    [JHSQUploadManager removeModel:_model];
}

-(void)retryAction
{
    self.model.status = JHSQUploadStatusUploading;
    [self.model start];
    [JHSQUploadManager reload];
}

-(void)bindMethod
{
    RAC(_progressView, progress) = [RACObserve(self.model, progress) takeUntil:self.rac_prepareForReuseSignal];
    
    @weakify(self);
    RAC(self.tipLabel,text) = [[RACObserve(self.model, progress) takeUntil:self.rac_prepareForReuseSignal] map:^id _Nullable(id  _Nullable value) {
        @strongify(self);
        NSInteger num = [value floatValue]*100;
        return [NSString stringWithFormat:@"%@(%@%%)",self.model.tipString,@(num)];
    }];
}

-(void)setModel:(JHSQUploadModel *)model
{
    _model = model;
    _progressView.progress = _model.progress;
    if([_model.image isKindOfClass:[NSString class]]) {
        [_photosView jh_setImageWithUrl:_model.image];
    }
    else {
        _photosView.image = _model.image;
    }
    _retryButton.hidden = (_model.status != JHSQUploadStatusUploadFail);
    _closeButton.hidden = (_model.status != JHSQUploadStatusUploadFail);
    _model.tipString = (_model.status == JHSQUploadStatusUploadFail ? @"发布失败" : @"正在发布，请勿离开天天鉴宝" );
    [self bindMethod];
}

@end


@interface JHSQUploadView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation JHSQUploadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = APP_BACKGROUND_COLOR;
        
        [self addUI];
    }
    return self;
}

- (void)addUI {

    _tableView = [UITableView jh_tableViewWithStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleNone target:self addToSuperView:self];
    _tableView.rowHeight = 40;
    _tableView.scrollEnabled = NO;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    @weakify(self);
    [JHSQUploadManager shareInstance].changeBlock = ^{
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reload];
        });
        
    };
}

- (void)reload {
    NSMutableArray *array = [JHSQUploadManager shareInstance].dataArray;
    if(array && array.count > 0) {
        NSInteger row = [JHSQUploadManager shareInstance].dataArray.count;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40 * row);
        }];
        [self.tableView reloadData];
    }
    else if(_deleteViewBlock) {
        _deleteViewBlock();
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [JHSQUploadManager shareInstance].dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JHSQUploadViewCell *cell = [JHSQUploadViewCell dequeueReusableCellWithTableView:tableView];
    cell.model = SAFE_OBJECTATINDEX([JHSQUploadManager shareInstance].dataArray, indexPath.row);
    return cell;
}

+ (BOOL)show {
//    JHSQUploadModel *model = [JHSQUploadModel new];
//    model.progress = 0.5;
//    model.tipString = @"234567890";
//    model.status = JHSQUploadStatusUploading;
//    [JHSQUploadManager addModel:model];
    
    NSMutableArray *array = [JHSQUploadManager shareInstance].dataArray;
    if(array && array.count > 0) {
        return YES;
    }
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

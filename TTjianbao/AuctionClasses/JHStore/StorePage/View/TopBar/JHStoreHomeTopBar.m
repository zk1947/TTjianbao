//
//  JHStoreHomeTopBar.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/20.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeTopBar.h"
#import "JHMyCenterDotNumView.h"
#import "TTjianbaoBussiness.h"

#import "TTjianbaoHeader.h"
#import "JHSkinManager.h"
#import "JHSkinSceneManager.h"
#import "JHSQHelper.h"
#import "JHAnimatedImageView.h"

@interface JHStoreHomeTopBar ()

@property (nonatomic, copy) dispatch_block_t msgClickBlock;

/// 右上角消息按钮
@property (nonatomic, strong) JHMyCenterDotNumView *msgCountLabel; //消息数Label
@property (nonatomic ,strong) UIButton *btn;//消息按钮
@property (nonatomic ,strong) JHAnimatedImageView *signBtn;//搜索按钮

@property (nonatomic ,strong) UIButton *classBtn;//搜索按钮

@end


@implementation JHStoreHomeTopBar

+ (instancetype)topBarWithMsgClickBlock:(dispatch_block_t)msgClickBlock withSearchClickBlock:(dispatch_block_t)searchClickBlock{
    JHStoreHomeTopBar *topBar = [[JHStoreHomeTopBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, UI.statusAndNavBarHeight + StoreHomeTopBarHeight - 0.5)];
    NSLog(@"UI.statusAndNavBarHeight === %f,ScreenWidth === %f",UI.statusAndNavBarHeight,ScreenWidth);
    //UI.statusAndNavBarHeight + 50 64 114*
    topBar.msgClickBlock = msgClickBlock;
    topBar.searchClickBlock = searchClickBlock;
    return topBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.backView = [[UIImageView alloc] init];
        self.backView.clipsToBounds = YES;
        self.backView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self).offset(0);
            make.height.height.mas_equalTo(ceilf(ScreenW * 134 / 375));
            make.bottom.mas_equalTo(self).offset(0.5);
        }];
        
//        JHSkinModel *model = [JHSkinManager entiretyHead];
//        if (model.isChange)
//        {
//            if ([model.type intValue] == 0)
//            {
//                UIImage *image = [JHSkinManager getEntiretyHeadImage];
//                self.backView.image = image;
//            }
//            else if ([model.type intValue] == 1)
//            {
//                self.backView.backgroundColor = COLOR_CHANGE(model.name);
//            }
//        }
    
        [self configUI];
        [self bindData];
    }
    return self;
}

///滑动效果 改变搜索框位置、改变签到和消息透明度
- (void)addAnimationWithOffset:(CGFloat)scrollY{
    self.top = - scrollY;
    self.btn.top = UI.statusBarHeight + scrollY;
    self.btn.alpha = 1- scrollY/50.0;
    self.signBtn.alpha = 1- scrollY/50.0;
//    self.height = UI.statusAndNavBarHeight + 50 - scrollY;
//    self.searchBar.top = UI.statusAndNavBarHeight + 10 - scrollY;//0-50
//    self.classBtn.top = UI.statusAndNavBarHeight + 10 - scrollY;
}
- (void)bindData {
    JHSkinSceneManager *manager = [JHSkinSceneManager shareManager];
    @weakify(self)
    [RACObserve(manager, sceneNaviModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *model = x;
        if (model == nil) return;
        if (model.imageNor != nil) {
            self.backView.image = model.imageNor;
        }else if (model.colorBGNor != nil) {
            self.backView.backgroundColor = model.colorBGNor;
        }
    }];
    [RACObserve(manager, sceneMsgModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *model = x;
        if (model == nil) return;
        if (model.imageNor != nil) {
            [self.btn setImage:model.imageNor forState:UIControlStateNormal];
        }
        if (model.colorNor != nil) {
            self.msgCountLabel.textColor = model.colorNor;
        }
        if (model.colorBGNor != nil) {
            self.msgCountLabel.backgroundColor = model.colorBGNor;
        }
    }];
    [RACObserve(manager, sceneMsgNumTitleModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *model = x;
        if (model == nil) return;
        self.msgCountLabel.textColor = model.colorNor;
    }];
    [RACObserve(manager, sceneMsgNumBgModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *model = x;
        if (model == nil) return;
        self.msgCountLabel.backgroundColor = model.colorBGNor;
    }];
    [RACObserve(manager, sceneSignModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *model = x;
        if (model == nil) return;
        
        if (model.imageNor != nil && self.isSign == false) {
            self.signBtn.image = model.imageNor;
        }else if (model.imageSel != nil && self.isSign == true) {
            self.signBtn.image = model.imageSel;
        }
    }];
    [RACObserve(manager, sceneCategoryModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *model = x;
        if (model == nil) return;
        [self.classBtn setImage:model.imageNor forState:UIControlStateNormal];
    }];
}
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex == 1)
    {
//        JHSkinModel *model = [JHSkinManager entiretyHead];
//        if (model.isChange)
//        {
//            if ([model.type intValue] == 0)
//            {
//                UIImage *image = [JHSkinManager getEntiretyHeadImage];
//                self.backView.image = image;
//            }
//            else if ([model.type intValue] == 1)
//            {
//                self.backView.backgroundColor = COLOR_CHANGE(model.name);
//            }
//        }
        
        //search
//        JHSkinModel *sign_model = [JHSkinManager sign];
//        if (sign_model.isChange)
//        {
//            if ([sign_model.type intValue] == 0)
//            {
//                UIImage *image = [JHSkinManager getSignImage];
//                self.signBtn.image = image;
//            }
//        }
        
//        JHSkinModel *message_model = [JHSkinManager message];
//        if (message_model.isChange)
//        {
//            if ([message_model.type intValue] == 0)
//            {
//                UIImage *image = [JHSkinManager getMessageImage];
//                [self.btn setImage:image forState:UIControlStateNormal];
//            }
//        } 
        
//        JHSkinModel *bottom_model = [JHSkinManager redBottom];
//        if (bottom_model.isChange)
//        {
//            if ([bottom_model.type intValue] == 1)
//            {
//                _msgCountLabel.backgroundColor = COLOR_CHANGE(bottom_model.name);
//            }
//        }
//        
//        JHSkinModel *num_model = [JHSkinManager numColor];
//        if (num_model.isChange)
//        {
//            if ([num_model.type intValue] == 1)
//            {
//                _msgCountLabel.textColor = COLOR_CHANGE(num_model.name);
//            }
//        }
    }
}

- (void)setIsSign:(BOOL)isSign{
    _isSign = isSign;

    JHSkinModel *sign_model = [JHSkinManager getSkinInfoWithType:JHSkinTypeSign];
    if (sign_model.isChange)
    {
        if ([sign_model.type intValue] == 0)
        {
            JHSkinSceneModel *scene = [JHSkinSceneManager shareManager].sceneSignModel;
            UIImage *image = _isSign ? scene.imageSel:scene.imageNor;
            self.signBtn.image = image;
        }
    }
}

- (void)configUI {
    [self addSubview:[self msgButton]];
    [self addSearchButton];
    [self addSubview:self.searchBar];
    [self addClassButton];
}

#pragma mark - 签到按钮
- (void)addSearchButton {
//    [iconImgv jh_setImageWithUrl:@"https://jh-live-video-test.oss-cn-beijing.aliyuncs.com/test/gif/financemix1619701102084.webp"];
    
    _signBtn = [[JHAnimatedImageView alloc]init];
    _signBtn.contentMode = UIViewContentModeScaleAspectFit;
    _signBtn.image = [UIImage imageNamed:@"navi_icon_sign"];
    _signBtn.userInteractionEnabled = YES;
    [self addSubview:_signBtn];
    [_signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btn.mas_left).offset(-5);
        make.top.bottom.equalTo(self.btn);
        make.width.equalTo(@29);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchBtnClick)];
    [_signBtn addGestureRecognizer:tap];
}

#pragma mark - 搜索框
- (JHEasyPollSearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [JHSQHelper searchBar];
        _searchBar.frame = CGRectMake(15, UI.statusAndNavBarHeight + 10, kScreenWidth-57, 30);
        _searchBar.backgroundColor = kColorFFF;
        _searchBar.layer.borderColor = HEXCOLOR(0xFFD70F).CGColor;
        _searchBar.layer.borderWidth = 1.5;
        _searchBar.searchBarShowFrom = JHSearchBarShowFromSoureHome;

        //搜索事件
        @weakify(self);
        _searchBar.didSelectedBlock = ^(NSInteger selectedIndex, BOOL isLeft) {
            @strongify(self);
            if (self.searchScrollBlock) {
                self.searchScrollBlock(selectedIndex,isLeft);
            }
        };
    }
    return _searchBar;
}

#pragma mark - 分类按钮
- (void)addClassButton {
    _classBtn = [[UIButton alloc] init];
    _classBtn.frame = CGRectMake(kScreenWidth-36, UI.statusAndNavBarHeight + 11, 30, 30);
    _classBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_classBtn setImage:[UIImage imageNamed:@"search_class_icon"] forState:UIControlStateNormal];
    [_classBtn addTarget:self action:@selector(classBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_classBtn];
}

-(void)searchBtnClick{
    if (self.searchClickBlock) {
        self.searchClickBlock();
    }
}

-(void)classBtnClick:(UIButton*)sender {
    if (self.classBlock) {
        self.classBlock();
    }
}

#pragma mark - 消息中心图标

- (UIButton *)msgButton {
    _btn = [[UIButton alloc] init];
    _btn.frame = CGRectMake(ScreenWidth-40, UI.statusBarHeight, 40, 44);
//    _btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_btn setImageEdgeInsets:UIEdgeInsetsMake(7.5, 5.5, 7.5, 5.5)];
    //[_btn setImage:[UIImage imageNamed:@"icon_mine_message"] forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@"navi_icon_message"] forState:UIControlStateNormal];
    
    @weakify(self);
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.msgClickBlock) {
            self.msgClickBlock();
        }
    }];
    [_btn addSubview:self.msgCountLabel];
    [self.msgCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btn).offset(-8);
        make.top.equalTo(self.btn.mas_centerY).offset(-20);
    }];
    [self addSubview:_btn];
    
    return _btn;
}

- (JHMyCenterDotNumView *)msgCountLabel {
    if (!_msgCountLabel) {
        _msgCountLabel = [JHMyCenterDotNumView new];
        _msgCountLabel.number = 0;
    }
    return _msgCountLabel;
}

- (void)refreshMsgCount:(NSString*)count {
    if([count isKindOfClass:[NSString class]] && count.length > 0){
        self.msgCountLabel.number = [count integerValue];
    }
}

- (void)refreshTheme:(BOOL)isNew index:(NSInteger)index
{
    if (self.selectedIndex == 1)
    {
//        /// 原周年庆未读消息样式（被我干掉了 wang 20200506）
//        if(isNew)
//        {
//            JHSkinModel *model = [JHSkinManager message];
//            if (model.isChange)
//            {
//                if ([model.type intValue] == 0)
//                {
//                    UIImage *image = [JHSkinManager getMessageImage];
//                    [_btn setImage:image forState:UIControlStateNormal];
//                }
//            }
//            else
//            {
//                [_btn setImage:[UIImage imageNamed:@"navi_icon_message"] forState:UIControlStateNormal];
//            }
//        }
//        else
//        {
//            if (index == 1 || index == 2)
//            {
//                [self.btn setImage:[UIImage imageNamed:@"navi_icon_message"] forState:UIControlStateNormal];
//            }
//            else
//            {
//                JHSkinModel *model = [JHSkinManager message];
//                if (model.isChange)
//                {
//                    if ([model.type intValue] == 0)
//                    {
//                        UIImage *image = [JHSkinManager getMessageImage];
//                        [_btn setImage:image forState:UIControlStateNormal];
//                    }
//                }
//                else
//                {
//                    [self.btn setImage:[UIImage imageNamed:@"navi_icon_message"] forState:UIControlStateNormal];
//                }
//            }
//        }

    }
}

//- (void)changeTopBar:(BOOL)isChange
//{
////    if (self.selectedIndex == 1)
////    {
////    }
//    
//    if (isChange)
//    {
//        [self.btn setImage:[UIImage imageNamed:@"navi_icon_message"] forState:UIControlStateNormal];
//        self.signBtn.image = [UIImage imageNamed:@"navi_icon_search"];
//        self.msgCountLabel.backgroundColor = RGB(252, 66, 0);
//        self.msgCountLabel.textColor = [UIColor whiteColor];
//    }
//    else
//    {
//        JHSkinModel *message_model = [JHSkinManager message];
//        if (message_model.isChange)
//        {
//            if ([message_model.type intValue] == 0)
//            {
//                UIImage *image = [JHSkinManager getMessageImage];
//                [self.btn setImage:image forState:UIControlStateNormal];
//            }
//        }
//        else
//        {
//            [self.btn setImage:[UIImage imageNamed:@"navi_icon_message"] forState:UIControlStateNormal];
//        }
//
//        JHSkinModel *search_model = [JHSkinManager search];
//        if (search_model.isChange)
//        {
//            if ([search_model.type intValue] == 0)
//            {
//                UIImage *image = [JHSkinManager getSearchImage];
//                self.signBtn.image = image;
//            }
//        }
//        else
//        {
//            self.signBtn.image = [UIImage imageNamed:@"navi_icon_search"];
//        }
//        
//        JHSkinModel *bottom_model = [JHSkinManager redBottom];
//        if (bottom_model.isChange)
//        {
//            if ([bottom_model.type intValue] == 1)
//            {
//                self.msgCountLabel.backgroundColor = COLOR_CHANGE(bottom_model.name);
//            }
//        }
//        
//        JHSkinModel *num_model = [JHSkinManager numColor];
//        if (num_model.isChange)
//        {
//            if ([num_model.type intValue] == 1)
//            {
//                self.msgCountLabel.textColor = COLOR_CHANGE(num_model.name);
//            }
//        }
//
//    }
//
//}


//- (void)refreshTheme:(BOOL)isNew
//{
//    if (self.selectedIndex == 1)
//    {
//        /// 原周年庆未读消息样式（被我干掉了 wang 20200506）
//        if(isNew)
//        {
//            JHSkinModel *model = [JHSkinManager message];
//            if (model.isChange)
//            {
//                if ([model.type intValue] == 0)
//                {
//                    UIImage *image = [JHSkinManager getMessageImage];
//                    [_btn setImage:image forState:UIControlStateNormal];
//                }
//            }
//            else
//            {
//                [_btn setImage:[UIImage imageNamed:@"navi_icon_message"] forState:UIControlStateNormal];
//            }
//        }
//        else
//        {
//            JHSkinModel *model = [JHSkinManager message];
//            if (model.isChange)
//            {
//                if ([model.type intValue] == 0)
//                {
//                    UIImage *image = [JHSkinManager getMessageImage];
//                    [_btn setImage:image forState:UIControlStateNormal];
//                }
//            }
//            else
//            {
//                [self.btn setImage:[UIImage imageNamed:@"navi_icon_message"] forState:UIControlStateNormal];
//            }
//        }
//
//    }
//}


@end

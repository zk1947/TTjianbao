//
//  JHFilterBoxView.m
//  test
//
//  Created by YJ on 2020/12/14.
//  Copyright © 2020 YJ. All rights reserved.
//

#import "JHFilterBoxView.h"
#import "JHFilterBoxCell.h"
#import "TTJianBaoColor.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define LEFT_PAD  65
#define TIMER     0.3

#define Header_Height 30
#define Footer_Height 0
#define NUM     3
#define PAD     15
#define BOTTOM_PAD 46

#define KEY_SECTION   @"cateType"
#define KEY_ROW       @"Id"
#define KEY_NAME      @"name"

#define DEFAULTE_FILTER_BOX  @"DEFAULTE_FILTER_BOX"

#define USER_DEFAULTS   [NSUserDefaults standardUserDefaults]

NSString * const JHCollectionViewCellID = @"cellID";
NSString * const JHReusableHeaderView = @"reuseHeader";
NSString * const JHReusableFooterView = @"reuseFooter";

@interface JHFilterBoxView()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *popView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *titlesArray;
@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) NSMutableArray *typesArray;
@property (strong, nonatomic) NSMutableArray *dicArray;

@end

@implementation JHFilterBoxView

- (instancetype)initWithTitles:(NSMutableArray<JHFilterBoxModel *> *)titles items:(NSMutableArray<NSString *> *)items cateTypes:(NSMutableArray<NSString *> *)types
{
        self = [super init];
        
        if (self)
        {
            self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3];
            
            self.dicArray = [NSMutableArray new];
            self.dicArray = [self getRecord];
            
            self.userInteractionEnabled = YES;

            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
            tapGestureRecognizer.delegate = self;
            [self addGestureRecognizer:tapGestureRecognizer];
            
            self.popView = [[UIView alloc] init];
            self.popView.backgroundColor = [UIColor whiteColor];
            [self addSubview:self.popView];
            
            UIButton *reSetBtn = [[UIButton alloc] initWithFrame:CGRectMake(PAD, SCREEN_HEIGHT - BOTTOM_PAD - 40, 95, 40)];
            reSetBtn.layer.cornerRadius = 5.0f;
            reSetBtn.layer.borderWidth = 0.5;
            reSetBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:16.0f];
            reSetBtn.layer.borderColor = MLIGHTGRAY_COLOR.CGColor;
            [reSetBtn setTitleColor:GRAY_COLOR forState:UIControlStateNormal];
            [reSetBtn addTarget:self action:@selector(clickResetBtn) forControlEvents:UIControlEventTouchUpInside];
            [reSetBtn setTitle:@"重置" forState:UIControlStateNormal];
            [self.popView addSubview:reSetBtn];
            
            CGFloat BTN_WIDTH = SCREEN_WIDTH - LEFT_PAD - PAD*2 - 95 - 10;
            UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(PAD + 95 + 10, SCREEN_HEIGHT - BOTTOM_PAD - 40, BTN_WIDTH, 40)];
            sureBtn.layer.cornerRadius = 5.0f;
            sureBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:16.0f];
            sureBtn.backgroundColor = SURE_BACK_COLOR;
            [sureBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
            [sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
            [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
            [self.popView addSubview:sureBtn];
            
            self.titlesArray = titles;
            self.itemsArray = items;
            self.typesArray = types;
                        
            if (self.dicArray.count > 0)
            {
                for (int j = 0; j < self.dicArray.count; j++)
                {
                    NSMutableDictionary *dic = self.dicArray[j];
                    NSString *cateType = [dic valueForKey:KEY_SECTION];
                    int Id = [[dic valueForKey:KEY_ROW] intValue];
      
                    if (titles.count == items.count && titles.count == types.count)
                    {
                        for (int k = 0; k < self.itemsArray.count; k++)
                        {
                            NSString *type = self.typesArray[k];
                            
                            NSMutableArray * array = [NSMutableArray arrayWithArray:self.titlesArray[k]];

                            for (int i = 0; i < array.count ; i++)
                            {
                                JHFilterBoxModel *model = [array objectAtIndex:i];
                                if (Id == [model.Id intValue] && [type isEqualToString:cateType])
                                {
                                    model.isSelected = YES;
                                }
                            }
                        }
                    }
                }
            }

            if (titles.count == items.count)
            {
                 [self.collectionView reloadData];
            }
        }
        return self;

}

- (void)show
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
    self.popView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];

    CGRect temp = self.popView.frame;
    temp.origin.x = SCREEN_WIDTH;
    self.popView.frame = temp;
    temp.origin.x = LEFT_PAD;
    
    [UIView animateWithDuration:TIMER animations:^{
        self.popView.frame = temp;
    }];
}

- (void)dismiss
{
    self.userInteractionEnabled = NO;
    
    CGRect temp = self.popView.frame;
    temp.origin.x = LEFT_PAD;
    self.popView.frame = temp;
    temp.origin.x = SCREEN_WIDTH;
    
    [UIView animateWithDuration:TIMER animations:^{
        
        self.popView.frame = temp;
        
    } completion:^(BOOL finished)
    {
        [self removeFromSuperview];
    }];
    
    [self performSelector:@selector(changeStatus) withObject:nil afterDelay:1.0f];
}

-(void)changeStatus
{
    self.userInteractionEnabled = YES;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.itemsArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([NSArray has:self.titlesArray[section]]) {
        NSArray *arr = self.titlesArray[section];
        return arr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHFilterBoxCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:JHCollectionViewCellID forIndexPath:indexPath];
    
    JHFilterBoxModel *model = self.titlesArray[indexPath.section][indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
     CGSize size = CGSizeMake((SCREEN_WIDTH - LEFT_PAD - 15*2 - 10*2 )/3, 28);
     return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //UIEdgeInsets inset = UIEdgeInsetsMake(15, 15, 10, 15);
    UIEdgeInsets inset = UIEdgeInsetsMake(10, 15, 25, 15);
    return inset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView;

    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        reusableView = [_collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:JHReusableHeaderView forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor whiteColor];

        for (UIView *view in reusableView.subviews)
        {
            [view removeFromSuperview];
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - LEFT_PAD - 15*2, Header_Height)];
        titleLabel.text = self.itemsArray[indexPath.section];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        //titleLabel.backgroundColor = [UIColor yellowColor];
        titleLabel.textColor = BLACK_COLOR;
        [reusableView addSubview:titleLabel];
    }

    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
    }

    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(SCREEN_WIDTH-LEFT_PAD, Header_Height);
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(0, 0);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.titlesArray[indexPath.section]];

    //NSString *cateName = self.itemsArray[indexPath.section];
    NSString *cateType = self.typesArray[indexPath.section];
    
    JHFilterBoxModel *model = self.titlesArray[indexPath.section][indexPath.row];
    NSString *Id = [NSString stringWithFormat:@"%@",model.Id];
    NSString *name = model.name;
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    //[dic setValue:cateName forKey:KEY_SECTION];
    [dic setValue:cateType forKey:KEY_SECTION];
    [dic setValue:Id forKey:KEY_ROW];
    [dic setValue:name forKey:KEY_NAME];
    
    for (int i = 0; i < array.count; i++)
    {
        JHFilterBoxModel *model = array[i];

        if (i == indexPath.row)
        {
            if (model.isSelected)
            {
                model.isSelected = NO;
                
                if (self.dicArray.count > 0)
                {
                    for (int i = 0; i < self.dicArray.count; i++)
                    {
                        NSMutableDictionary *dictionary = self.dicArray[i];
                        if ([dic isEqual:dictionary])
                        {
                            [self.dicArray removeObject:dictionary];
                        }
                    }
                }
            }
            else
            {
                model.isSelected = YES;
                [self.dicArray addObject:dic];
            }
        }
        else
        {
            //单选
//            model.isSelected = NO;
//
//            [dic setValue:sectionStr forKey:KEY_SECTION];
//            [dic setValue:rowStr forKey:KEY_ROW];
//
//            if (self.dicArray.count > 0)
//            {
//                for (int i = 0; i < self.dicArray.count; i ++)
//                {
//                    NSMutableDictionary *dictionary = self.dicArray[i];
//                    NSString *section = dictionary[KEY_SECTION];
//                    NSString *row = dictionary[KEY_ROW];
//                    if ([section integerValue] == indexPath.section && [row integerValue] != indexPath.row)
//                    {
//                        [self.dicArray removeObject:dictionary];
//                    }
//                }
//            }
        }
    }

    [self.collectionView reloadData];
}

- (void)saveRecord:(NSMutableArray *)dics
{
    NSArray *array = [NSArray arrayWithArray:dics];
    [USER_DEFAULTS setObject:array forKey:DEFAULTE_FILTER_BOX];
    [USER_DEFAULTS synchronize];
}

- (NSMutableArray *)getRecord
{
    NSArray *dics = [USER_DEFAULTS valueForKey:DEFAULTE_FILTER_BOX];
    NSMutableArray *dics_arr = [NSMutableArray new];
    dics_arr = [NSMutableArray arrayWithArray:dics];
    return dics_arr;
}


+ (void)clearRecord
{
    NSArray *array = [NSArray new];
    [USER_DEFAULTS setObject:array forKey:DEFAULTE_FILTER_BOX];
    [USER_DEFAULTS synchronize];
}

- (void)clickResetBtn
{
//    [self.dicArray removeAllObjects];
//
//    for (int i = 0; i < self.itemsArray.count; i++)
//    {
//        NSMutableArray * array = [NSMutableArray arrayWithArray:self.titlesArray[i]];
//
//        for (int k = 0; k < array.count; k++)
//        {
//            JHFilterBoxModel *model = array[k];
//            model.isSelected = NO;
//        }
//
//        [self.collectionView reloadData];
//    }

    [self.dicArray removeAllObjects];

    NSArray *array = [NSArray new];
    [USER_DEFAULTS setObject:array forKey:DEFAULTE_FILTER_BOX];
    [USER_DEFAULTS synchronize];

    for (int i = 0; i < self.itemsArray.count; i++)
    {
        NSMutableArray * array = [NSMutableArray arrayWithArray:self.titlesArray[i]];

        for (int k = 0; k < array.count; k++)
        {
            JHFilterBoxModel *model = array[k];
            model.isSelected = NO;
            //[array replaceObjectAtIndex:k withObject:model];
        }

        [self.collectionView reloadData];
    }

    NSString *textureStr = @"";
    
    NSMutableDictionary *dataDic = [NSMutableDictionary new];

    for (int i = 0; i < self.typesArray.count; i++)
    {
        NSString *cateType = self.typesArray[i];
        NSArray *array = [NSArray new];
        [dataDic setObject:array forKey:cateType];
    }

    if ([self.delegate respondsToSelector:@selector(filterBoxView:clickButton:title:)])
    {
        [self.delegate filterBoxView:self clickButton:dataDic title:textureStr];
    }

    //[self dismiss];
}

- (void)clickSureBtn
{
    [self saveRecord:self.dicArray];
    
    NSString *textureStr = @"";
    NSMutableDictionary *dataDic = [NSMutableDictionary new];
    
    if (self.dicArray.count > 0)
    {
        NSMutableArray *textureArray = [NSMutableArray new];
    
        for (int j = 0; j < self.dicArray.count; j++)
        {
           NSDictionary *dic = self.dicArray[j];
           NSString *type = dic[KEY_SECTION];
           NSString *name = dic[KEY_NAME];
    
           if ([type isEqualToString:@"texture"])
           {
              [textureArray addObject:name];
           }
        }
        
        
        NSMutableArray *nameArray = [NSMutableArray new];
        NSArray *modelsArr = self.titlesArray[0];
        if (modelsArr.count > 0 && modelsArr.count >= textureArray.count)
        {
            for (int i = 0; i<modelsArr.count; i++)
            {
                JHFilterBoxModel *model = modelsArr[i];
                NSString *name = model.name;
                
                if (textureArray.count > 0)
                {
                    for (int j = 0; j<textureArray.count; j++)
                    {
                        if ([name isEqualToString:textureArray[j]])
                        {
                            [nameArray addObject:name];
                        }
                    }
                }
            }
        }

        if (nameArray.count > 0)
        {
            textureStr = [nameArray objectAtIndex:0];
        }
        
//        //NSString *textureStr = [textureArray componentsJoinedByString:@","];
//        if (textureArray.count > 0)
//        {
//            textureStr = [textureArray objectAtIndex:0];
//        }
        
        
        for (int i = 0; i < self.typesArray.count; i++)
        {
            NSString *cateType = self.typesArray[i];
            
            NSMutableArray *array = [NSMutableArray new];
            
            for (int j = 0; j < self.dicArray.count; j++)
            {
                NSDictionary *dic = self.dicArray[j];
                NSString *type = dic[KEY_SECTION];
                NSString *Id = dic[KEY_ROW];
            
                if ([cateType isEqualToString:type])
                {
                    [array addObject:Id];
                }
            }
            
            [dataDic setObject:array forKey:cateType];
        }
    }
    else
    {
        for (int i = 0; i < self.typesArray.count; i++)
        {
            NSString *cateType = self.typesArray[i];
            NSArray *array = [NSArray new];
            [dataDic setObject:array forKey:cateType];
        }
    }

    if ([self.delegate respondsToSelector:@selector(filterBoxView:clickButton:title:)])
    {
        if (!([textureStr isEqualToString:@"红蓝宝"] ||[textureStr isEqualToString:@"翡翠"] ||[textureStr isEqualToString:@"和田玉"]))
        {
            textureStr = @"";
        }
        
        [self.delegate filterBoxView:self clickButton:dataDic title:textureStr];
    }
    
    [self dismiss];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH - LEFT_PAD, SCREEN_HEIGHT - 50 - 46 - 40 - 30) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.popView addSubview:_collectionView];
        
        [_collectionView registerClass:[JHFilterBoxCell class] forCellWithReuseIdentifier:JHCollectionViewCellID];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:JHReusableHeaderView];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:JHReusableFooterView];

    }
    return _collectionView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isDescendantOfView:self.collectionView])
    {
        return NO;
    }
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

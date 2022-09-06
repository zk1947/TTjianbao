//
//  PageView.m
//  AutographAlbum
//
//  Created by jiangchao on 2016/11/22.
//  Copyright © 2016年 jiangchao. All rights reserved.
//
#import "PageView.h"
#import "UIParameter.h"
#define MaxNums  10
@implementation PageView
{
   
    NSArray *myArray;
   // NSArray *classArray;
    NSString* viewString;
    NSArray *colorArray;
    NSMutableArray *viewNumArray;
    BOOL viewAlloc[MaxNums];
    BOOL fontChangeColor;
    
}
@synthesize pagerView;
- (instancetype)initWithFrame:(CGRect)frame WithTitles:(NSArray *)titles  WithColorArrays:(NSArray *)colors  WithViewString:(NSString*)String;{
    if (self = [super init]) {
        //Need You Edit,title for the toptabbar
        self.frame=frame;
        myArray = titles;
        //classArray = childVCs;
        viewString=String;
        colorArray = colors;
        self.viewTag=100;
    }
    
      return self;
}
-(void)createPagerView{

    [self createPagerView:myArray  WithColors:colorArray WithViewString:viewString];

}
//-(void)layoutSubviews{
//  
//     NSLog(@"dfdfd");
//    // [self createPagerView:myArray  WithColors:colorArray WithViewString:viewString];
//}
#pragma mark - CreateView
- (void)createPagerView:(NSArray *)titles  WithColors:(NSArray *)colors WithViewString:(NSString*)String {
    viewNumArray = [NSMutableArray array];
    //No Need to edit
    if (colors.count > 0) {
        for (NSInteger i = 0; i < colors.count; i++) {
            switch (i) {
                case 0:
                    _selectColor = colors[0];
                    break;
                case 1:
                    _unselectColor = colors[1];
                    break;
                case 2:
                    _underlineColor = colors[2];
                    break;
                case 3:
                    _topCoulor = colors[3];
                    break;
                default:
                    break;
            }
        }
    }
    
    if (titles.count > 0 && viewString!=nil) {
        pagerView = [[PageBaseView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) WithSelectColor:_selectColor WithUnselectorColor:_unselectColor WithUnderLineColor:_underlineColor WithTopColur:_topCoulor];
        pagerView.titleArray = myArray;
        [pagerView.lineBottom setHidden:NO];
        pagerView.currentPage=-1;
        [pagerView addObserver:self forKeyPath:@"currentPage" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        
        [self addSubview:pagerView];
        
//        //First ViewController present to the screen
//        if (viewString!=nil && myArray.count > 0) {
//            
//            for (int i=0; i<2; i++) {
//             
//                NSString *className = viewString;
//                Class class = NSClassFromString(className);
//                
//                NSObject *ctrl = class.new;
//                if ([ctrl isKindOfClass:[UIView class]]) {
//                    
//                    UIView* view=(UIView*)ctrl;
//                    view.frame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height - PageBtn);
//                    view.tag=self.viewTag+i;
//                    
//                    [pagerView.scrollView addSubview:view];
//                    viewAlloc[i] = YES;
//                    
//                }
//            }
//            
////            if (self.currentPage==0) {
////                
////                if ([self.delegate respondsToSelector:@selector(UpdateInfoForCurrentPage:Index:)]) {
////                    [self.delegate UpdateInfoForCurrentPage:self Index:0];
////                }
////                
////            }
//           
//            
//          
////
//            
//            
//            
//        }
//        
//        
//    }else {
//        
//        NSLog(@"You should correct titlesArray or childVCs count!");
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
  
    
    if ([keyPath isEqualToString:@"currentPage"]) {
        
         NSInteger oldPage = [change[@"old"] integerValue];
         NSInteger newPage = [change[@"new"] integerValue];
        
        if (newPage==oldPage) {
            return;
        }
       
        NSLog(@"newPage==%ld",newPage);
        if (myArray.count > 5) {
            CGFloat topTabOffsetX = 0;
            if (newPage >= 2) {
                if (newPage <= myArray.count - 3) {
                    topTabOffsetX = (newPage - 2) * More5LineWidth;
                }
                else {
                    if (newPage == myArray.count - 2) {
                        topTabOffsetX = (newPage - 3) * More5LineWidth;
                    }else {
                        topTabOffsetX = (newPage - 4) * More5LineWidth;
                    }
                }
            }
            else {
                if (newPage == 1) {
                    topTabOffsetX = 0 * More5LineWidth;
                }else {
                    topTabOffsetX = newPage * More5LineWidth;
                }
            }
            [UIView animateWithDuration:0.3 animations:^{
                
               [pagerView.topTab setContentOffset:CGPointMake(topTabOffsetX, 0) animated:NO];
                
            }];
            
            //  [pagerView.topTab setContentOffset:CGPointMake(topTabOffsetX, 0) animated:YES];
        }
       // for (NSInteger n = 0; n < myArray.count; n++) {
            
           // if (newPage == n ) {
                
            //    for (NSInteger i=n-1; i<=n+1&&i>=0&&i<[myArray count]; i++) {
                    
                    NSString *className = viewString;
                    Class class = NSClassFromString(className);
                    
                    
                    if (class && viewAlloc[newPage] == NO) {
                        
                        NSObject *ctrl = class.new;
                        if ([ctrl isKindOfClass:[UIView class]]) {
                            UIView *view = (UIView*)ctrl;
                            view.frame = CGRectMake(self.frame.size.width * newPage, 0, self.frame.size.width, self.frame.size.height - PageBtn);
                            view.tag=newPage+self.viewTag;
                            [pagerView.scrollView addSubview:view];
                            viewAlloc[newPage] = YES;
                            
                            if ([self.delegate respondsToSelector:@selector(CreatUIForPage:Index:)]) {
                                 [self.delegate CreatUIForPage:self Index:newPage];
                            }

                        }
                        
                    }
                
                    else if (!class) {
                        NSLog(@"您所提供的vc%li类并没有找到。  Your Vc%li is not found in this project!",(long)newPage + 1,(long)newPage + 1);
                    }
        
                if ([self.delegate respondsToSelector:@selector(UpdateInfoForCurrentPage:Index:)]) {
                    [self.delegate UpdateInfoForCurrentPage:self Index:newPage];
                }
    }
                    
             //   }
//}
        
        
   
}
#pragma mark - SetMethod

-(void)setCurrentPage:(NSInteger)currentPage{

    _currentPage=currentPage;
    pagerView.currentPage=_currentPage;

}
-(void)setTopCoulor:(UIColor *)topCoulor{

    pagerView.topTab.backgroundColor=topCoulor;
    
}
- (void)dealloc
{
      [pagerView removeObserver:self forKeyPath:@"currentPage"];
}
@end


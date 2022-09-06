//
//  JHMallHelper.m
//  TTjianbao
//
//  Created by lihui on 2020/12/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallHelper.h"
#import "TTjianbao.h"
#import "JHTMallGranduateeTableCell.h"
#import "JHMallOpreationTableCell.h"
#import "JHMallCategoryTableCell.h"

@implementation JHMallHelper


+ (JXPageListView *)pageListWithDelegate:(id)delegate {
    JXPageListView *page = [[JXPageListView alloc] initWithDelegate:delegate];
    page.listViewScrollStateSaveEnabled = NO;
    page.pinCategoryViewVerticalOffset = 0;
    page.pinCategoryView.backgroundColor = [UIColor whiteColor];
    page.pinCategoryView.cellSpacing = 25.f;
    page.pinCategoryView.contentEdgeInsetLeft = 15.f;
    page.pinCategoryView.titleFont = [UIFont fontWithName:kFontBoldPingFang size:14.f];
    page.pinCategoryView.titleColor = kColor999;
    page.pinCategoryView.titleSelectedFont = [UIFont fontWithName:kFontBoldPingFang size:14.f];
    page.pinCategoryView.titleSelectedColor = kColor222;
    page.indicatorView.indicatorColor = [UIColor clearColor];
        
    //Tips:成为mainTableView dataSource和delegate的代理，像普通UITableView一样使用它
    page.mainTableView.backgroundColor = [UIColor clearColor];
    page.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone; //默认无分割线
    page.mainTableView.delegate = delegate;
    page.mainTableView.dataSource = delegate;
    page.mainTableView.gestureDelegate = delegate;
    ///保障栏位置
    [page.mainTableView registerClass:[JHTMallGranduateeTableCell class] forCellReuseIdentifier:@"JHTMallGranduateeTableCell"];
    ///运营位
    [page.mainTableView registerClass:[JHMallOpreationTableCell class] forCellReuseIdentifier:@"JHMallOpreationTableCell"];
    [page.mainTableView registerClass:[JHMallCategoryTableCell class] forCellReuseIdentifier:@"JHMallCategoryTableCell"];
    return page;
}


@end

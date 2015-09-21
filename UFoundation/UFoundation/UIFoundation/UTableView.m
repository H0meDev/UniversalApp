//
//  BaseTableView.m
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <objc/runtime.h>
#import "UDefines.h"
#import "UTableView.h"
#import "UIView+UAExtension.h"
#import "NSObject+UAExtension.h"

@interface UTableView ()
{
    // For UTableViewDefault
    NSArray *_sectionArray;
}

@end

@implementation UTableView

@end

@implementation UTableViewDataRow

- (id)init
{
    self = [super init];
    if (self) {
        self.cellName = @"UTableViewCell";
        self.style = UITableViewCellStyleDefault;
    }
    
    return self;
}

+ (UTableViewDataRow *)row
{
    @autoreleasepool
    {
        return [[UTableViewDataRow alloc]init];
    }
}

@end

@implementation UTableViewDataSection

- (id)init
{
    self = [super init];
    if (self) {
        self.headerHeight = 0.01;
        self.footerHeight = 0.01;
        
        self.headerView = [[UIView alloc]init];
        self.footerView = [[UIView alloc]init];
        self.headerView.backgroundColor = sysClearColor();
        self.footerView.backgroundColor = sysClearColor();
    }
    
    return self;
}

+ (UTableViewDataSection *)section
{
    @autoreleasepool
    {
        return [[UTableViewDataSection alloc]init];
    }
}

- (void)addRow:(UTableViewDataRow *)row
{
    if (!checkClass(row, UTableViewDataRow)) {
        return;
    }
    
    NSMutableArray *marray = nil;
    if (_rowArray) {
        marray = [NSMutableArray arrayWithArray:_rowArray];
    } else {
        marray = [NSMutableArray array];
    }
    
    [marray addObject:row];
    _rowArray = [marray copy];
}

@end

@implementation UTableView (UTableViewDefault)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = rgbColor(239, 239, 239);
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSArray *)sectionArray
{
    return _sectionArray;
}

- (void)setSectionArray:(NSArray *)sectionArray
{
    _sectionArray = sectionArray;
    
    // Reload data
    [super performOnMainThread:@selector(reloadData)];
}

- (id<UTableViewDefaultDelegate>)defaultDelegate
{
    return objc_getAssociatedObject(self, "UTableViewDefaultDelegate");
}

- (void)setDefaultDelegate:(id<UTableViewDefaultDelegate>)delegate
{
    objc_setAssociatedObject(self, "UTableViewDefaultDelegate", delegate, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (checkValidNSArray(_sectionArray)) {
        return _sectionArray.count;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UTableViewDataSection *sectionItem = (UTableViewDataSection *)(_sectionArray[section]);
    if (checkValidNSArray(sectionItem.rowArray)) {
        return sectionItem.rowArray.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Section & row info
    UTableViewDataSection *sectionItem = (UTableViewDataSection *)_sectionArray[indexPath.section];
    UTableViewDataRow *rowItem = (UTableViewDataRow *)sectionItem.rowArray[indexPath.row];
    
    if (rowItem.cellHeight != -1) {
        return rowItem.cellHeight;
    }
    
    // Auto resize height
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        // Record cell height
        rowItem.cellHeight = cell.sizeHeight;
        return cell.sizeHeight;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UTableViewDataSection *sectionItem = (UTableViewDataSection *)_sectionArray[section];
    
    return sectionItem.headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    UTableViewDataSection *sectionItem = (UTableViewDataSection *)_sectionArray[section];
    
    return sectionItem.footerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UTableViewDataSection *sectionItem = (UTableViewDataSection *)_sectionArray[section];
    
    return sectionItem.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UTableViewDataSection *sectionItem = (UTableViewDataSection *)_sectionArray[section];
    
    return sectionItem.footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Section & row info
    UTableViewDataSection *sectionItem = (UTableViewDataSection *)_sectionArray[indexPath.section];
    UTableViewDataRow *rowItem = (UTableViewDataRow *)sectionItem.rowArray[indexPath.row];
    
    // Load cell
    UTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rowItem.cellName];
    if (!cell) {
        // Register nib
        registerCellNibName(rowItem.cellName);
        cell = [tableView dequeueReusableCellWithIdentifier:rowItem.cellName];
        
        // Check if xib not be used.
        if (!cell) {
            Class ClassOfCell = NSClassFromString(rowItem.cellName);
            if (checkClass(ClassOfCell, UTableViewCell)) {
                cell = [[ClassOfCell alloc]initWithStyle:rowItem.style reuseIdentifier:rowItem.cellName];
            } else {
                cell = [[UTableViewCell alloc]init];
            }
        }
    }
    
    // Set cell data
    [cell setCellData:rowItem.cellData];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.defaultDelegate && [self.defaultDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [self.defaultDelegate tableView:(UTableView *)tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.defaultDelegate && [self.defaultDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
    {
        [self.defaultDelegate tableView:(UTableView *)tableView didDeselectRowAtIndexPath:indexPath];
    }
}

@end


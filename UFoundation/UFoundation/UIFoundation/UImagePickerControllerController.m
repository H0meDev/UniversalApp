//
//  UImagePickerControllerController.m
//  UFoundation
//
//  Created by Think on 15/8/11.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UImagePickerControllerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UDefines.h"
#import "UTableView.h"
#import "UTableViewCell.h"
#import "UIImage+UAExtension.h"
#import "UITableView+UAExtension.h"
#import "UITableViewCell+UAExtension.h"


@protocol UImageSelectorItemCellDelegate <NSObject>

@required
- (void)selectorItemDidTouched:(NSInteger)index selected:(BOOL)selected;

@end

@interface UImageSelectorItemCell : UTableViewCell

@property (nonatomic, weak) id<UImageSelectorItemCellDelegate> delegate;

@end

@implementation UImageSelectorItemCell

- (void)setCellData:(id)cellData
{
    if (checkClass(cellData, NSArray)) {
        NSArray *data = (NSArray *)cellData;
        NSInteger startIndex = self.tag * 4;
        NSInteger maxIndex = startIndex + 4;
        maxIndex = (data.count <= maxIndex)?data.count:maxIndex;
        
        CGFloat originX = 4;
        CGFloat width = (screenWidth() - 20) / 4;
        for (NSInteger i = startIndex; i < maxIndex; i ++) {
            // Image
            ALAsset *asset = data[i];
            UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
            
            // Button for selection
            UNavigationBarButton *button = [UNavigationBarButton button];
            button.tag = i;
            button.frame = rectMake(originX, 2, width, width);
            [button setImage:image];
            [button addTouchDownTarget:self action:@selector(selectAction:)];
            [self.contentView addSubview:button];
            
            originX += width + 4;
        }
    }
}

- (void)selectAction:(UNavigationBarButton *)button
{
    button.selected = !button.selected;
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectorItemDidTouched:selected:)]) {
        [_delegate selectorItemDidTouched:button.tag selected:button.selected];
    }
}

@end

@interface UImageSelectorControllerController : UViewController <UITableViewDataSource, UITableViewDelegate, UImageSelectorItemCellDelegate>
{
    ALAssetsGroup *_assetsGroup;
    NSMutableArray *_assetArray;
    NSMutableArray *_selectedItems;
    
    // Count
    NSInteger _countOfPhotos;
    NSInteger _countOfVideos;
}

@property (nonatomic, strong) UTableView *tableView;
@property (nonatomic, weak) UImagePickerControllerController *picker;

@end

@implementation UImageSelectorControllerController

- (id)initWithData:(id)data
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (checkClass(data, ALAssetsGroup)) {
            _assetsGroup = (ALAssetsGroup *)data;
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (systemVersionFloat() >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // Resize container
    CGFloat originY = statusHeight() + naviHeight();
    self.containerView.frame = rectMake(0, originY, screenWidth(), screenHeight() - originY);
    
    if (checkClass(_assetsGroup, ALAssetsGroup)) {
        NSString *title = [_assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        self.navigationBarView.title = title;
        
        // Image list
        [self tableView];
        
        // Load assets
        [self loadAssetsWith:_assetsGroup];
    }
    
    UNavigationBarButton *rightButton = [UNavigationBarButton button];
    rightButton.frame = rectMake(screenWidth() - 46, 0, 46, naviHeight() - naviBLineH());
    [rightButton setTitle:@"选择"];
    [rightButton setTitleFont:systemFont(16)];
    [rightButton setTitleColor:rgbColor(29, 158, 246)];
    [rightButton addTarget:self action:@selector(rightButtonAction)];
    self.navigationBarView.rightButton = rightButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    // Keep the same style
    self.statusBarView.backgroundColor = _picker.statusBarView.backgroundColor;
    
    self.navigationBarView.titleFont = _picker.navigationBarView.titleFont;
    self.navigationBarView.titleColor = _picker.navigationBarView.titleColor;
    self.navigationBarView.backgroundColor = _picker.navigationBarView.backgroundColor;
    self.navigationBarView.backgroundImage = _picker.navigationBarView.backgroundImage;
    self.navigationBarView.bottomLineColor = _picker.navigationBarView.bottomLineColor;
    self.navigationBarView.bottomLineHidden = _picker.navigationBarView.bottomLineHidden;
}

#pragma mark - Properties

- (UTableView *)tableView
{
    if (_tableView) {
        return _tableView;
    }
    
    CGFloat height = screenHeight() - statusHeight() - naviHeight();
    
    UTableView *tableView = [[UTableView alloc]init];
    tableView.frame = rectMake(0, 0, screenWidth(), height);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self addSubview:tableView];
    _tableView = tableView;
    
    return _tableView;
}

#pragma mark - Methods

- (void)loadAssetsWith:(ALAssetsGroup *)group
{
    if (checkClass(group, ALAssetsGroup)) {
        // Clear
        _countOfPhotos = 0;
        _countOfVideos = 0;
        
        if (!_assetArray) {
            _assetArray = [NSMutableArray array];
        } else {
            [_assetArray removeAllObjects];
        }
        
        // Enumeration
        ALAssetsGroupEnumerationResultsBlock result = ^(ALAsset *asset, NSUInteger index, BOOL *stop)
        {
            if (asset) {
                NSString *type = [asset valueForProperty:ALAssetPropertyType];
                if ([type isEqualToString:ALAssetTypePhoto]) {
                    _countOfPhotos ++;
                } else if ([type isEqualToString:ALAssetTypeVideo]) {
                    _countOfVideos ++;
                }
                
                [_assetArray addObject:asset];
            } else {
                if (_assetArray && _assetArray.count > 0) {
                    [_tableView reloadData];
                }
            }
        };
        
        [_assetsGroup enumerateAssetsUsingBlock:result];
    }
}

#pragma mark - Actions

- (void)rightButtonAction
{
    if (self.navigationController) {
        self.countOfControllerToPop = 2;
        [self popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
    if (_picker && _picker.delegate && [_picker.delegate respondsToSelector:@selector(imagePickerDidSelected:)]) {
        NSMutableArray *imageArray = [NSMutableArray array];
        for (NSNumber *item in _selectedItems) {
            NSInteger index = item.integerValue;
            [imageArray addObject:_assetArray[index]];
        }
        
        [_picker.delegate imagePickerDidSelected:imageArray];
    }
}

#pragma mark - UImageSelectorItemCellDelegate

- (void)selectorItemDidTouched:(NSInteger)index selected:(BOOL)selected
{
    if (!_selectedItems) {
        _selectedItems = [NSMutableArray array];
    }
    
    if (selected) {
        [_selectedItems addObject:@(index)];
    } else {
        [_selectedItems removeObject:@(index)];
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_assetArray) {
        return ceilf(_assetArray.count / 4.0);
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (screenWidth() - 20) / 4 + 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UImageSelectorItemCell *cell = [tableView cellWith:@"UImageSelectorItemCell"];
    if (!cell) {
        cell = [UImageSelectorItemCell cellWithStyle:UITableViewCellStyleSubtitle];
    }
    
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    [cell setCellData:_assetArray];
    
    return cell;
}

@end

@interface UImagePickerGroupCell : UTableViewCell

@end

@implementation UImagePickerGroupCell

- (void)setCellData:(id)cellData
{
    if (checkClass(cellData, ALAssetsGroup)) {
        ALAssetsGroup *data = (ALAssetsGroup *)cellData;
        CGImageRef image = data.posterImage;
        CGFloat height = CGImageGetHeight(image);
        CGFloat scale = height / (90 - 16);
        
        self.imageView.image = [UIImage imageWithCGImage:image scale:scale orientation:UIImageOrientationUp];
        self.textLabel.text = [data valueForProperty:ALAssetsGroupPropertyName];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSString *text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:data.numberOfAssets]];
        self.detailTextLabel.text = text;
    }
}

@end

@interface UImagePickerControllerController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_libraryGroups;
    ALAssetsLibrary *_assetsLibrary;
    ALAssetsFilter *_assetsFilter;
    BOOL _showEmptyGroups;
}

@property (nonatomic, strong) UTableView *tableView;

@end

@implementation UImagePickerControllerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (systemVersionFloat() >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // Resize container
    CGFloat originY = statusHeight() + naviHeight();
    self.containerView.frame = rectMake(0, originY, screenWidth(), screenHeight() - originY);
    
    // Navigation bar
    self.navigationBarView.title = @"相簿";
    UNavigationBarButton *leftButton = [UNavigationBarButton button];
    leftButton.frame = rectMake(0, 0, 46, naviHeight() - naviBLineH());
    [leftButton setTitle:@"取消"];
    [leftButton setTitleFont:systemFont(16)];
    [leftButton setTitleColor:rgbColor(29, 158, 246)];
    [leftButton addTarget:self action:@selector(leftButtonAction)];
    self.navigationBarView.leftButton = leftButton;
    
    // Table view
    [self tableView];
    
    // Load all groups
    [self loadLibraryGroups];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    //
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Properties

- (UTableView *)tableView
{
    if (_tableView) {
        return _tableView;
    }
    
    CGFloat height = screenHeight() - statusHeight() - naviHeight();
    
    UTableView *tableView = [[UTableView alloc]init];
    tableView.frame = rectMake(0, 0, screenWidth(), height);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self addSubview:tableView];
    _tableView = tableView;
    
    return _tableView;
}

#pragma mark - Methods

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t predicate = 0;
    static ALAssetsLibrary *library = nil;
    
    dispatch_once(&predicate, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    
    return library;
}

- (void)loadLibraryGroups
{
    ALAssetsLibraryGroupsEnumerationResultsBlock results = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group) {
            [group setAssetsFilter:_assetsFilter];
            if (group.numberOfAssets > 0 || !_showEmptyGroups) {
                [_libraryGroups addObject:group];
            }
        } else {
            // Load all groups in table
            [_tableView reloadData];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failure = ^(NSError *error)
    {
        //
    };
    
    if (!_assetsLibrary) {
        _assetsLibrary = [self.class defaultAssetsLibrary];
    }
    
    if (!_libraryGroups) {
        _libraryGroups = [NSMutableArray array];
    } else {
        [_libraryGroups removeAllObjects];
    }
    
    // Camera
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:results failureBlock:failure];
    
    // Others
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupLibrary | ALAssetsGroupPhotoStream usingBlock:results failureBlock:failure];
}

#pragma mark - Actions

- (void)leftButtonAction
{
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_libraryGroups) {
        return _libraryGroups.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UImagePickerGroupCell *cell = [tableView cellWith:@"UImagePickerGroupCell"];
    if (!cell) {
        cell = [UImagePickerGroupCell cellWithStyle:UITableViewCellStyleSubtitle];
    }
    
    [cell setCellData:_libraryGroups[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ALAssetsGroup *group = _libraryGroups[indexPath.row];
    UImageSelectorControllerController *selector = [[UImageSelectorControllerController alloc]initWithData:group];
    selector.picker = self; // Response in selector controller
    [self pushViewController:selector animated:YES];
}

@end

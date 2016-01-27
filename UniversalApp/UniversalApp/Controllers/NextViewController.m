//
//  NextViewController.m
//  UniversalApp
//
//  Created by Think on 15/8/27.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "NextViewController.h"
#import "LastViewController.h"
#import "NetworkSDK.h"
#import "UserInfo.h"

@interface NextViewController ()
{
    UHTTPOperation *_request;
}

@property (nonatomic, strong) UButton *button;

@end

@implementation NextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBarView.title = @"Next";
//    self.statusBarView.backgroundColor = sysClearColor();
//    self.navigationBarView.backgroundColor = sysClearColor();
    self.containerView.backgroundColor = sysLightGrayColor();
    
//    UNavigationBarButton *rightButton = [UNavigationBarButton button];
//    rightButton.frame = rectMake(screenWidth() - 70, 0, 70, naviHeight() - naviBLineH());
//    [rightButton setHAlpha:0.3];
//    [rightButton setTitle:@"Option"];
//    [rightButton setTitleColor:sysWhiteColor()];
//    [rightButton setTitleFont:systemFont(16)];
//    [rightButton addTarget:self action:@selector(buttonAction)];
//    self.navigationBarView.rightButton = rightButton;
    
    CGFloat height = statusHeight() + naviHeight();
    UView *navigationView = [[UView alloc]init];
    navigationView.frame = rectMake(0, - height, screenWidth(), height);
    navigationView.backgroundColor = sysLightGrayColor();
    [self addSubview:navigationView];
    
    UButton *button = [UButton button];
    button.frame = rectMake(0, 160, screenWidth(), 50);
    [button setTitle:@"Push"];
    [button setTitleColor:sysWhiteColor()];
    [button setHTitleColor:sysLightGrayColor()];
    button.backgroundColor = sysRedColor();
    [button setTarget:self action:@selector(buttonAction)];
    [self addSubview:button];
    
//    // 校导网登录
//    LoginRequest *request = [LoginRequest model];
//    request.username = @"";
//    request.password = @"";
//    
//    __weak typeof(self) weakself = self;
//    _request = [NetworkSDK loginWith:request callback:^(UHTTPStatus *status, NetworkResponse *response) {
//        if (NetworkSDKCodeOK == response.status) {
//            // 登陆成功
//            if (checkClass(response.data, LoginResponseData)) {
//                [[UserInfo info]setLogin:response.data];
//                UDataBase *database = [UserInfo info].database;
////                [database createTableWith:[response.data class]];
////                [database insertWithArray:@[response.data, response.data, response.data]];
//                NSArray *results = [database selectWith:[response.data class] conditions:nil];
//                NSLog(@"%@", results);
//            }
//            
//            // 接下来就获取信息吧
//            [NetworkSDK userInfoWithCallback:^(UHTTPStatus *status,NetworkResponse *response) {
//                if (NetworkSDKCodeOK == response.status) {
//                    // 获取成功
//                } else {
//                    // 获取失败
//                }
//                
//                weakself.button.hidden = NO;
//            }];
//        } else {
//            // 登录失败
//        }
//    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_request && !_request.isCancelled) {
        [_request cancel];
    }
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

- (void)buttonAction
{
    LastViewController *next = [[LastViewController alloc]init];
    [self pushViewController:next];
}

@end

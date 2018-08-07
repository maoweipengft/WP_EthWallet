//
//  WalletNavigationController.m
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/7/30.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import "WalletNavigationController.h"
#import "UINavigationBar+BackgroundColor.h"
@interface WalletNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation WalletNavigationController


#pragma mark - Lazy load
- (NSMutableArray *)blackList {
    if (!_blackList) {
        _blackList = [NSMutableArray array];
    }
    return _blackList;
}

#pragma mark - Public
- (void)addFullScreenPopBlackListItem:(UIViewController *)viewController {
    if (!viewController) {
        return ;
    }
    [self.blackList addObject:viewController];
}

- (void)removeFromFullScreenPopBlackList:(UIViewController *)viewController {
    for (UIViewController *vc in self.blackList) {
        if (vc == viewController) {
            [self.blackList removeObject:vc];
        }
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏设置
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setNavColor:[UIColor blueColor]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //全局滑动返回
    id target = self.interactivePopGestureRecognizer.delegate;
    
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    
    UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
}



#pragma mark - UIGestureRecognizerDelegate
//  防止导航控制器只有一个rootViewcontroller时触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    // 根据具体控制器对象决定是否开启全屏右滑返回
    for (UIViewController *viewController in self.blackList) {
        if ([self topViewController] == viewController) {
            return NO;
        }
    }
    
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    //不需要滑动返回
    if ([self.topViewController isKindOfClass:NSClassFromString(@"HomeViewController")])
    {
        
        
        return NO;
    }
    
    // 解决右滑和UITableView左滑删除的冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return self.childViewControllers.count == 1 ? NO : YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

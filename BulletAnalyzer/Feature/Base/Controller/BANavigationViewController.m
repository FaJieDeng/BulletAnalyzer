
//
//  BANavigationViewController.m
//  BulletAnalyzer
//
//  Created by Zj on 17/6/4.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BANavigationViewController.h"
#import "UIBarButtonItem+ZJExtension.h"
#import "BATransition.h"

@interface BANavigationViewController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@end

@implementation BANavigationViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavibationBar];
    
    //设置全局右滑返回
    [self setupRightPanReturn];

    self.delegate = self;
    self.transitioningDelegate = self;
    //self.modalPresentationStyle = UIModalPresentationCustom;
}


- (void)setBackGestureEnable:(BOOL)backGestureEnable{
    
    if (!backGestureEnable) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _backGestureEnable = backGestureEnable;
        });
    } else {
        _backGestureEnable = backGestureEnable;
    }
}


- (void)dealloc{
    [BANotificationCenter removeObserver:self];
}


#pragma mark - private
- (void)setupNavibationBar{

    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:BANavigationBarColor] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.contentMode = UIViewContentModeScaleAspectFill;
    self.navigationBar.translucent = YES;
    self.navigationBar.shadowImage = [UIImage imageWithColor:BANavigationBarColor];
    self.navigationBar.tintColor = BAThemeColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : BAWhiteColor};
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


#pragma mark - transitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{

    //if (!_cycleRect.origin.x) {
    //    _cycleRect = CGRectMake(BAScreenWidth / 2, BAScreenHeight / 2, 0, 0);
    //}
    //return [BATransition transitionWithType:BATransitionTypePresent animation:BATransitionAnimationCycle attribute:@{BATransitionAttributeCycleRect : [NSValue valueWithCGRect:_cycleRect]}];
    
    return [BATransition transitionWithType:BATransitionTypePresent animation:BATransitionAnimationGradient attribute:nil];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    //if (!_cycleRect.origin.x) {
    //    _cycleRect = CGRectMake(BAScreenWidth / 2, BAScreenHeight / 2, 0, 0);
    //}
    //return [BATransition transitionWithType:BATransitionTypeDismiss animation:BATransitionAnimationCycle attribute:@{BATransitionAttributeCycleRect : [NSValue valueWithCGRect:_cycleRect]}];
    
    return [BATransition transitionWithType:BATransitionTypeDismiss animation:BATransitionAnimationGradient attribute:nil];
}


#pragma mark - 每次push之后生成返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithImg:@"back_black"  highlightedImg:nil target:self action:@selector(popViewController)];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
        viewController.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // push的时候禁用手势
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
        self.backGestureEnable = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}


- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
    for (UIViewController *viewController in viewControllers) {
        if (viewController != [viewControllers firstObject]) {
            viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithImg:@"back_black"  highlightedImg:nil target:self action:@selector(popViewController)];
            viewController.hidesBottomBarWhenPushed = YES;
            viewController.edgesForExtendedLayout = UIRectEdgeNone;
            viewController.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    
    // push的时候禁用手势
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
        self.backGestureEnable = NO;
    }
    
    [super setViewControllers:viewControllers animated:animated];
}


- (void)popViewController{
    [self popViewControllerAnimated:YES];
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    // pop的时候禁用手势
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return [super popViewControllerAnimated:animated];
}


- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    
    // pop的时候禁用手势
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return [super popToRootViewControllerAnimated:animated];
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // push完成后的时候判断是否在根控制器启用手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        if ([navigationController.viewControllers count] == 1) {
            navigationController.interactivePopGestureRecognizer.enabled = NO;
        } else {
            self.backGestureEnable = YES;
            navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}


#pragma mark - 处理全局右滑返回
- (void)setupRightPanReturn{
    
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 获取返回方法
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    
    //  创建pan手势 作用范围是全屏
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:handler];
    pan.delegate = self;
    [targetView addGestureRecognizer:pan];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    
    //解决与左滑手势冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0 || !self.isBackGestureEnable) {
        return NO;
    }
    return self.childViewControllers.count == 1 ? NO : YES;
}

@end

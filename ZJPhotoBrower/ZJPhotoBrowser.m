
//
//  ViewController.m
//  ZJPhotoBrower
//
//  Created by 吴孜健 on 17/2/14.
//  Copyright © 2017年 吴孜健. All rights reserved.
//

#import "ZJPhotoBrowser.h"
#import "<#header#>"
static const NSTimeInterval kAnimationDuration = 0.3;
static const NSTimeInterval kSpringAnimationDuration = 0.5;

@interface ZJPhotoBrowser ()<UIScrollViewDelegate,UIViewControllerTransitioningDelegate,CAAnimationDelegate>
{
    CGPoint _startLocation;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *photoItems;
@property (nonatomic, strong) NSMutableSet *reusableItemViews;
@property (nonatomic, strong) NSMutableArray *visibleItemViews;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, assign) BOOL presented;

@end

@implementation ZJPhotoBrowser

+ (instancetype)browserWithPhotoItems:(NSArray<ZJPhotoItem *> *)photoItems selectedIndex:(NSInteger)selectedIndex
{
    ZJPhotoBrowser *browser = [[ZJPhotoBrowser alloc]initWithPhotoItems:photoItems selectedIndex:selectedIndex];
    return browser;
}

- (instancetype)init
{
    NSAssert(NO, @"Use initWithMediaItems: instead.");
    return nil;
}

- (instancetype)initWithPhotoItems:(NSArray<ZJPhotoItem *> *)photoItems selectedIndex:(NSInteger)selectedIndex
{
    if (self = [super init]) {
        _photoItems = [NSMutableArray arrayWithArray:photoItems];
        _currentPage = selectedIndex;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        _reusableItemViews = [[NSMutableSet alloc] init];
        _visibleItemViews = [[NSMutableArray alloc] init];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundView.alpha = 0;
    [self.view addSubview:_backgroundView];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

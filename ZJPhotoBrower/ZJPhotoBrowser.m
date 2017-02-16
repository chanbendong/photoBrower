
//
//  ViewController.m
//  ZJPhotoBrower
//
//  Created by 吴孜健 on 17/2/14.
//  Copyright © 2017年 吴孜健. All rights reserved.
//

#import "ZJPhotoBrowser.h"
#import "ZJPhotoView.h"
#import "UIImageView+YYWebImage.h"
#import "UIImage+YYAdd.h"
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
    
    CGRect rect = self.view.bounds;
    rect.origin.x -=  ZJPhotoViewPadding;
    rect.size.width += 2*ZJPhotoViewPadding;
    _scrollView = [[UIScrollView alloc]initWithFrame:rect];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    if (_pageindicatorStyle == ZJPhotoBrowserPageIndicatorStyleDot) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-40, self.view.bounds.size.width, 20)];
        _pageControl.numberOfPages = _photoItems.count;
        _pageControl.currentPage = _currentPage;
        [self.view addSubview:_pageControl];
    }else{
        _pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-40, self.view.bounds.size.width, 20)];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.font = [UIFont systemFontOfSize:16];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        [self configPageLabelWithPage:_currentPage];
        [self.view addSubview:_pageLabel];
    }
    
    CGSize contentSize = CGSizeMake(rect.size.width*_photoItems.count, rect.size.height);
    _scrollView.contentSize = contentSize;
  
//    [self addGestureRecognizer]
    
    CGPoint contectOffset = CGPointMake(_scrollView.frame.size.width*_currentPage, 0);
    [_scrollView setContentOffset:contectOffset animated:NO];
    if (contectOffset.x == 0) {
        [self scrollViewDidScroll:_scrollView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ZJPhotoItem *item = [_photoItems objectAtIndex:_currentPage];
    ZJPhotoView *photoView =[self photoViewForPage:_currentPage];
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:item.imageUrl];
    if ([manager.cache getImageForKey:key withType:YYImageCacheTypeMemory]) {
        [self configPhotoView:photoView withItem:item];
    }else{
        photoView.imageView.image = item.thumbImage;
        [photoView resizeImageView];
    }
    
    CGRect endRect = photoView.imageView.frame;
    CGRect sourceRect;
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 8.0 && systemVersion < 9.0) {
        sourceRect = [item.sourceView.superview convertRect:item.sourceView.frame toCoordinateSpace:photoView];
    } else {
        sourceRect = [item.sourceView.superview convertRect:item.sourceView.frame toView:photoView];
    }
    photoView.imageView.frame = sourceRect;
    if (_backgroundStyle == ZJPhotoBrowserBackgroundStyleBlur) {
        [self blurBackgroundWithImage:[self screenshot] animated:NO];
    } else if (_backgroundStyle == ZJPhotoBrowserBackgroundStyleBlurPhoto) {
        [self blurBackgroundWithImage:item.thumbImage animated:NO];
    }
    
    if (_bounces) {
        [UIView animateWithDuration:kSpringAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:kNilOptions animations:^{
            photoView.imageView.frame = endRect;
            self.view.backgroundColor = [UIColor blackColor];
        } completion:^(BOOL finished) {
            [self configPhotoView:photoView withItem:item];
            _presented = YES;
            [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

        }];
    }else{
        [UIView animateWithDuration:kAnimationDuration animations:^{
            photoView.imageView.frame = endRect;
            self.view.backgroundColor = [UIColor blackColor];
            _backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [self configPhotoView:photoView withItem:item];
            _presented = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }];
    }
}

- (void)dealloc
{
}

// MARK: - Public

- (void)showFromViewController:(UIViewController *)vc {
    [vc presentViewController:self animated:NO completion:nil];
}

// MARK: - Private

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -获取当前图片
- (ZJPhotoView *)photoViewForPage:(NSInteger)page
{
    for (ZJPhotoView *photoView in _visibleItemViews) {
        if (photoView.tag == page) {
            return photoView;
        }
    }
    return nil;
}

- (ZJPhotoView *)dequeueReusableItemView {
    ZJPhotoView *photoView = [_reusableItemViews anyObject];
    if (photoView == nil) {
        photoView = [[ZJPhotoView alloc] initWithFrame:_scrollView.bounds];
    } else {
        [_reusableItemViews removeObject:photoView];
    }
    photoView.tag = -1;
    return photoView;
}

- (void)updateReusableItemViews {
    NSMutableArray *itemsForRemove = @[].mutableCopy;
    for (ZJPhotoView *photoView in _visibleItemViews) {
        if (photoView.frame.origin.x + photoView.frame.size.width < _scrollView.contentOffset.x - _scrollView.frame.size.width ||
            photoView.frame.origin.x > _scrollView.contentOffset.x + 2 * _scrollView.frame.size.width) {
            [photoView removeFromSuperview];
            [self configPhotoView:photoView withItem:nil];
            [itemsForRemove addObject:photoView];
            [_reusableItemViews addObject:photoView];
        }
    }
    [_visibleItemViews removeObjectsInArray:itemsForRemove];
}

- (void)configItemViews
{
    NSInteger page = _scrollView.contentOffset.x/_scrollView.frame.size.width+0.5;
    for (NSInteger i = page-1; i <= page+1; i++) {
        if (i < 0 || i >= _photoItems.count) {
            continue;
        }
        ZJPhotoView *photoView = [self photoViewForPage:i];
        if (photoView == nil) {
            photoView = [self dequeueReusableItemView];
            CGRect rect = _scrollView.bounds;
            rect.origin.x = i * _scrollView.bounds.size.width;
            photoView.frame = rect;
            photoView.tag = i;
            [_scrollView addSubview:photoView];
            [_visibleItemViews addObject:photoView];
        }
        if (photoView.item == nil && _presented) {
            ZJPhotoItem *item = [_photoItems objectAtIndex:i];
            [self configPhotoView:photoView withItem:item];
        }
    }
    if (page != _currentPage && _presented) {
        ZJPhotoItem *item = [_photoItems objectAtIndex:page];
        if (_backgroundStyle == ZJPhotoBrowserBackgroundStyleBlurPhoto) {
            [self blurBackgroundWithImage:item.thumbImage animated:YES];
        }
        _currentPage = page;
        if (_pageindicatorStyle == ZJPhotoBrowserPageIndicatorStyleDot) {
            _pageControl.currentPage = page;
        }else{
            [self configPageLabelWithPage:_currentPage];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(ZJPhotoBrowser:didSelectItem:atIndex:)]) {
            [_delegate ZJPhotoBrowser:self didSelectItem:item atIndex:page];
        }
    }
}

- (void)dismissAnimated:(BOOL)animated
{
    for (ZJPhotoView *photoView in _visibleItemViews) {
        [photoView cancelCurrentImageLoad];
    }
    ZJPhotoItem *item = [_photoItems objectAtIndex:_currentPage];
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            item.sourceView.alpha = 1;
        }];
    }else{
        item.sourceView.alpha = 1;
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)performRotationWithPan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self.view];
    CGPoint location = [pan locationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    ZJPhotoView *photoView = [self photoViewForPage:_currentPage];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _startLocation = location;
            [self handlePanBegin];
            break;
            
        default:
            break;
    }
}


- (void)configPageLabelWithPage:(NSInteger)currentPage
{
    
}

- (void)handlePanBegin
{
}

- (void)configPhotoView:(ZJPhotoView *)photoView withItem:(ZJPhotoItem *)item {
    [photoView setItem:item determinate:(_loadingStyle == ZJPhotoBrowserImageLoadingStyleDeterminate)];
}

-(UIWindow*)getCurrentKeyWindow
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    return window;
}
- (UIImage *)screenshot {
    UIWindow *window = [self getCurrentKeyWindow];
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, YES, [UIScreen mainScreen].scale);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



- (void)blurBackgroundWithImage:(UIImage *)image animated:(BOOL)animated {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *blurImage = [image imageByBlurDark];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (animated) {
                [UIView animateWithDuration:kAnimationDuration animations:^{
                    _backgroundView.alpha = 0;
                } completion:^(BOOL finished) {
                    _backgroundView.image = blurImage;
                    [UIView animateWithDuration:kAnimationDuration animations:^{
                        _backgroundView.alpha = 1;
                    } completion:nil];
                }];
            } else {
                _backgroundView.image = blurImage;
            }
        });
    });
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

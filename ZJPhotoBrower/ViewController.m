//
//  ViewController.m
//  ZJPhotoBrower
//
//  Created by 吴孜健 on 17/2/20.
//  Copyright © 2017年 吴孜健. All rights reserved.
//

#import "ViewController.h"
#import "ZJPhotoBrowser.h"
#import "UIImageView+YYWebImage.h"
@interface ViewController ()<ZJPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *urls;
@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _urls = @[@"http://ww4.sinaimg.cn/bmiddle/a15bd3a5jw1f12r9ku6wjj20u00mhn22.jpg",
              @"http://ww2.sinaimg.cn/bmiddle/a15bd3a5jw1f01hkxyjhej20u00jzacj.jpg",
              @"http://ww4.sinaimg.cn/bmiddle/a15bd3a5jw1f01hhs2omoj20u00jzwh9.jpg",
              @"http://ww2.sinaimg.cn/bmiddle/a15bd3a5jw1ey1oyiyut7j20u00mi0vb.jpg",
              @"http://ww2.sinaimg.cn/bmiddle/a15bd3a5jw1exkkw984e3j20u00miacm.jpg",
              @"http://ww4.sinaimg.cn/bmiddle/a15bd3a5jw1ezvdc5dt1pj20ku0kujt7.jpg",
              @"http://ww3.sinaimg.cn/bmiddle/a15bd3a5jw1ew68tajal7j20u011iacr.jpg",
              @"http://ww2.sinaimg.cn/bmiddle/a15bd3a5jw1eupveeuzajj20hs0hs75d.jpg",
              @"http://ww2.sinaimg.cn/bmiddle/d8937438gw1fb69b0hf5fj20hu13fjxj.jpg"];
    
    CGFloat top = 64;
    CGFloat gap = 5;
    NSInteger count = 3;
    CGFloat width = (self.view.frame.size.width - gap * (count + 1)) / count;
    CGFloat height = width;
    _imageViews = @[].mutableCopy;
    for (int i = 0; i < _urls.count; i++) {
        CGFloat x = gap + (width + gap) * (i % count);
        CGFloat y = top + gap + (height + gap) * (i / count);
        CGRect rect = CGRectMake( x, y, width, height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.imageURL = [NSURL URLWithString:_urls[i]];
        imageView.clipsToBounds = YES;
        imageView.tag = i;
        imageView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self.view addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imageView addGestureRecognizer:tap];
        [_imageViews addObject:imageView];
    }

}

- (void)imageViewTapped:(UITapGestureRecognizer *)tap {
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < _imageViews.count; i++) {
        NSString *url = [_urls[i] stringByReplacingOccurrencesOfString:@"bmiddle" withString:@"large"];
        UIImageView *imageView = _imageViews[i];
        ZJPhotoItem *item = [ZJPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:url]];
        [items addObject:item];
    }
    ZJPhotoBrowser *browser = [ZJPhotoBrowser browserWithPhotoItems:items selectedIndex:tap.view.tag];
    browser.dismissalStyle = ZJPhotoBrowserInteractiveDismissStyleNone;
    browser.delegate = self;

    [browser showFromViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ZJPhotoBrowser:(ZJPhotoBrowser *)browser didSelectItem:(ZJPhotoItem *)item atIndex:(NSInteger)index
{
    NSLog(@"slectIndex : %ld",index);
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

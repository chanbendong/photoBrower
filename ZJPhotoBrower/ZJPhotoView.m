//
//  ZJPhotoView.m
//  ZJPhotoBrower
//
//  Created by 吴孜健 on 17/2/14.
//  Copyright © 2017年 吴孜健. All rights reserved.
//

#import "ZJPhotoView.h"
#import "ZJPhotoItem.h"
#import "ZJProgressLayer.h"
#import "UIImageView+YYWebImage.h"
#import "YYAnimatedImageView.h"
const CGFloat ZJPhotoViewPadding = 10;
const CGFloat ZJPhotoViewMaxScale = 3;

@interface ZJPhotoView()<UIScrollViewDelegate>

@end

@implementation ZJPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.bouncesZoom = YES;
        self.maximumZoomScale = ZJPhotoViewMaxScale;
        self.multipleTouchEnabled = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
        self.delegate = self;
        
        _imageView = [[YYAnimatedImageView alloc] init];
        _imageView.backgroundColor = [UIColor darkGrayColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        [self resizeImageView];
        
        _progressLayer = [[ZJProgressLayer alloc]initWithFram:CGRectMake(0, 0, 40, 40)];
        _progressLayer.position = CGPointMake(frame.size.width/2, frame.size.height/2);
        _progressLayer.hidden = YES;
        [self.layer addSublayer:_progressLayer];
    }
    return self;
}

- (void)setItem:(ZJPhotoItem *)item determinate:(BOOL)determinate
{
    _item = item;
    [_imageView yy_cancelCurrentImageRequest];
}

@end

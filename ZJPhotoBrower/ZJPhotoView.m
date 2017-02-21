//
//  ZJPhotoView.m
//  ZJPhotoBrower
//
//  Created by 吴孜健 on 17/2/14.
//  Copyright © 2017年 吴孜健. All rights reserved.
//

#import "ZJPhotoView.h"
#import "ZJPhotoItem.h"



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
    [_imageView cancelCurrentImageRequest];
    if (_item) {
        if (_item.image) {
            _imageView.image = item.image;
            _item.finished = YES;
            [_progressLayer stopSpin];
            _progressLayer.hidden = YES;
            [self resizeImageView];
            return;
        }
        __weak typeof(self) weakSelf = self;
        YYWebImageProgressBlock progressBlock = nil;
        if (determinate) {
            progressBlock =  ^(NSInteger receviedSize, NSInteger expectedSize){
                double progress = (double)receviedSize/expectedSize;
                weakSelf.progressLayer.hidden = NO;
                weakSelf.progressLayer.strokeEnd = MAX(progress, 0.01);
            };
        }else{
            [_progressLayer startSpin];
        }
        _progressLayer.hidden = NO;
        
        _imageView.image = item.thumbImage;
        [_imageView setImageWithURL:item.imageUrl placeholder:item.thumbImage options:kNilOptions completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (stage == YYWebImageStageFinished) {
                [weakSelf resizeImageView];
            }
            [weakSelf.progressLayer stopSpin];
            weakSelf.progressLayer.hidden = YES;
            weakSelf.item.finished = YES;
        }];
    }else{
        [_progressLayer stopSpin];
        _progressLayer.hidden = YES;
        _imageView.image = nil;
    }
    [self resizeImageView];
}

- (void)resizeImageView
{
    if (_imageView.image) {
        CGSize imageSize = _imageView.image.size;
        CGFloat width = _imageView.frame.size.width;
        CGFloat height = width * (imageSize.height / imageSize.width);
        CGRect rect = CGRectMake(0, 0, width, height);
        _imageView.frame = rect;
        
        if (height <= self.bounds.size.height) {
            _imageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        }else{
            _imageView.center = CGPointMake(self.bounds.size.width/2, height/2);
        }
        
        if (width / height > 2) {
            self.maximumZoomScale = self.bounds.size.height / height;
        }
    }else{
        CGFloat width = self.frame.size.width - 2*ZJPhotoViewPadding;
        _imageView.frame = CGRectMake(0, 0, width, width*2.f/3.f);
        _imageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    }
    self.contentSize = _imageView.frame.size;
}

- (void)cancelCurrentImageLoad
{
    [_imageView cancelCurrentImageRequest];
    [_progressLayer stopSpin];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width-scrollView.contentSize.width)*0.5f:0.f;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height-scrollView.contentSize.height)*0.5:0.f;
    _imageView.center = CGPointMake(scrollView.contentSize.width*0.5+offsetX, scrollView.contentSize.height*0.5+offsetY);
}


@end

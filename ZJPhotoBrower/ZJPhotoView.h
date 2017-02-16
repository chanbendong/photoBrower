//
//  ZJPhotoView.h
//  ZJPhotoBrower
//
//  Created by 吴孜健 on 17/2/14.
//  Copyright © 2017年 吴孜健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJProgressLayer.h"
#import "UIImageView+YYWebImage.h"
#import "YYAnimatedImageView.h"

extern CGFloat const ZJPhotoViewPadding;

@class ZJPhotoItem, YYAnimatedImageView;

@interface ZJPhotoView : UIScrollView

@property (nonatomic, strong, readonly) YYAnimatedImageView *imageView;
@property (nonatomic, strong, readonly) ZJProgressLayer *progressLayer;
@property (nonatomic, strong, readonly) ZJPhotoItem *item;

- (void)setItem:(ZJPhotoItem *)item determinate:(BOOL)determinate;
- (void)resizeImageView;
- (void)cancelCurrentImageLoad;


@end

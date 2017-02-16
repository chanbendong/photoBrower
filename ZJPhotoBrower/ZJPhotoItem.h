//
//  ZJPhotoItem.h
//  ZJPhotoBrower
//
//  Created by 吴孜健 on 17/2/14.
//  Copyright © 2017年 吴孜健. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJPhotoItem : NSObject

@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, assign) BOOL finished;

- (instancetype)initWithSourceView:(UIView *)view
                        thumbImage:(UIImage *)image
                          imageUrl:(NSURL *)url;
- (instancetype)initWithSourceView:(UIImageView *)view
                          imageUrl:(NSURL *)url;
- (instancetype)initWithSourceView:(UIImageView *)view
                             image:(UIImage *)image;

+ (instancetype)itemWithSourceView:(UIView *)view
                        thumbImage:(UIImage *)image
                          imageUrl:(NSURL *)url;
+ (instancetype)itemWithSourceView:(UIImageView *)view
                          imageUrl:(NSURL *)url;
+ (instancetype)itemWithSourceView:(UIImageView *)view
                             image:(UIImage *)image;



@end

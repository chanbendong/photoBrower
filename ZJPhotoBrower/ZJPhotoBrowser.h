//
//  ViewController.h
//  ZJPhotoBrower
//
//  Created by 吴孜健 on 17/2/14.
//  Copyright © 2017年 吴孜健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJPhotoItem.h"

typedef NS_ENUM(NSInteger, ZJPhotoBrowserInteractiveDismissStyle) {
    ZJPhotoBrowserInteractiveDismissStyleRotation,
    ZJPhotoBrowserInteractiveDismissStyleScale,
    ZJPhotoBrowserInteractiveDismissStyleSlide,
    ZJPhotoBrowserInteractiveDismissStyleNone
};

typedef NS_ENUM(NSInteger, ZJPhotoBrowserBackgroundStyle) {
    ZJPhotoBrowserBackgroundStyleBlurPhoto,
    ZJPhotoBrowserBackgroundStyleBlur,
    ZJPhotoBrowserBackgroundStyleBlack
};

typedef NS_ENUM(NSInteger, ZJPhotoBrowserPageIndicatorStyle) {
    ZJPhotoBrowserPageIndicatorStyleDot,
    ZJPhotoBrowserPageIndicatorStyleText,
};

typedef NS_ENUM(NSInteger, ZJPhotoBrowserImageLoadingStyle) {
    ZJPhotoBrowserImageLoadingStyleIndeterminate,
    ZJPhotoBrowserImageLoadingStyleDeterminate
};
@protocol ZJPhotoBrowserDelegate <NSObject>

- (void)ZJPhotoBrowser:(ZJPhotoBrowser *)browser didSelectItem:(zjphotoItem*)item atIndex:(NSInteger)index;

@end

@interface ZJPhotoBrowser : UIViewController

@property (nonatomic, assign) ZJPhotoBrowserInteractiveDismissalStyle dismissalStyle;
@property (nonatomic, assign) ZJPhotoBrowserBackgroundStyle backgroundStyle;
@property (nonatomic, assign) ZJPhotoBrowserPageIndicatorStyle pageindicatorStyle;
@property (nonatomic, assign) ZJPhotoBrowserImageLoadingStyle loadingStyle;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, weak) id<ZJPhotoBrowserDelegate> delegate;

+ (instancetype)browserWithPhotoItems:(NSArray<ZJPhotoItem *> *)photoItems selectedIndex:(NSInteger)selectedIndex;
- (instancetype)initWithPhotoItems:(NSArray<ZJPhotoItem *> *)photoItems selectedIndex:(NSInteger)selectedIndex;
- (void)

@end


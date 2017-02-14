//
//  ZJProgressLayer.h
//  ZJPhotoBrower
//
//  Created by 吴孜健 on 17/2/14.
//  Copyright © 2017年 吴孜健. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ZJProgressLayer : CAShapeLayer

- (instancetype)initWithFram:(CGRect)frame;
- (void)startSpin;
- (void)stopSpin;

@end

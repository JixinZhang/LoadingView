//
//  LoadingView.m
//  LoadingView
//
//  Created by WSCN on 8/22/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "LoadingView.h"
#import "LoadingLayer.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface LoadingView()

@property (nonatomic, strong) LoadingLayer *loadingLayer;
@property (nonatomic, strong) CABasicAnimation *animation;
@end

@implementation LoadingView

- (CABasicAnimation *)animation {
    if (!_animation) {
        self.animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        self.animation.duration = 10.0f;
        self.animation.fromValue = @0.0;
        self.animation.toValue = @8.0;
        self.animation.repeatCount = INFINITY;
    }
    return _animation;
}

- (LoadingLayer *)loadingLayer {
    if (!_loadingLayer) {
        _loadingLayer = [LoadingLayer layer];
        _loadingLayer.contentsScale = [UIScreen mainScreen].scale;
        _loadingLayer.bounds = CGRectMake(0, 0, screenWidth, screenHeight);
        _loadingLayer.position = CGPointMake(screenWidth / 2.0, screenHeight / 2.0);
        _loadingLayer.progress = 8;
        [_loadingLayer addAnimation:self.animation forKey:@"test"];
    }
    return _loadingLayer;
}

- (void)drawRect:(CGRect)rect {
    [self setupLoadLayer];
}

- (void)setupLoadLayer {
    [self.layer addSublayer:self.loadingLayer];
}

- (void)setSpeedOfLoadingView:(float)speed {
    self.loadingLayer.speed = speed;
    [self.loadingLayer needsDisplay];
}

@end

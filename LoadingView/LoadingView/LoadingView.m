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

- (void)drawRect:(CGRect)rect {
    [self setupLoadLayer];
}

- (void)setupLoadLayer {
    self.loadingLayer = [LoadingLayer layer];
    self.loadingLayer.contentsScale = [UIScreen mainScreen].scale;
    self.loadingLayer.bounds = CGRectMake(0, 0, screenWidth, screenHeight);
    self.loadingLayer.position = CGPointMake(screenWidth / 2.0, screenHeight / 2.0);
    self.loadingLayer.progress = 8;
    [self.layer addSublayer:self.loadingLayer];
    
    self.animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    self.animation.duration = 10.0f;
    self.animation.fromValue = @0.0;
    self.animation.toValue = @8.0;
    self.animation.repeatCount = INFINITY;
    [self.loadingLayer addAnimation:self.animation forKey:@"test"];
}

- (void)setSpeedOfLoadingView:(float)speed {
    [self.animation setSpeed:speed];
}

@end

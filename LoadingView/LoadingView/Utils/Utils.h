//
//  Utils.h
//  LoadingView
//
//  Created by WSCN on 8/22/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

#pragma mark - 绘制画圆

+ (void)drawCircle:(nullable CGContextRef)context
         fillcolor:(nullable UIColor *)fillColor
            radius:(CGFloat)radius
             point:(CGPoint)point;

+ (void)drawCircles:(nullable CGContextRef)context
          fillColor:(nullable UIColor *)fillColor
             points:(nullable NSArray *)points
             radius:(CGFloat)radius;

+ (void)drawConcentricCircle:(nullable CGContextRef)context
                   lineColor:(nullable UIColor *)lineColor
                   fillColor:(nullable UIColor *)fillColor
                   lineWidth:(CGFloat)lineWidth
                      radius:(CGFloat)radius
                       point:(CGPoint)point;

#pragma mark - 两点间的距离

+ (double)distanceBetweenPointA:(CGPoint)pointA pointB:(CGPoint)pointB;

#pragma mark - 计算两点中点的坐标

+ (CGPoint)midpointBetweenPointA:(CGPoint)pointA pointB:(CGPoint)pointB;

#pragma mark - 计算圆周上两点之间的弧长
/**
 *  计算圆周上两点之间的弧长
 *
 *  @param radius 圆弧的半径
 *  @param angle  两点与圆心连线之间夹角的角度0-180度
 *
 *  @return 弧长
 */
+ (CGFloat)calculateArcLengthRadius:(CGFloat)radius
                              angle:(CGFloat)angle;

@end

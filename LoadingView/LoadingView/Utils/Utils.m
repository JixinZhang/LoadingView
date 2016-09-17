//
//  Utils.m
//  LoadingView
//
//  Created by WSCN on 8/22/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "Utils.h"

@implementation Utils

/*
 *画圆
 *context   当前上下文
 *fillColor 填充色
 *radius    半径
 *point     圆心点坐标
 */
+ (void)drawCircle:(CGContextRef)context
         fillcolor:(UIColor *)fillColor
            radius:(CGFloat)radius
             point:(CGPoint)point {
    CGContextSaveGState(context);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextAddArc(context, point.x, point.y, radius, 0, M_PI * 2, 0);
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
    /*
     kCGPathFill,
     kCGPathEOFill,
     kCGPathStroke, //画圆的轮廓
     kCGPathFillStroke,
     kCGPathEOFillStroke
     */
}

+ (void)drawCircles:(nullable CGContextRef)context
          fillColor:(nullable UIColor *)fillColor
             points:(nullable NSArray *)points
             radius:(CGFloat)radius {
    CGContextSetShouldAntialias(context, YES);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    for (NSInteger i = 0; i < points.count; i++) {
        NSValue *value = points[i];
        CGPoint point = [value CGPointValue];
        CGContextAddArc(context, point.x, point.y, radius, 0, M_PI * 2, 0);
        CGContextDrawPath(context, kCGPathFill);
    }
}
/*
 *画同心圆
 *context   当前上下文
 *lineColor 外圆颜色
 *fillColor 内圆颜色
 *lineWidth 外圆半径－内圆半径
 *radius    内圆半径
 *point     圆心点坐标
 
 */
+ (void)drawConcentricCircle:(nullable CGContextRef)context
                   lineColor:(nullable UIColor *)lineColor
                   fillColor:(nullable UIColor *)fillColor
                   lineWidth:(CGFloat)lineWidth
                      radius:(CGFloat)radius
                       point:(CGPoint)point {
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);   //线的填充色
    CGContextSetFillColorWithColor(context, fillColor.CGColor);     //圆的填充色
    
    //内圆
    CGContextAddArc(context, point.x, point.y, radius, 0, M_PI * 2, 0);
    CGContextDrawPath(context, kCGPathFill);
    
    //外圆
    CGContextAddArc(context, point.x, point.y, radius, 0, M_PI * 2, 0);
    CGContextDrawPath(context, kCGPathStroke);
}

#pragma mark - 两点间的距离

+ (double)distanceBetweenPointA:(CGPoint)pointA pointB:(CGPoint)pointB {
    double x = fabs(pointA.x - pointB.x);
    double y = fabs(pointA.y - pointB.y);
    return hypot(x, y);
}

#pragma mark - 计算两点中点的坐标

+ (CGPoint)midpointBetweenPointA:(CGPoint)pointA pointB:(CGPoint)pointB {
    return CGPointMake((pointA.x + pointB.x) / 2.0, (pointA.y + pointB.y) / 2.0);
}

#pragma mark - 计算圆周上两点之间的弧长
/**
 *  计算圆周上两点之间的弧长
 *
 *  @param radius 圆弧的半径
 *  @param angle  两点与圆心连线之间夹角的角度0-180度
 *
 *  @return arc length
 */
+ (CGFloat)calculateArcLengthRadius:(CGFloat)radius
                              angle:(CGFloat)angle {
    return (2 * M_PI * radius * (angle / 360.0));
}

+ (CGFloat)calculateAngleWithRadius:(CGFloat)radius
                             center:(CGPoint)center
                        startCenter:(CGPoint)startCenter
                          endCenter:(CGPoint)endCenter {
    //a^2 = b^2 + c^2 - 2bccosA;
    CGFloat cosA = (2 * radius * radius - powf([Utils distanceBetweenPointA:startCenter pointB:endCenter], 2)) / (2 * radius * radius);
    NSLog(@"+++++++%lf",cosA);
    return 180 / M_PI * acosf(cosA);
}

@end

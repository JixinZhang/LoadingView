//
//  LoadingLayer.m
//  LoadingView
//
//  Created by WSCN on 8/22/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "LoadingLayer.h"
#import "Circle.h"
#import "Utils.h"

#define screenWidth self.frame.size.width
#define screenHeight self.frame.size.height

@interface LoadingLayer()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, strong) Circle *startCircle;
@property (nonatomic, strong) Circle *moveCircle;
@property (nonatomic, strong) Circle *endCircle;

@end

@implementation LoadingLayer

@dynamic progress;

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (UIBezierPath *)path {
    if (!_path) {
        _path = [[UIBezierPath alloc] init];
        UIColor *fillColor = [UIColor redColor];
        [fillColor set];
    }
    return _path;
}

- (Circle *)startCircle {
    if (!_startCircle) {
        _startCircle = [[Circle alloc] init];
        _startCircle.radius = 10;
    }
    return _startCircle;
}

- (Circle *)moveCircle {
    if (!_moveCircle) {
        _moveCircle = [[Circle alloc] init];
        _moveCircle.radius = 13;
    }
    return _moveCircle;
}

- (Circle *)endCircle {
    if (!_endCircle) {
        _endCircle = [[Circle alloc] init];
        _endCircle.radius = 10;
    }
    return _endCircle;
}

- (void)drawInContext:(CGContextRef)ctx {
    //绘制8个圆
    CGPoint center = CGPointMake(screenWidth / 2.0, screenHeight / 2.0);
    CGFloat radius = 120;
    NSArray *centers = @[[NSValue valueWithCGPoint:CGPointMake(center.x, center.y - radius)],
                         [NSValue valueWithCGPoint:CGPointMake(center.x + radius / sqrtf(2), center.y - radius / sqrtf(2))],
                         [NSValue valueWithCGPoint:CGPointMake(center.x + radius, center.y)],
                         [NSValue valueWithCGPoint:CGPointMake(center.x + radius / sqrtf(2), center.y + radius / sqrtf(2))],
                         [NSValue valueWithCGPoint:CGPointMake(center.x, center.y + radius)],
                         [NSValue valueWithCGPoint:CGPointMake(center.x - radius / sqrtf(2), center.y + radius / sqrtf(2))],
                         [NSValue valueWithCGPoint:CGPointMake(center.x - radius, center.y)],
                         [NSValue valueWithCGPoint:CGPointMake(center.x - radius / sqrtf(2), center.y - radius / sqrtf(2))],
                         [NSValue valueWithCGPoint:CGPointMake(center.x, center.y - radius)]
                         ];
    [Utils drawCircles:ctx fillColor:[UIColor redColor] points:centers radius:10.0f];
    
    //计算两个点之间的距离
    self.distance = [Utils distanceBetweenPointA:[centers[0] CGPointValue] pointB:[centers[1] CGPointValue]];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    CGFloat originstart = -M_PI_2;
    CGFloat currentOrigin = originstart + (M_PI_4 * self.progress);
    CGFloat currentDest = 2 * M_PI - M_PI_2;
    
    CGFloat x = center.x + radius * cosf(currentOrigin);
    CGFloat y = center.y + radius * sinf(currentOrigin);
    CGPoint point = CGPointMake(x, y);
    
    [circlePath addArcWithCenter:center radius:radius startAngle:currentOrigin endAngle:currentDest clockwise:0];
    
    NSString *index = [NSString stringWithFormat:@"%.0f",floorf(self.progress)];
    NSInteger endCircleIndex = ((index.integerValue + 1) == 9 ? 0 : (index.integerValue + 1));
    self.startCircle.center = [centers[index.intValue] CGPointValue];
    self.endCircle.center = [centers[endCircleIndex] CGPointValue];
    self.moveCircle.center = point;
    [self drawStartCircle:self.startCircle
               moveCircle:self.moveCircle
                endCircle:self.endCircle
                  context:ctx];


}

/**
 *  绘制三个圆，startCircle和endCircle连成一条弧线，moveCircle在弧线上运动
 *
 *  @param startCircle 开始的圆
 *  @param moveCircle  运动的圆
 *  @param endCircle   结束的圆
 *  @param context     上下文
 */

- (void)drawStartCircle:(Circle *)startCircle
             moveCircle:(Circle *)moveCircle
              endCircle:(Circle *)endCircle
                context:(CGContextRef)context {
    [self.path removeAllPoints];
    //绘制开始的圆
    [Utils drawCircle:context fillcolor:[UIColor redColor] radius:startCircle.radius point:startCircle.center];
    
    //绘制结束的圆
    [Utils drawCircle:context fillcolor:[UIColor redColor] radius:endCircle.radius point:endCircle.center];
    
    //绘制运动的圆
    [Utils drawCircle:context fillcolor:[UIColor redColor] radius:moveCircle.radius point:moveCircle.center];
    
    //startCirlce和endCircle之间的弧长，半径为8个圆的所在圆的半径
    CGFloat distanceSE = [Utils calculateArcLengthRadius:120 angle:45.0f];
    
    //先处理startCircle和moveCircle-SM
    NSArray *pointsSM = [self commonTangentPointsOfCircleA:startCircle cricleB:moveCircle];
    CGPoint pointSM1 = [pointsSM[0] CGPointValue];
    CGPoint pointSM2 = [pointsSM[1] CGPointValue];
    CGPoint pointSM3 = [pointsSM[2] CGPointValue];
    CGPoint pointSM4 = [pointsSM[3] CGPointValue];
    
    CGFloat currDisSM = [Utils distanceBetweenPointA:startCircle.center pointB:moveCircle.center];
    if (currDisSM < distanceSE / 5.0 * 3) {
        //        [self.path removeAllPoints];
        [self drawCurveWithPointA:pointSM1 pointB:pointSM2 controlPoint:[Utils midpointBetweenPointA:pointSM1 pointB:pointSM4]];
        [self.path addLineToPoint:pointSM4];
        
        [self drawCurveWithPointA:pointSM4 pointB:pointSM3 controlPoint:[Utils midpointBetweenPointA:pointSM3 pointB:pointSM2]];
        [self.path addLineToPoint:pointSM1];
        
        [self.path moveToPoint:pointSM1];
        [self.path closePath];
        [self.path fill];
        //        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        //        CGContextAddPath(context, self.path.CGPath);
        //        CGContextDrawPath(context, kCGPathFill);
    }else {
        CGFloat controlPointDistance = distanceSE - currDisSM + 30;
        CGFloat ß = controlPointDistance / self.distance;
        CGFloat ySM = (moveCircle.center.y - startCircle.center.y) * ß + startCircle.center.y;
        CGFloat xSM = (moveCircle.center.x - startCircle.center.x) * ß + startCircle.center.x;
        
        CGPoint controlPoint = CGPointMake(xSM, ySM);
        //        [self.path removeAllPoints];
        [self drawCurveWithPointA:pointSM1 pointB:pointSM3 controlPoint:controlPoint];
        [self.path moveToPoint:pointSM1];
        [self.path closePath];
        
        CGFloat yMS = (startCircle.center.y - moveCircle.center.y) * ß + moveCircle.center.y;
        CGFloat xMS = (startCircle.center.x - moveCircle.center.x) * ß + moveCircle.center.x;
        
        CGPoint controlPointMS = CGPointMake(xMS, yMS);
        [self drawCurveWithPointA:pointSM2 pointB:pointSM4 controlPoint:controlPointMS];
        [self.path moveToPoint:pointSM2];
        [self.path closePath];
        
        //        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        //        CGContextAddPath(context, self.path.CGPath);
        //        CGContextDrawPath(context, kCGPathFill);
    }
    
    
    //endCircle和moveCircle-EM
    
    NSArray *pointsEM = [self commonTangentPointsOfCircleA:endCircle cricleB:moveCircle];
    CGPoint pointEM1 = [pointsEM[0] CGPointValue];
    CGPoint pointEM2 = [pointsEM[1] CGPointValue];
    CGPoint pointEM3 = [pointsEM[2] CGPointValue];
    CGPoint pointEM4 = [pointsEM[3] CGPointValue];
    CGFloat currDisEM = [Utils distanceBetweenPointA:endCircle.center pointB:moveCircle.center];
    if (currDisEM >= distanceSE / 5 * 2.0 &&
        currDisEM < distanceSE / 2.0 ) {
                CGFloat controlPointDistance = currDisSM - distanceSE / 2.0;
                CGFloat ß = controlPointDistance / distanceSE / 2.0;
                CGFloat yEM = (moveCircle.center.y - endCircle.center.y) * ß + endCircle.center.y;
                CGFloat xEM = (moveCircle.center.x - endCircle.center.x) * ß + endCircle.center.x;
        
                CGPoint controlPoint = CGPointMake(xEM, yEM);
        //        [self.path removeAllPoints];
                [self drawCurveWithPointA:pointEM2 pointB:pointEM4 controlPoint:controlPoint];
                [self.path moveToPoint:pointSM2];
                [self.path closePath];
        
                CGFloat yME = (endCircle.center.y - moveCircle.center.y) * ß + moveCircle.center.y;
                CGFloat xME = (endCircle.center.x - moveCircle.center.x) * ß + moveCircle.center.x;
        
                CGPoint controlPointMS = CGPointMake(xME, yME);
                [self drawCurveWithPointA:pointEM1 pointB:pointEM3 controlPoint:controlPointMS];
                [self.path moveToPoint:pointEM1];
                [self.path closePath];
        
    }else if (currDisEM <= distanceSE / 5.0 * 2) {
        [self drawCurveWithPointA:pointEM1 pointB:pointEM2 controlPoint:[Utils midpointBetweenPointA:pointEM1 pointB:pointEM4]];
        [self.path addLineToPoint:pointEM4];
        
        [self drawCurveWithPointA:pointEM4 pointB:pointEM3 controlPoint:[Utils midpointBetweenPointA:pointEM3 pointB:pointEM2]];
        [self.path addLineToPoint:pointEM1];
        [self.path moveToPoint:pointEM1];
        
        [self.path closePath];
    }
    
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddPath(context, self.path.CGPath);
    CGContextDrawPath(context, kCGPathFill);
}

- (void)drawCurveWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB controlPoint:(CGPoint)controlPoint {
    [self.path moveToPoint:pointA];
    [self.path addQuadCurveToPoint:pointB controlPoint:controlPoint];
}

- (NSArray *)commonTangentPointsOfCircleA:(Circle *)circleA cricleB:(Circle *)circleB {
    /*
     *  计算两个圆的外公切线的四个点的坐标
     *  http://blog.csdn.net/xieyupeng520/article/details/50374561
     *    α	Alpha
     *    β	Beta
     *    γ	Gamma
     *    ζ	Zeta
     */
    CGPoint pointA = circleA.center;
    double radiusA = circleA.radius;
    CGPoint pointB = circleB.center;
    double radiusB = circleB.radius;
    
    double d = [Utils distanceBetweenPointA:pointA pointB:pointB];
    double gamma = asin((circleB.radius - circleA.radius) / d);
    double alpha = atan((pointB.y - pointA.y) / (pointA.x - pointB.x));
    
    double beta = M_PI_2 - gamma - alpha;
    
    CGPoint p1 = CGPointMake(pointA.x - cos(beta) * radiusA, pointA.y - sin(beta) * radiusA);
    CGPoint p2 = CGPointMake(pointB.x - cos(beta) * radiusB, pointB.y - sin(beta) * radiusB);
    
    double zeta = M_PI_2 + gamma - alpha;
    CGPoint p3 = CGPointMake(pointA.x + cos(zeta) * radiusA, pointA.y + sin(zeta) * radiusA);
    CGPoint p4 = CGPointMake(pointB.x + cos(zeta) * radiusB, pointB.y + sin(zeta) * radiusB);
    
    NSArray *points = @[[NSValue valueWithCGPoint:p1],
                        [NSValue valueWithCGPoint:p2],
                        [NSValue valueWithCGPoint:p3],
                        [NSValue valueWithCGPoint:p4]];
    return points;
}


@end

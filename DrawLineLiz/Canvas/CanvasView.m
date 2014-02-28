//
// Created by azu on 2014/02/28.
//


#import "CanvasView.h"
#import "ArsScale.h"
#import "ArsScaleLinear.h"
#import "ArsDashFunction.h"


@implementation CanvasView {

}
- (void)drawRect:(CGRect) rect {
    [super drawRect:rect];
    CGSize size = self.bounds.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawContext:context size:size];

}

- (void)drawBar:(CGRect) rect context:(CGContextRef) ctx {
    CGContextBeginPath(ctx);
    CGContextSetGrayFillColor(ctx, 0.2, 0.7);
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

- (void)drawContext:(CGContextRef) context size:(CGSize) size {
    NSArray *dataSet = @[@130, @20, @30, @33, @140, @600, @1200, @400, @440];
    ArsScaleLinear *yScale = [[ArsScaleLinear alloc] init];
    yScale.domain = @[@0, ArsMax(dataSet)];
    yScale.range = @[@0, @(size.height - 5)];
    // bar
    float step = 30;
    float barWidth = 20;
    float startX = 30;
    for (NSUInteger i = 0; i < [dataSet count]; i++) {
        NSNumber *data = dataSet[i];
        [self drawBar:CGRectMake(startX + barWidth + step * i, size.height,
            barWidth, -[[yScale scale:data] floatValue]) context:context];
    }
    // text
    for (NSUInteger i = 0; i < [dataSet count]; i++) {
        NSNumber *data = dataSet[i];
        [self drawDataLabel:CGRectMake(startX + barWidth + step * i,
            size.height - [[yScale scale:data] floatValue] - 20,
            barWidth, 20) text:[data stringValue]];
    }

    // y - axis
    NSArray *axis = [yScale ticks:10];
    for (NSUInteger i = 0; i < [axis count]; i++) {
        NSNumber *data = [yScale scale:axis[i]];
        [self drawAxisLabel:CGRectMake(0, size.height - [data floatValue], startX,
            30) text:[NSString stringWithFormat:@"%d", [axis[i] integerValue]]];

    }
}

- (void)drawDataLabel:(CGRect) rect text:(NSString *) text {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.textColor = [UIColor purpleColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    [label sizeToFit];
    [self addSubview:label];
}

- (void)drawAxisLabel:(CGRect) rect text:(NSString *) text {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.frame = CGRectOffset(rect, 0, -(rect.size.height / 2));
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    [label sizeToFit];
    [self addSubview:label];
}
@end
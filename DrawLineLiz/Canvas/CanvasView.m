//
// Created by azu on 2014/02/28.
//


#import <ArsScale/ArsScaleLinear.h>
#import "CanvasView.h"
#import "ArsDashFunction.h"


@interface CanvasView ()
@property(nonatomic, strong) ArsScaleLinear *yScale;
@property(nonatomic, strong) NSArray *dataSet;
@property(nonatomic) NSMutableArray *touchAreas;
@property(nonatomic) NSInteger selectedDataIndex;
@end

@implementation CanvasView {

}

- (void)drawRect:(CGRect) rect {
    [super drawRect:rect];
    CGSize size = self.bounds.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawContext:context size:size];
}

- (void)drawBar:(CGRect) rect color:(UIColor *) color context:(CGContextRef) ctx {
    CGContextBeginPath(ctx);

    CGContextSetGrayFillColor(ctx, 1.0, 1.0);
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
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
    self.touchAreas = [NSMutableArray array];
    self.dataSet = @[@130, @20, @30, @33, @140, @600, @1200, @400, @440];
    self.yScale = [[ArsScaleLinear alloc] init];
    self.yScale.domain = @[@0, ArsMax(self.dataSet)];
    self.yScale.range = @[@0, @(size.height - 5)];
    // bar
    float step = 30;
    float barWidth = 20;
    float startX = 30;
    for (NSUInteger i = 0; i < [self.dataSet count]; i++) {
        NSNumber *data = self.dataSet[i];
        CGRect rect = CGRectMake(startX + barWidth + step * i, size.height,
            barWidth, -[[self.yScale scale:data] floatValue]);
        [self.touchAreas addObject:[NSValue valueWithCGRect:rect]];
        if (self.selectedDataIndex == i) {
            [self drawBar:rect color:[UIColor redColor] context:context];
        } else {
            [self drawBar:rect context:context];
        }
    }
    // text
    for (NSUInteger i = 0; i < [self.dataSet count]; i++) {
        NSNumber *data = self.dataSet[i];
        [self drawDataLabel:CGRectMake(startX + barWidth + step * i,
            size.height - [[self.yScale scale:data] floatValue] - 20,
            barWidth, 20) text:[data stringValue]];
    }

    // y - axis
    NSArray *axis = [self.yScale ticks:10];
    for (NSUInteger i = 0; i < [axis count]; i++) {
        NSNumber *data = [self.yScale scale:axis[i]];
        [self drawAxisLabel:CGRectMake(0, size.height - [data floatValue], 30,
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

#pragma mark - touch delegate
- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self detectTouchDataAtPoint:point];
}

- (void)detectTouchDataAtPoint:(CGPoint) point {
    for (int i = 0; i < [self.dataSet count]; i++) {
        CGRect rect = [self.touchAreas[(NSUInteger)i] CGRectValue];
        if (CGRectContainsPoint(rect, point)) {
            self.selectedDataIndex = i;
            break;
        }
    }
    [self setNeedsDisplay];
}
@end
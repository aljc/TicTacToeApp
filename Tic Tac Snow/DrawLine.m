//
//  DrawLine.m
//  Tic Tac Snow
//
//  Created by ajchang on 2/8/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "DrawLine.h"

@implementation DrawLine

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRectWithLine:(CGRect)rect {
    self.x1 = 0.0f;
    self.y1 = 0.0f;
    self.x2 = 20.0f;
    self.y2= 20.0f;
    
    [super drawRect:rect];
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
    
    CGContextSetLineWidth(context, 2.0f);
    CGContextMoveToPoint(context, self.x1, self.y1);
    CGContextAddLineToPoint(context, self.x2, self.y2);
    
    CGContextStrokePath(context);
}


@end

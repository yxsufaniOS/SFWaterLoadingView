
//
//  SFWaterLoadingView.m
//  TestDemo
//
//  Created by 苏凡 on 16/9/14.
//  Copyright © 2016年 sf. All rights reserved.
//

#define SFViewRadius(View, Radius)      \
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]


#import "SFWaterLoadingView.h"

@implementation SFWaterLoadingView{
    CAShapeLayer *layer;
    CADisplayLink *_link;
    CGFloat _waveWidth;
    CGFloat _offset,_h;
    CAShapeLayer *layer2;
    UILabel *_title;
    BOOL _showTitle;
    CGFloat _test;
}


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font showLoadNote:(BOOL)show{
    if (self = [super initWithFrame:frame]) {
        CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:40]} context:nil];
        
        CGFloat w = MAX(rect.size.height, rect.size.width) + 12;
        
        
        _crossLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-w)/2, (frame.size.height-w)/2-50, w, w)];
        _crossLabel.textColor = [UIColor lightGrayColor];
        _crossLabel.text = title;
        _crossLabel.font = [UIFont boldSystemFontOfSize:40];
        _crossLabel.backgroundColor = [UIColor colorWithRed:0.14 green:0.51 blue:0.91 alpha:1];
        _crossLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_crossLabel];
        
        SFViewRadius(_crossLabel, w/2);
        
        _bottomLabel = [[UILabel alloc] initWithFrame:_crossLabel.frame];
        _bottomLabel.textColor = [UIColor whiteColor];
        _bottomLabel.text = title;
        _bottomLabel.font = [UIFont boldSystemFontOfSize:40];
        _bottomLabel.backgroundColor = [UIColor colorWithRed:0.24 green:0.61 blue:0.91 alpha:1.00];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_bottomLabel];
        
        SFViewRadius(_bottomLabel, w/2);
        
        _topLabel = [[UILabel alloc] initWithFrame:_crossLabel.frame];
        _topLabel.textColor = [UIColor colorWithRed:0.24 green:0.61 blue:0.91 alpha:1.00];
        _topLabel.text = title;
        _topLabel.font = [UIFont boldSystemFontOfSize:40];
        _topLabel.backgroundColor = [UIColor whiteColor];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_topLabel];
        
        SFViewRadius(_topLabel, w/2);
        
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, rect.size.height/2)];
        [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height/2)];
        [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
        [path addLineToPoint:CGPointMake(0, rect.size.height)];
        
        [path closePath];
        
        layer = [CAShapeLayer layer];
        layer.frame = _bottomLabel.bounds;
        layer.path = path.CGPath;
        layer.strokeColor = [UIColor greenColor].CGColor;
        
        layer2 = [CAShapeLayer layer];
        layer2.frame = _bottomLabel.bounds;
        layer2.path = path.CGPath;
        layer2.strokeColor = [UIColor clearColor].CGColor;
        
        _topLabel.layer.mask = layer;
        _bottomLabel.layer.mask = layer2;
        
        _showTitle = show;
        
        
        if (show) {
            _title = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-w)/2, CGRectGetMaxY(_bottomLabel.frame)+30, w, 20)];
            _title.textColor = [UIColor darkGrayColor];
            _title.text = @"加载中...";
            _title.font = [UIFont systemFontOfSize:15];
            _title.backgroundColor = [UIColor clearColor];
            _title.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_title];
        }
        
        _waveNum = 2;
        _waveWidth = w;
        _waveHeight = 6;
        _h = w/2;
        _speed = 6.f;
        [self wave];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    return  [self initWithFrame:frame title:@"666" font:[UIFont boldSystemFontOfSize:40] showLoadNote:YES];
}

- (void)valueChanged:(UISlider *)sender{
    //    _test = 1 + sender.value * 10;
    _offset -= _speed;
}

- (void)wave
{
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(doAni)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)stopWave
{
    [_link invalidate];
    _link = nil;
}

- (void)doAni
{
    _offset += _speed;
    
    if (_showTitle) {
        CGFloat num = ((int)fabs(_offset)/200)%3;
        if (num == 0) {
            _title.text = @"加载中.";
        }else if (num == 1){
            _title.text = @"加载中..";
        }else{
            _title.text = @"加载中...";
        }
    }
    
    //设置第一条波曲线的路径
    CGMutablePathRef pathRef = CGPathCreateMutable();
    //起始点
    CGFloat startY = _waveHeight*sinf(_offset*M_PI/_waveWidth) + _h;
    CGPathMoveToPoint(pathRef, NULL, 0, startY);
    //第一个波的公式
    for (CGFloat i = 0.0; i < _waveWidth; i ++) {
        CGFloat y = 1.1*_waveHeight*sinf(_waveNum*M_PI*i/_waveWidth + _offset*M_PI/_waveWidth) + _h;
        CGPathAddLineToPoint(pathRef, NULL, i, y);
    }
    CGPathAddLineToPoint(pathRef, NULL, _waveWidth, 0);
    CGPathAddLineToPoint(pathRef, NULL, 0, 0);
    CGPathCloseSubpath(pathRef);
    //设置第一个波layer的path
    layer.path = pathRef;
    layer.fillColor = [UIColor lightGrayColor].CGColor;
    CGPathRelease(pathRef);
    
    //设置第二条波曲线的路径
    CGMutablePathRef pathRef2 = CGPathCreateMutable();
    CGFloat startY2 = _waveHeight*sinf(_offset*M_PI/_waveWidth + M_PI/3)+_h;
    CGPathMoveToPoint(pathRef2, NULL, 0, startY2);
    //第二个波曲线的公式
    for (CGFloat i = 0.0; i < _waveWidth; i ++) {
        CGFloat y = 1.1 *_waveHeight*sinf(_waveNum*M_PI*i/_waveWidth + _offset*M_PI/_waveWidth + M_PI/3) + _h;
        CGPathAddLineToPoint(pathRef2, NULL, i, y);
    }
    
    CGPathAddLineToPoint(pathRef2, NULL, _waveWidth, _bottomLabel.frame.size.height);
    CGPathAddLineToPoint(pathRef2, NULL, 0, _bottomLabel.frame.size.height);
    CGPathCloseSubpath(pathRef2);
    
    layer2.path = pathRef2;
    layer2.fillColor = [UIColor blackColor].CGColor;
    CGPathRelease(pathRef2);
}




@end

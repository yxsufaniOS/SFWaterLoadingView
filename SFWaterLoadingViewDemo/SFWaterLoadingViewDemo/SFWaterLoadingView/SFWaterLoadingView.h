//
//  SFWaterLoadingView.h
//  NewTestDemo
//
//  Created by sfgod on 16/9/15.
//  Copyright © 2016年 sufan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SFWaterLoadingView : UIView



@property (strong, nonatomic) UILabel *crossLabel;
@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UILabel *bottomLabel;
@property (assign, nonatomic) CGFloat speed;
@property (assign, nonatomic) CGFloat waveHeight;
@property (assign, nonatomic) CGFloat waveNum;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font showLoadNote:(BOOL)show;

- (void)wave;

- (void)stopWave;


@end

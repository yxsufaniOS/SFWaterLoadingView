//
//  ViewController.m
//  SFWaterLoadingViewDemo
//
//  Created by 苏凡 on 16/9/23.
//  Copyright © 2016年 sf. All rights reserved.
//

#import "ViewController.h"
#import "SFWaterLoadingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    SFWaterLoadingView *loadingView = [[SFWaterLoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 500)
                                                                          title:@"哈哈"
                                                                           font:[UIFont boldSystemFontOfSize:40 ]
                                                                   showLoadNote:YES];
    [self.view addSubview:loadingView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

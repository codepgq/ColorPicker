//
//  ViewController.m
//  ColorDemo-色盘
//
//  Created by cxb on 2017/5/16.
//  Copyright © 2017年 pgq. All rights reserved.
//

#import "ViewController.h"
#import "ColorView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet ColorView *colorView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) wSelf = self;
    [self.colorView nowColor:^(UIColor *color) {
        wSelf.view.backgroundColor = color;
    }];
    [self.colorView showNowColor:^(UIColor *color) {
        wSelf.view.backgroundColor = color;
    }];
    
}




@end

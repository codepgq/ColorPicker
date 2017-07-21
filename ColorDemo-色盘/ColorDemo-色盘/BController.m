//
//  BController.m
//  ColorDemo-色盘
//
//  Created by cxb on 2017/7/11.
//  Copyright © 2017年 pgq. All rights reserved.
//

#import "BController.h"
#import "ColorView.h"
@interface BController ()
@property (weak, nonatomic) IBOutlet ColorView *colorView;
@end

@implementation BController

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
- (IBAction)exitController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end

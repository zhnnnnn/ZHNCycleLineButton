//
//  ViewController.m
//  ZHNCycleLineButton
//
//  Created by 张辉男 on 17/2/23.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ViewController.h"
#import "ZHNCycleLineButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZHNCycleLineButton *button1 = [ZHNCycleLineButton CycleLinebuttonWithTitle:@"zhnnnnn" tapAction:^{
        NSLog(@"zhnnnnn");
    }];
    [self.view addSubview:button1];
    button1.frame = CGRectMake(100, 100, 200, 50);
    
    
    ZHNCycleLineButton *button2 = [ZHNCycleLineButton CycleLinebuttonWithTitle:@"zhnnnnn" tapAction:^{
        NSLog(@"zhnnnnn");
    }];
    button2.lineWidth = 1;
    button2.lineColor = [UIColor greenColor];
    button2.lineAnimateduration = 0.7;
    button2.lineAnimateRepeatCount = 5;
    button2.buttonTitleColor = [UIColor greenColor];
    [self.view addSubview:button2];
    button2.frame = CGRectMake(100, 200, 200, 50);
    
    ZHNCycleLineButton *button3 = [ZHNCycleLineButton CycleLinebuttonWithTitle:@"zhnnnnn" tapAction:^{
        NSLog(@"zhnnnnn");
    }];
    button3.lineWidth = 1;
    button3.lineColor = [UIColor blueColor];
    button3.lineAnimateduration = 0.7;
    button3.lineAnimateRepeatCount = 3;
    button3.buttonTitleColor = [UIColor blueColor];
    button3.lineStartPercent = 0.05;
    button3.lineEndPercent = 0.7;
    [self.view addSubview:button3];
    button3.frame = CGRectMake(100, 300, 200, 50);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

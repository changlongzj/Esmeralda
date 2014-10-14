//
//  ViewController.m
//  Esmeralda
//
//  Created by Marc on 14/10/14.
//  Copyright (c) 2014 Marc Exposito. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void) viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"0 - Init application");
    [self configure];
    
}

- (void) didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configuration
- (void) configure {
    
    // Create Esmeralda view
    EsmeraldaView *esmeralda = [[EsmeraldaView alloc] init];
    
    // Set frame
    esmeralda.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    // Add view
    [self.view addSubview:esmeralda];
    
}

@end

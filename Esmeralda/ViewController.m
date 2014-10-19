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
    
    UIButton *chooseImages = [[UIButton alloc]init];
    
    [chooseImages setTitle:@"JSON" forState:UIControlStateNormal];
    
    [chooseImages addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    
    [chooseImages setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    chooseImages.frame = CGRectMake(20.0, 30.0, 60.0, 40.0);
    
    [self.view addSubview:chooseImages];

    
}

#pragma mark - Create JSON

- (void) chooseImage {
    
    NSLog(@"Create image");
    
    // Create the image picker
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.maximumImagesCount = 100;
    elcPicker.returnsOriginalImage = NO;
    elcPicker.returnsImage = YES;
    elcPicker.onOrder = YES;
    elcPicker.imagePickerDelegate = self;
    
    //Present modally
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    
    NSLog(@"We have images...");
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        
        // We know for sure they are images
        UIImage* image= [dict objectForKey:UIImagePickerControllerOriginalImage];
        [images addObject:image];
    }
    
    JSONManager *jsonManager = [[JSONManager alloc]init];
    
    int typeGesture = 3;
    [jsonManager createJSONWithImages:images andType:typeGesture];
    
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}



@end

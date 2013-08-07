//
//  ViewController.m
//  CSSView
//
//  Created by ChenLei on 13-7-24.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import "ViewController.h"
#import "SkinManager.h"
#import "Actions.h"
@interface ViewController () {
    NSArray *viewconfig;
}

@end

@implementation ViewController

- (void)loadView{
    [super loadView];
}

- (void)click{
    UIView *view = $i(@"button", self.view);
    [(UIImageView *)view setHighlighted:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    SkinManager *manager = [[SkinManager alloc] init];
    
    UIImageView *imageview = [[UIImageView alloc] init];
    
    [imageview setClasses:@[@"buttonid"]];
    [imageview setVid:@"button"];
    [self.view addSubview:imageview];
    
    [manager loadskin:imageview recursion:NO];
    
    [self performSelector:@selector(click) withObject:nil afterDelay:5];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

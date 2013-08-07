//
//  Actions.h
//  CSSView
//
//  Created by ChenLei on 13-8-7.
//  Copyright (c) 2013年 cmc. All rights reserved.
//
#define $c(class, root, result) findViewByClass(class, root, result)

#define $i(vid, root) findViewById(vid, root)

void findViewByClass(NSString *classname, UIView *root, NSMutableArray *array);
UIView *findViewById(NSString *vid, UIView *root);

#import <Foundation/Foundation.h>

@interface Actions : NSObject


- (void)bind:(UIView *)view;

@end

//
//  Actions.m
//  CSSView
//
//  Created by ChenLei on 13-8-7.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import "Actions.h"


void findViewByClass(NSString *classname, UIView *root, NSMutableArray *array){
    if ([root.classes containsObject:classname]){
        [array addObject:root];
    }
    for (UIView *view in [root subviews]){
        findViewByClass(classname, view, array);
    }
}

UIView *findViewById(NSString *vid, UIView *root){
    if ([root.vid isEqualToString:vid]){
        return root;
    }
    for (UIView *view in [root subviews]){
        return findViewById(vid, view);
    }
    return nil;
}



@implementation Actions



- (void)bind:(UIView *)view {
    [$i(view.vid, view.superview) setClick:@selector(log) Target:self];
}






@end

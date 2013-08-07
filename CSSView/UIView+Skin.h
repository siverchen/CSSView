//
//  UIView+Skin.h
//  OMusic
//
//  Created by ChenLei on 13-6-4.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIView (Skin)

@property (nonatomic, retain) NSString *vid;
@property (nonatomic, retain) NSArray *classes;
@property (nonatomic, retain) UIView *container;


- (void)setTop:(float)top;
- (void)setLeft:(float)left;
- (void)setWidth:(float)width;
- (void)setHeight:(float)height;



- (void)setClick:(SEL)selector Target:(id)target;



@end

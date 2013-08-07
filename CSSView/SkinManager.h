//
//  SkinManager.h
//  CSSView
//
//  Created by ChenLei on 13-7-24.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkinManager : NSObject

@property (nonatomic, retain) NSString * skinid;

- (void)loadskin:(UIView *)view
       recursion:(BOOL)recursion;


@end

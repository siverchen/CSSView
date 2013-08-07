//
//  UIView+Skin.m
//  OMusic
//
//  Created by ChenLei on 13-6-4.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import "UIView+Skin.h"
#import <objc/runtime.h>
#import <objc/message.h>

void (*setTapMethod)(id object, id target, SEL sel, UIControlEvents state);


@implementation UIView (Skin)

static char _viewvid;
static char _classname;
static char _container;





- (void)setVid:(NSString *)vid
{
    objc_setAssociatedObject(self, &_viewvid, vid, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)vid
{
    return (NSString *)objc_getAssociatedObject(self, &_viewvid);
}

- (UIView *)container{
    return (UIView *)objc_getAssociatedObject(self, &_container);
}

- (void)setContainer:(UIView *)container{
    objc_setAssociatedObject(self, &_container, container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setClasses:(NSArray *)classes{
    objc_setAssociatedObject(self, &_classname, [classes componentsJoinedByString:@"_"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)classes{
    return [(NSString *)objc_getAssociatedObject(self, &_classname) componentsSeparatedByString:@"_"];
}


#pragma - mark position&size

- (void)setTop:(float)top{
    CGRect frame = self.frame;
    frame.origin.y = top;
    [self setFrame:frame];
}

- (void)setLeft:(float)left{
    CGRect frame = self.frame;
    frame.origin.x = left;
    [self setFrame:frame];
}
- (void)setWidth:(float)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    
    [self setFrame:frame];
    [self.container setFrame:self.bounds];
}
- (void)setHeight:(float)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    [self setFrame:frame];
    [self.container setFrame:self.bounds];
}

- (void)setPadding:(UIEdgeInsets)inset{
    
}

- (void)setClick:(SEL)selector Target:(id)target{
    if ([self respondsToSelector:@selector(addTarget:action:forControlEvents:)]){
        objc_msgSend(self, @selector(addTarget:action:forControlEvents:), target, selector, UIControlEventTouchUpInside);
    }
}



@end

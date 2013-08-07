//
//  SkinManager.m
//  CSSView
//
//  Created by ChenLei on 13-7-24.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import "SkinManager.h"
#import "ESCSSParser.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define ___SkinKey @"___skinid"

typedef enum {
    RenderCssType_Class,
    RenderCssType_ID
}RenderCssType;


void (*setAttrForState)(id object, SEL sel, id attr, UIControlState state);
void (*setIntAttrForState)(id object, SEL sel, int value);
void (*setFloatAttrForState)(id object, SEL sel, float value);


@interface CSSRender : NSObject

@property (nonatomic, assign) SEL selector;
@property (nonatomic, retain) NSString *argClass;

- (void)render:(id)object
      withAttr:(NSString *)attr;

@end




@implementation CSSRender




- (void)render:(id)object
      withAttr:(NSString *)attr{
    if ([object respondsToSelector:self.selector]){
        if ([self.argClass isEqualToString:@"UIImage"]){
            [object performSelector:self.selector withObject:[UIImage imageNamed:attr]];
        }else if ([self.argClass isEqualToString:@"float"]){
            setFloatAttrForState = (void (*)(id, SEL, float))[object methodForSelector:self.selector];
            setFloatAttrForState(object, self.selector, [attr floatValue]);
        }else if ([self.argClass isEqualToString:@"int"]){
            setIntAttrForState = (void (*)(id, SEL, int))[object methodForSelector:self.selector];
            setIntAttrForState(object, self.selector, [attr intValue]);
        }else if ([self.argClass isEqualToString:@"UIColor"]){
            NSArray *colors = [attr componentsSeparatedByString:@","];
            UIColor *color = [UIColor colorWithRed:[colors[0] floatValue] / 255
                                             green:[colors[1] floatValue] / 255
                                              blue:[colors[2] floatValue] / 255
                                             alpha:[colors[3] floatValue]];
            if ([object respondsToSelector:self.selector]){
                [object performSelector:self.selector withObject:color];
            }
        }else if ([self.argClass isEqualToString:@"UIFont"]){
            NSArray *fonts = [attr componentsSeparatedByString:@","];
            UIFont *font = [UIFont fontWithName:fonts[0] size:[fonts[1] floatValue]];
            if ([object respondsToSelector:self.selector]){
                [object performSelector:self.selector withObject:font];
            }
        }
        
    }
    
}

- (void)render:(id)object
      withAttr:(NSString *)attr
       AtState:(UIControlState)state{
    if ([object respondsToSelector:self.selector]){
        if ([self.argClass isEqualToString:@"UIImage"]){
            setAttrForState = (void (*)(id, SEL, id, UIControlState))([object methodForSelector:self.selector]);
            setAttrForState(object, self.selector, [UIImage imageNamed:attr], state);
        }else if ([self.argClass isEqualToString:@"UIColor"]){
            NSArray *colors = [attr componentsSeparatedByString:@","];
            UIColor *color = [UIColor colorWithRed:[colors[0] floatValue] / 255
                                             green:[colors[1] floatValue] / 255
                                              blue:[colors[2] floatValue] / 255
                                             alpha:[colors[3] floatValue]];
            
            setAttrForState = (void (*)(id, SEL, id, UIControlState))([object methodForSelector:self.selector]);
            setAttrForState(object, self.selector, color, state);
        }
    }
}

@end


@interface SkinManager ()

@property (nonatomic, retain) NSMutableDictionary *classCss;
@property (nonatomic, retain) NSMutableDictionary *idCss;
@property (nonatomic, retain) NSMutableDictionary *highlightCss;
@property (nonatomic, retain) NSMutableDictionary *selectCss;
@property (nonatomic, retain) NSMutableDictionary *disableCss;
@property (nonatomic, retain) NSMutableDictionary *cssconfig;

- (void)readCss;


@end

@implementation SkinManager

@synthesize skinid = _skinid;

- (id)init{
    if (self = [super init]){
        self.classCss = [NSMutableDictionary dictionary];
        self.idCss = [NSMutableDictionary dictionary];
        
        self.cssconfig = [NSMutableDictionary dictionary];
        
        NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"resource" ofType:@"plist"]];
        for (NSString *k in config){
            CSSRender *render = [[CSSRender alloc] init];
            NSDictionary *c = [config objectForKey:k];
            render.selector = NSSelectorFromString([c objectForKey:@"selector"]);
            render.argClass = [c objectForKey:@"class"];
            [self.cssconfig setValue:render forKey:k];
        }
        
        [self readCss];
    }
    return self;
}



- (NSString *)skinid{
    return [[NSUserDefaults standardUserDefaults] valueForKey:___SkinKey];
}

- (void)setSkinid:(NSString *)skinid{
    if (_skinid){
        [_skinid release];
        _skinid = nil;
    }
    _skinid = [skinid retain];
    [[NSUserDefaults standardUserDefaults] setValue:skinid forKey:___SkinKey];
}



- (void)readCss{
    ESCSSParser *parse = [[ESCSSParser alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"testcase" ofType:@"css"];
    NSString *cstr = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *csses = [parse parse:cstr];  
    
    for (NSString *key in csses){
        NSMutableDictionary *tcss = nil;
        if ([key hasPrefix:@"#"]){
            tcss = self.idCss;
        }else{
            tcss = self.classCss;
        }
        [tcss setObject:[csses objectForKey:key] forKey:[key substringFromIndex:1]];
    }
    [parse release];
}


- (NSString *)getSforState:(UIControlState)state{
    switch (state) {
        case UIControlStateNormal:
            return @"normal";
        case UIControlStateSelected:
            return @"select";
        case UIControlStateDisabled:
            return @"disable";
        case UIControlStateHighlighted:
            return @"hover";
        default:
            return nil;
    }
}

- (void)render:(UIView *)view
          Type:(RenderCssType)type
          Name:(NSString *)name
         State:(UIControlState )state{
    NSMutableDictionary *tcss = nil;
    if (type == RenderCssType_Class){
        tcss = self.classCss;
    }else if (type == RenderCssType_ID){
        tcss = self.idCss;
    }
    NSDictionary *param = [tcss objectForKey:[NSString stringWithFormat:@"%@:%@", name, [self getSforState:state]]];
    if (param){
        for (NSString *key in param){
            CSSRender *render = [self.cssconfig objectForKey:[NSString stringWithFormat:@"%@:*", key]];
            if (render){
                [render render:view withAttr:[param objectForKey:key] AtState:state];
            }
        }
    }
}

- (void)loadskin:(UIView *)view
       recursion:(BOOL)recursion{
    NSDictionary *param = nil;
    if (view.classes){
        for (NSString *classname in view.classes){
            param = [self.classCss objectForKey:classname];
            if (param){
                for (NSString *key in param){
                    CSSRender *render = [self.cssconfig objectForKey:key];
                    if (render){
                        [render render:view withAttr:[param objectForKey:key]];
                    }
                }
            }
            [self render:view Type:RenderCssType_Class Name:classname State:UIControlStateNormal];
            [self render:view Type:RenderCssType_Class Name:classname State:UIControlStateHighlighted];
            [self render:view Type:RenderCssType_Class Name:classname State:UIControlStateSelected];
            [self render:view Type:RenderCssType_Class Name:classname State:UIControlStateDisabled];
        }
    }
    
    if (view.vid){
        param = [self.idCss objectForKey:view.vid];
        if (param){
            for (NSString *key in param){
                CSSRender *render = [self.cssconfig objectForKey:key];
                if (render){
                    [render render:view withAttr:[param objectForKey:key]];
                }
            }
            [self render:view Type:RenderCssType_ID Name:view.vid State:UIControlStateNormal];
            [self render:view Type:RenderCssType_ID Name:view.vid State:UIControlStateHighlighted];
            [self render:view Type:RenderCssType_ID Name:view.vid State:UIControlStateSelected];
            [self render:view Type:RenderCssType_ID Name:view.vid State:UIControlStateDisabled];
        }
    }
    
    
    if (recursion){
        for (UIView *subview in view.subviews){
            [self loadskin:subview recursion:YES];
        }
    }
}

@end

//
//  CALayer+RuntimeAttribute.h
//  Indus Towers Limited
//
//  Created by KISHAN on 30/04/15.
//  Copyright (c) 2015 HARSHIT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@import QuartzCore;

@interface CALayer (RuntimeAttribute)
@property(nonatomic, assign) UIColor* borderIBColor;
@property(nonatomic, assign) UIColor* shadowIBColor;
@end

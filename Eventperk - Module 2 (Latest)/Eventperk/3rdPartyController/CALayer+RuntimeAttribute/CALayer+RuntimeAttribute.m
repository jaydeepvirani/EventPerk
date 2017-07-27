//
//  CALayer+RuntimeAttribute.m
//  Indus Towers Limited
//
//  Created by KISHAN on 30/04/15.
//  Copyright (c) 2015 HARSHIT. All rights reserved.
//

#import "CALayer+RuntimeAttribute.h"

@implementation CALayer (RuntimeAttribute)
-(void)setBorderIBColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderIBColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

-(void)setShadowIBColor:(UIColor*)color
{
    self.shadowColor = color.CGColor;
}

-(UIColor*)shadowIBColor
{
    return [UIColor colorWithCGColor:self.shadowColor];
}
@end

//
//  CustomMKPointAnnotation.m
//  ProyectoMoviliOS
//
//  Created by Alexis Martínez on 18/7/15.
//  Copyright (c) 2015 Alexis Martínez Chacón. All rights reserved.
//

#import "CustomMKPointAnnotation.h"

@implementation CustomMKPointAnnotation

- (id)initWithLocation:(NSString *) identi avRage:(NSString *) avRage{
    self = [super init];
    if (self) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        
        self.avgRate=[f numberFromString:avRage];
        self.identificador=[f numberFromString:identi];
    }
    return self;
}

@end

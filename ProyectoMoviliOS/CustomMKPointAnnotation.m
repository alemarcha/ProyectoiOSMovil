//
//  CustomMKPointAnnotation.m
//  ProyectoMoviliOS
//
//  Created by Alexis Martínez on 18/7/15.
//  Copyright (c) 2015 Alexis Martínez Chacón. All rights reserved.
//

#import "CustomMKPointAnnotation.h"

@implementation CustomMKPointAnnotation

- (id)initWithValues:(NSJSONSerialization *) restaurantesInfo{
    self = [super init];
    if (self) {
        
        NSString *descripcion=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"description"]];
        NSString *horario=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"hour_open"]];
        NSString *telefono=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"phone"]];
        NSString *mesasLibres=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"freetables"]];
        NSString *latitud=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"latitud"]];
        NSString *identi=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"id"]];
        NSString *longitud=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"longitud"]];
        NSString *name=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"name"]];
        NSString *speciality=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"speciality"]];
        NSString *avgRateString=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"avgRate"]];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        
        self.descript=descripcion;
        self.hourOpen=horario;
        self.phone=telefono;
        self.freeTables=mesasLibres;
        self.title=name;
        self.subtitle=speciality;
        self.avgRate=[f numberFromString:avgRateString];
        self.identificador=[f numberFromString:identi];
        CLLocationCoordinate2D coord;
        
        coord.latitude = latitud.doubleValue;
        
        coord.longitude = longitud.doubleValue;
        
        self.coordinate = coord;


        
    }
    return self;
}

@end

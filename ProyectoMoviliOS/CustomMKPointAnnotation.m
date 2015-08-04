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
        NSString *noDisponible=@"No disponible";
        if(![[restaurantesInfo valueForKey:@"description"] isEqual:[NSNull null]]){
            
            self.descript=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"description"]];
        }else{
            self.descript=noDisponible;
        }
        if(![[restaurantesInfo valueForKey:@"hourOpen"] isEqual:[NSNull null]]){
            self.hourOpen=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"hourOpen"]];
        }else{
            self.hourOpen=noDisponible;
        }
        if(![[restaurantesInfo valueForKey:@"phone"] isEqual:[NSNull null]]){
            self.phone=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"phone"]];
        }else{
            self.phone=noDisponible;
        }
        if(![[restaurantesInfo valueForKey:@"freetables"] isEqual:[NSNull null]]){
            self.freeTables=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"freetables"]];
        }else{
            self.freeTables=noDisponible;
        }
        
        if(![[restaurantesInfo valueForKey:@"name"] isEqual:[NSNull null]]){
            self.title=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"name"]];
        }else{
            self.title=noDisponible;
        }
        if(![[restaurantesInfo valueForKey:@"speciality"] isEqual:[NSNull null]]){
            self.speciality=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"speciality"]];

        }else{
            self.speciality=noDisponible;
        }
       
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;

        
        NSString *latitud=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"latitud"]];
        NSString *identi=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"id"]];
        NSString *avgString=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"avgRate"] ];
        NSString *longitud=[NSString stringWithFormat:@"%@",[restaurantesInfo valueForKey:@"longitud"]];
        
        self.subtitle=self.speciality;
        self.identificador=[f numberFromString:identi];
        f.maximumFractionDigits=2;
        f.minimumFractionDigits = 2;


         self.avgRate=[f numberFromString:avgString];

        if(![[restaurantesInfo valueForKey:@"avgRate"] isEqual:[NSNull null]]){
            self.avgRateString=[f stringFromNumber:self.avgRate];
            
        }else{
            self.avgRateString=noDisponible;
        }
       
        CLLocationCoordinate2D coord;
        
        coord.latitude = latitud.doubleValue;
        
        coord.longitude = longitud.doubleValue;
        
        self.coordinate = coord;
        
        
        
    }
    return self;
}

@end

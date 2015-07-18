//
//  CustomMKPointAnnotation.h
//  ProyectoMoviliOS
//
//  Created by Alexis Martínez on 18/7/15.
//  Copyright (c) 2015 Alexis Martínez Chacón. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomMKPointAnnotation : NSObject <MKAnnotation>

@property (nonatomic) NSNumber *identificador;
@property (nonatomic) NSNumber *avgRate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;
- (id)initWithLocation:(NSString *) identi avRage:(NSString *) avRage;

@end


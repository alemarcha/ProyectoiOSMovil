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
@property (nonatomic) NSString *avgRateString;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *descript;
@property (nonatomic,copy) NSString *freeTables;
@property (nonatomic,copy) NSString *hourOpen;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *speciality;
@property (nonatomic) CLLocationCoordinate2D coordinate;
- (id)initWithValues:(NSJSONSerialization *) restaurantesInfo;

@end


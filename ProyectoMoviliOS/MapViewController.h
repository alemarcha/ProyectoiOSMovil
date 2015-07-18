//
//  MapViewController.h
//  ProyectoMoviliOS
//
//  Created by Alexis Martínez on 14/7/15.
//  Copyright (c) 2015 Alexis Martínez Chacón. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
@property (nonatomic,retain) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapComponent;
@property bool *primeraUbicacion;
@property NSNumber *ultimaLatitudPeticion;
@property NSNumber *ultimaLongitudPeticion;
@property NSMutableDictionary *dict;

- (void) getRestaurantes:(CLLocationDegrees) latitud longitud:(CLLocationDegrees) longitud;
@end

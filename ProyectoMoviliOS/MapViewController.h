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

@property (weak, nonatomic) IBOutlet MKMapView *mapComponent;

@property bool *primeraUbicacion;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedTipeMap;

@property (weak, nonatomic) IBOutlet UIStepper *stteperZoom;
@property NSNumber *ultimaLatitudPeticion;
@property NSNumber *ultimaLongitudPeticion;
@property NSMutableDictionary *dict;
@property CLLocationDegrees latitudDelta;
@property CLLocationDegrees longDelta;
@property double oldValueZoom;
- (IBAction)changedTipeMap:(id)sender;


- (IBAction)changedZoom:(id)sender;
- (void) getRestaurantes:(CLLocationDegrees) latitud longitud:(CLLocationDegrees) longitud;
@end

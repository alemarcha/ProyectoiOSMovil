//
//  MapViewController.h
//  ProyectoMoviliOS
//
//  Created by Alexis Martínez on 14/7/15.
//  Copyright (c) 2015 Alexis Martínez Chacón. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<CLLocationManagerDelegate,MKAnnotation>
@property (nonatomic,retain) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapComponent;

- (void) getRestaurantes:(CLLocationDegrees) latitud longitud:(CLLocationDegrees) longitud;
@end

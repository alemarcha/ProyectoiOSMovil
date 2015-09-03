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

//Variable utilizada para controlar la pos actual del usuario
@property (nonatomic,retain) CLLocationManager *locationManager;

//Mapa
@property (weak, nonatomic) IBOutlet MKMapView *mapComponent;

//Variable para determinar si se ha pintado en pantalla la primera ubicación
@property bool *primeraUbicacion;

//
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedTipeMap;

//
@property (weak, nonatomic) IBOutlet UIStepper *stteperZoom;

//ultima latitud y longitud desde la ultima petición
@property NSNumber *ultimaLatitudPeticion;
@property NSNumber *ultimaLongitudPeticion;

//Dictionary en el que guardaremos el resultado de la llamada a la api
@property NSMutableDictionary *dict;

//latitud y longitud delta, que son las que nos marcarán el zoom del mapa
@property CLLocationDegrees latitudDelta;
@property CLLocationDegrees longDelta;

//Localización actual del usuario
@property CLLocation *currentLocation;

//Antiguo valor del zoom
@property double oldValueZoom;

//Rango en el que vamos a realizar la busqueda de los restaurantes
@property double rangoBusqueda;

//Método para cambiar el tipo de mapa
- (IBAction)changedTipeMap:(id)sender;

//Método que nos redirigirá a la pos actual
- (IBAction)posicionActual:(id)sender;

//Método con el que cambiaremos el zoom
- (IBAction)changedZoom:(id)sender;

//Calcula los restaures cercanos a una longitud y latitud dada
- (void) getRestaurantes:(CLLocationDegrees) latitud longitud:(CLLocationDegrees) longitud;
@end

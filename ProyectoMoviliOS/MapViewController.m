//
//  MapViewController.m
//  ProyectoMoviliOS
//
//  Created by Alexis Martínez on 14/7/15.
//  Copyright (c) 2015 Alexis Martínez Chacón. All rights reserved.
//

#import "MapViewController.h"
#import "math.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.locationManager=[[CLLocationManager alloc]init];
    self.locationManager.delegate=self;
    self.mapComponent.delegate=self;
    [self.locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    self.mapComponent.mapType = MKMapTypeStandard;
    _mapComponent.showsUserLocation=YES;
    self.primeraUbicacion=false;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *loc= [locations lastObject];
    NSLog(@"Latitud: %f y longitud: %f",(double)loc.coordinate.latitude,(double)loc.coordinate.longitude);
    // Earth’s radius, sphere
    
    float radioTierra=6378137;
    
    // offsets in meters
    float dn = 1000;
    float de = 1000;
    
    
    // Coordinate offsets in radians
    float dLat =  dn / radioTierra;
    float dLon = de / (radioTierra * cos(M_PI * loc.coordinate.latitude / 180));
    
    // OffsetPosition, decimal degrees
    float mayorLat = loc.coordinate.latitude + dLat * 180 / M_PI;
    double mayorLongitud = loc.coordinate.longitude + dLon * 180 / M_PI;
    
    double menorLat = loc.coordinate.latitude - dLat * 180 / M_PI;
    double menorLongitud = loc.coordinate.longitude - dLon * 180 / M_PI;
    
    
    
    if (!self.primeraUbicacion || mayorLat<[_ultimaLatitudPeticion floatValue] || menorLat>[self.ultimaLatitudPeticion floatValue] ||  menorLongitud>[self.ultimaLongitudPeticion floatValue]|| mayorLongitud<[_ultimaLongitudPeticion floatValue ]) {
        self.primeraUbicacion=true;
        [self getRestaurantes:loc.coordinate.latitude longitud:loc.coordinate.longitude];
    }
    
    [self.locationManager stopUpdatingLocation];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(_turnOnLocationManager)  userInfo:nil repeats:NO];
    
}

- (void)_turnOnLocationManager {
    [self.locationManager startUpdatingLocation];
}



- (void) getRestaurantes:(CLLocationDegrees) latitud longitud:(CLLocationDegrees) longitud{
    

    NSString *myStringLatitud = [[NSNumber numberWithDouble:latitud] stringValue];
    NSString *myStringLongitud= [[NSNumber numberWithDouble:longitud] stringValue];
    NSString *urlForm= [NSString stringWithFormat:@"%@%@/%@/2000", @"http://localhost:8888/Trabajo-fin-master-us/api/restaurantesPorCercaniaLatLong/", myStringLatitud,myStringLongitud];
    NSMutableString *urlString=[[NSMutableString alloc]initWithString:urlForm];
    NSURL *url= [NSURL URLWithString:urlString];
    NSURLRequest *req=[NSURLRequest requestWithURL:url];
    self.ultimaLatitudPeticion=[NSNumber numberWithDouble:latitud];
    (self.ultimaLongitudPeticion)=[NSNumber numberWithDouble:longitud];
    
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //Esto se ejecuta cuando termina la llamada
        if(data.length>0 && connectionError== nil){
            NSArray *restaurantesInfo= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            int tam=[restaurantesInfo count];
            for (int i=0; tam>i; i++) {
                
                NSString *latitud=[NSString stringWithFormat:@"%@",[restaurantesInfo[i] valueForKey:@"latitud"]];
                NSString *longitud=[NSString stringWithFormat:@"%@",[restaurantesInfo[i] valueForKey:@"longitud"]];
                NSString *name=[NSString stringWithFormat:@"%@",[restaurantesInfo[i] valueForKey:@"name"]];
                NSString *speciality=[NSString stringWithFormat:@"%@",[restaurantesInfo[i] valueForKey:@"speciality"]];
                
                CLLocationCoordinate2D coord;
                
                coord.latitude = latitud.doubleValue;
                
                coord.longitude = longitud.doubleValue;

                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                point.coordinate = coord;
                
                point.title = name;
                point.subtitle = speciality;
                
                [self.mapComponent addAnnotation:point];
                
            }
            
            CLLocationCoordinate2D coord;
            
            coord.latitude = latitud;
            
            coord.longitude = longitud;
            MKCoordinateRegion rec=MKCoordinateRegionMakeWithDistance(coord, 4000, 4000);
            self.mapComponent.mapType=MKMapTypeHybrid;
            
            [self.mapComponent setRegion:rec];
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([[annotation title] isEqualToString:@"Current Location"]) {
        return nil;
    }
        static NSString *annotationIdentifier = @"annotationIdentifier";
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
    pinView.pinColor = MKPinAnnotationColorPurple;
    pinView.canShowCallout = YES;
    return pinView;}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

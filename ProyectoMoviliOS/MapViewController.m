
//
//  MapViewController.m
//  ProyectoMoviliOS
//
//  Created by Alexis Martínez on 14/7/15.
//  Copyright (c) 2015 Alexis Martínez Chacón. All rights reserved.
//

#import "MapViewController.h"
#import "math.h"
#import "CustomMKPointAnnotation.h"

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
    self.latitudDelta=0.2;

self.longDelta=0.2;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *loc= [locations lastObject];
    NSLog(@"Latitud: %f y longitud: %f",(double)loc.coordinate.latitude,(double)loc.coordinate.longitude);
//    // Earth’s radius, sphere
//    
//    float radioTierra=6378137;
//    
//    // offsets in meters
//    float dn = 1000;
//    float de = 1000;
//    
//    
//    // Coordinate offsets in radians
//    float dLat =  dn / radioTierra;
//    float dLon = de / (radioTierra * cos(M_PI * loc.coordinate.latitude / 180));
//    
//    // OffsetPosition, decimal degrees
//    float mayorLat = loc.coordinate.latitude + dLat * 180 / M_PI;
//    double mayorLongitud = loc.coordinate.longitude + dLon * 180 / M_PI;
//    
//    double menorLat = loc.coordinate.latitude - dLat * 180 / M_PI;
//    double menorLongitud = loc.coordinate.longitude - dLon * 180 / M_PI;
//    
//    
//    
//    if (!self.primeraUbicacion || mayorLat<[_ultimaLatitudPeticion floatValue] || menorLat>[self.ultimaLatitudPeticion floatValue] ||  menorLongitud>[self.ultimaLongitudPeticion floatValue]|| mayorLongitud<[_ultimaLongitudPeticion floatValue ]) {
    if (!self.primeraUbicacion){
        self.primeraUbicacion=true;
        [self getRestaurantes:loc.coordinate.latitude longitud:loc.coordinate.longitude];
    }
//    
//    [self.locationManager stopUpdatingLocation];
//    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(_turnOnLocationManager)  userInfo:nil repeats:NO];
    
}

- (void)_turnOnLocationManager {
    [self.locationManager startUpdatingLocation];
}



- (void) getRestaurantes:(CLLocationDegrees) latitud longitud:(CLLocationDegrees) longitud{
    
    
    NSString *myStringLatitud = [[NSNumber numberWithDouble:latitud] stringValue];
    NSString *myStringLongitud= [[NSNumber numberWithDouble:longitud] stringValue];
    NSString *urlForm= [NSString stringWithFormat:@"%@%@/%@/1000", @"http://localhost:8888/Trabajo-fin-master-us/api/restaurantesPorCercaniaLatLong/", myStringLatitud,myStringLongitud];
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
            self.dict =[[NSMutableDictionary alloc] init];
            for (int i=0; tam>i; i++) {
                
                NSString *latitud=[NSString stringWithFormat:@"%@",[restaurantesInfo[i] valueForKey:@"latitud"]];
                                NSString *id=[NSString stringWithFormat:@"%@",[restaurantesInfo[i] valueForKey:@"id"]];
                NSString *longitud=[NSString stringWithFormat:@"%@",[restaurantesInfo[i] valueForKey:@"longitud"]];
                NSString *name=[NSString stringWithFormat:@"%@",[restaurantesInfo[i] valueForKey:@"name"]];
                NSString *speciality=[NSString stringWithFormat:@"%@",[restaurantesInfo[i] valueForKey:@"speciality"]];
                NSString *avgRateString=[NSString stringWithFormat:@"%@",[restaurantesInfo[i] valueForKey:@"avgRate"]];

                CustomMKPointAnnotation *point=[[CustomMKPointAnnotation alloc] initWithLocation:id avRage:avgRateString];
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *myNumber = [f numberFromString:avgRateString];
                NSString *imprimir=[NSString stringWithFormat:name,@"-",id];

               
               
                
                CLLocationCoordinate2D coord;
                
                coord.latitude = latitud.doubleValue;
                
                coord.longitude = longitud.doubleValue;
                
                //MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                point.coordinate = coord;
                point.title=[NSString stringWithFormat:avgRateString];
                point.subtitle = imprimir;
                point.avgRate =myNumber;
                [self.mapComponent addAnnotation:point];
                
            }
            
            CLLocationCoordinate2D coord;
            
            coord.latitude = latitud;
            
            coord.longitude = longitud;
           // MKCoordinateRegion rec=MKCoordinateRegionMakeWithDistance(coord, 2000, 2000);


           MKCoordinateRegion rec= MKCoordinateRegionMake(coord,MKCoordinateSpanMake(self.latitudDelta, self.longDelta));
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
    //    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationIdentifier;
    //    pinView.pinColor = MKPinAnnotationColorPurple;
    //    pinView.canShowCallout = YES;
    MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
    if (!pinView)
    {
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        // If an existing pin view was not available, create one.
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
    }
    
        pinView.canShowCallout = YES;

        if(((CustomMKPointAnnotation *)annotation).avgRate!=nil && [((CustomMKPointAnnotation *)annotation).avgRate doubleValue] < 5){
            pinView.image=[UIImage imageNamed:@"Image_black"];
        
        }else if(((CustomMKPointAnnotation *)annotation).avgRate!=nil && [((CustomMKPointAnnotation *)annotation).avgRate doubleValue] < 6){
            pinView.image=[UIImage imageNamed:@"Image_brown"];
        }else if(((CustomMKPointAnnotation *)annotation).avgRate!=nil && [((CustomMKPointAnnotation *)annotation).avgRate doubleValue]< 7){
            pinView.image=[UIImage imageNamed:@"Image_blue"];
        }else if(((CustomMKPointAnnotation *)annotation).avgRate!=nil && [((CustomMKPointAnnotation *)annotation).avgRate doubleValue] < 8){
            pinView.image=[UIImage imageNamed:@"Image_green"];
        }else if(((CustomMKPointAnnotation *)annotation).avgRate!=nil && [((CustomMKPointAnnotation *)annotation).avgRate doubleValue] < 10){
            pinView.image=[UIImage imageNamed:@"Image_pink"];
            
        }else{
            pinView.image=[UIImage imageNamed:@"Image_white"];
        }
        
        pinView.calloutOffset = CGPointMake(0, 32);


    
    
    
    return pinView;
}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

    NSLog(@"holaaa%f %f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
        NSLog(@"delta%f %f",mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);
    if(self.primeraUbicacion){
        self.latitudDelta=mapView.region.span.latitudeDelta;
        self.longDelta=mapView.region.span.longitudeDelta;
    [self getRestaurantes:mapView.centerCoordinate.latitude longitud:mapView.centerCoordinate.longitude];

    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

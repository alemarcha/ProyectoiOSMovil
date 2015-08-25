
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
#import "DetailsViewController.h"

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
    self.oldValueZoom=0;
    self.rangoBusqueda=1000;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation= [locations lastObject];
    // NSLog(@"Latitud: %f y longitud: %f",(double)loc.coordinate.latitude,(double)loc.coordinate.longitude);
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
        if(self.currentLocation!=nil){
        self.primeraUbicacion=true;
        [self getRestaurantes:self.currentLocation.coordinate.latitude longitud:self.currentLocation.coordinate.longitude];
        }
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
    NSString *urlForm= [NSString stringWithFormat:@"%@%@/%@/%f", @"http://localhost:8888/Trabajo-fin-master-us/api/restaurantesPorCercaniaLatLong/", myStringLatitud,myStringLongitud,self.rangoBusqueda];
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
                
                
                CustomMKPointAnnotation *point=[[CustomMKPointAnnotation alloc] initWithValues:restaurantesInfo[i]];
                
                
                [self.mapComponent addAnnotation:point];
                
            }
            
            CLLocationCoordinate2D coord;
            
            coord.latitude = latitud;
            
            coord.longitude = longitud;
            // MKCoordinateRegion rec=MKCoordinateRegionMakeWithDistance(coord, 2000, 2000);
            
            
            MKCoordinateRegion rec= MKCoordinateRegionMake(coord,MKCoordinateSpanMake(self.latitudDelta, self.longDelta));
            
            
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
    }else if(((CustomMKPointAnnotation *)annotation).avgRate!=nil && [((CustomMKPointAnnotation *)annotation).avgRate doubleValue] <= 10){
        pinView.image=[UIImage imageNamed:@"Image_pink"];
        
    }else{
        pinView.image=[UIImage imageNamed:@"Image_white"];
    }
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pinView.rightCalloutAccessoryView = rightButton;
    
    pinView.calloutOffset = CGPointMake(0, 32);
    
    
    
    
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if (control == view.annotation) {
        //handle left control tap...
    }
    else if (control == view.rightCalloutAccessoryView) {
        //handle right control tap...
    }
    
    UIStoryboard *storyboard = self.navigationController.storyboard;
    DetailsViewController *detail = [storyboard
                                    instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detail.detallesAnotacion=view;

[self.navigationController pushViewController:detail animated:YES];
    
    
    
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

- (IBAction)changedTipeMap:(id)sender {
    
    if([self.segmentedTipeMap selectedSegmentIndex] == 0){
        self.mapComponent.mapType = MKMapTypeStandard;
    }else if([self.segmentedTipeMap selectedSegmentIndex]==1){
        self.mapComponent.mapType = MKMapTypeHybrid;
    }else{
        self.mapComponent.mapType = MKMapTypeSatellite;
    }
    
    
}

- (IBAction)posicionActual:(id)sender {
            [self getRestaurantes:self.currentLocation.coordinate.latitude longitud:self.currentLocation.coordinate.longitude];
}

- (IBAction)changedZoom:(id)sender {
    if(self.stteperZoom.value>self.oldValueZoom){
        self.oldValueZoom=self.stteperZoom.value;
        if(self.longDelta<0.1 && self.longDelta>0.01){
            self.rangoBusqueda=1000;
            self.longDelta-=0.01;
        }else if(self.longDelta<0.01 && self.longDelta>0.001){
            self.rangoBusqueda=2500;
            self.longDelta-=0.001;
        }else if(self.longDelta>0.1){
            self.rangoBusqueda=3500;
            self.longDelta-=0.1;
        }
        
        if(self.latitudDelta <0.1 && self.latitudDelta>0.01){
            self.latitudDelta-=0.01;
        }else if(self.latitudDelta <0.1 && self.latitudDelta>0.001){
            self.latitudDelta-=0.001;
        }
        else if(self.latitudDelta>0.1){
            self.latitudDelta-=0.1;
        }
    }else{
        self.latitudDelta+=0.4;
        self.longDelta+=0.4;
        self.rangoBusqueda=3500;
        self.oldValueZoom=self.stteperZoom.value ;
    }
    [self getRestaurantes:_mapComponent.centerCoordinate.latitude longitud:_mapComponent.centerCoordinate.longitude];
    NSLog(@"%f",self.stteperZoom.value);
}




@end

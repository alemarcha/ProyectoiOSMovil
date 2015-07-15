//
//  MapViewController.m
//  ProyectoMoviliOS
//
//  Created by Alexis Martínez on 14/7/15.
//  Copyright (c) 2015 Alexis Martínez Chacón. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.locationManager=[[CLLocationManager alloc]init];
    self.locationManager.delegate=self;
    [self.locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    self.mapComponent.mapType = MKMapTypeHybrid;
    _mapComponent.showsUserLocation=YES;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *loc= [locations lastObject];
    NSLog(@"Latitud: %f y longitud: %f",(double)loc.coordinate.latitude,(double)loc.coordinate.longitude);

    [self getRestaurantes:loc.coordinate.latitude longitud:loc.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(_turnOnLocationManager)  userInfo:nil repeats:NO];

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
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //Esto se ejecuta cuando termina la llamada
        if(data.length>0 && connectionError== nil){
            NSArray *restaurantesInfo= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            int tam=[restaurantesInfo count];
            for (int i=0; tam>i; i++) {
                
                NSString *latitud=[NSString stringWithFormat:@"%@",[restaurantesInfo[i] valueForKey:@"latitud"]];
                NSString *longitud=[NSString stringWithFormat:@"%@",[restaurantesInfo[i] valueForKey:@"longitud"]];
                                NSString *name=[NSString stringWithFormat:@"%@",[restaurantesInfo[i] valueForKey:@"name"]];
                                NSString *description=[NSString stringWithFormat:@"%@",[restaurantesInfo[i] valueForKey:@"description"]];
                NSString *phone=[NSString stringWithFormat:@"%@",[restaurantesInfo[i] valueForKey:@"phone"]];
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
            MKCoordinateRegion rec=MKCoordinateRegionMakeWithDistance(coord, 2000, 20000);
            _mapComponent.mapType=MKMapTypeHybrid;

            [_mapComponent setRegion:rec];
        }
    }];
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

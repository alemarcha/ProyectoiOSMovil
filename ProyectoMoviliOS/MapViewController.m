
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
    
    //inicializamos variables utiles y delegamos el locationManager y el mapcomponent para que lo controle esta clase
    self.locationManager=[[CLLocationManager alloc]init];
    self.locationManager.delegate=self;
    self.mapComponent.delegate=self;
    
    //Indicamos que queremos empezar a actualizar la ubicacion y que pediremos la authorización para acceder a su ubicación
    [self.locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    self.mapComponent.mapType = MKMapTypeStandard;
    _mapComponent.showsUserLocation=YES;
    
    self.primeraUbicacion=false;
    
    //zoom por defecto
    self.latitudDelta=0.2;
    self.longDelta=0.2;
    self.oldValueZoom=0;
    
    //rango de busqueda por defecto
    self.rangoBusqueda=1000;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Método que a actualizando la posición actual continuamente y que inicializará la pantalla la primera vez que entremos
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation= [locations lastObject];
    
    if (!self.primeraUbicacion){
        if(self.currentLocation!=nil){
            self.primeraUbicacion=true;
            //llamamos al método para calcular los restaurantes cercanos a partir de la posición actual
            [self getRestaurantes:self.currentLocation.coordinate.latitude longitud:self.currentLocation.coordinate.longitude];
        }
    }
    
}

- (void)_turnOnLocationManager {
    [self.locationManager startUpdatingLocation];
}



- (void) getRestaurantes:(CLLocationDegrees) latitud longitud:(CLLocationDegrees) longitud{
    
    //Montamos la url de petición
    NSString *myStringLatitud = [[NSNumber numberWithDouble:latitud] stringValue];
    NSString *myStringLongitud= [[NSNumber numberWithDouble:longitud] stringValue];
    NSString *urlForm= [NSString stringWithFormat:@"%@%@/%@/%f", @"http://localhost:8888/Trabajo-fin-master-us/api/restaurantesPorCercaniaLatLong/", myStringLatitud,myStringLongitud,self.rangoBusqueda];
    NSMutableString *urlString=[[NSMutableString alloc]initWithString:urlForm];
    NSURL *url= [NSURL URLWithString:urlString];
    NSURLRequest *req=[NSURLRequest requestWithURL:url];
    
    //Guardamos la última latitud y longitud con la que hicimos peticiones
    self.ultimaLatitudPeticion=[NSNumber numberWithDouble:latitud];
    (self.ultimaLongitudPeticion)=[NSNumber numberWithDouble:longitud];
    
    //Realizamos la petición
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //Esto se ejecuta cuando termina la llamada
        if(data.length>0 && connectionError== nil){
            //Si no hay error se recibe un json con los datos de los restaurantes cercanos a la latitud y longitud dada
            NSArray *restaurantesInfo= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            int tam=[restaurantesInfo count];
            self.dict =[[NSMutableDictionary alloc] init];
            
            //Para cada restaurante pintamos una anotación y la añadimos al mapa
            for (int i=0; tam>i; i++) {
                //Parseamos cada restaurante a un objeto personalizado
                CustomMKPointAnnotation *point=[[CustomMKPointAnnotation alloc] initWithValues:restaurantesInfo[i]];
                [self.mapComponent addAnnotation:point];
                
            }
            
            ////pintamos el mapa a partir de las latitudes recibidas con un zoom concreto
            CLLocationCoordinate2D coord;
            coord.latitude = latitud;
            coord.longitude = longitud;
            
            MKCoordinateRegion rec= MKCoordinateRegionMake(coord,MKCoordinateSpanMake(self.latitudDelta, self.longDelta));
            
            
            [self.mapComponent setRegion:rec];
        }
    }];
}

//Pintamos la anotación de un restaurante segun su valoración media
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if ([[annotation title] isEqualToString:@"Current Location"]) {
        return nil;
    }
    static NSString *annotationIdentifier = @"annotationIdentifier";
    
    MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
    if (!pinView)
    {
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        // If an existing pin view was not available, create one.
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
    }
    
    pinView.canShowCallout = YES;
    
    //Dependiendo del valor de la valoración media añadimos una imagen de un color
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
    
    //Añadimos la posibilidad de pinchar en la anotación
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pinView.rightCalloutAccessoryView = rightButton;
    
    pinView.calloutOffset = CGPointMake(0, 32);
    
    
    
    
    
    return pinView;
}


//Método al que se llama al pulsar sobre una anotación
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    //Redirigimos a la vista de detalle con los datos del restaurante correspondiente
    UIStoryboard *storyboard = self.navigationController.storyboard;
    DetailsViewController *detail = [storyboard
                                     instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detail.detallesAnotacion=view;
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
}

//Este método identifica cada vez que el mapa cambia para volver  actualizar los restaurantes. Por ejemplo cuando movemos el mapa
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    //Si ya hemos hecho la primera ubicación actualizamos
    if(self.primeraUbicacion){
        self.latitudDelta=mapView.region.span.latitudeDelta;
        self.longDelta=mapView.region.span.longitudeDelta;
        [self getRestaurantes:mapView.centerCoordinate.latitude longitud:mapView.centerCoordinate.longitude];
        
        
    }
}


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
        //si la long delta esta en este intervalo definimos un rango de busqueda un una long delta
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
        
        //Hacemos lo mismo con la latitud
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

}




@end

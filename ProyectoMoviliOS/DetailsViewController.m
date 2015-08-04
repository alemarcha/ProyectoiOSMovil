//
//  DetailsViewController.m
//  ProyectoMoviliOS
//
//  Created by Alexis Martínez on 28/7/15.
//  Copyright (c) 2015 Alexis Martínez Chacón. All rights reserved.
//

#import "DetailsViewController.h"
#import "CustomMKPointAnnotation.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _labelTitle.text=    [_detallesAnotacion.annotation title];
    _labelDescription.text=    ((CustomMKPointAnnotation *)_detallesAnotacion.annotation).descript;
    _labelHour.text=    ((CustomMKPointAnnotation *)_detallesAnotacion.annotation).hourOpen;
    _mesasLibres.text=((CustomMKPointAnnotation *)_detallesAnotacion.annotation).freeTables;
    _especialidad.text=((CustomMKPointAnnotation *)_detallesAnotacion.annotation).speciality;
        _valoracion.text=((CustomMKPointAnnotation *)_detallesAnotacion.annotation).avgRateString;
        _telefono.text=((CustomMKPointAnnotation *)_detallesAnotacion.annotation).phone;


    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

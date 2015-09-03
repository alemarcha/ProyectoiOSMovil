//
//  LoginViewController.m
//  ProyectoMoviliOS
//
//  Created by Alexis Martínez on 14/7/15.
//  Copyright (c) 2015 Alexis Martínez Chacón. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickLoginButton:(id)sender {
    
    //Si el usuario y el password no son vacios
    if ([_userInput.text length]>0 && [_passwordInput.text length]>0)
    {
        //llamamos al método para que llame a la api
        [self login:_userInput.text password:_passwordInput.text completion:^(NSDictionary *dictionary, NSError *error) {
            //Si no se ha producido error
            if(!error){
                //Si existe el resultado de vuelta de la llamada al método de la api
                if(dictionary){
                    //Nos dirigimos a la siguiente pantalla
                    [self performSegueWithIdentifier:@"segueToMap" sender:nil];
                }else{
                    //Avisamos con un alert
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:@"Lo sentimos, el usuario y contraseña no son correctos"
                                              message:@"Intentelo de nuevo."
                                              delegate:self
                                              cancelButtonTitle:@"Aceptar"
                                              otherButtonTitles:nil,nil];
                        [alert show];
                    }
            }else{
                    //Avisamos con un alert
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Lo sentimos, ha ocurrido un error"
                                      message:@"Intentelo de nuevo."
                                      delegate:self
                                      cancelButtonTitle:@"Aceptar"
                                      otherButtonTitles:nil,nil];
                [alert show];
            }
            
        }];
        
    }else{
                //Avisamos con un alert
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Lo sentimos, el usuario y contraseña estan vacíos"
                              message:@"Rellénelos para continuar."
                              delegate:self
                              cancelButtonTitle:@"Aceptar"
                              otherButtonTitles:nil,nil];
        [alert show];
    }
    
    
}
- (void) login:(NSString *) usuario password:(NSString *) password completion:(void (^)(NSDictionary *dictionary, NSError *error))completion {
    //Url donde se encuentra el método de la api
    NSString *urlForm= [NSString stringWithFormat:@"%@%@/%@/", @"http://localhost:8888/Trabajo-fin-master-us/api/login/", usuario,password];
    NSMutableString *urlString=[[NSMutableString alloc]initWithString:urlForm];
    NSURL *url= [NSURL URLWithString:urlString];
    NSURLRequest *req=[NSURLRequest requestWithURL:url];
    //Realizamos la petición
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //Esto se ejecuta cuando termina la llamada
        if (connectionError) {
            if (completion)
                //Si hay error devolvemos en el completion los datos que le llegaran al método que llame a este para comprobar lo que ha ocurrido
                completion(nil, connectionError);
        } else {
            NSArray *restaurantesInfo= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if (completion)
                //Se devuelve en el completion aquello que haya devuelto la llamada a la api para procesar el resultado en el método de llamada.
                completion(restaurantesInfo, connectionError);
        }
    }];
}

- (IBAction)touchOutPass:(id)sender {
    [sender resignFirstResponder];
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

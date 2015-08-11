//
//  RegisterViewController.m
//  ProyectoMoviliOS
//
//  Created by Alexis Martínez on 6/8/15.
//  Copyright (c) 2015 Alexis Martínez Chacón. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag==1){
        UIStoryboard *storyboard = self.navigationController.storyboard;
         LoginViewController *login = [storyboard
                                         instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController popToRootViewControllerAnimated:FALSE];
        [self.navigationController pushViewController:login animated:YES];
    }
        
    
}

- (IBAction)registrar:(id)sender {
    
    if ([_inputUsuario.text length]>0 && [_inputPassword.text length]>0)
    {
        if([_aceptaLosTerminps isOn]){
            [self addUser:_inputUsuario.text password:_inputPassword.text completion:^(NSDictionary *res, NSError *error) {
                if(!error){
                    NSLog(@"aa");
                    BOOL b= [[res valueForKey:@"respuesta"] boolValue];
                    if(res!=nil && b ){
                        
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:@"Usuario registrado correctamente"
                                              message:@""
                                              delegate:self
                                              cancelButtonTitle:@"Aceptar"
                                              otherButtonTitles:nil,nil];
                        alert.tag=1;
                        [alert show];
                        
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:@"Lo sentimos, el usuario ya existe"
                                              message:@"Intentelo de nuevo."
                                              delegate:self
                                              cancelButtonTitle:@"Aceptar"
                                              otherButtonTitles:nil,nil];
                        [alert show];
                    }
                }else{
                    NSLog(@"bb");
                    
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
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Debe de aceptar los terminos"
                                  message:@"Intentelo de nuevo."
                                  delegate:self
                                  cancelButtonTitle:@"Aceptar"
                                  otherButtonTitles:nil,nil];
            [alert show];
        }
        
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Lo sentimos, el usuario y contraseña estan vacíos"
                              message:@"Rellénelos para continuar."
                              delegate:self
                              cancelButtonTitle:@"Aceptar"
                              otherButtonTitles:nil,nil];
        [alert show];
    }
    
    
}
- (void) addUser:(NSString *) usuario password:(NSString *) password completion:(void (^)(NSDictionary *res, NSError *error))completion {
    NSString *urlForm= [NSString stringWithFormat:@"%@%@/%@/", @"http://localhost:8888/Trabajo-fin-master-us/api/addUser/", usuario,password];
    NSMutableString *urlString=[[NSMutableString alloc]initWithString:urlForm];
    NSURL *url= [NSURL URLWithString:urlString];
    NSURLRequest *req=[NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //Esto se ejecuta cuando termina la llamada
        if (connectionError) {
            if (completion)
                completion(nil, connectionError);
        } else {
            NSArray *restaurantesInfo= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            if (completion)
                completion(restaurantesInfo, connectionError);
        }
    }];
}
@end

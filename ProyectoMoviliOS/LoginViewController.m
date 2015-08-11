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
    // Do any additional setup after loading the view.
    self.existeUsuario=false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //this is the "Cancel"-Button
            //do something
        }
            break;
            
        case 1:
        {
            //this is the "OK"-Button
            //do something
        }
            break;
            
        default:
            break;
    }
    
}

- (IBAction)onClickLoginButton:(id)sender {
    
    if ([_userInput.text length]>0 && [_passwordInput.text length]>0)
    {
        [self login:_userInput.text password:_passwordInput.text completion:^(NSDictionary *dictionary, NSError *error) {
            if(!error){
                NSLog(@"aa");
                if(dictionary){
                    [self performSegueWithIdentifier:@"segueToMap" sender:nil];
                }else{
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:@"Lo sentimos, el usuario y contraseña no son correctos"
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
                              initWithTitle:@"Lo sentimos, el usuario y contraseña estan vacíos"
                              message:@"Rellénelos para continuar."
                              delegate:self
                              cancelButtonTitle:@"Aceptar"
                              otherButtonTitles:nil,nil];
        [alert show];
    }
    
    
}
- (void) login:(NSString *) usuario password:(NSString *) password completion:(void (^)(NSDictionary *dictionary, NSError *error))completion {
    NSString *urlForm= [NSString stringWithFormat:@"%@%@/%@/", @"http://localhost:8888/Trabajo-fin-master-us/api/login/", usuario,password];
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

//
//  LoginViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/13/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

// TODO: modally present registration screen

#import "LoginViewController.h"
#import "MapViewController.h"
#import "SuggestViewController.h"
#import "Court.h"
@import MaterialComponents;
@import Parse;

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet MDCButton *registerButton;
@property (weak, nonatomic) IBOutlet MDCButton *loginButton;

@property (nonatomic, strong) UIAlertController *emptyUsernameAlert;
@property (nonatomic, strong) UIAlertController *emptyPWAlert;
@property (nonatomic, strong) UIAlertController *badLoginAlert;
@property (nonatomic, strong) UIAlertController *usernameTakenAlert;

@property (nonatomic, assign) BOOL tappedButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self alertSetUp];
    [self buttonSetup];
}

- (void)buttonSetup {
    
    MDCContainerScheme *containerScheme = [[MDCContainerScheme alloc] init];
    containerScheme.colorScheme.primaryColor = [[UIColor alloc] initWithRed:246.0/255.0 green:106.0/255.0 blue:172.0/255.0 alpha:1];
    
    [self.registerButton applyTextThemeWithScheme:containerScheme];
    [self.loginButton applyTextThemeWithScheme:containerScheme];
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    [self.registerButton setTitleFont:font forState:UIControlStateNormal];
    [self.loginButton setTitleFont:font forState:UIControlStateNormal];
    [self.registerButton setTitleFont:font forState:UIControlStateHighlighted];
    [self.loginButton setTitleFont:font forState:UIControlStateHighlighted];
}

- (void) alertSetUp {
    self.emptyUsernameAlert = [UIAlertController alertControllerWithTitle:@"Missing username."
           message:@"Please input your username."
    preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [self.emptyUsernameAlert addAction:okAction];
    
    self.emptyPWAlert = [UIAlertController alertControllerWithTitle:@"Missing password."
           message:@"Please input your password."
    preferredStyle:(UIAlertControllerStyleAlert)];
    [self.emptyPWAlert addAction:okAction];
    
    self.badLoginAlert = [UIAlertController alertControllerWithTitle:@"Invalid credentials."
           message:@"Invalid login parameters, please try again."
    preferredStyle:(UIAlertControllerStyleAlert)];
    [self.badLoginAlert addAction:okAction];
    
    self.usernameTakenAlert = [UIAlertController alertControllerWithTitle:@"Username taken."
           message:@"Please try a different username."
    preferredStyle:(UIAlertControllerStyleAlert)];
    [self.usernameTakenAlert addAction:okAction];
}

- (IBAction)tapOther:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)tapRegister:(id)sender {
    if (!self.tappedButton) {
        self.tappedButton = YES;
        if ([self.usernameField.text isEqual:@""]) {
            [self presentViewController:self.emptyUsernameAlert animated:YES completion:^{  }];
        } else if ([self.passwordField.text isEqual:@""]) {
            [self presentViewController:self.emptyPWAlert animated:YES completion:^{  }];
        } else {
            PFUser *newUser = [PFUser user];
            
            newUser.username = self.usernameField.text;
            newUser.password = self.passwordField.text;
            
            // call sign up function on the object
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (error != nil) {
                    if (error.code == 202) {
                        [self presentViewController:self.usernameTakenAlert animated:YES completion:^{  }];
                    } else {
                         UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                             message:[error localizedDescription]
                          preferredStyle:(UIAlertControllerStyleAlert)];
                          UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                          [tempAlert addAction:okAction];
                         [self presentViewController:tempAlert animated:YES completion:^{  }];
                    }
                } else {
                    [self performSegueWithIdentifier:@"registerSegue" sender:nil];
                }
            }];
        }
        self.tappedButton = NO;
    }
}

- (IBAction)tapLogin:(id)sender {
    if (!self.tappedButton) {
        self.tappedButton = YES;
        if ([self.usernameField.text isEqual:@""]) {
            [self presentViewController:self.emptyUsernameAlert animated:YES completion:^{  }];
        } else if ([self.passwordField.text isEqual:@""]) {
            [self presentViewController:self.emptyPWAlert animated:YES completion:^{  }];
        } else {
         NSString *username = self.usernameField.text;
         NSString *password = self.passwordField.text;
         
         [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
             if (error != nil) {
                 if (error.code == 101) {
                     [self presentViewController:self.badLoginAlert animated:YES completion:^{  }];
                 } else {
                      UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                         message:error.localizedDescription
                      preferredStyle:(UIAlertControllerStyleAlert)];
                      UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                      [tempAlert addAction:okAction];
                     [self presentViewController:tempAlert animated:YES completion:^{  }];
                 }
             } else {
                 [self performSegueWithIdentifier:@"loginSegue" sender:nil];
             }
         }];
        }
        self.tappedButton = NO;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"loginSegue"]) {
        UITabBarController *tabController = [segue destinationViewController];
        tabController.selectedIndex = 2;
        
        
    } 
}

@end

//
//  RegisterViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/13/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "RegisterViewController.h"
@import Parse;

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegControl;
@property (weak, nonatomic) IBOutlet UITextField *contactField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateOfBirthPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *skillSegControl;

@property (nonatomic, strong) UIAlertController *emptyUsernameAlert;
@property (nonatomic, strong) UIAlertController *invalidContactAlert;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAlerts];
}

-(void)setUpAlerts {
    self.emptyUsernameAlert = [UIAlertController alertControllerWithTitle:@"Missing field."
              message:@"Please fill in all fields."
       preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [self.emptyUsernameAlert addAction:okAction];
    
    self.invalidContactAlert = [UIAlertController alertControllerWithTitle:@"Invalid contact."
              message:@"Please fill in a valid contact number."
       preferredStyle:(UIAlertControllerStyleAlert)];
    [self.invalidContactAlert addAction:okAction];
}

- (IBAction)tapRegister:(id)sender {
    if ([self.nameField.text isEqual:@""] ||[self.contactField.text isEqual:@""]) {
        [self presentViewController:self.emptyUsernameAlert animated:YES completion:^{  }];
    } else if ([self.contactField.text length] != 10) {
        [self presentViewController:self.invalidContactAlert animated:YES completion:^{  }];
    } else {
        PFUser *user = [PFUser currentUser];
        
        user[@"name"] = self.nameField.text;
        user[@"gender"] = [self.genderSegControl titleForSegmentAtIndex:self.genderSegControl.selectedSegmentIndex];
        
        NSString *unformatted = self.contactField.text;
        NSArray *stringComponents = [NSArray arrayWithObjects:[unformatted substringWithRange:NSMakeRange(0, 3)],
                                     [unformatted substringWithRange:NSMakeRange(3, 3)],
                                     [unformatted substringWithRange:NSMakeRange(6, [unformatted length]-6)], nil];

        NSString *formattedString = [NSString stringWithFormat:@"(%@)%@-%@", [stringComponents objectAtIndex:0], [stringComponents objectAtIndex:1], [stringComponents objectAtIndex:2]];
        user[@"contact"] = formattedString;
        user[@"age"] = self.dateOfBirthPicker.date;
        user[@"experience"] = [NSNumber numberWithLong: self.skillSegControl.selectedSegmentIndex];
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) { }];
        
        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    }
}

- (IBAction)tapCancel:(id)sender {
    [[PFUser currentUser] delete];
    [self performSegueWithIdentifier:@"delSegue" sender:nil];
}

- (IBAction)tapOther:(id)sender {
    [self.view endEditing:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginSegue"]) {
        UITabBarController *tabController = [segue destinationViewController];
        tabController.selectedIndex = 3;
    }
}


@end
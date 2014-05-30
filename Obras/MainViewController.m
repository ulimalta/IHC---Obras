//
//  MainViewController.m
//  Obras
//
//  Created by Ulisses Malta Santos on 28/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *TitleNavigationItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *MapButton;
@property (weak, nonatomic) IBOutlet UITabBar *MyTabBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logInOutButton;

@end

@implementation MainViewController

- (void) viewWillAppear:(BOOL)animated
{
    if(![PFUser currentUser])
    {
        self.logInOutButton.title = @"Log In";
    }
    else
    {
        self.logInOutButton.title = @"Log Out";
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIFont *textFont = [UIFont fontWithName: @"Chalkduster" size: 17];
    UIColor *textColor = [UIColor colorWithRed: 139.0/255.0 green: 191.0/255.0 blue: 249.0/255.0 alpha: 1.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 30)];
    titleLabel.font = textFont;
    titleLabel.textColor = textColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"OBrasil";
    
    [self.TitleNavigationItem setTitleView: titleLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)logInOutButton:(id)sender {
    
    if([PFUser currentUser])
    {
        self.logInOutButton.title = @"Log In";
        [PFUser logOut ];
        
    }
    else
    {
        NSLog(@"vadfasdfa");
        PFLogInViewController * login = [[PFLogInViewController alloc]init];
        login.delegate = self;
        login.signUpController.delegate = self;
        [self presentModalViewController:login animated:YES];
    }
    
    
    
}

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Campos não preenchidos"
                                message:@"Certifique-se de preencher todos os campos!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    self.logInOutButton.title = @"Log Out";
    [self dismissViewControllerAnimated:YES completion:NULL];
}



// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
    [[[UIAlertView alloc] initWithTitle:@"Erro"
                                message:@"Usuário ou senha inexistente"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Campos não preenchidos"
                                    message:@"Certifique-se de preencher todos os campos"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}


// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    self.logInOutButton.title = @"Log Out";
    [self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}




- (IBAction)MApButtonAction:(id)sender {
    [self performSegueWithIdentifier: @"mapSegue" sender: self];
}

@end

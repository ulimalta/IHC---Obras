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
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation MainViewController

- (void) viewWillAppear:(BOOL)animated
{
    if (![PFUser currentUser]) {
        self.logInOutButton.title = @"Log In";
    }
    else {
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
    self.mainTableView.separatorInset = UIEdgeInsetsZero;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget: self action: @selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.mainTableView addSubview: refreshControl];
    [self.MyTabBar setSelectedItem: [self.MyTabBar.items objectAtIndex: 0]];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)logInOutButton:(id)sender {
    if ([PFUser currentUser]) {
        self.logInOutButton.title = @"Log In";
        [PFUser logOut ];
        
    }
    else {
        NSLog(@"vadfasdfa");
        PFLogInViewController * login = [[PFLogInViewController alloc]init];
        login.delegate = self;
        login.signUpController.delegate = self;
        [self presentViewController: login animated: YES completion: NULL];
    }
}

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length != 0 && password.length != 0) {
        return YES;
    }
    [[[UIAlertView alloc] initWithTitle: @"Campos não preenchidos"
                                message: @"Certifique-se de preencher todos os campos!"
                               delegate: nil
                      cancelButtonTitle: @"ok"
                      otherButtonTitles: nil] show];
    return NO;
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    self.logInOutButton.title = @"Log Out";
    [self dismissViewControllerAnimated: YES completion: NULL];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
    [[[UIAlertView alloc] initWithTitle: @"Erro"
                                message: @"Usuário ou senha incorretos."
                               delegate: nil
                      cancelButtonTitle: @"ok"
                      otherButtonTitles: nil] show];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle: @"Campos não preenchidos."
                                    message: @"Certifique-se de preencher todos os campos"
                                   delegate: nil
                          cancelButtonTitle: @"ok"
                          otherButtonTitles: nil] show];
    }
    return informationComplete;
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    self.logInOutButton.title = @"Log Out";
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

- (IBAction)MApButtonAction:(id)sender {
    [self performSegueWithIdentifier: @"mapSegue" sender: self];
}

@end

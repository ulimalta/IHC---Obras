//
//  MainViewController.m
//  Obras
//
//  Created by Ulisses Malta Santos on 28/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UINavigationItem *TitleNavigationItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *MapButton;
@property (weak, nonatomic) IBOutlet UITabBar *MyTabBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logInOutButton;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *cArray;
@property (nonatomic) NSInteger constNumber;

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
    [DatabaseUtilities getObrasMostRecentWithCompletionBlock:^void(NSArray *constructionsArray) {
        self.cArray = [constructionsArray mutableCopy];
        for (Obra *ob in self.cArray) {
            [DatabaseUtilities getOneAndOnlyOnePictureFromObra: ob withCompletionBlock:^void(UIImage *img) {
                ob.pictures = [[NSMutableArray alloc] init];
                if (img) {
                    [ob.pictures addObject: img];
                    [self.mainTableView reloadData];
                }
            }];
        }
        [self.mainTableView reloadData];
    }];
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
    self.cArray = [[NSMutableArray alloc] init];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    [DatabaseUtilities getObrasMostRecentWithCompletionBlock:^void(NSArray *constructionsArray) {
        self.cArray = [constructionsArray mutableCopy];
        for (Obra *ob in self.cArray) {
            [DatabaseUtilities getOneAndOnlyOnePictureFromObra: ob withCompletionBlock:^void(UIImage *img) {
                ob.pictures = [[NSMutableArray alloc] init];
                if (img) {
                    [ob.pictures addObject: img];
                    [self.mainTableView reloadData];
                }
            }];
        }
        [self.mainTableView reloadData];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"directDetailSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        DetailViewController *nextController = (id)[[navigationController viewControllers] objectAtIndex: 0];
        [nextController setConstruction: [self.cArray objectAtIndex: self.constNumber]];
    }
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [DatabaseUtilities getObrasMostRecentWithCompletionBlock:^void(NSArray *constructionsArray) {
        self.cArray = [constructionsArray mutableCopy];
        for (Obra *ob in self.cArray) {
            [DatabaseUtilities getOneAndOnlyOnePictureFromObra: ob withCompletionBlock:^void(UIImage *img) {
                ob.pictures = [[NSMutableArray alloc] init];
                if (img) {
                    [ob.pictures addObject: img];
                    [self.mainTableView reloadData];
                }
            }];
        }
        [self.mainTableView reloadData];
        [refreshControl endRefreshing];
    }];
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
        PFLogInViewController *login = [[PFLogInViewController alloc]init];
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

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier: @"initialCell"];
    Obra *ob = [self.cArray objectAtIndex: [indexPath row]];
    
    UIFont *textFont = [UIFont fontWithName: @"Noteworthy-Bold" size: 17];
    cell.textLabel.font = textFont;
    cell.textLabel.text = ob.titulo;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if ([ob.pictures count]) {
        cell.imageView.image = [ob.pictures objectAtIndex: 0];
    }
    else {
        cell.imageView.image = [UIImage imageNamed: @"Obras.jpg"];
    }
    cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 60, 60);
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.constNumber = [indexPath row];
    [self performSegueWithIdentifier: @"directDetailSegue" sender: self];
}

@end

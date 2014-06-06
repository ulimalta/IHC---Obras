//
//  DetailViewController.m
//  Obras
//
//  Created by Ulisses Malta Santos on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *TitleNavigationItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *BackButton;
@property (weak, nonatomic) IBOutlet UIImageView *Picture;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITableView *CommentsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *CommentButton;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeP;
@property (weak, nonatomic) IBOutlet UILabel *dislikeP;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;
@property (weak, nonatomic) IBOutlet UIButton *fowardButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UILabel *imageNumberLabel;

@property (nonatomic) NSInteger currentPicture;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, strong) UIActivityIndicatorView *imageIndicator;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.imageIndicator setCenter: self.Picture.center];
    [self.view addSubview: self.imageIndicator];
    [self.BackButton setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName: @"Noteworthy-Bold" size: 13], NSFontAttributeName, nil] forState: UIControlStateNormal];
    [self.CommentButton setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName: @"Noteworthy-Bold" size: 13], NSFontAttributeName, nil] forState: UIControlStateNormal];
    self.commentArray = [[NSMutableArray alloc] init];
    [DatabaseUtilities getAllCommentsFromObra: self.construction withCompletionBlock:^void(NSArray *cArray) {
        self.commentArray = [cArray mutableCopy];
        [self.CommentsTableView reloadData];
    }];
    self.Picture.userInteractionEnabled = YES;
    self.Picture.layer.cornerRadius = 5.0;
    self.Picture.clipsToBounds = YES;
    if ([[self.construction pictures] count]) {
        self.currentPicture = 0;
        self.Picture.image = [self.construction.pictures objectAtIndex: 0];
        self.imageNumberLabel.text = [NSString stringWithFormat: @"1/1"];
    }
    else {
        self.currentPicture = -1;
    }
    UIFont *textFont = [UIFont fontWithName: @"Noteworthy-Bold" size: 18];
    UIColor *textColor = [UIColor colorWithRed: 139.0/255.0 green: 191.0/255.0 blue: 249.0/255.0 alpha: 1.0];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 30)];
    titleLabel.font = textFont;
    titleLabel.textColor = textColor;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    if (self.construction.titulo && ![self.construction.titulo isEqualToString: @""]) {
        titleLabel.text = self.construction.titulo;
    }
    else {
        titleLabel.text = @"Obras - Info";
    }
    [self.TitleNavigationItem setTitleView: titleLabel];
    CGFloat borderWidth = 1.0;
    self.descriptionTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.descriptionTextView.layer.borderWidth = borderWidth;
    self.descriptionTextView.layer.cornerRadius = 5.0;
    self.descriptionTextView.clipsToBounds = YES;
    self.descriptionTextView.editable = NO;
    self.descriptionTextView.font = [UIFont fontWithName: @"Noteworthy-Bold" size: 15];
    self.descriptionTextView.backgroundColor = [UIColor whiteColor];
    if (self.construction.descricao && ![self.construction.descricao isEqualToString: @""]) {
        self.descriptionTextView.text = self.construction.descricao;
    }
    else {
        self.descriptionTextView.text = @"Descrição indisponível";
    }
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget: self
                                                                                    action: @selector(swipeHandlerLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.numberOfTouchesRequired = 1;
    [self.Picture addGestureRecognizer: swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget: self
                                                                                     action: @selector(swipeHandlerRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.Picture addGestureRecognizer: swipeRight];
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                               action: @selector(myTap:)];
    self.CommentsTableView.separatorInset = UIEdgeInsetsZero;
    self.CommentsTableView.dataSource = self;
    self.CommentsTableView.delegate = self;
    self.CommentsTableView.layer.cornerRadius = 5;
    self.CommentsTableView.backgroundColor = [UIColor colorWithRed: 215.0/255.0 green: 215.0/255.0 blue: 215.0/255.0 alpha: 0.5];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget: self action: @selector(refresh:) forControlEvents: UIControlEventValueChanged];
    [self.CommentsTableView addSubview: refreshControl];
    self.authorLabel.text = [NSString stringWithFormat: @"Autor do post: %@", self.construction.usuario.userName];
    self.authorLabel.font = [UIFont fontWithName: @"Noteworthy-Bold" size: 17];
    self.authorLabel.adjustsFontSizeToFitWidth = YES;
    self.backLabel.backgroundColor = [UIColor colorWithRed: 215.0/255.0 green: 215.0/255.0 blue: 215.0/255.0 alpha: 0.5];
    int total = self.construction.numeroLikes+self.construction.numeroDislikes;
    if (total) {
        self.likeP.text = [NSString stringWithFormat: @"%.1f%%", (float)(self.construction.numeroLikes*100)/total];
        self.dislikeP.text = [NSString stringWithFormat: @"%.1f%%", (float)(self.construction.numeroDislikes*100)/total];
    }
    [self.imageIndicator startAnimating];
    [DatabaseUtilities getAllPicturesFromObra: self.construction withCompletionBlock:^void(NSArray *pArray) {
        self.construction.pictures = [pArray mutableCopy];
        if ([[self.construction pictures] count]) {
            self.currentPicture = 0;
            self.Picture.image = [self.construction.pictures objectAtIndex: 0];
            self.imageNumberLabel.text = [NSString stringWithFormat: @"1/%d", [pArray count]];
        }
        else {
            self.currentPicture = -1;
        }
        [self.imageIndicator stopAnimating];
        [self.Picture addGestureRecognizer: tapImage];
    }];
    self.likeP.font = [UIFont fontWithName: @"Noteworthy-Bold" size: 15];
    self.dislikeP.font = [UIFont fontWithName: @"Noteworthy-Bold" size: 15];
    self.imageNumberLabel.font = [UIFont fontWithName: @"Noteworthy-Bold" size: 15];
    self.imageNumberLabel.adjustsFontSizeToFitWidth = YES;
    UIColor *color = self.likeButton.titleLabel.textColor;
    self.likeButton.clipsToBounds = YES;
    self.likeButton.layer.cornerRadius = 10.0;
    self.likeButton.backgroundColor = color;
    self.likeButton.titleLabel.font = [UIFont fontWithName: @"Noteworthy-Bold" size: 15];
    [self.likeButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [self.likeButton setTitleColor: [UIColor lightGrayColor] forState: UIControlStateDisabled];
    self.dislikeButton.clipsToBounds = YES;
    self.dislikeButton.layer.cornerRadius = 10.0;
    self.dislikeButton.backgroundColor = color;
    [self.dislikeButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [self.dislikeButton setTitleColor: [UIColor lightGrayColor] forState: UIControlStateDisabled];
    self.dislikeButton.titleLabel.font = [UIFont fontWithName: @"Noteworthy-Bold" size: 15];
    self.addPhotoButton.clipsToBounds = YES;
    self.addPhotoButton.layer.cornerRadius = 10.0;
    self.addPhotoButton.backgroundColor = color;
    [self.addPhotoButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    self.addPhotoButton.titleLabel.font = [UIFont fontWithName: @"Noteworthy-Bold" size: 15];
    self.previousButton.titleLabel.font = [UIFont fontWithName: @"Noteworthy-Bold" size: 18];
    self.fowardButton.titleLabel.font = [UIFont fontWithName: @"Noteworthy-Bold" size: 18];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [DatabaseUtilities getAllCommentsFromObra: self.construction withCompletionBlock:^void(NSArray *cArray) {
        self.commentArray = [cArray mutableCopy];
        [self.CommentsTableView reloadData];
        [refreshControl endRefreshing];
    }];
}

- (IBAction)fowardButtonAction:(id)sender {
    [self swipeHandlerLeft: nil];
}

- (IBAction)previousButtonAction:(id)sender {
    [self swipeHandlerRight: nil];
}

- (void) myTap:(UITapGestureRecognizer*)gestureRecognizer
{
    if (self.construction.pictures && [self.construction.pictures count]) {
         [self performSegueWithIdentifier: @"imgSegue" sender: self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"imgSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ImageViewController *nextController = (id)[[navigationController viewControllers] objectAtIndex: 0];
        [nextController setOb: self.construction];
        [nextController setIndex: (int)self.currentPicture];
    }
}

- (void)swipeHandlerLeft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (self.currentPicture >= 0) {
        if (self.currentPicture >= 0) {
            if (self.currentPicture + 1 < [[self.construction pictures] count]) {
                self.currentPicture++;
                self.Picture.image = [self.construction.pictures objectAtIndex: self.currentPicture];
                self.imageNumberLabel.text = [NSString stringWithFormat: @"%d/%d", self.currentPicture+1, [self.construction.pictures count]];
            }
        }
    }
}

- (void)swipeHandlerRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (self.currentPicture >= 0) {
        if (self.currentPicture - 1 >= 0) {
            self.currentPicture--;
            self.Picture.image = [self.construction.pictures objectAtIndex: self.currentPicture];
            self.imageNumberLabel.text = [NSString stringWithFormat: @"%d/%d", self.currentPicture+1, [self.construction.pictures count]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setConstruction:(Obra *)obra
{
    if (obra) {
        _construction = obra;
    }   
}

- (IBAction)BackButtonAction:(id)sender {
     [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)commentAction:(id)sender {
    if (![PFUser currentUser]) {
        [[[UIAlertView alloc] initWithTitle: @"Log In."
                                    message: @"Você precisa estar logado para comentar!"
                                   delegate: nil
                          cancelButtonTitle: @"ok"
                          otherButtonTitles: nil] show];
        return;
    }
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Novo Comentário"
                                                     message: nil
                                                    delegate: self
                                           cancelButtonTitle: @"Cancelar"
                                           otherButtonTitles: @"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (IBAction)newPictureAction:(id)sender {
    [[[UIAlertView alloc] initWithTitle: @"Nova foto."
                                message: @"Escolha uma foto da sua biblioteca ou tire uma nova foto."
                               delegate: self
                      cancelButtonTitle: @"Cancelar"
                      otherButtonTitles: @"Biblioteca", @"Tirar foto", nil] show];
}

- (IBAction)likeAction:(id)sender {
    self.construction.numeroLikes++;
    int total = self.construction.numeroLikes+self.construction.numeroDislikes;
    self.likeP.text = [NSString stringWithFormat: @"%.1f%%", (float)(self.construction.numeroLikes*100)/total];
    self.dislikeP.text = [NSString stringWithFormat: @"%.1f%%", (float)(self.construction.numeroDislikes*100)/total];
    [DatabaseUtilities updateObraLikesAndDislikes: self.construction];
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
}

- (IBAction)dislikeAction:(id)sender {
    self.construction.numeroDislikes++;
    int total = self.construction.numeroLikes+self.construction.numeroDislikes;
    self.likeP.text = [NSString stringWithFormat: @"%.1f%%", (float)(self.construction.numeroLikes*100)/total];
    self.dislikeP.text = [NSString stringWithFormat: @"%.1f%%", (float)(self.construction.numeroDislikes*100)/total];
    [DatabaseUtilities updateObraLikesAndDislikes: self.construction];
    self.dislikeButton.enabled = NO;
    self.likeButton.enabled = NO;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commentArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = (CommentCell*)[tableView dequeueReusableCellWithIdentifier: @"commentCell"];
    Comentario *comment = [self.commentArray objectAtIndex: [indexPath row]];
    UIFont *textFont = [UIFont fontWithName: @"Noteworthy-Bold" size: 17];
    cell.CommentTextLabel.font = textFont;
    CGSize maxSize = CGSizeMake(300.f, FLT_MAX);
    CGRect labRect = [comment.comment boundingRectWithSize: maxSize
                                                   options: NSStringDrawingUsesLineFragmentOrigin
                                                attributes: @{NSFontAttributeName: cell.CommentTextLabel.font}
                                                   context: nil];
    cell.CommentTextLabel.frame = CGRectMake(cell.CommentTextLabel.frame.origin.x, cell.CommentTextLabel.frame.origin.y, 300.f, labRect.size.height);
    cell.CommentTextLabel.text = comment.comment;
    cell.CommentTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.CommentTextLabel.numberOfLines = 0;
    cell.InfoLabel.text = [NSString stringWithFormat: @"%@ %@", [comment user].userName, comment.postDate];
    textFont = [UIFont fontWithName: @"Noteworthy-Bold" size: 10];
    cell.InfoLabel.font = textFont;
    cell.InfoLabel.textColor = [UIColor darkGrayColor];
    cell.InfoLabel.adjustsFontSizeToFitWidth = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed: 230.0/255.0 green: 230.0/255.0 blue: 230.0/255.0 alpha: 0.8];
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comentario *comment = [self.commentArray objectAtIndex: [indexPath row]];
    CGSize maxSize = CGSizeMake(300.f, FLT_MAX);
    CGRect labRect = [comment.comment boundingRectWithSize: maxSize
                                                   options: NSStringDrawingUsesLineFragmentOrigin
                                                attributes: @{NSFontAttributeName: [UIFont fontWithName: @"Noteworthy-Bold" size: 17]}
                                                   context: nil];
    return labRect.size.height+25;
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        return;
    }
    if ([[alertView message] isEqualToString: @"Escolha uma foto da sua biblioteca ou tire uma nova foto."] && buttonIndex == 1) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated: YES completion: NULL];
    }
    else if ([[alertView message] isEqualToString: @"Escolha uma foto da sua biblioteca ou tire uma nova foto."] && buttonIndex == 2) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated: YES completion: NULL];
    }
    else if ([[alertView textFieldAtIndex: 0] text] && ![[[alertView textFieldAtIndex:0] text] isEqualToString: @""]) {
        Comentario *newComment = [[Comentario alloc] init];
        newComment.comment = [[alertView textFieldAtIndex: 0] text];
        newComment.user = [DatabaseUtilities getCurrentUser];
        NSLog(@"asasa");
        if (!self.commentArray || ![self.commentArray count]) {
            self.commentArray = [[NSMutableArray alloc] init];
        }
        [self.commentArray insertObject: newComment atIndex: 0];
        [DatabaseUtilities uploadComment: newComment InObra: self.construction];
        [self.CommentsTableView reloadData];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if (!self.construction.pictures || ![self.construction.pictures count]) {
        self.construction.pictures = [[NSMutableArray alloc] init];
    }
    [[self.construction pictures] insertObject: chosenImage atIndex: 0];
    if ([[self.construction pictures] count]) {
        self.currentPicture = 0;
        self.Picture.image = [self.construction.pictures objectAtIndex: 0];
    }
    else {
        self.currentPicture = -1;
    }
    [DatabaseUtilities uploadPhoto: chosenImage toObra: self.construction];
    [picker dismissViewControllerAnimated: YES completion: NULL];
}

@end

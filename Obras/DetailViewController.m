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
@property (weak, nonatomic) IBOutlet UILabel *totalVotes;

@property (nonatomic) NSInteger currentPicture;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.Picture.userInteractionEnabled = YES;
    self.Picture.layer.cornerRadius = 5.0;
    self.Picture.clipsToBounds = YES;
    if ([[self.construction pictures] count]) {
        self.currentPicture = 0;
        self.Picture.image = [self.construction.pictures objectAtIndex: 0];        
    }
    else {
        self.currentPicture = -1;
    }
    UIFont *textFont = [UIFont fontWithName: @"Chalkduster" size: 17];
    UIColor *textColor = [UIColor colorWithRed: 139.0/255.0 green: 191.0/255.0 blue: 249.0/255.0 alpha: 1.0];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 30)];
    titleLabel.font = textFont;
    titleLabel.textColor = textColor;
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
    self.CommentsTableView.separatorInset = UIEdgeInsetsZero;
    self.CommentsTableView.dataSource = self;
    self.CommentsTableView.delegate = self;
    self.CommentsTableView.layer.cornerRadius = 5;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget: self action: @selector(refresh:) forControlEvents: UIControlEventValueChanged];
    [self.CommentsTableView addSubview: refreshControl];
    self.authorLabel.text = [NSString stringWithFormat: @"Autor do post: %@", self.construction.usuario.userName];
    self.authorLabel.font = [UIFont fontWithName: @"Noteworthy-Bold" size: 17];
    self.authorLabel.adjustsFontSizeToFitWidth = YES;
    self.view.backgroundColor = [UIColor colorWithRed: 200.0/255.0 green: 200.0/255.0 blue: 200.0/255.0 alpha: 1.0];
    self.totalVotes.text = [NSString stringWithFormat: @"Total votos: %d", self.construction.numeroLikes+self.construction.numeroDislikes];
    self.totalVotes.font = [UIFont fontWithName: @"Noteworthy-Bold" size: 17];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
}

- (void)swipeHandlerLeft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (self.currentPicture >= 0) {
        if (self.currentPicture >= 0) {
            if (self.currentPicture + 1 < [[self.construction pictures] count]) {
                self.currentPicture++;
                self.Picture.image = [self.construction.pictures objectAtIndex: self.currentPicture];
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
    self.totalVotes.text = [NSString stringWithFormat: @"Total votos: %d", self.construction.numeroLikes+self.construction.numeroDislikes];
    self.totalVotes.font = [UIFont fontWithName: @"Noteworthy-Bold" size: 17];
}

- (IBAction)dislikeAction:(id)sender {
    self.construction.numeroDislikes++;
    int total = self.construction.numeroLikes+self.construction.numeroDislikes;
    self.likeP.text = [NSString stringWithFormat: @"%.1f%%", (float)(self.construction.numeroLikes*100)/total];
    self.dislikeP.text = [NSString stringWithFormat: @"%.1f%%", (float)(self.construction.numeroDislikes*100)/total];
    self.totalVotes.text = [NSString stringWithFormat: @"Toatal votos: %d", self.construction.numeroLikes+self.construction.numeroDislikes];
    self.totalVotes.font = [UIFont fontWithName: @"Noteworthy-Bold" size: 17];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.construction comentarios] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = (CommentCell*)[tableView dequeueReusableCellWithIdentifier: @"commentCell"];
    Comentario *comment = [[self.construction comentarios] objectAtIndex: [indexPath row]];
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
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed: 213.0/255.0 green: 213.0/255.0 blue: 213.0/255.0 alpha: 0.4];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comentario *comment = [[self.construction comentarios] objectAtIndex: [indexPath row]];
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
        if (!self.construction.comentarios || ![[self.construction comentarios] count]) {
            self.construction.comentarios = [[NSMutableArray alloc] init];
        }
        [[self.construction comentarios] insertObject: newComment atIndex: 0];
        [self.CommentsTableView reloadData];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [[self.construction pictures] addObject: chosenImage];
    if ([[self.construction pictures] count]) {
        self.currentPicture = 0;
        self.Picture.image = [self.construction.pictures objectAtIndex: 0];
    }
    else {
        self.currentPicture = -1;
    }
    [picker dismissViewControllerAnimated: YES completion: NULL];
}

@end

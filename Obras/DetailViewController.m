//
//  DetailViewController.m
//  Obras
//
//  Created by Ulisses Malta Santos on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *TitleNavigationItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *BackButton;
@property (weak, nonatomic) IBOutlet UIImageView *Picture;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITableView *CommentsTableView;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *CommentButton;

@property (nonatomic) NSInteger currentPicture;
@property (nonatomic) BOOL newComment;
@property (nonatomic, strong) Comentario *c;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.newComment = NO;
    self.Picture.userInteractionEnabled = YES;
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
    self.CommentsTableView.separatorColor = [UIColor clearColor];
    
    self.backLabel.backgroundColor = [UIColor colorWithRed: 0.9
                                                     green: 0.9
                                                      blue: 0.9
                                                     alpha: 1.0];
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
//    if (![PFUser currentUser]) {
//        [[[UIAlertView alloc] initWithTitle: @"Log In."
//                                    message: @"Você precisa estar logado para comentar!"
//                                   delegate: nil
//                          cancelButtonTitle: @"ok"
//                          otherButtonTitles: nil] show];
//        return;
//    }
    self.newComment = YES;
    [[self.construction comentarios] insertObject: [[Comentario alloc] init] atIndex: [[self.construction comentarios] count]];
    NSIndexPath *path = [NSIndexPath indexPathForRow: 0 inSection: 0];
    [self.CommentsTableView insertRowsAtIndexPaths: @[path] withRowAnimation: UITableViewRowAnimationAutomatic];
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
    if (!self.newComment) {
        Comentario *comment = [[self.construction comentarios] objectAtIndex: [indexPath row]];
        UIFont *textFont = [UIFont fontWithName: @"Noteworthy-Bold" size: 17];
        cell.DescriptionTextView.text = comment.comment;
        cell.DescriptionTextView.font = textFont;
        cell.DescriptionTextView.textColor = [UIColor blackColor];
        CGFloat borderWidth = 1.0;
        cell.DescriptionTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        cell.DescriptionTextView.layer.borderWidth = borderWidth;
        cell.DescriptionTextView.layer.cornerRadius = 5.0;
        cell.DescriptionTextView.clipsToBounds = YES;
        cell.DescriptionTextView.editable = NO;
        cell.InfoLabel.text = [NSString stringWithFormat: @"%@ %@", [comment user].userName, comment.postDate];
        textFont = [UIFont fontWithName: @"Noteworthy-Bold" size: 10];
        cell.InfoLabel.font = textFont;
        cell.InfoLabel.textColor = [UIColor blackColor];
        cell.InfoLabel.adjustsFontSizeToFitWidth = YES;
    }
    else {
        self.c = [[Comentario alloc] init];
        self.c.user = [DatabaseUtilities getCurrentUser];
        self.c.comment = @"";
        UIFont *textFont = [UIFont fontWithName: @"Noteworthy-Bold" size: 17];
        cell.DescriptionTextView.text = @"";
        cell.DescriptionTextView.editable = YES;
        cell.DescriptionTextView.textColor = [UIColor blackColor];
        CGFloat borderWidth = 1.0;
        cell.DescriptionTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        cell.DescriptionTextView.layer.borderWidth = borderWidth;
        cell.DescriptionTextView.layer.cornerRadius = 5.0;
        cell.DescriptionTextView.clipsToBounds = YES;
        [cell.DescriptionTextView becomeFirstResponder];
        cell.InfoLabel.text = [NSString stringWithFormat: @"%@ %@", [self.c user].userName, self.c.postDate];
        textFont = [UIFont fontWithName: @"Noteworthy-Bold" size: 10];
        cell.InfoLabel.font = textFont;
        cell.InfoLabel.textColor = [UIColor blackColor];
        cell.InfoLabel.adjustsFontSizeToFitWidth = YES;
        
        self.newComment = NO;
    }
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
}

#pragma mark UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    textView.editable = NO;
    self.newComment = NO;
    [[self.construction comentarios] replaceObjectAtIndex: [[self.construction comentarios] count]-1 withObject: self.c];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text rangeOfString: @"\n"].location != NSNotFound) {
        [textView resignFirstResponder];
    }
    return YES;
}

@end

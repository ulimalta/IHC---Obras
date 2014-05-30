//
//  DetailViewController.m
//  Obras
//
//  Created by Ulisses Malta Santos on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *TitleNavigationItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *BackButton;
@property (weak, nonatomic) IBOutlet UIImageView *Picture;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITableView *CommentsTableView;

@property (nonatomic) NSInteger currentPicture;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    cell.DescriptionTextView.text = comment.comment;
    cell.DescriptionTextView.font = textFont;
    cell.DescriptionTextView.textColor = [UIColor blackColor];
    CGFloat borderWidth = 1.0;
    cell.DescriptionTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cell.DescriptionTextView.layer.borderWidth = borderWidth;
    cell.DescriptionTextView.layer.cornerRadius = 5.0;
    cell.DescriptionTextView.clipsToBounds = YES;
    cell.DescriptionTextView.editable = NO;
    cell.InfoLabel.text = [NSString stringWithFormat: @"%@ %@", [self.construction usuario].userName, comment.postDate];
    textFont = [UIFont fontWithName: @"Noteworthy-Bold" size: 10];
    cell.InfoLabel.font = textFont;
    cell.InfoLabel.textColor = [UIColor blackColor];
    cell.InfoLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed: 0.9
                                           green: 0.9
                                            blue: 0.9
                                           alpha: 0.4];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
}

@end

//
//  CommentCell.h
//  Obras
//
//  Created by Ulisses Malta Santos on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *DescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *InfoLabel;

@end

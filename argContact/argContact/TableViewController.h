//
//  TableViewController.h
//  argContact
//
//  Created by Anup Gupta on 24/04/16.
//  Copyright © 2016 anup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController
{
    
    NSMutableArray *addressbookConacts;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
- (IBAction)DoneAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)editAction:(id)sender;



@end

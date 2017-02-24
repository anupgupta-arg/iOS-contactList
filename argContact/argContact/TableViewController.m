//
//  TableViewController.m
//  argContact
//
//  Created by Anup Gupta on 24/04/16.
//  Copyright © 2016 anup. All rights reserved.
//

#import "TableViewController.h"
#import "AppDelegate.h"
#import <sqlite3.h>
@interface TableViewController ()
{
    sqlite3 *db;
}
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppDelegate getContactAuthorizationFromUser];
    [self setContacts];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
      
    // Uncomment the following line to preserve selection between presentations.
  //   self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     [self updateButtonsToMatchTableState];
   // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)setContacts
{
    addressbookConacts = [AppDelegate getContacts];
    NSSortDescriptor *contactSortDiscriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [addressbookConacts sortUsingDescriptors:[NSArray arrayWithObject:contactSortDiscriptor]];
}
-(NSString*)getDatabasePath
{   NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[path objectAtIndex:0];
    docPath=[docPath stringByAppendingPathComponent:@"argContact.sqlite"];
    NSLog (@"%@",docPath);
    return docPath;
}
-(NSString *)sqliteapppath
{
    // The database is stored in the application bundle.
    NSString *apppath=[[NSBundle mainBundle]bundlePath];
    apppath=[apppath stringByAppendingPathComponent:@"argContact.sqlite"];
    NSLog(@"app path%@\n",apppath);
    return apppath;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return addressbookConacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reCell" forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reCell"];
    }
    cell.textLabel.text=[[addressbookConacts objectAtIndex:indexPath.row]valueForKey:@"name"];
    cell.detailTextLabel.text=[[addressbookConacts objectAtIndex:indexPath.row]valueForKey:@"phoneno"];
    return cell;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%ld",(long)indexPath.row);
//    
//    NSString *strName = [[addressbookConacts objectAtIndex:indexPath.row] valueForKey:@"name"];
//    NSString *strNumber = [[addressbookConacts objectAtIndex:indexPath.row] valueForKey:@"phoneno"];
//    
//    NSString *str=[self getDatabasePath];
//    const char *path=[str UTF8String];
//    
//    NSFileManager *file=[NSFileManager defaultManager];
//    
//    BOOL success=[file fileExistsAtPath:str];
//    if (!success) {
//        NSLog(@"file does not exist");
//    }
//    
//    if (sqlite3_open(path, &db)==SQLITE_OK) {
//        //    NSString *insertSql=[NSString stringWithFormat:@"INSERT INTO info (name,email,mobno) VALUES (\"%@\", \"%@\", \"%@\")",self.name.text,self.email.text, self.mobileno.text];
//        const char *query=[[NSString stringWithFormat:@"INSERT INTO argContactList(name, number) VALUES (\"%@\", \"%@\")",strName,strNumber] UTF8String];
//        // const char *query=[insertSql UTF8String];
//        sqlite3_stmt *statement;
//        // NSLog(@"%@",_name.text);
//        
//        if (sqlite3_prepare_v2(db, query, -1, &statement, nil)==SQLITE_OK)
//        {
//            if ((sqlite3_step(statement)==SQLITE_DONE)) {
//                NSLog(@"record insert sucessful ");
//            }
//            else NSLog(@"data not insert");
//        }
//        else
//        {
//            NSLog(@"statement not prepare ");
//        }
//        sqlite3_finalize(statement);
//        sqlite3_close(db);
//    }
//    
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




- (IBAction)DoneAction:(id)sender {
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
    NSString *str=[self getDatabasePath];
    const char *path=[str UTF8String];
    
    NSFileManager *file=[NSFileManager defaultManager];
    
    BOOL success=[file fileExistsAtPath:str];
    if (!success) {
        NSLog(@"file does not exist");
    }
    for (NSIndexPath *selectionIndex in selectedRows)
    {
        [indicesOfItemsToDelete addIndex:selectionIndex.row];
        NSString *strName = [[addressbookConacts objectAtIndex:selectionIndex.row] valueForKey:@"name"];
           NSString *strNumber = [[addressbookConacts objectAtIndex:selectionIndex.row] valueForKey:@"phoneno"];
        if (sqlite3_open(path, &db)==SQLITE_OK) {
            //    NSString *insertSql=[NSString stringWithFormat:@"INSERT INTO info (name,email,mobno) VALUES (\"%@\", \"%@\", \"%@\")",self.name.text,self.email.text, self.mobileno.text];
            const char *query=[[NSString stringWithFormat:@"INSERT INTO argContactList(name, number) VALUES (\"%@\", \"%@\")",strName,strNumber] UTF8String];
            // const char *query=[insertSql UTF8String];
            sqlite3_stmt *statement;
            // NSLog(@"%@",_name.text);
            
            if (sqlite3_prepare_v2(db, query, -1, &statement, nil)==SQLITE_OK)
            {
                if ((sqlite3_step(statement)==SQLITE_DONE)) {
                    NSLog(@"record insert sucessful ");
                }
                else NSLog(@"data not insert");
            }
            else
            {
                NSLog(@"statement not prepare ");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }

    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
}

- (IBAction)cancelAction:(id)sender {
    [self.tableView setEditing:NO animated:YES];
    [self updateButtonsToMatchTableState];
}

- (IBAction)editAction:(id)sender {
    [self.tableView setEditing:YES animated:YES];
    [self updateButtonsToMatchTableState];
}
- (void)updateButtonsToMatchTableState
{
    if (self.tableView.editing)
    {
        // Show the option to cancel the edit.
        self.navigationItem.rightBarButtonItem = self.cancelButton;
        self.navigationItem.hidesBackButton=YES;
        
      //  [self updateDeleteButtonTitle];
        
        // Show the delete button.
        self.navigationItem.leftBarButtonItem = self.doneButton;
    }
    else
    {
        // Not in editing mode.
        self.navigationItem.leftBarButtonItem = nil;
        
        // Show the edit button, but disable the edit button if there's nothing to edit.
//        if (self.dataArray.count > 0)
//        {
//            self.editButton.enabled = YES;
//        }
//        else
//        {
//            self.editButton.enabled = NO;
//        }
        self.navigationItem.rightBarButtonItem = self.editButton;
        self.navigationItem.hidesBackButton=nil;
    }
}

@end

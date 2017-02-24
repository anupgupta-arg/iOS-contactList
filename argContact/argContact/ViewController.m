//
//  ViewController.m
//  argContact
//
//  Created by Anup Gupta on 24/04/16.
//  Copyright © 2016 anup. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize nameArray,numberArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)sqliteapppath
{
    // The database is stored in the application bundle.
    NSString *apppath=[[NSBundle mainBundle]bundlePath];
    apppath=[apppath stringByAppendingPathComponent:@"argContact.sqlite"];
    NSLog(@"app path%@\n",apppath);
    return apppath;
    
}
-(NSString *)savedocpath
{
    // Copy the database from the package to the users filesystem
    NSArray *arr=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docpath=[arr objectAtIndex:0];
    docpath=[docpath stringByAppendingPathComponent:@"argContact.sqlite"];
    NSLog(@"doc path %@ \n",docpath);
    return docpath;
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self savedocpath]])
    {
        
        NSLog(@"%@",nameArray);
        NSLog(@"%@",numberArray);
        
        [self getdataFromsqliteDB];
    }else
    {
        if ([[NSFileManager defaultManager] copyItemAtPath:[self sqliteapppath] toPath:[self savedocpath] error:nil])
        {
            NSLog(@"sqlite file copied");
        }else
        {
            NSLog(@"sqlite file not copied");
        }
    }
    [_table reloadData];
    
}
-(void)getdataFromsqliteDB
{
    NSString *str=[self savedocpath];  sqlite3_stmt *stmt;
    const char *path=[str UTF8String];
    if ( ( sqlite3_open ( path,  &db ) == SQLITE_OK ) ) {
        const char *statment="select * From argContactList";
        nameArray=[[NSMutableArray alloc]init];
        numberArray=[[NSMutableArray alloc]init];
        
        if (sqlite3_prepare(db, statment, -1, &stmt, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(stmt)==SQLITE_ROW)
            {
                // Read the data from the result row
                const char *const_name=(char *)sqlite3_column_text(stmt, 0);
                //converting const char to nsstring
                NSString *name=[NSString stringWithFormat:@"%s",const_name];
                [nameArray addObject:name];
                const char *const_number=(char *)sqlite3_column_text(stmt, 1);
                //converting const char to nsstring
                NSString *number=[NSString stringWithFormat:@"%s",const_number];
                [numberArray addObject:number];
            }}
        sqlite3_finalize(stmt);
        sqlite3_close(db);
    }
    
    //    [self.tableView reloadData];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"reUseCell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reUseCell"];
    }
    cell.textLabel.text=[nameArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text=[numberArray objectAtIndex:indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return nameArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure to delete?"delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    deletenNum=[numberArray objectAtIndex:indexPath.row];
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
    }
    if (buttonIndex == 1) {
        
        NSString *str=[self savedocpath];  sqlite3_stmt *stmt;
        const char *path=[str UTF8String];
        if ( ( sqlite3_open ( path,  &db ) == SQLITE_OK ) ) {
            NSString *removeNumber =[NSString stringWithFormat:@"DELETE FROM argContactList where number=%@",deletenNum];
            const char *statment=[removeNumber UTF8String];
//            nameArray=[[NSMutableArray alloc]init];
//            numberArray=[[NSMutableArray alloc]init];
            
            if (sqlite3_prepare(db, statment, -1, &stmt, NULL)==SQLITE_OK)
            {
                if(sqlite3_step(stmt) == SQLITE_DONE) {
                    NSLog(@"delete Success");
                    
                }
            }
            sqlite3_finalize(stmt);
            sqlite3_close(db);
            
        }
    }
    [self viewWillAppear:YES];
}



@end

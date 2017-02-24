//
//  ViewController.h
//  argContact
//
//  Created by Anup Gupta on 24/04/16.
//  Copyright © 2016 anup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <sqlite3.h>
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    sqlite3 *db;
    NSString *deletenNum;
}
@property (strong, nonatomic) IBOutlet UITableView *table;
@property(retain, nonatomic) NSMutableArray * nameArray;
@property(retain, nonatomic) NSMutableArray * numberArray;
@end


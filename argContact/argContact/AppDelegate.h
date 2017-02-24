//
//  AppDelegate.h
//  argContact
//
//  Created by Anup Gupta on 24/04/16.
//  Copyright © 2016 anup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+(NSMutableArray *)getContactAuthorizationFromUser;

+(NSMutableArray *)getContacts;

@end


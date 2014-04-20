//
//  ContactsController.h
//  Email
//
//  Created by Zhou Jinxiu on 14-4-19.
//  Copyright (c) 2014年 com.vitatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactsDelegate <NSObject>

-(void)selectedContact:(id)contact;

@end

@interface ContactsController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_contactsTable;
    NSArray *_personArray;
}

@property (nonatomic,weak) id<ContactsDelegate> contactDelegate;

@end

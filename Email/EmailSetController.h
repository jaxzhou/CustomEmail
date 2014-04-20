//
//  EmailSetController.h
//  Email
//
//  Created by Zhou Jinxiu on 14-4-19.
//  Copyright (c) 2014年 com.vitatlas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactView.h"
#import "EmailContentView.h"
#import "ContactsController.h"

@interface EmailSetController : UIViewController<ContactsDelegate,UITextViewDelegate>{
    ContactView *_contacts;
    UITextView *_subject;
    EmailContentView *_contents;
}

-(void)addContact:(NSDictionary*)contact;

-(void)setContent:(NSAttributedString*)content;

-(void)setSubject:(NSString*)subject;

@end

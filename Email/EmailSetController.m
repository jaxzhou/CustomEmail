//
//  EmailSetController.m
//  Email
//
//  Created by Zhou Jinxiu on 14-4-19.
//  Copyright (c) 2014年 com.vitatlas. All rights reserved.
//

#import "EmailSetController.h"

@interface EmailSetController ()

@end

@implementation EmailSetController

-(id)init{
    self =[super init];
    if (self) {
        _contacts = [[ContactView alloc] initWithFrame:CGRectMake(0, 45, 320, 45)];
        [self.view addSubview:_contacts];
        [_contents setBackgroundColor:[UIColor clearColor]];
        //[_contacts setDelegate:self];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [btn setFrame:CGRectMake(320-45, 45, 45, 45)];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(viewContacts) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 90, 320, 0.5)];
        [self.view addSubview:line];
        [line setBackgroundColor:[UIColor whiteColor]];
        
        _subject = [[UITextView alloc] initWithFrame:CGRectMake(0, 90, 320, 45)];
        [self.view addSubview:_subject];
        [_subject setFont:[UIFont systemFontOfSize:18]];
        [_subject setTextColor:[UIColor whiteColor]];
        [_subject setBackgroundColor:[UIColor clearColor]];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, 135, 320, 0.5)];
        [self.view addSubview:line];
        [line setBackgroundColor:[UIColor whiteColor]];
        
        _contents = [[EmailContentView alloc] initWithFrame:CGRectMake(0, 135, 320, [UIScreen mainScreen].bounds.size.height-135)];
        [self.view addSubview:_contents];
        [_contents setFont:[UIFont systemFontOfSize:18]];
        [_contents setTextColor:[UIColor whiteColor]];
        [_contents setBackgroundColor:[UIColor clearColor]];
        
        [self.view setBackgroundColor:[UIColor colorWithRed:0.1 green:1 blue:0.1 alpha:1]];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewContacts{
    ContactsController *c = [[ContactsController alloc] init];
    [c setContactDelegate:self];
    [self presentViewController:c animated:YES completion:^{
        
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

-(void)addContact:(NSDictionary *)contact{
    [_contacts addContact:contact];
}

-(void)setContent:(NSAttributedString *)content{
    [_contents setAttributedText:content];
}

-(void)setSubject:(NSString*)subject{
    [_subject setText:subject];
}

-(void)selectedContact:(id)contact{
    [_contacts addContact:contact];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

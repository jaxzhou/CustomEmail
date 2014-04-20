//
//  ViewController.m
//  Email
//
//  Created by Zhou Jinxiu on 14-4-19.
//  Copyright (c) 2014年 com.vitatlas. All rights reserved.
//

#import "ViewController.h"
#import "EmailSetController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *test = [UIButton buttonWithType:UIButtonTypeCustom];
    [test setTitle:NSLocalizedString(@"Test", @"") forState:0];
    [test addTarget:self action:@selector(viewTest:) forControlEvents:UIControlEventTouchUpInside];
    [test setFrame:CGRectMake(100, 100, 120, 60)];
    [test setBackgroundColor:[UIColor darkGrayColor]];
    [self.view addSubview:test];
}

-(void)viewTest:(id)sender{
    EmailSetController *c = [[EmailSetController alloc] init];
    [c setSubject:@"Invite Your Friends"];
    [c setContent:[[NSAttributedString alloc] initWithString:@"Invite your friends to ss lalala blahblahblah"]];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

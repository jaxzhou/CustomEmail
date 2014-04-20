//
//  ContactsController.m
//  Email
//
//  Created by Zhou Jinxiu on 14-4-19.
//  Copyright (c) 2014年 com.vitatlas. All rights reserved.
//

#import "ContactsController.h"

@interface ContactsController ()

@end

@implementation ContactsController

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
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (addressBook) {
            NSArray *peoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                ABMultiValueRef t = ABRecordCopyValue((__bridge ABRecordRef)evaluatedObject,kABPersonEmailProperty);
                return ABMultiValueGetCount(t)>0;
            }];
            NSArray *filterd = [peoples filteredArrayUsingPredicate:predicate];
            _personArray = [NSMutableArray array];
            for (id p in filterd) {
                NSMutableDictionary *perDic = [NSMutableDictionary dictionary];
                ABMultiValueRef t = ABRecordCopyValue((__bridge ABRecordRef)p,kABPersonEmailProperty);
                CFTypeRef mail = ABMultiValueCopyValueAtIndex(t, 0);
                [perDic setObject:(__bridge NSString*)mail forKey:@"mail"];
                CFTypeRef last = ABRecordCopyValue((__bridge ABRecordRef)p,kABPersonLastNameProperty);
                CFTypeRef first = ABRecordCopyValue((__bridge ABRecordRef)p,kABPersonFirstNameProperty);
                NSMutableString *name = [NSMutableString stringWithString:@""];
                if (last && CFGetTypeID(last)==CFStringGetTypeID()) {
                    [name appendString:(__bridge NSString*)last];
                }
                if (first && CFGetTypeID(first)==CFStringGetTypeID()) {
                    [name appendString:(__bridge NSString*)first];
                }
                if ([name length]==0) {
                    CFTypeRef nick = ABRecordCopyValue((__bridge ABRecordRef)p,kABPersonMiddleNameProperty);
                    if (nick && CFGetTypeID(nick)==CFStringGetTypeID()) {
                        [name appendString:(__bridge NSString*)nick];
                    }
                }
                if ([name length]==0) {
                    CFTypeRef nick = ABRecordCopyValue((__bridge ABRecordRef)p,kABPersonNicknameProperty);
                    if (nick && CFGetTypeID(nick)==CFStringGetTypeID()) {
                        [name appendString:(__bridge NSString*)nick];
                    }
                }
                if (name.length > 0) {
                    [perDic setObject:name forKey:@"name"];
                    [(NSMutableArray*)_personArray addObject:perDic];
                }
            }
            [(NSMutableArray*)_personArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [[obj1 objectForKey:@"name"] localizedCompare:[obj2 objectForKey:@"name"]];
            }];
            [_contactsTable reloadData];
        }
    });
    
    _contactsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, self.view.bounds.size.height-45)];
    [_contactsTable setDelegate:self];
    [_contactsTable setDataSource:self];
    [self.view addSubview:_contactsTable];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_personArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *k = @"contact";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:k];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:k];
    }
    
    id p = [_personArray objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[p objectForKey:@"name"]];
    [[cell detailTextLabel] setText:[p objectForKey:@"mail"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.contactDelegate) {
        [self.contactDelegate selectedContact:[_personArray objectAtIndex:indexPath.row]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

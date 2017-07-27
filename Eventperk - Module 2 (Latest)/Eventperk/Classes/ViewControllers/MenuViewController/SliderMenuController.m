//
//  SliderMenuController.m
//  Resume
//
//  Created by KishanKumar Sutariya on 08/06/16.
//  Copyright © 2016 Crayon. All rights reserved.
//

#import "SliderMenuController.h"
#import "MenuTableViewCell.h"
#import "Eventperk-Swift.h"
#import <Realm/Realm.h>
#import <AWSMobileHubHelper/AWSMobileHubHelper.h>
#import "Eventperk-Swift.h"

#define App_Delegate (AppDelegate*)[UIApplication sharedApplication].delegate

#define kkeyName    @"Title"
#define kkeyImage  @"Image"

@interface SliderMenuController ()
{
    IBOutlet UIView *v_nav;
    IBOutlet UIImageView *img_User;
    IBOutlet UILabel *lbl_UserName;

    NSInteger _presentedRow;
    NSIndexPath *selectIndexPath;
    NSArray *menuArray;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end

@implementation SliderMenuController
@synthesize rearTableView = _rearTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _listTableView.separatorColor = [UIColor grayColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"UserDetail"]) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[[Constants appDelegate] dictUserDetail]];
        
        NSString *strName = [NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"given_name"], [dict valueForKey:@"family_name"]];
        lbl_UserName.text = strName;
        
        if ([dict valueForKey:@"pictureInData"]) {
            img_User.image = [UIImage imageWithData:[dict valueForKey:@"pictureInData"]];
        }else if ([dict valueForKey:@"picture"]) {
            
            NSURL *url = [NSURL URLWithString:[dict valueForKey:@"picture"]];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                
                NSData *data = [NSData dataWithContentsOfURL:url];
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    if (data != nil) {
                        img_User.image = [UIImage imageWithData:data];
                    }else{
                        img_User.image = [UIImage imageNamed:@"ic_UserPic"];
                    }
                });
            });
        }else{
            img_User.image = [UIImage imageNamed:@"ic_UserPic"];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(IBAction)clk_EditProfile:(id)sender
{
    ProfileViewController *profileView = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:profileView];
    nav.navigationBar.hidden = YES;
    [_rdvTabVC closeMenu];
    [_rdvTabVC presentViewController:nav animated:YES completion:nil];
}

#pragma marl - UITableView Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MenuTableViewCell";
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:NULL];
        cell = (MenuTableViewCell *)[nib objectAtIndex:0];
    }
    
    NSDictionary *itemDic = [menuArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lbl_Name.text = [itemDic valueForKey:kkeyName];
    cell.img_View.image = [UIImage imageNamed:[itemDic valueForKey:kkeyImage]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    selectIndexPath = indexPath;
    _presentedRow = row;  // <- store the presented row
    
    switch (row) {
        case 0:
        {
            
        }
            break;
        case 2:
        {
            [App_Delegate getVenderModeStatus]?[App_Delegate LoadUserTabMenu]:[App_Delegate LoadVendorTabMenu];
        }
            break;
        case 7:
        {
            [[AWSCognitoUserPoolsSignInProvider sharedInstance] logout];
            [[RLMSyncUser currentUser] logOut];
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm deleteAllObjects];
            [realm commitWriteTransaction];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserDetail"];
            [Constants appDelegate].dictUserDetail = [[NSMutableDictionary alloc] init];

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *nav = [storyboard instantiateViewControllerWithIdentifier:@"EPNavigationViewController"];
            nav.navigationBar.hidden = YES;
            [_rdvTabVC closeMenu];
            [_rdvTabVC presentViewController:nav animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)reloadData{
    
    menuArray = @[  @{kkeyName:@"Invite friends",kkeyImage:@"ic_InviteFriends"},
                    @{kkeyName:@"Manage orders",kkeyImage:@"ic_Orders"},
                    [App_Delegate getVenderModeStatus]?@{kkeyName:@"Switch to user",kkeyImage:@"ic_Switch"}:@{kkeyName:@"Switch to vendor",kkeyImage:@"ic_Switch"},
                    @{kkeyName:@"Settings",kkeyImage:@"ic_Settings"},
                    @{kkeyName:@"Help & support",kkeyImage:@"ic_Help"},
                    @{kkeyName:@"List your service",kkeyImage:@"ic_Services"},
                    @{kkeyName:@"Give us feedback",kkeyImage:@"ic_Feedback"},
                    @{kkeyName:@"Log out",kkeyImage:@"ic_"}
                    ];
    
    [_listTableView reloadData];
}

-(IBAction)clk_Back:(id)sender{

}

@end

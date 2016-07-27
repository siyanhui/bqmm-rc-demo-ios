//
//  RCDMeInfoTableViewController.m
//  RCloudMessage
//
//  Created by litao on 15/11/4.
//  Copyright © 2015年 RongCloud. All rights reserved.
//

#import "RCDMeInfoTableViewController.h"
#import "UIColor+RCColor.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDChatViewController.h"
#import "RCDRCIMDataSource.h"
#import "RCDEditUserNameViewController.h"

@interface RCDMeInfoTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentUserNickNameLabel;

@end

@implementation RCDMeInfoTableViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView=[UIView new];
    //设置分割线颜色
    self.tableView.separatorColor = [UIColor colorWithHexString:@"dfdfdf" alpha:1.0f];

    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[RCDRCIMDataSource shareInstance]getUserInfoWithUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId completion:^(RCUserInfo *userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentUserNickNameLabel.text=userInfo.name;
        });
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        NSLog(@"show the edit user name view");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RCDEditUserNameViewController *editUserNameVC = [storyboard instantiateViewControllerWithIdentifier:@"editUserNameVC"];
        [self.navigationController pushViewController:editUserNameVC animated:YES];
    } 
}

@end

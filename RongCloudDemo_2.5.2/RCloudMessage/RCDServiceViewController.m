//
//  RCDServiceViewController.m
//  RCloudMessage
//
//  Created by Liv on 14/12/1.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCDServiceViewController.h"
//#import "RCChatViewController.h"
#import <RongIMKit/RongIMKit.h>
//#import "RCHandShakeMessage.h"
#import "RCDChatViewController.h"
#import "RCDCustomServiceViewController.h"

@interface RCDServiceViewController () <UITextFieldDelegate>

@property (nonatomic, strong)UITextField *kefuIdField;
@end

@implementation RCDServiceViewController



- (IBAction)acService:(UIButton *)sender {

    
    //测试环境客服Id "rongcloud.net.kefu.service112"
    RCDCustomServiceViewController *chatService = [[RCDCustomServiceViewController alloc] init];
#define SERVICE_ID @"KEFU145801184889727"
    chatService.userName = @"客服";
    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
#ifdef DEBUG
    NSString *kefuId = self.kefuIdField.text;
    [[NSUserDefaults standardUserDefaults] setObject:kefuId forKey:@"KefuId"];
    chatService.targetId = kefuId;
#else
    chatService.targetId = SERVICE_ID;
#endif

    chatService.title = chatService.userName;

//    RCHandShakeMessage* textMsg = [[RCHandShakeMessage alloc] init];
//    [[RongUIKit sharedKit] sendMessage:ConversationType_CUSTOMERSERVICE targetId:SERVICE_ID content:textMsg delegate:nil];
//   
    [self.navigationController pushViewController :chatService animated:YES];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //设置为不用默认渲染方式
        self.tabBarItem.image = [[UIImage imageNamed:@"icon_server"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_server_hover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMessageNotification:)
                                                     name:RCKitDispatchMessageNotification
                                                   object:nil];
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:19];
    titleView.textColor = [UIColor whiteColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = @"客服";
    self.tabBarController.navigationItem.titleView = titleView;
   // self.tabBarController.navigationItem.title = @"客服";
    self.tabBarController.navigationItem.rightBarButtonItem = nil;


}
- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef DEBUG
    if (!self.kefuIdField) {
        self.kefuIdField = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, 200, 30)];
        [self.kefuIdField setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:self.kefuIdField];
        NSString *kefuId = [[NSUserDefaults standardUserDefaults] objectForKey:@"KefuId"];
        if (kefuId == nil) {
            kefuId = @"KEFU145801184889727";//online kefuId
//            kefuId = @"KEFU145760441681012";//offline kefuId
        }
        [self.kefuIdField setText:kefuId];
        [self.kefuIdField setDelegate:self];
        self.kefuIdField.returnKeyType = UIReturnKeyDone;
    }
#endif
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarItem.badgeValue = nil;
}
-(void)didReceiveMessageNotification:(NSNotification *)notification
{
    __weak typeof(&*self) __weakSelf = self;
    RCMessage *message = notification.object;
    if (message.conversationType == ConversationType_CUSTOMERSERVICE) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            int count = [[RCIMClient sharedRCIMClient]getUnreadCount:@[@(ConversationType_CUSTOMERSERVICE)]];
//            if (count>0) {
                __weakSelf.tabBarItem.badgeValue = @"";
//            }
            });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RCKitDispatchMessageNotification object:nil];
}

@end

//
//  RCDFindPswViewController.m
//  RCloudMessage
//
//  Created by 杜立召 on 15/3/23.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDFindPswViewController.h"
#import "RCDRegisterViewController.h"
#import "RCDTextFieldValidate.h"
#import "AFHttpTool.h"
#import "RCAnimatedImagesView.h"
#import "RCUnderlineTextField.h"
#import "RCDLoginViewController.h"
#import "RCDCommonDefine.h"
@interface RCDFindPswViewController () <UITextFieldDelegate>
@property(unsafe_unretained, nonatomic) IBOutlet UITextField *tfEmail;
@property(unsafe_unretained, nonatomic) IBOutlet UITextField *tfNickName;
@property(unsafe_unretained, nonatomic) IBOutlet UITextField *tfPassword;
@property(unsafe_unretained, nonatomic) IBOutlet UITextField *tfRePassword;
@property(nonatomic, strong) UIView *headBackground;
@property(nonatomic, strong) UIImageView *rongLogo;
@property(nonatomic, strong) UIView *inputBackground;
@property(weak, nonatomic) IBOutlet UITextField *tfMobile;
@property(strong, nonatomic) RCAnimatedImagesView *animatedImagesView;
@property(nonatomic, strong) UIView *statusBarView;
@property(nonatomic, strong) UILabel *licenseLb;
@property(nonatomic, strong) UILabel *errorMsgLb;
@end

@implementation RCDFindPswViewController
#define UserTextFieldTag 1000
#define PassWordFieldTag 1001
#define RePassWordFieldTag 1002
@synthesize animatedImagesView = _animatedImagesView;
@synthesize inputBackground = _inputBackground;
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
  self.animatedImagesView = [[RCAnimatedImagesView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                               self.view.bounds.size.height)];
  [self.view addSubview:self.animatedImagesView];
  self.animatedImagesView.delegate = self;
  self.view.translatesAutoresizingMaskIntoConstraints = YES;
  _headBackground = [[UIView alloc]
      initWithFrame:CGRectMake(0, -100, self.view.bounds.size.width, 50)];
  _headBackground.userInteractionEnabled = YES;
  _headBackground.backgroundColor =
      [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.2];
  [self.view addSubview:_headBackground];

  UIButton *registerHeadButton = [[UIButton alloc]
      initWithFrame:CGRectMake(self.view.bounds.size.width - 80, 0, 70, 50)];
  [registerHeadButton setTitle:@"登录" forState:UIControlStateNormal];
  [registerHeadButton
      setTitleColor:
          [[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5]
           forState:UIControlStateNormal];
  [registerHeadButton.titleLabel
      setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
  [registerHeadButton addTarget:self
                         action:@selector(loginPageEvent)
               forControlEvents:UIControlEventTouchUpInside];

  [_headBackground addSubview:registerHeadButton];
  UIImage *rongLogoSmallImage = [UIImage imageNamed:@"title_logo_small"];

  UIImageView *rongLogoSmallImageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 60, 5, 100,
                               40)];
  [rongLogoSmallImageView setImage:rongLogoSmallImage];

  [rongLogoSmallImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
  rongLogoSmallImageView.contentMode = UIViewContentModeScaleAspectFit;
  rongLogoSmallImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
  rongLogoSmallImageView.clipsToBounds = YES;
  [_headBackground addSubview:rongLogoSmallImageView];
  UIButton *forgetPswHeadButton =
      [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];

  [forgetPswHeadButton setTitle:@"新用户" forState:UIControlStateNormal];
  [forgetPswHeadButton
      setTitleColor:
          [[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5]
           forState:UIControlStateNormal];
  [forgetPswHeadButton.titleLabel
      setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
  [forgetPswHeadButton addTarget:self
                          action:@selector(registerEvent)
                forControlEvents:UIControlEventTouchUpInside];
  [_headBackground addSubview:forgetPswHeadButton];
  _licenseLb = [[UILabel alloc] initWithFrame:CGRectZero];
  _licenseLb.text = @"仅供演示融云SDK功能使用";
  _licenseLb.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
  _licenseLb.translatesAutoresizingMaskIntoConstraints = NO;
  _licenseLb.textColor =
      [[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5];
  [self.view addSubview:_licenseLb];

  UIImage *rongLogoImage = [UIImage imageNamed:@"login_logo"];
  _rongLogo = [[UIImageView alloc] initWithImage:rongLogoImage];
  _rongLogo.contentMode = UIViewContentModeScaleAspectFit;
  _rongLogo.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_rongLogo];

  _inputBackground = [[UIView alloc] initWithFrame:CGRectZero];
  _inputBackground.translatesAutoresizingMaskIntoConstraints = NO;
  _inputBackground.userInteractionEnabled = YES;
  [self.view addSubview:_inputBackground];
  _errorMsgLb = [[UILabel alloc] initWithFrame:CGRectZero];
  _errorMsgLb.text = @"";
  _errorMsgLb.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
  _errorMsgLb.translatesAutoresizingMaskIntoConstraints = NO;
  _errorMsgLb.textColor = [UIColor colorWithRed:204.0f / 255.0f
                                          green:51.0f / 255.0f
                                           blue:51.0f / 255.0f
                                          alpha:1];
  [self.view addSubview:_errorMsgLb];
  RCUnderlineTextField *userNameTextField =
      [[RCUnderlineTextField alloc] initWithFrame:CGRectZero];

  userNameTextField.backgroundColor = [UIColor clearColor];
  userNameTextField.tag = UserTextFieldTag;
  //_account.placeholder=[NSString stringWithFormat:@"Email"];
  UIColor *color = [UIColor whiteColor];
  userNameTextField.attributedPlaceholder = [[NSAttributedString alloc]
      initWithString:@"手机号"
          attributes:@{NSForegroundColorAttributeName : color}];
  userNameTextField.textColor = [UIColor whiteColor];
  self.view.translatesAutoresizingMaskIntoConstraints = YES;
  userNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
  userNameTextField.delegate = self;
  [_inputBackground addSubview:userNameTextField];
  if (userNameTextField.text.length > 0) {
    [userNameTextField setFont:[UIFont fontWithName:@"Heiti SC" size:25.0]];
  }

  [userNameTextField addTarget:self
                        action:@selector(textFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
  UIButton *sendCodeButton = [[UIButton alloc] initWithFrame:CGRectZero];
  [sendCodeButton setTitle:@"发送" forState:UIControlStateNormal];
  [sendCodeButton setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
  sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
  [sendCodeButton addTarget:self
                     action:@selector(sendCodeEvent)
           forControlEvents:UIControlEventTouchUpInside];

  sendCodeButton.translatesAutoresizingMaskIntoConstraints = NO;

  [_inputBackground addSubview:sendCodeButton];
  RCUnderlineTextField *verificationCodeField =
      [[RCUnderlineTextField alloc] initWithFrame:CGRectZero];

  verificationCodeField.backgroundColor = [UIColor clearColor];
  verificationCodeField.attributedPlaceholder = [[NSAttributedString alloc]
      initWithString:@"验证码"
          attributes:@{NSForegroundColorAttributeName : color}];
  verificationCodeField.textColor = [UIColor whiteColor];
  verificationCodeField.delegate = self;
  verificationCodeField.translatesAutoresizingMaskIntoConstraints = NO;

  [_inputBackground addSubview:verificationCodeField];
  UIButton *reSendCodeButton = [[UIButton alloc] initWithFrame:CGRectZero];
  [reSendCodeButton setTitle:@"重发验证码" forState:UIControlStateNormal];
  [reSendCodeButton
      setTitleColor:
          [[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5]
           forState:UIControlStateDisabled];
  [reSendCodeButton setTitleColor:[UIColor blueColor]
                         forState:UIControlStateNormal];
  reSendCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
  [reSendCodeButton addTarget:self
                       action:@selector(sendCodeEvent)
             forControlEvents:UIControlEventTouchUpInside];
  [reSendCodeButton setEnabled:false];
  reSendCodeButton.translatesAutoresizingMaskIntoConstraints = NO;

  [_inputBackground addSubview:reSendCodeButton];
  UILabel *vCodeTimerLb = [[UILabel alloc] initWithFrame:CGRectZero];
  vCodeTimerLb.text = @"(60)";
  vCodeTimerLb.font = [UIFont fontWithName:@"Heiti SC" size:14.0];
  vCodeTimerLb.translatesAutoresizingMaskIntoConstraints = NO;
  vCodeTimerLb.textColor =
      [[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5];
  [_inputBackground addSubview:vCodeTimerLb];
  RCUnderlineTextField *passwordTextField =
      [[RCUnderlineTextField alloc] initWithFrame:CGRectZero];
  passwordTextField.tag = PassWordFieldTag;
  passwordTextField.textColor = [UIColor whiteColor];
  passwordTextField.returnKeyType = UIReturnKeyDone;
  passwordTextField.delegate = self;
  passwordTextField.secureTextEntry = YES;

  passwordTextField.attributedPlaceholder = [[NSAttributedString alloc]
      initWithString:@"新密码"
          attributes:@{NSForegroundColorAttributeName : color}];
  passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
  [_inputBackground addSubview:passwordTextField];
  UILabel *pswMsgLb = [[UILabel alloc] initWithFrame:CGRectZero];
  pswMsgLb.text = @"6-16位字符 区分大小写";
  pswMsgLb.font = [UIFont fontWithName:@"Heiti SC" size:10.0];
  pswMsgLb.translatesAutoresizingMaskIntoConstraints = NO;
  pswMsgLb.textColor =
      [[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5];
  [_inputBackground addSubview:pswMsgLb];

  UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [loginButton addTarget:self
                  action:@selector(btnDoneClicked:)
        forControlEvents:UIControlEventTouchUpInside];
  [loginButton setBackgroundImage:[UIImage imageNamed:@"confirm_button"]
                         forState:UIControlStateNormal];
  loginButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
  loginButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_inputBackground addSubview:loginButton];

  UIView *bottomBackground = [[UIView alloc] initWithFrame:CGRectZero];
  bottomBackground.translatesAutoresizingMaskIntoConstraints = NO;
  UIButton *registerButton = [[UIButton alloc]
      initWithFrame:CGRectMake(self.view.bounds.size.width - 100, -20, 80, 50)];
  [registerButton setTitle:@"登录" forState:UIControlStateNormal];
  [registerButton
      setTitleColor:
          [[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5]
           forState:UIControlStateNormal];
  [registerButton.titleLabel
      setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
  [registerButton addTarget:self
                     action:@selector(loginPageEvent)
           forControlEvents:UIControlEventTouchUpInside];

  UIButton *forgetPswButton =
      [[UIButton alloc] initWithFrame:CGRectMake(-10, -20, 80, 50)];
  [forgetPswButton setTitle:@"新用户" forState:UIControlStateNormal];
  [forgetPswButton
      setTitleColor:
          [[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5]
           forState:UIControlStateNormal];
  forgetPswButton.titleLabel.font = [UIFont systemFontOfSize:18];
  [forgetPswButton.titleLabel
      setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
  [forgetPswButton addTarget:self
                      action:@selector(registerEvent)
            forControlEvents:UIControlEventTouchUpInside];
  [bottomBackground addSubview:forgetPswButton];
  [bottomBackground addSubview:registerButton];
  [self.view addSubview:bottomBackground];

  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:sendCodeButton
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:userNameTextField
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:1.0
                                         constant:-13]];
  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:sendCodeButton
                                        attribute:NSLayoutAttributeRight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:userNameTextField
                                        attribute:NSLayoutAttributeRight
                                       multiplier:1.0
                                         constant:-7]];
  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:reSendCodeButton
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:verificationCodeField
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:1.0
                                         constant:-7]];
  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:reSendCodeButton
                                        attribute:NSLayoutAttributeRight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:verificationCodeField
                                        attribute:NSLayoutAttributeRight
                                       multiplier:1.0
                                         constant:-33]];
  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:vCodeTimerLb
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:verificationCodeField
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:1.0
                                         constant:-13]];
  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:vCodeTimerLb
                                        attribute:NSLayoutAttributeRight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:verificationCodeField
                                        attribute:NSLayoutAttributeRight
                                       multiplier:1.0
                                         constant:-7]];

  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:bottomBackground
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.view
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:1.0
                                         constant:20]];
  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:pswMsgLb
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:passwordTextField
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:1.0
                                         constant:0]];
  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:pswMsgLb
                                        attribute:NSLayoutAttributeRight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:passwordTextField
                                        attribute:NSLayoutAttributeRight
                                       multiplier:1.0
                                         constant:-7]];

  NSDictionary *views = NSDictionaryOfVariableBindings(
      _errorMsgLb, _licenseLb, _rongLogo, _inputBackground, bottomBackground);

  NSArray *viewConstraints = [[[[[[[NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-41-[_inputBackground]-41-|"
                          options:0
                          metrics:nil
                            views:views]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|-14-[_rongLogo]-70-|"
                                  options:0
                                  metrics:nil
                                    views:views]]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint constraintsWithVisualFormat:
                                  @"V:|-70-[_licenseLb(==10)]-20-[_rongLogo(=="
                                  @"60)]-[_errorMsgLb(==5)]-[_inputBackground("
                                  @"==235)]" options:0
                                                  metrics:nil
                                                    views:views]]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"V:[bottomBackground(==50)]"
                                  options:0
                                  metrics:nil
                                    views:views]]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|-10-[bottomBackground]-10-|"
                                  options:0
                                  metrics:nil
                                    views:views]]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|-40-[_licenseLb]-10-|"
                                  options:0
                                  metrics:nil
                                    views:views]]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|-50-[_errorMsgLb]-10-|"
                                  options:0
                                  metrics:nil
                                    views:views]];

  [self.view addConstraints:viewConstraints];

  NSDictionary *inputViews = NSDictionaryOfVariableBindings(
      verificationCodeField, pswMsgLb, userNameTextField, passwordTextField,
      loginButton);

  NSArray *inputViewConstraints = [[[[
      [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[userNameTextField]|"
                                              options:0
                                              metrics:nil
                                                views:inputViews]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|[passwordTextField]|"
                                  options:0
                                  metrics:nil
                                    views:inputViews]]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|[verificationCodeField]|"
                                  options:0
                                  metrics:nil
                                    views:inputViews]]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:
                  @"V:|[userNameTextField(60)]-[verificationCodeField(50)]-["
                  @"passwordTextField(55)]-[loginButton(50)]"
                                  options:0
                                  metrics:nil
                                    views:inputViews]]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[loginButton]|"
                                                  options:0
                                                  metrics:nil
                                                    views:inputViews]];

  [_inputBackground addConstraints:inputViewConstraints];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWillShow:)
             name:UIKeyboardWillShowNotification
           object:self.view.window];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWillHide:)
             name:UIKeyboardWillHideNotification
           object:self.view.window];
  _statusBarView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
  _statusBarView.backgroundColor =
      [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.2];
  [self.view addSubview:_statusBarView];
  [self.view setNeedsLayout];
  [self.view setNeedsUpdateConstraints];
}

- (void)textFieldDidChange:(UITextField *)textField {
  if (textField.text.length == 0) {
    [textField setFont:[UIFont fontWithName:@"Heiti SC" size:18.0]];
  } else {
    [textField setFont:[UIFont fontWithName:@"Heiti SC" size:25.0]];
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  NSLog(@"textFieldShouldReturn");
  [textField resignFirstResponder];
  return YES;
}
- (void)keyboardWillShow:(NSNotification *)notif {

  [UIView animateWithDuration:0.25
                   animations:^{

                     self.view.frame =
                         CGRectMake(0.f, -50, self.view.frame.size.width,
                                    self.view.frame.size.height);
                     _headBackground.frame =
                         CGRectMake(0, 70, self.view.bounds.size.width, 50);
                     _rongLogo.hidden = YES;
                     _licenseLb.hidden = YES;
                     _statusBarView.frame =
                         CGRectMake(0.f, 50, self.view.frame.size.width, 20);
                   }
                   completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notif {
  [UIView animateWithDuration:0.25
                   animations:^{
                     self.view.frame =
                         CGRectMake(0.f, 0.f, self.view.frame.size.width,
                                    self.view.frame.size.height);
                     CGRectMake(0, -100, self.view.bounds.size.width, 50);
                     _headBackground.frame =
                         CGRectMake(0, -100, self.view.bounds.size.width, 50);
                     _rongLogo.hidden = NO;
                     _licenseLb.hidden = NO;
                     _statusBarView.frame =
                         CGRectMake(0.f, 0, self.view.frame.size.width, 20);
                   }
                   completion:nil];
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.animatedImagesView startAnimating];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];

  [self.animatedImagesView stopAnimating];
}

/*阅读用户协议*/
- (void)userProtocolEvent {
}
/*注册*/
- (void)loginPageEvent {
  RCDLoginViewController *temp = [[RCDLoginViewController alloc] init];
  CATransition *transition = [CATransition animation];
  transition.type = kCATransitionPush;        //可更改为其他方式
  transition.subtype = kCATransitionFromLeft; //可更改为其他方式
  [self.navigationController.view.layer addAnimation:transition
                                              forKey:kCATransition];
  [self.navigationController pushViewController:temp animated:NO];
}
/*发送验证码*/
- (void)sendCodeEvent {
}
- (void)registerEvent {
  RCDRegisterViewController *temp = [[RCDRegisterViewController alloc] init];
  [self.navigationController pushViewController:temp animated:YES];
}

/**
 *  获取默认用户
 *
 *  @return 是否获取到数据
 */
- (BOOL)getDefaultUser {
  NSString *userName =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
  NSString *userPwd =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"userPwd"];
  return userName && userPwd;
}
/*获取用户账号*/
- (NSString *)getDefaultUserName {
  NSString *defaultUser =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
  return defaultUser;
}
/*获取用户密码*/
- (NSString *)getDefaultUserPwd {
  NSString *defaultUserPwd =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"userPwd"];
  return defaultUserPwd;
}

- (IBAction)btnDoneClicked:(id)sender {
  if (![self checkContent])
    return;
  NSString *userName =
      [(UITextField *)[self.view viewWithTag:UserTextFieldTag] text];
  NSString *userPwd =
      [(UITextField *)[self.view viewWithTag:PassWordFieldTag] text];
  [AFHttpTool registerWithEmail:userName
      mobile:@""
      userName:userName
      password:userPwd
      success:^(id response) {
        int code = [response[@"code"] intValue];
        NSString *messsage = nil;
        if (code == 200) {
          messsage = @"注册成功!";
        } else if (code == 101) {
          messsage = @"Email已经被注册！";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
          _errorMsgLb.text = messsage;
        });
      }
      failure:^(NSError *err) {
        dispatch_async(dispatch_get_main_queue(), ^{
          _errorMsgLb.text = @"注册失败!";
        });

      }];
}

/**
 *  检查输入内容
 *
 *  @return 是否合法输入
 */
- (BOOL)checkContent {
  NSString *userName =
      [(UITextField *)[self.view viewWithTag:UserTextFieldTag] text];
  NSString *userPwd =
      [(UITextField *)[self.view viewWithTag:PassWordFieldTag] text];
  NSString *reUserPwd =
      [(UITextField *)[self.view viewWithTag:RePassWordFieldTag] text];

  if (![RCDTextFieldValidate validateEmail:userName]) {
    _errorMsgLb.text = @"邮箱格式不正确!";
    return NO;
  }

  if (userName.length == 0) {

    _errorMsgLb.text = @"用户名不能为空!";
    return NO;
  }
  if (userPwd.length < 6) {
    _errorMsgLb.text = @"密码不能小于6位!";
  }
  if (reUserPwd.length == 0 || userPwd.length == 0) {
    _errorMsgLb.text = @"密码或确认密码不能为空!";
    return NO;
  }
  if (![reUserPwd isEqualToString:userPwd]) {
    _errorMsgLb.text = @"两次输入密码不一致!";
    return NO;
  }
  return YES;
}

- (NSUInteger)animatedImagesNumberOfImages:
    (RCAnimatedImagesView *)animatedImagesView {
  return 2;
}

- (UIImage *)animatedImagesView:(RCAnimatedImagesView *)animatedImagesView
                   imageAtIndex:(NSUInteger)index {
  return [UIImage imageNamed:@"login_background.png"];
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little
 preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

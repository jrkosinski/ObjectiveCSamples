//
//  LoginModalViewController.h
//  [Client Name]  
//
//  Created by John Kosinski on 4/13/15.
//

#import "ForgotPasswordController.h"
#import "LoginOperation.h"
#import "LearnMoreOperation.h"
#import "LearnMoreOperationResponse.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import <GooglePlus/GooglePlus.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface LoginModalViewController : CustomDialogViewController <UITextFieldDelegate, WebServiceOperationDelegate, GIDSignInDelegate, GIDSignInUIDelegate>
{
    BOOL keyboardShown;
}

@property (nonatomic, retain) IBOutlet UITextField  * usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField  * passwordTextField;
@property (nonatomic, retain) IBOutlet UILabel    * usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel    * passwordLabel;
@property (retain, nonatomic) IBOutlet UIImageView *splashImageView;
@property (retain, nonatomic) IBOutlet UIImageView *bluredSplashView;
@property (retain, nonatomic) IBOutlet UIView *controlView;

@property (nonatomic, retain) IBOutlet CustomIconButton   * loginButton;
@property (retain, nonatomic) IBOutlet CustomIconButton *theNewToButton;

- (id) init;
- (id) initWithDelegate: (id) aDelegate;

- (IBAction) loginAction;
- (IBAction) newToAction;
- (IBAction) forgotPasswordAction;
- (IBAction) dismissKeyboard: (UITapGestureRecognizer *)recognizer;

@property (nonatomic) BOOL isSocialEnabled;

@end

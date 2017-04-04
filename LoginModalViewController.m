//
//  LoginModalViewController.m
//  [Client Name] 
//
//  Created by John Kosinski on 4/13/15.
//
//

#import "LoginModalViewController.h"

#import "LoginZipCaptureViewController.h"
#import "FutronixAppDelegate.h"
#import "SignUpSelectionViewController.h"
#import "SessionOperation.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <GooglePlus/GooglePlus.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

#import "SocialLoginOperation.h"
#import "SocialSignUpCommand.h"

#define NO_MATCH_ALERT_VIEW 1230986

@interface LoginModalViewController ()

//IBOutlets
@property (retain, nonatomic) IBOutletCollection(UIView) NSArray *socialViews;
@property (retain, nonatomic) IBOutlet UIButton *facebookButton;
@property (retain, nonatomic) IBOutlet UIButton *googleButton;

@property (retain, nonatomic) NSString *accessToken;
@property (retain, nonatomic) NSString *provider;

@end

@implementation LoginModalViewController

@synthesize usernameTextField, passwordTextField;
@synthesize usernameLabel, passwordLabel;
@synthesize loginButton;
@synthesize theNewToButton;
@synthesize accessToken, provider;



#pragma mark init and dealloc

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id) initWithNibName: (NSString *) nibNameOrNil  bundle: (NSBundle *) nibBundleOrNil {
    if (self = [super initWithNibName: nibNameOrNil  bundle: nibBundleOrNil]) {
        delegate = nil;
    }
    return self;
}

- (id) initWithDelegate: (id<CustomDialogDelegate>) aDelegate {
    NSString *nibName = @"LoginModalView";
    if ([FutronixAppDelegate sharedDelegate].socialLogin) {
        self.isSocialEnabled = YES;
    } else {
        self.isSocialEnabled = NO;
        nibName = @"LoginModalViewNoSocial";
    }
    
    self = [self initWithNibName:nibName  bundle: nil];
    if (self)
    {
        delegate = aDelegate; // we don't retain this!
    }
    return self;
}

- (id) init {
    return [self initWithDelegate:nil];
}

- (void) dealloc
{
    [usernameTextField release];
    [passwordTextField release];
    [usernameLabel release];
    [passwordLabel release];
    [loginButton release];
    [accessToken release];
    [provider release];
    
    [theNewToButton release];
    [_splashImageView release];
    [_bluredSplashView release];
    [_controlView release];
    [_facebookButton release];
    [_googleButton release];
    [_socialViews release];
    [super dealloc];
}

- (IBAction) dismissKeyboard: (UITapGestureRecognizer *)recognizer {
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}



#pragma mark -
#pragma mark LOGIN METHODS
#pragma mark -

/*
 loginAction
 * * *
 Responds to login button pressed
 */
- (IBAction) loginAction
{
    Debug(@"!>> Login pressed!");
    LoginOperation * operation;
    
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [self showOverlay];
    operation = [[[LoginOperation alloc] initWithEmail: usernameTextField.text
                                                password: passwordTextField.text
                                                delegate: self] autorelease];
    [operation queue];
}

/*
 newToAction
 * * *
 Special handling for new users
 */
- (IBAction) newToAction {
    if (!self.isSocialEnabled) {
        LoginZipCaptureViewController * zipCapture;
        
        //must capture zip code?
        zipCapture = [[LoginZipCaptureViewController alloc] initWithDelegate: delegate];
        [self.navigationController pushViewController:zipCapture animated:YES];
        [zipCapture release];
    }
    else
    {
        //or move to address selection
        SignUpSelectionViewController *selectionCtrl = [[SignUpSelectionViewController alloc] initWithDelegate:delegate];
        [self.navigationController pushViewController:selectionCtrl animated:YES];
        [selectionCtrl release];
    }
}

/*
 forgotPasswordAction
 * * *
 Begin forgot password flow
 */
- (IBAction) forgotPasswordAction;
{
    self.title = [NSString stringForCopydeckKey: @"forgot_password_back_button_title"]; //to show this title on back button
    ForgotPasswordController * forgotPasswordView = [[ForgotPasswordController alloc] initWithNibName: @"ForgotPasswordController"  bundle: nil];
    [self.navigationController pushViewController: forgotPasswordView animated: YES];
    [forgotPasswordView release];
}

/*
 alertView
 * * *
 Alertview handler
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == NO_MATCH_ALERT_VIEW) {
        if (buttonIndex == 0) {
            // Nothing to do. Let them sign in using other methods
        } else {
            // Create Account
            SocialSignUpCommand *signUpCommand = [[SocialSignUpCommand alloc] initCommandWithViewController:self withAccessToken:self.accessToken withProvider:self.provider delegate:delegate];
            [signUpCommand execute];
        }
    }
}

/*
 logOutSocial
 * * *
 Log out from social accounts
 */
-(void)logOutSocial
{
    // Delete all NSUserDefaults data.
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [[FBSDKLoginManager new] logOut];
    [[GIDSignIn sharedInstance] signOut];
}

/*
 succeededWithResponse
 * * *
 Login success callback
 */
- (void) operation: (WebServiceOperation *) operation  succeededWithResponse: (id) response
{
    //operation response
    LoginOperationResponse *theResponse = (LoginOperationResponse*)response;
    
    if ([operation isKindOfClass: [LoginOperation class]]) {
        if ([operation isKindOfClass:[SocialLoginOperation class]]) {
            if (![theResponse.status isEqualToString:API_SUCCESS]) {
                
                //remove spinner
                [self removeOverlay];
                
                //account did not match any existing
                if ([theResponse.resultAction isEqualToString:@"NOMATCH"]) {
                    UIAlertView *noMatchAlertView = [[[UIAlertView alloc] initWithTitle:nil message:theResponse.resultMessage delegate:self cancelButtonTitle:@"Sign in using a different method" otherButtonTitles:@"Create Account", nil] autorelease];
                    [noMatchAlertView setTag:NO_MATCH_ALERT_VIEW];
                    [noMatchAlertView show];
                    
                //response is empty
                } else if (!isEmpty(theResponse.resultMessage)) {
                    [[[[UIAlertView alloc] initWithTitle:nil message:theResponse.resultMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
                    [self logOutSocial];
                }
                
                return;
#warning JRK -- Need to fix the or logic below
            } else if ([theResponse.resultAction isEqualToString:@"SIGNEDIN_ALERT"] || ![theResponse.resultMessage isEqualToString:@"Auto Sign In"]) {
                [[[[UIAlertView alloc] initWithTitle:nil message:theResponse.resultMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
            }
        }
        
        //set loggined in flag and post notification
        [FutronixAppDelegate sharedDelegate].isLoggedIn = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedIn" object:nil];
        
        //must user see new terms of service?
        if (!theResponse.tcAcknowledge)
            [[NSNotificationCenter defaultCenter]  postNotificationName: @"ShowUpdatedTermsAndConditions" object:nil];

        //check if user is already in the list and show welcome back message on home.
        NSString * email = [((LoginOperation *)operation) email];
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        if (![[FutronixAppDelegate sharedDelegate] checkIsOnListAndSaveUser: email])
        {
            [userDefaults setBool: YES  forKey: @"JustWelcomeUser"];
        }
        else
        {
            [userDefaults removeObjectForKey: @"JustWelcomeUser"];
        }
        [userDefaults synchronize];
        
        //remove spinner
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self removeOverlay];
        
        [delegate proceedPressed: self];
        [self dismissDialog];
        
        //Coremetrics
        [CoremetricsSupport trackConversionEventId: @"login"  actionType: @"2"  eventCategory: @"login"  eventPoints: @"1"  unitSumDif: nil  addressTypeAndorderId: nil  CustomerId: [FutronixAppDelegate sharedDelegate].user.userId  zipCode: nil  emailSubject: nil  helpPageUrl: nil  totalOrderNumber: nil];
#warning JRK -- Need to fix the tracking
    }
}

/*
 failedWithError
 * * *
 Login failure callback
 */
- (void) operation: (WebServiceOperation *) operation  failedWithError: (NSError *) error
{
    if ([operation isKindOfClass: [LoginOperation class]])
    {
        //remove spinner & log out
        [self removeOverlay];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self logOutSocial];
    }
    [self presentError: error];
}

/*
 initializeCustomButtons
 * * *
 Create custom buttons for different social logins
 */
- (void) initializeCustomButtons
{
    //login button
    [loginButton setTitleText: [NSString stringForCopydeckKey: @"login_login_to_accout"]];
    [loginButton setStyle: CustomIconButtonTypeNewLightGreen];
    [loginButton setSizeMask: CustomIconButtonSizeMaskSelf];
    [loginButton setPositionOfIcon: CustomIconPositionNone];
    [loginButton setFontSize1: 16.0];
    [loginButton layout];
    
    //signup button
    [theNewToButton setTitleText:@"Sign up"];
    [theNewToButton setSizeMask:CustomIconButtonSizeMaskSelf];
    [theNewToButton setStyle: CustomIconButtonTypeNewGreen];
    [theNewToButton setPositionOfIcon: CustomIconPositionNone];
    [theNewToButton setFontSize1: 16.0];
    [theNewToButton layout];
}



#pragma mark -
#pragma mark CONTROLLER METHODS
#pragma mark -

/*
 viewDidLoad
 * * *
 Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 */
- (void) viewDidLoad
{
    [super viewDidLoad];
    [self initializeCustomButtons];
    
    hideModifiableOrderNotification = YES;
    
    //set username/password text fields
    usernameLabel.text = [NSString stringForCopydeckKey:@"startup_login_email"];
    passwordLabel.text = [NSString stringForCopydeckKey:@"startup_login_password"];
    
    //set status bar for navigation controller to white
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
#warning JRK: hard-coded dimensions
    FutronixAppDelegate *appDele = (FutronixAppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDele.screenHeight == 480) {
        
        CGRect frame = self.theNewToButton.frame;
        CGFloat yPosition = 400.0;
        self.theNewToButton.frame = CGRectMake(frame.origin.x, yPosition, frame.size.width, frame.size.height);
        
        frame = self.controlView.frame;
        yPosition = 25.0;
        self.controlView.frame = CGRectMake(frame.origin.x, yPosition, frame.size.width, frame.size.height);
    }
    
    //G+ specific setup
    GIDSignIn *sharedInstance = [GIDSignIn sharedInstance];
    
    [sharedInstance setDelegate:self];
    [sharedInstance setUiDelegate:self];
    
    //[self logOutSocial];
}

/*
 viewWillAppear
 * * *
 */
- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    //Coremetrics
    [CoremetricsSupport trackPageView: @"LOGIN" cg: @"login"];
}

/*
 shouldAutorotateToInterfaceOrientation
 * * *
 */
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
 didReceiveMemoryWarning
 * * *
 Delegate to superclass
 */
- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}



#pragma mark -
#pragma mark delegate methods (UITextFieldDelegate)
#pragma mark -

/*
 textFieldDidEndEditing
 * * *
 */
- (void) textFieldDidEndEditing: (UITextField *) textField
{
}

/*
 textFieldShouldReturn
 * * *
 Textfield navigation
 */
- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
    Debug(@"Text field should end editing! %@", textField);
    
    if ([textField isEqual: usernameTextField])
    {
        [passwordTextField becomeFirstResponder];
    }
    else if ([textField isEqual: passwordTextField])
    {
        [self loginAction];
    }
    return YES;
}

/*
 viewDidUnload
 * * *
 */
- (void)viewDidUnload {
    [self setSplashImageView:nil];
    [self setBluredSplashView:nil];
    [self setControlView:nil];
    [super viewDidUnload];
}

/*
 facebookLoginPressed
 * * *
 Facebook login
 */
- (IBAction)facebookLoginPressed:(UIButton *)sender
{
    //set FB login behavior
    FBSDKLoginManager *loginManager = [FBSDKLoginManager new];
    loginManager.loginBehavior = FBSDKLoginBehaviorWeb;
    if ([[FutronixAppDelegate sharedDelegate] facebookAppIsInstalled])
        loginManager.loginBehavior = FBSDKLoginBehaviorNative;
    
    //do login
    NSArray *readPermissions = @[@"public_profile", @"email", @"user_friends"];
    [loginManager logOut];
    [loginManager logInWithReadPermissions:readPermissions handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        [self loginButton:sender didCompleteWithResult:result error:error];
    }];
}

/*
 googleLoginPressed
 * * *
 Google login
 */
- (IBAction)googleLoginPressed:(UIButton *)sender {
    GIDSignIn *sharedInstance = [GIDSignIn sharedInstance];
    
    [sharedInstance signOut];
    [sharedInstance signIn];
}



#pragma mark -
#pragma mark delegate methods (FBSDKLoginButtonDelegate)
#pragma mark -
-(void)loginButton:(UIButton *)fb_loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (result.isCancelled) {
        return;
    }
    
    if (error) {
        NSLog(@"Facebook login error: %@", [error localizedDescription]);
        return;
    }
        [self showOverlay];
    self.accessToken = [result.token.tokenString retain];
    self.provider = [@"facebook" retain];
    
    SocialLoginOperation *loginOperation = [[SocialLoginOperation alloc] initWithToken:result.token.tokenString delegate:self];
    SessionOperation *sessionOperation = [[SessionOperation alloc] init];
    [sessionOperation setFinalCall:loginOperation];
    [sessionOperation queue];
}

-(void)loginButtonDidLogOut:(UIButton *)loginButton {
    
}



#pragma mark - GIDSignInDelegate

/*
 didSignInForUser
 * * *
 Google handler/callback for login
 */
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    if (error != nil)
    {
        //user cancelled
        if ([error.description rangeOfString:@"user canceled"].location != NSNotFound)
        {
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Futronix Login" message:@"Please use other methods of logging in" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
            [alertView show];
        }
        //access denied
        else if([error.description rangeOfString:@"access_denied"].location != NSNotFound){
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"We are unable to sign in using your Google account." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
            [alertView show];
        }
        //otherwise failed
        else
        {
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Login Failed" message: error.description delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
            [alertView show];
            
        }
    }
    else
    {
        //login succeeded
        if (user != nil && user.authentication != nil && user.authentication.accessToken != nil)
        {
            [self showOverlay];
            self.accessToken = [user.authentication.accessToken retain];
            self.provider = [@"google" retain];
            
            //complete login
            SocialLoginOperation *loginOperation = [[SocialLoginOperation alloc] initWithToken:user.authentication.accessToken provider:@"google" delegate:self];
            SessionOperation *sessionOperation = [[SessionOperation alloc] init];
            [sessionOperation setFinalCall:loginOperation];
            [sessionOperation queue];
        }
    }
}

/*
 didDisconnectWithUser
 * * *
 Google handler/callback for disconnect
 */
- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
      withError:(NSError *)error {
    
}


@end

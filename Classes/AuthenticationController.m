#import "AuthenticationController.h"


@interface AuthenticationController ()
- (void)failWithMessage:(NSString *)theMessage;
- (void)startAuthentication;
- (void)finishAuthenticationWithSuccess:(BOOL)success;
- (void)presentLogin;
- (void)dismissLogin;
- (void)showAuthenticationSheet;
- (void)dismissAuthenticationSheet;
- (void)dismissKeyboard;
@end


@implementation AuthenticationController

@synthesize username, password;

- (id)initWithTarget:(id)theTarget andSelector:(SEL)theSelector andViewController:(UIViewController *)theViewController {
	[super initWithNibName:@"Authentication" bundle:nil];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	self.username = [defaults stringForKey:kUsernameDefaultsKey];
	self.password = [defaults stringForKey:kPasswordDefaultsKey];
	target = theTarget;
	selector = theSelector;
	viewController = theViewController;
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	usernameField.text = username;
	passwordField.text = password;
}

- (void)dealloc {
	[usernameField release];
	[passwordField release];
	[submitButton release];
	[cancelButton release];
	[username release];
	[password release];
    [super dealloc];
}

- (void)authenticate {
	if (username.length > 0 && password.length > 0) {
		[self startAuthentication];
	} else {
		[self failWithMessage:@"Please enter your username and password"];
	}
}

- (void)startAuthentication {
	[self dismissKeyboard];
	[self showAuthenticationSheet];
	NSURL *url = [NSURL URLWithString:@"http://twitter.com/account/verify_credentials.xml"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)failWithMessage:(NSString *)theMessage {
	[self dismissAuthenticationSheet];
	[self presentLogin];
	[usernameField becomeFirstResponder];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:theMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)showAuthenticationSheet {
	authSheet = [[UIActionSheet alloc] initWithTitle:@"Authenticating, please wait..." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	UIView *currentView = viewController.modalViewController ? viewController.modalViewController.view : viewController.view;
	[authSheet showInView:currentView];
	[authSheet release];
}

- (void)finishAuthenticationWithSuccess:(BOOL)success {
	if (success) { // save credentials
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setValue:username forKey:kUsernameDefaultsKey];
		[defaults setValue:password forKey:kPasswordDefaultsKey];
		[defaults synchronize];
	}
	[self dismissAuthenticationSheet];
	[self dismissLogin];
	[target performSelector:selector withObject:success];
}

- (void)dismissAuthenticationSheet {
	[authSheet dismissWithClickedButtonIndex:0 animated:YES];
	authSheet = nil;
}

- (void)presentLogin {
	if (viewController.modalViewController == self) return;
	[viewController presentModalViewController:self animated:YES];
}

- (void)dismissLogin {
	if (viewController.modalViewController != self) return;
	[viewController dismissModalViewControllerAnimated:YES];
}

#pragma mark Actions

- (IBAction)submit:(id)sender {
	self.username = usernameField.text;
	self.password = passwordField.text;
	[self authenticate];
}

- (IBAction)cancel:(id)sender {
	[self finishAuthenticationWithSuccess:NO];
}

#pragma mark NSURLConnection delegation methods

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ([challenge previousFailureCount] == 0) {
		NSURLCredential *credential = [[NSURLCredential alloc] initWithUser:username password:password persistence:NSURLCredentialPersistenceForSession];
		[challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
		[credential release];
	} else {
		[challenge.sender cancelAuthenticationChallenge:challenge];
	}
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self finishAuthenticationWithSuccess:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self failWithMessage:@"Please ensure that you are connected to the internet and that your username and password are correct"];
}

#pragma mark Keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	if (textField == usernameField) [passwordField becomeFirstResponder];
	if (textField == passwordField) [self submit:nil];
	return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self dismissKeyboard];
}

- (void)dismissKeyboard {
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
}

@end
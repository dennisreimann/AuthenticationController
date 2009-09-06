#import "AuthenticationAppDelegate.h"
#import "AuthenticationController.h"
#import "AuthenticationViewController.h"


@implementation AuthenticationAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {   
    [window addSubview:viewController.view];
    [self authenticate];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

- (void)authenticate {
	authController = [[AuthenticationController alloc] initWithTarget:self andSelector:@selector(authenticationSucceeded:) andViewController:viewController];
	[authController authenticate];
}

- (void)authenticationSucceeded:(BOOL)success {
	viewController.statusLabel.text = success ? @"succeeded" : @"failed";
	[authController release];
}

@end
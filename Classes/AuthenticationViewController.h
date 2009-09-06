#import <UIKit/UIKit.h>


@interface AuthenticationViewController : UIViewController {
	IBOutlet UILabel *statusLabel;
}

@property (nonatomic, readonly) UILabel *statusLabel;

@end
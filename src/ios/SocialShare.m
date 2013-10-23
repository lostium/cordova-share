//
//  socialShare.m
//  deadtone
//
//  Created by SARATH DR on 28/11/2012.
//
//

#import "SocialShare.h"
#import <Cordova/CDV.h>

@implementation SocialShare

@synthesize  callbackId;

NSString *successCallback = nil;

- (void) showEmailComposer:(CDVInvokedUrlCommand*)command
{

	NSString* subject = [command.arguments objectAtIndex:0];
	NSString* body = [command.arguments objectAtIndex:1];
	callbackId = command.callbackId;
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	// Set subject
	if(subject != nil)
		[picker setSubject:subject];
	// set body
	if(body != nil)
	{
		[picker setMessageBody:body isHTML:YES];
		
	}
	
	if (picker != nil) {
		[[ super viewController ] presentModalViewController:picker animated:YES];
	}
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[[ super viewController ] dismissModalViewControllerAnimated:YES];

	CDVPluginResult* pluginResult = nil;
	pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
	
	NSString* javaScript = nil;
	
	NSLog (@"%@",callbackId);
	
	javaScript = [pluginResult toSuccessCallbackString:callbackId];
	[self writeJavascript:javaScript];
	
}

- (void) showSMSComposer:(CDVInvokedUrlCommand*)command
{
	

	NSString* body = [command.arguments objectAtIndex:0];
	callbackId = command.callbackId;

	
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
	
	
	// set body
	if(body != nil)
	{
		picker.body = body;
		
	}
	
	if (picker != nil) {
		[[ super viewController ] presentModalViewController:picker animated:YES];
	}

}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	
	[self.viewController dismissModalViewControllerAnimated:YES];
	
	CDVPluginResult* pluginResult = nil;
	pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
	
	NSString* javaScript = nil;
	
	NSLog (@"%@",callbackId);
	
	javaScript = [pluginResult toSuccessCallbackString:callbackId];
	[self writeJavascript:javaScript];
	
}

- (void) showTwitter:(CDVInvokedUrlCommand*)command
{

	NSString* tweetText = [command.arguments objectAtIndex:0];
	NSString* url       = [command.arguments objectAtIndex:1];

		callbackId = command.callbackId;
	
	TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
	
	if(tweetViewController != nil)
	{
		[tweetViewController setInitialText:tweetText];
		[tweetViewController addURL:[NSURL URLWithString:url]];
		
		[tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
			[super.viewController dismissModalViewControllerAnimated:YES];
			
			CDVPluginResult* pluginResult = nil;
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
			
			NSString* javaScript = nil;
			javaScript = [pluginResult toSuccessCallbackString:callbackId];
			[self writeJavascript:javaScript];
			
		}];
		
		[super.viewController presentModalViewController:tweetViewController animated:YES];

	}
	else{
		
		CDVPluginResult* pluginResult = nil;
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Twitter app is not installed"];
		
		NSString* javaScript = nil;
		javaScript = [pluginResult toErrorCallbackString:callbackId];
		[self writeJavascript:javaScript];
	}
	
}

- (void) showFacebook:(CDVInvokedUrlCommand*)command
{
	
	NSString *fbText = [command.arguments objectAtIndex:0];
	NSString *webUrl = [command.arguments count]>1?[command.arguments objectAtIndex:1]:NULL;
	
	callbackId = command.callbackId;
	
	NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
																																								 NULL,
																																								 (CFStringRef)webUrl,
																																								 NULL,
																																								 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																																								 kCFStringEncodingUTF8 ));
	
	NSString *fbShareText =  [NSString stringWithFormat:@"%@%@%@%@", @"fb://publish?text=",fbText,@"%20" ,encodedString ];
	
	NSString *webFbUrlStr =  [NSString stringWithFormat:@"%@%@", @"http://www.facebook.com/sharer.php?u=", webUrl ];
	
	
	// if it is available to us, we will post using the native dialog
	BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:super.viewController
																																				initialText:fbText
																																							image:nil
																																								url:[[NSURL alloc] initWithString:webUrl]
																																						handler:nil];
	if (!displayedNativeDialog)
	{
    NSURL *webFbUrl = [NSURL URLWithString:webFbUrlStr ];
    NSURL *theURL = [NSURL URLWithString:fbShareText ];
    
    if ([[UIApplication sharedApplication] canOpenURL:theURL])
    {
			[[UIApplication sharedApplication] openURL:theURL];
    }
    else
    {
			[[UIApplication sharedApplication] openURL:webFbUrl];
    }
    
	}
	
	
	CDVPluginResult* pluginResult = nil;
	pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
	
	NSString* javaScript = nil;
	javaScript = [pluginResult toSuccessCallbackString:callbackId];
	[self writeJavascript:javaScript];
	
	
}

@end
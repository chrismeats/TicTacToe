//
//  SafariViewController.m
//  TicTacToe
//
//  Created by ETC ComputerLand on 7/25/14.
//  Copyright (c) 2014 cmeats. All rights reserved.
//

#import "SafariViewController.h"

@interface SafariViewController () <UIWebViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) IBOutlet UITextField *myURLTextField;
@property (strong, nonatomic) IBOutlet UIButton *myBackButton;
@property (strong, nonatomic) IBOutlet UIButton *myForwardButton;

@end

@implementation SafariViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myBackButton.enabled = NO;
    self.myBackButton.alpha = .5;

    self.myForwardButton.enabled = NO;
    self.myForwardButton.alpha = .5;

    self.myWebView.scrollView.delegate = self;

    [self setDefaultTextField];

    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.center = self.view.center;
    [self.view addSubview:self.activityIndicator];


    NSURL *url = [NSURL URLWithString:@"http://en.wikipedia.org/wiki/Tic-tac-toe"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:urlRequest];

}

- (void)setDefaultTextField
{
    self.myURLTextField.text = @"Enter URL";
    self.myURLTextField.textColor = [UIColor lightGrayColor];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self.activityIndicator startAnimating];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *urlString = textField.text;
    NSString *formattedUrlString = @"";
    if ([urlString hasPrefix:@"http://"]) {
        formattedUrlString = urlString;
    } else {
        formattedUrlString = [NSString stringWithFormat:@"http://%@", urlString];
    }
    NSURL *url = [NSURL URLWithString:formattedUrlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:urlRequest];
    [textField resignFirstResponder];

    return YES;
}
- (IBAction)onBackButtonPressed:(id)sender {
    [self.myWebView goBack];


}
- (IBAction)onForwardButtonPressed:(id)sender {
    [self.myWebView goForward];
}
- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [self.myWebView stopLoading];
}
- (IBAction)onReloadButtonPressed:(id)sender {
    [self.myWebView reload];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self.myWebView canGoBack]) {
        self.myBackButton.enabled = YES;
        self.myBackButton.alpha = 1;
    } else {
        self.myBackButton.enabled = NO;
        self.myBackButton.alpha = .5;
    }

    if ([self.myWebView canGoForward]) {
        self.myForwardButton.enabled = YES;
        self.myForwardButton.alpha = 1;
    } else {
        self.myForwardButton.enabled = NO;
        self.myForwardButton.alpha = .5;
    }
    self.myURLTextField.text = webView.request.URL.absoluteString;

    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    [self.activityIndicator stopAnimating];
}
- (IBAction)onPluesButtonPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.title = @"New Features";
    alertView.message = @"Coming Soon";
    [alertView addButtonWithTitle:@"OK"];
    [alertView show];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    CGRect textFieldFrame = self.myURLTextField.frame;
    if(translation.y > 0) {
        // dragging down -- Scrolling Up
        textFieldFrame.origin.y = 71;
        self.myURLTextField.frame = textFieldFrame;
    } else {
        // dragging up -- Scrolling Down
        textFieldFrame.origin.y = -250;
        self.myURLTextField.frame = textFieldFrame;
    }
}
- (IBAction)onXButtonPress:(id)sender {
    self.myURLTextField.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        [self setDefaultTextField];
    }
    [textField resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    textField.textColor = [UIColor blackColor];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
}


@end

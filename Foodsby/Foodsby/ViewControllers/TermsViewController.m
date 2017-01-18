//
//  TermsViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/11/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController ()

@end

@implementation TermsViewController

@synthesize urlTerms;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self setCustomNavBar];
    
    [self loadLocalHtml];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) setCustomNavBar {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    
    self.navigationItem.title = @"Terms of Use";
}

- (void) loadTermsAndConditions {
    
    _webViewTermsAndConditions.delegate = self;
    
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:urlTerms];
    [_webViewTermsAndConditions loadRequest:request];
}

- (void) loadLocalHtml {

    [_indicatorView stopAnimating];

    NSString * htmlFile = [[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"];
    NSString * htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    
    [_webViewTermsAndConditions loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [_indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [_indicatorView stopAnimating];
}


#pragma mark - UI Action methods

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

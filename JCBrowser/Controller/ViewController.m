//
//  ViewController.m
//  JCBrowser
//
//  Created by molin on 15/11/4.
//  Copyright © 2015年 molin. All rights reserved.
//

#import "ViewController.h"
#import "JCFileShowController.h"

#import "JCBarView.h"
#import "AlertHelper.h"

#import "JCFileMultiDownloader.h"
#import "JCFileManager.h"

#import "JCDownloader.h"

@interface ViewController ()<JCBarViewDelegate,UIWebViewDelegate,NSURLConnectionDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) JCBarView               *barview;
@property (nonatomic, strong) UIWebView               *webview;
@property (nonatomic, strong) UIButton                *hideButton;
@property (nonatomic, strong) UIButton                *holdUrl;
@property (nonatomic, strong) UITableView             *bookmark;
@property (nonatomic, assign) BOOL                     isTo;
@property (nonatomic, copy)   NSString                *name;
@property (nonatomic, strong) NSMutableArray          *bookmarkArray;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.barview];
    [self.view addSubview:self.webview];
    [self.view addSubview:self.activityIndicator];
    [self.webview addSubview:self.hideButton];
    [self.webview addSubview:self.holdUrl];
    [self.view addSubview:self.bookmark];
    self.isTo = NO;
    self.name = @"";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [self.webview loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - UIWebView代理

//当网页视图已经开始加载一个请求后，得到通知
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
}

//当网页视图结束加载一个请求之后，得到通知
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.barview.title = [self.webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.activityIndicator stopAnimating];
}

//当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类型。
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    //    [alterview show];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *strUrl = [[request URL] absoluteString];
    NSArray *urlArray = [strUrl componentsSeparatedByString:@"/"];
    NSString *str = urlArray[urlArray.count-1];
    self.name = [[str componentsSeparatedByString:@"."] objectAtIndex:0];
    if ([urlArray[urlArray.count-1] isEqualToString:@"down.php"]) {
        [self downloaderFileWithUrl:strUrl name:self.name];
        return YES;
    }else if([urlArray[urlArray.count-2] isEqualToString:@"file.php"]) {
        JCFileManager *fileManager = [JCFileManager sharedFileManager];
        if ([fileManager writeFile:@"addrs.txt" andData:strUrl]) {
            [AlertHelper showOneSecond:@"写入成功!" andDelegate:self.view andBackgroundColor:[UIColor colorWithRed:0.132 green:0.508 blue:1.000 alpha:0.800]];
        }
        return NO;
    }
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        NSRange range = [strUrl rangeOfString:@".zip"];
        if (range.length != 0) {
            [self downloaderFileWithUrl:strUrl];
        }
    }
    return YES;
}

#pragma mark - 下载动作

//获取web里的所有的img url 
- (NSString *)createImgArrayJavaScript {
    NSString *js = @"var imgArray = document.getElementsByTagName('img'); var imgstr = ''; function f(){ for(var i = 0; i < imgArray.length; i++){ imgstr += imgArray[i].src;imgstr += ';';} return imgstr; } f();";
    return js;
}

//返回web img图片的数量
- (NSString *)createGetImgNumJavaScript {
    NSString *js = @"var imgArray = document.getElementsByTagName('img');function f(){ var num=imgArray.length;return num;} f();";
    return js;
}

//获取点击点的图片
- (NSString *)createTouchJavaScriptString {
    NSString *js = @"document.ontouchstart=function(event){\
    x=event.targetTouches[0].clientX;\
    y=event.targetTouches[0].clientY;\
    document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
    document.ontouchmove=function(event){\
    x=event.targetTouches[0].clientX;\
    y=event.targetTouches[0].clientY;\
    document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
    document.ontouchcancel=function(event){\
    document.location=\"myweb:touch:cancel\";};\
    document.ontouchend=function(event){\
    document.location=\"myweb:touch:end\";};";
    return js;
}

/**
 *  下载网页所有图片
 *
 *  @param webView 网页
 */
- (void)downloaderWebAllImage:(UIWebView *)webView { // [self performSelectorInBackground:@selector(test) withObject:nil];
    NSString *allImageAddressWithString = [webView stringByEvaluatingJavaScriptFromString:[self createImgArrayJavaScript]];
    NSArray *allImageAddressWithArray = [allImageAddressWithString componentsSeparatedByString:@";"];
    
    for (int i=0; i<allImageAddressWithArray.count; i++) {
        [self downloaderFileWithUrl:allImageAddressWithArray[i]];
    }
}

/**
 *  下载文件
 *
 *  @param url 地址
 */
- (void)downloaderFileWithUrl:(NSString *)url {
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSArray *arr = [url componentsSeparatedByString:@"/"];
    
    NSString *filepath = [caches stringByAppendingPathComponent:arr[arr.count-1]];
    JCDownloader *down = [JCDownloader new];
    [down startDownloaderURL:url depositPath:filepath];
}

- (void)downloaderFileWithUrl:(NSString *)url name:(NSString *)name {
    JCFileMultiDownloader *fmd = [[JCFileMultiDownloader alloc]init];
    fmd.url = url;
    // 文件保存到什么地方
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //NSArray *arr = [url componentsSeparatedByString:@"/"];
    NSString *filepath = [caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.torrent",name]];
    fmd.destPath = filepath;
    [fmd start];
}

#pragma mark - JCBarView代理

/**
 *  开始加载网页
 *
 *  @param address 地址
 */
- (void)startEventWithAddress:(NSString *)address {
    
    NSRange range = [address rangeOfString:@"http://"];
    
    NSRange range_info = [address rangeOfString:@"info"];
    
    if (range_info.length != 0) {
        self.isTo = YES;
    }
    
    NSURLRequest *request;
    
    if (range.length != 0) {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    }else {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",address]]];
    }
    [self.webview loadRequest:request];
}

/**
 *  前进
 */
- (void)advanceEvent {
    [self.webview goForward];
}

/**
 *  后退
 */
- (void)retreatEvent {
    [self.webview goBack];
}

/**
 *  关闭
 */
- (void)closeEvent {
    [self.webview stopLoading];//取消载入内容
}

/**
 *  刷新
 */
- (void)refreshEvent {
    [self.webview reload]; 
}

- (void)listEvent {
    if (self.isTo) {
        JCFileShowController *fileShowC = [[JCFileShowController alloc]init];
        [self.navigationController pushViewController:fileShowC animated:NO];
    }
}

#pragma mark - 点击事件

- (void)hideButton_action:(UIButton *)sender {
    [AlertHelper showOneSecond:@"开始保存图片" andDelegate:self.view andBackgroundColor:[UIColor colorWithRed:0.059 green:1.000 blue:0.167 alpha:0.800]];
    //[AlertHelper showOneSecond:@"开始保存图片" andDelegate:self.view ab];
    [self downloaderWebAllImage:self.webview];
    //[self performSelectorInBackground:@selector(downloaderWebAllImage) withObject:nil];
    //[self.webview reload]; //重载 --- 刷新
}

- (void)holdUrl_action:(UIButton *)sender {
    if (self.bookmark.frame.origin.y == 64) {
        [UIView animateWithDuration:1 animations:^{
            self.bookmark.frame = CGRectMake(0, -self.view.frame.size.height*0.25, self.view.frame.size.width, self.view.frame.size.height*0.25);
        }];
    }else {
        [UIView animateWithDuration:1 animations:^{
            self.bookmark.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height*0.25);
        }];
    }
}

- (void)longPressToDo:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint pt = [gesture locationInView:self.webview];
        NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
        NSString *urlToSave = [self.webview stringByEvaluatingJavaScriptFromString:imgURL];
        if (urlToSave.length > 0) {
            [AlertHelper showOneSecond:@"获取到图片地址" andDelegate:self.view andBackgroundColor:[UIColor colorWithRed:0 green:1 blue:1 alpha:0.8]];
            [self downloaderFileWithUrl:urlToSave];
        }else {
            [AlertHelper showOneSecond:@"没有获取到图片地址" andDelegate:self.view andBackgroundColor:[UIColor colorWithRed:1.000 green:0.125 blue:0.038 alpha:0.800]];
        }
    }
}

#pragma mark- TapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookmarkArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"点击保存书签";
        }else {
            cell.textLabel.text = self.bookmarkArray[indexPath.row-1];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        JCFileManager *fileManager = [JCFileManager sharedFileManager];
        if ([fileManager writeFile:@"holdUrl.txt" andData:self.webview.request.URL.absoluteString]) {
            [AlertHelper showOneSecond:@"写入成功!" andDelegate:self.view andBackgroundColor:[UIColor colorWithRed:0.132 green:0.508 blue:1.000 alpha:0.800]];
        }
    }else {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.bookmarkArray[indexPath.row]]];
        [self.webview loadRequest:request];
    }
    [UIView animateWithDuration:1 animations:^{
        tableView.frame = CGRectMake(0, -self.view.frame.size.height*0.25, self.view.frame.size.width, self.view.frame.size.height*0.25);
    }];
}


#pragma mark - 懒加载

- (JCBarView *)barview {
    if (!_barview) {
        _barview = [[JCBarView alloc]init];
        _barview.delegate = self;
    }
    return _barview;
}

- (UIWebView *)webview {
    if (!_webview) {
        _webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
        _webview.delegate = self;
        _webview.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
        // _webview.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDo:)];
        [_webview addGestureRecognizer:longPressGestureRecognizer];
        longPressGestureRecognizer.delegate = self;
        //longPressGestureRecognizer.cancelsTouchesInView = NO;

    }
    return _webview;
}

- (UIButton *)hideButton {
    if (!_hideButton) {
        _hideButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _hideButton.frame = CGRectMake(self.webview.frame.size.width-45, 0, 45, 45);
        _hideButton.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.150];
        [_hideButton addTarget:self action:@selector(hideButton_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hideButton;
}

- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicator.frame = CGRectMake(50, 0, 20, 20);
    }
    return _activityIndicator;
}

- (UIButton *)holdUrl {
    if (!_holdUrl) {
        _holdUrl = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _holdUrl.frame = CGRectMake(self.webview.frame.size.width-45, self.webview.frame.size.height-45, 45, 45);
        _holdUrl.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.150];
        [_holdUrl addTarget:self action:@selector(holdUrl_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _holdUrl;
}

- (UITableView *)bookmark {
    if (!_bookmark) {
        _bookmark = [[UITableView alloc]initWithFrame:CGRectMake(0, -self.view.frame.size.height*0.25, self.view.frame.size.width, self.view.frame.size.height*0.25) style:UITableViewStylePlain];
        _bookmark.backgroundColor = [UIColor whiteColor];
        _bookmark.delegate = self;
        _bookmark.dataSource = self;
    }
    return _bookmark;
}

- (NSMutableArray *)bookmarkArray {
    if (!_bookmarkArray) {
        _bookmarkArray = [[JCFileManager sharedFileManager] readFile:@"holdUrl.txt"];
    }
    return _bookmarkArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

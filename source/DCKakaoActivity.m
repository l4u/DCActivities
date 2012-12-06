//
//  DCKakaoActivity.m
//  DCActivities
//
// This is under The MIT License
//
// Copyright © 2012 Ha-Nyung Chung <minorblend@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "DCKakaoActivity.h"
#import "NSString+DCActivities.h"

static NSString *KakaoLinkAPIVersion = @"2.0";
static NSString *KakaoLinkAPIBaseURL = @"kakaolink://sendurl";

NSString *queryStringFromDictionary(NSDictionary *params) {
  NSMutableArray *components = [NSMutableArray array];

  for (NSString *key in params)
    [components
     addObject:[NSString stringWithFormat:@"%@=%@", key, [(NSString *)[params valueForKey:key] URLEscapedString]]];

  return [components componentsJoinedByString:@"&"];
}

@implementation DCKakaoActivity {
  NSString *_message;
  NSURL *_url;
}

- (NSString *)activityType {
  return @"MBKakaoActivity";
}

- (NSString *)activityTitle {
  return @"KakaoTalk";
}

- (UIImage *)activityImage {
  return [UIImage imageNamed:@"icon_kakao"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
  return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:KakaoLinkAPIBaseURL]];
}

- (void)performActivity {
  NSDictionary *params = @{@"appver": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
  @"appid": [[NSBundle mainBundle] bundleIdentifier],
  @"appname": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"],
  @"type": @"link", @"apiver": KakaoLinkAPIVersion, @"msg": _message, @"url": _url.absoluteString};

  NSString *urlToOpen = [NSString stringWithFormat:@"%@?%@", KakaoLinkAPIBaseURL, queryStringFromDictionary(params)];

  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToOpen]];
  
  [self activityDidFinish:YES];
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
  for (id item in activityItems) {
    if ([item isKindOfClass:[NSString class]] && !_message)
      _message = item;
    else if ([item isKindOfClass:[NSURL class]] && !_url)
      _url = item;
    }
}

@end

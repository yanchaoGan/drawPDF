//
//  ViewController.m
//  ocrdemo
//
//  Created by 甘延超 on 15/6/9.
//  Copyright (c) 2015年 甘延超. All rights reserved.
//

#import "ViewController.h"



#import <ifaddrs.h>
#import <arpa/inet.h>

#import  "HWCloudsdk.h"



@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property(nonatomic,strong)UIImagePickerController * picker;


@end

@implementation ViewController


// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    ///Users/goldwallet/Desktop/gbanker_ios_pro
    
    
#define PDFPageWidth     242
#define PDFPageHeight    1000
    
    // draw pdf
    NSString* pdfFileName = @"/Users/goldwallet/Desktop/order.pdf";[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"order.pdf"];
    

    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, PDFPageWidth,PDFPageHeight), nil);
    
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();

    
    
    float xuxianX    = 1;  // 虚线距离 x 距离
    
    float _linewidth = 1.0;  // 画线线宽度
    
    
    
    int addX_X     = 20;
    
    __block  int addHeight = 20;
    __block  NSString * title;
    
    __block CGSize size;
    
    //开始绘制PDF
    CGContextBeginPath(pdfContext);
    
    
    // 绘制顶行logo图片
    UIImage* myUIImage = [UIImage imageNamed:@"01"];
   
    [myUIImage  drawInRect:(CGRect){PDFPageWidth/2 - (myUIImage.size.width/[UIScreen mainScreen].scale)/2  ,addHeight,myUIImage.size.width/[UIScreen mainScreen].scale,myUIImage.size.height/[UIScreen mainScreen].scale}];
    

    
    CGContextSetLineWidth(pdfContext, _linewidth);
    
    CGContextSetTextDrawingMode(pdfContext, kCGTextFill);
    CGContextSetRGBFillColor(pdfContext, 0, 0, 0, 1);
    
    
    addHeight += myUIImage.size.height;
    
    
    
    // 画两边虚线
    CGContextSetStrokeColorWithColor(pdfContext, [UIColor lightGrayColor].CGColor);
    CGFloat lengths[] = {10,10};
    
    CGContextSetLineDash(pdfContext, 0, lengths,2);
    
    CGContextMoveToPoint(pdfContext, xuxianX , 0);
    CGContextAddLineToPoint(pdfContext, xuxianX,PDFPageHeight);
    
    CGContextMoveToPoint(pdfContext, PDFPageWidth-xuxianX , 0);
    CGContextAddLineToPoint(pdfContext, PDFPageWidth-xuxianX,PDFPageHeight);
    
    CGContextStrokePath(pdfContext); //  填充虚线
    
    CGContextSetLineDash(pdfContext, 0, lengths,0); //取消画虚线
    //
    
    
    
    CGContextSetStrokeColorWithColor(pdfContext, [UIColor blackColor].CGColor);

    
    // 画标题
    title  = @"用户黄金存管单";//NSFontAttributeName
    size  = [title  sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22]}];
    
    [title drawInRect:(CGRect){PDFPageWidth/2 - size.width/2,addHeight,size.width,size.height} withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22]}];  // 在这里设置属性 回头自己调
    
    addHeight += (size.height + 11);
    CGContextMoveToPoint(pdfContext, xuxianX+_linewidth, addHeight);
    CGContextAddLineToPoint(pdfContext, PDFPageWidth-xuxianX-_linewidth, addHeight);
    CGContextStrokePath(pdfContext);
    
  
    
    // 开启画 日期 账户 门店 存入类型 模式
    
    NSDictionary * arrdic = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    
    //
   __block NSString * tmpStr = nil;
   __block CGSize temSize = CGSizeZero;
    
    void (^ tableCellDraw)(NSArray * titls) = ^(NSArray * tils){
    
    
        for (int i = 0; i < tils.count; i ++
             ) {
            title = tils[i];
            if (i == 0) {
                addHeight += 10;
            }else if( i %2 == 0){
                
                addHeight += 5;
            }
            
            size = [title sizeWithAttributes:arrdic];
            
            if (i %2 == 0) {
                
                [title  drawInRect:(CGRect){xuxianX+_linewidth,addHeight,size.width,size.height} withAttributes:arrdic];
                
            }else{
            
                
                tmpStr = tils[i -1];
                temSize = [tmpStr sizeWithAttributes:arrdic];
                
                [ title drawInRect:(CGRect){xuxianX+_linewidth+temSize.width + 8,addHeight,size.width,size.height} withAttributes:arrdic];
                
            
            }
            
            
            if (i %2 != 0) {
                
                addHeight += size.height;

            }
            
            
            if (i == tils.count -1) {
                
                
                addHeight += 10;
                CGContextSetStrokeColorWithColor(pdfContext, [UIColor blackColor].CGColor);
                CGContextMoveToPoint(pdfContext, xuxianX+_linewidth, addHeight);
                CGContextAddLineToPoint(pdfContext, PDFPageWidth-xuxianX-_linewidth, addHeight);
                
                
            }
            
        }
    
    };
    
    
    tableCellDraw(@[@"日期:",@"2015-06-10",@"编号:",@"0000000025"]);
    tableCellDraw(@[@"账户号:",@"18613521314", @"用户姓名:",@"*超",@"身份证号",@"4115211990"]);
    tableCellDraw(@[@"存金门店:",@"翠微黄金（公主坟店）",@"存金时间:",@"2015-06-10 10:15:35"]);
    tableCellDraw(@[@"存入类型:",@"流动金",@"解冻日:",@"2015-08-15",@"计息日:",@"2015-06-15"]);
    //
    
    // 绘制 田字格
    addHeight += 5;
    CGFloat tempHeight = addHeight; // 暂存这个高度，画 ｜ 起点
    
    CGContextMoveToPoint(pdfContext, xuxianX + _linewidth + _linewidth, addHeight);
    CGContextAddLineToPoint(pdfContext, PDFPageWidth - xuxianX - _linewidth - _linewidth, addHeight);
    
    arrdic  = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor blackColor]};
    
    
    void (^ drawLineTitle)(NSMutableArray * stringS, CGFloat distance,BOOL isNeedLabelHeight) = ^(NSMutableArray * string, CGFloat distanc_x , BOOL isNeedLabelHeight){
        
        
        for (int i = 0 ; i < string.count; i++) {
        
            
            addHeight += 5;

            
            title = string[i];
            
            if (isNeedLabelHeight) {
                
                size = [title boundingRectWithSize:(CGSize){77,200} options:
                        
                        NSStringDrawingTruncatesLastVisibleLine |
                        NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading
                        
                                        attributes:arrdic context:nil].size;
                
            }else{
                
                size = [title  sizeWithAttributes:arrdic];
                
            }
            
            
            
            [title  drawInRect:(CGRect){(i == 0)?(xuxianX+_linewidth+10):(PDFPageWidth/3 * i) ,addHeight,size.width,size.height} withAttributes:arrdic];
            
        }
        
        addHeight += 5;
       
    };
    
    

//    drawLineTitle(@[@"黄金类型",@"检测重量(克)",@"存金重量(克)"])
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    CGContextStrokePath(pdfContext);
    UIGraphicsEndPDFContext();

    
    

    

    
}


- (IBAction)takePhoto:(id)sender {
    
    
    self.picker  = [[UIImagePickerController alloc] init];
    
    self.picker.delegate = self;
    
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    [self presentViewController:self.picker animated:YES completion:nil];
    
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    
    UIImage * orign = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (orign) {
        
        
//       [self baidu:orign];  // 一直  成功之后 一直返回 空的 数据， 识别不出来
    
        
//        [self hanwang:orign];
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    self.picker = nil;
}



-(void)hanwang:(UIImage *)image{

    
   HWCloudsdk * sdk =   [[HWCloudsdk alloc] init];
    
  NSString * result =  [sdk  idCardImage:image apiKey:@"2d50513e-31c4-4a14-a913-7ab91c4ae6e6"];
    
    NSLog(@"result is %@",result);
    
}






-(void)baidu:(UIImage *)image{

    
    
//    UIImage *  orign = [self scaleImage:image toScale:0.8];
    
    NSData *  Jorign = UIImageJPEGRepresentation(image, 0.08);
    
//      NSString * or =  @"/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDABMNDxEPDBMREBEWFRMXHTAfHRsbHTsqLSMwRj5KSUU+RENNV29eTVJpU0NEYYRiaXN3fX59S12Jkoh5kW96fXj/2wBDARUWFh0ZHTkfHzl4UERQeHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHj/wAARCAAfACEDAREAAhEBAxEB/8QAGAABAQEBAQAAAAAAAAAAAAAAAAQDBQb/xAAjEAACAgICAgEFAAAAAAAAAAABAgADBBESIRMxBSIyQXGB/8QAFAEBAAAAAAAAAAAAAAAAAAAAAP/EABQRAQAAAAAAAAAAAAAAAAAAAAD/2gAMAwEAAhEDEQA/APawEBAQEBAgy8i8ZTVV3UY6V1eU2XoWDDZB19S646Gz39w9fkKsW1r8Wm2yo1PYis1be0JG9H9QNYCAgc35Cl3yuVuJZl0cB41rZQa32dt2y6OuOiOxo61vsLcVblxaVyXD3hFFjL6La7I/sDWAgICAgICB/9k=";
//    
//        NSData * pdata = [[NSData alloc] initWithBase64EncodedString:or options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    
//    
//        UIImage * imageer = [UIImage imageWithData:pdata];
//    
//    
//        UIImageView * ve = [[UIImageView alloc] initWithImage:imageer];
//    
//        ve.frame = (CGRect){100,100,100,100};
//    
//        [self.view addSubview:ve];
    
    [self pushImageData:[Jorign base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];

}




- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
                                

    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                                
                                return scaledImage;
}
                                
                                


-(void)pushImageData:(NSString *)imagedata{
NSString *httpUrl = @"http://apis.baidu.com/apistore/idlocr/ocr";
    
    
//    NSString * ip = [self getIPAddress];
//    
//    LocateRecognize
NSString *httpArg =
        [NSString stringWithFormat:
    @"fromdevice=iPhone&clientip=10.10.10.0&detecttype=LocateRecognize&languagetype=CHN_ENG&imagetype=1&image=%@",imagedata];
    
    
//    
//    NSString *httpArg = @"fromdevice=pc&clientip=10.10.10.0&detecttype=LocateRecognize&languagetype=CHN_ENG&imagetype=1&image=/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDABMNDxEPDBMREBEWFRMXHTAfHRsbHTsqLSMwRj5KSUU+RENNV29eTVJpU0NEYYRiaXN3fX59S12Jkoh5kW96fXj/2wBDARUWFh0ZHTkfHzl4UERQeHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHj/wAARCAAfACEDAREAAhEBAxEB/8QAGAABAQEBAQAAAAAAAAAAAAAAAAQDBQb/xAAjEAACAgICAgEFAAAAAAAAAAABAgADBBESIRMxBSIyQXGB/8QAFAEBAAAAAAAAAAAAAAAAAAAAAP/EABQRAQAAAAAAAAAAAAAAAAAAAAD/2gAMAwEAAhEDEQA/APawEBAQEBAgy8i8ZTVV3UY6V1eU2XoWDDZB19S646Gz39w9fkKsW1r8Wm2yo1PYis1be0JG9H9QNYCAgc35Cl3yuVuJZl0cB41rZQa32dt2y6OuOiOxo61vsLcVblxaVyXD3hFFjL6La7I/sDWAgICAgICB/9k=";
    
[self request: httpUrl withHttpArg: httpArg];
    
    
}

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSURL *url = [NSURL URLWithString: httpUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
    [request setHTTPMethod: @"POST"];
    [request addValue: @"52c5299e76130ed65f65a7d062205bef" forHTTPHeaderField: @"apikey"];
    [request addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    
    NSData *data = [HttpArg dataUsingEncoding: NSUTF8StringEncoding];
    [request setHTTPBody: data];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                   NSLog(@"HttpResponseCode:%ld", responseCode);
                                   
                                   NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   
                                  NSArray * arr = [dic objectForKey:@"retData"];
                                   
                                   
                                   NSLog(@"HttpResponseBody %@  \n\n\n and arr is %d",responseString,arr.count);
                               }
                           }];
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    NSLog(@"CANCLE");
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

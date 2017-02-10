//
//  ViewController.m
//  AFNetWorkingUploadDownload
//
//  Created by MY on 2017/2/10.
//  Copyright © 2017年 com.gzkiwi.yinpubaoblue. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

#define Kboundary @"----WebKitFormBoundaryjv0UfA04ED44AhWx"

#define KNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self download];
    [self upload2];
}
#pragma mark - 上传
//不推荐
-(void)upload
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //2.1url
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/upload"];
    
    //2.2创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //2.3 设置请求方法
    request.HTTPMethod = @"POST";
    
    //2.4 设请求头信息
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Kboundary] forHTTPHeaderField:@"Content-Type"];
    
    //3.发送请求上传文件
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:[self getBodyData] progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount/ uploadProgress.totalUnitCount);
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSLog(@"%@",responseObject);
    }];
    
    //4.执行task
    [uploadTask resume];
}

-(void)upload2
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    NSDictionary *dictM = @{}
    //2.发送post请求上传文件
    /*
     第一个参数:请求路径
     第二个参数:字典(非文件参数)
     第三个参数:constructingBodyWithBlock 处理要上传的文件数据
     第四个参数:进度回调
     第五个参数:成功回调 responseObject:响应体信息
     第六个参数:失败回调
     */
    [manager POST:@"http://120.25.226.186:32812/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        UIImage *image = [UIImage imageNamed:@"Snip20160227_128"];
        NSData *imageData = UIImagePNGRepresentation(image);
        NSData * imageData1 = UIImageJPEGRepresentation(image, 0.3);
        //使用formData来拼接数据
        /*
         第一个参数:二进制数据 要上传的文件参数
         第二个参数:服务器规定的
         第三个参数:该文件上传到服务器以什么名称保存
         */
        //[formData appendPartWithFileData:imageData name:@"file" fileName:@"xxxx.png" mimeType:@"image/png"];
        
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/Snip20160227_128.png"] name:@"file" fileName:@"123.png" mimeType:@"image/png" error:nil];
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/Snip20160227_128.png"] name:@"file" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功---%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败---%@",error);
    }];
    
}
-(NSData *)getBodyData
{
    NSMutableData *fileData = [NSMutableData data];
    //5.1 文件参数
    /*
     --分隔符
     Content-Disposition: form-data; name="file"; filename="Snip20160225_341.png"
     Content-Type: image/png(MIMEType:大类型/小类型)
     空行
     文件参数
     */
    [fileData appendData:[[NSString stringWithFormat:@"--%@",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    
    //name:file 服务器规定的参数
    //filename:Snip20160225_341.png 文件保存到服务器上面的名称
    //Content-Type:文件的类型
    [fileData appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"Sss.png\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:[@"Content-Type: image/png" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:KNewLine];
    
    UIImage *image = [UIImage imageNamed:@"Snip20160227_128"];
    //UIImage --->NSData
    NSData *imageData = UIImagePNGRepresentation(image);
    [fileData appendData:imageData];
    [fileData appendData:KNewLine];
    
    //5.2 非文件参数
    /*
     --分隔符
     Content-Disposition: form-data; name="username"
     空行
     123456
     */
    [fileData appendData:[[NSString stringWithFormat:@"--%@",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:[@"Content-Disposition: form-data; name=\"username\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:KNewLine];
    [fileData appendData:[@"123456" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    
    //5.3 结尾标识
    /*
     --分隔符--
     */
    [fileData appendData:[[NSString stringWithFormat:@"--%@--",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return fileData;
}


#pragma mark - 下载
-(void)download
{
    //1. 创建回话管理者
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]init];
    //2. 下载文件
    
    /*
        第一个参数:请求对象
        第二个参数:progress 进度回调 downloadProgress
        第三个参数:destination目标回调 
                    NSURL:有返回值
                    targetPath:临时文件路径
                    response:响应头信息
        第四个参数:completionHandler 现在完成后的回调
                    filePath:文件路径
     */
    NSURL *url = [NSURL URLWithString:@"http://mvimg2.meitudata.com/55713dd0165c89055.jpg"];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSessionDownloadTask * downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%f", 1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString * filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:response.suggestedFilename];
        return [NSURL URLWithString:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载成功");
    }];
    
    //开始下载
    [downloadTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

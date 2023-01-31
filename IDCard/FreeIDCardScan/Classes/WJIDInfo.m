//
//  WJIDInfo.h
//  idcard
//
//  Created by 彭维剑 on 16-9-10.
//  Copyright (c) 2016年 Session. All rights reserved.
//

#import "WJIDInfo.h"

@implementation WJIDInfo
-(NSString *)toString
{
    if (_type == WJIDInfoTypeFront) {
        return [NSString stringWithFormat:@"\n身份证号:%@\n姓名:%@\n性别:%@\n民族:%@\n地址:%@\n出生日期:%@",
                _code, _name, _gender, _nation, _address, _birth];
    } else {
        return [NSString stringWithFormat:@"\n签发机关:%@\n有效期限:%@", _issue,_valid];
    }
}

-(BOOL)isOK
{
    if (self.type == WJIDInfoTypeBack) {
        if (_issue.length>0 && _valid.length >0) return true;
    } else {
        if (_code.length>0 && _name.length >0 &&
            _gender.length>0 && _nation.length>0 &&
            _address.length>0)
        {
            return true;
        }
    }
    return false;
}

- (BOOL)isEqual:(WJIDInfo *)idInfo
{
    if (idInfo == nil) return false;
    if (_type != idInfo.type) return false;
    
    if (idInfo.type == WJIDInfoTypeBack)
    {
        return [_issue isEqualToString:idInfo.issue] && [_valid isEqualToString:idInfo.valid];
    }
    
    if ([_code isEqualToString:idInfo.code] &&
        [_name isEqualToString:idInfo.name] &&
        [_gender isEqualToString:idInfo.gender] &&
        [_nation isEqualToString:idInfo.nation] &&
        [_address isEqualToString:idInfo.address])
    {
        return true;
    }
    
    return false;
}

-(void)setCurImage:(UIImage *)curImage{
    _curImage = curImage;

    NSData * data= UIImageJPEGRepresentation(curImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(curImage, 0.3);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(curImage, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(curImage, 0.9);
        }
    }
    
    _compressImage = [UIImage imageWithData:data];
}

- (void)setCode:(NSString *)code{
    _code = code;
    
    if (code.length > 0) {
        _birth = [code substringWithRange:NSMakeRange(6, 8)];
    }
}

@end

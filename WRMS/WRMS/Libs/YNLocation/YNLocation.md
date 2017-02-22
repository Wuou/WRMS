#基本用法
1导入myLocation.h
2 初始化
	/**	 *  获取蓝牙盒子数据或取手机定位	 *	 *  @param lat       经度	 *  @param lonti     纬度	 *  @param locaBlock 成功block	 *  @param failBlock 失败block	 */  
		 	[myLocation getMyLocation:self.strLat	                    lontitude:self.strLong	                       height:nil	                 successBlock:^(NSString *strLat, NSString *strLon, NSString *strHeight) {	                     self.strLat = strLat;	                     self.strLong = strLon;	                 } failBlock:^{ 	                 }];
```
	第2步就是myLocation 的使用方法
```

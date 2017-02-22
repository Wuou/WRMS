#基本用法
1导入该类.h文件2 初始化
	/**	 *  naviagationbar右上角点击按钮	 *	 *  @param title      标题	 *  @param bgImg      icon	 *  @param controller controller	 *	 *  @return self	 */    _btnRightItem = [[NavigationRightBtn alloc]initWith:@"+" img:nil contro:self];    __weak typeof(self) weakSelf = self;    _btnRightItem.clickBlock = ^(){        [weakSelf AddWellAction];
        };
```
	第2步就是NavigationRightBtn 的使用方法
```

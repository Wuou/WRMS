# LYPhotoBrowser


使用方法：

	//一
	LYPhoto *photo;
	
	//二 填充数据
	photo = [LYPhoto photoWithImageView:webImageView placeHold:webImageView.image photoUrl:[NSString stringWithFormat:@"%@",rmediamodel.mconUrl]];
    [self.arrMediaPic addObject:photo];

	//数据展示 图片
	[LYPhotoBrowser showPhotos:self.arrMediaPic currentPhotoIndex: picindex countType:LYPhotoBrowserCountTypeCountLabel];
	 
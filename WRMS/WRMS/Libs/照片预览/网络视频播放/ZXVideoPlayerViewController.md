# ZXVideoPlayerViewController


使用方法：

	//直接使用
	    ZXVideoPlayerViewController *videoVC = [[ZXVideoPlayerViewController alloc]init];
        [self presentViewController:videoVC animated:YES completion:nil];
        videoVC.videoUrl =[NSString stringWithFormat:@"%@",urlstr]
		 
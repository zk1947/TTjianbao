//
//  FaceARDetectIOS.h
//  FaceAR_SDK_IOS_OpenFace_RunFull
//
//  Created by Guozhi Xu on 2019/1/11.
//  Copyright © 2019 Guozhi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <iostream>
#include <fstream>
#include <sstream>

#include <stdio.h>
// OpenCV includes
#include <opencv2/videoio/videoio.hpp>  // Video write
#include <opencv2/videoio/videoio_c.h>  // Video write
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/video/tracking_c.h>
#include <opencv2/video/tracking.hpp>
#include <opencv2/core/core_c.h>

@interface FaceARDetectIOS : NSObject

- (BOOL)reset_FaceAR;

- (BOOL)clear_FaceAR;

- (BOOL)run_DetectLiveness:(cv::Mat)captured_image
                 command__:(std::string)command
              action_mun__:(int)action_num
            notification__:(std::string &)notification
  face_detection_success__:(bool &)face_detection_success
                   frame__:(int)frame_count
        saved_image_path__:(std::string)saved_image_path
        detect_exception__:(bool &)detect_exception;

- (id)initWithSensitivityType:(int)type;

@end

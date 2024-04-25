/******************************************************************************
 *  Copyright (C) Qualcomm Technologies International, Ltd. 2016
 *
 *  This software is provided to the customer for evaluation purposes only
 *  and, as such early feedback on performance and operation is anticipated.
 *  The software source code is subject to change and not intended for
 *  production. Use of developmental release software is at the user's own
 *  risk. This software is provided "as is," and Qualcomm Technologies
 *  International cautions users to determine for themselves the suitability
 *  of using the beta release version of this software. Qualcomm Technologies
 *  International makes no warranty or representation whatsoever of
 *  merchantability or fitness of the product for any particular purpose or
 *  use. In no event shall Qualcomm Technologies International be liable for
 *  any consequential, incidental or special damages whatsoever arising out
 *  of the use of or inability to use this software, even if the user has
 *  advised Qualcomm Technologies International of the possibility of such
 *  damages.
 *
 ******************************************************************************/
//
//  GCMOTAUManager.h
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>

//! Project version number for GCMOTAUManager.
FOUNDATION_EXPORT double GCMOTAUManagerVersionNumber;

//! Project version string for GCMOTAUManager.
FOUNDATION_EXPORT const unsigned char GCMOTAUManagerVersionString[];

@class GCMOTAUManager;
@protocol GCMOTAUManagerDelegate;
NS_ASSUME_NONNULL_BEGIN

extern NSString *const GCMOTAUErrorDomain;

/**
 NSError error codes in the GCMOTAUErrorDomain.
 */
typedef enum : NSInteger {
    //! Specified controller is not in the availableControllers list.
    GCMOTAUErrorControllerNotFound,
    //! Specified file is not a valid OTA update image.
    GCMOTAUErrorImageInvalid,
    //! An error has occurred on the data streams to the controller.
    GCMOTAUErrorStreamError,
    //! The controller did not response within timeout.
    GCMOTAUErrorTransferTimeout,
    //! Unexpected data has been received from the controller.
    GCMOTAUErrorUnexpectedDataReceived,
    //! The provided Access Key was rejected by the controller. GCMOTAUManager needs to be re-initialized with the correct Access Key.
    GCMOTAUErrorWrongAccessKey,
    //! The controller failed to start the OTA update process.
    GCMOTAUErrorControllerOpenFail,
    //! The controller failed to write the OTA image data.
    GCMOTAUErrorControllerWriteFail,
    //! The CRC of the OTA update image received by the controller is invalid. This usually means image data was corrupted during the OTA data transfer between iOS and the controller.
    GCMOTAUErrorControllerCRCFail
} GCMOTAUErrorCode;

/**
 Battery levels of game controllers. The level thresholds are configured with the GCM Configurator.
 */
typedef enum : NSInteger {
    //! Battery level is low. Low battery LED animation should be seen when switching the HOLD switch from OFF to ON position.
    GCMControllerBatteryLevelLow,
    //! Battery level is in the range of 0% to 25%. 0% charging LED animation should be seen when the controller is being charged.
    GCMControllerBatteryLevel0to25,
    //! Battery level is in the range of 25% to 50%. 25% charging LED animation should be seen when the controller is being charged.
    GCMControllerBatteryLevel25to50,
    //! Battery level is in the range of 50% to 75%. 50% charging LED animation should be seen when the controller is being charged.
    GCMControllerBatteryLevel50to75,
    //! Battery level is in the range of 75% to 100%. 75% charging LED animation should be seen when the controller is being charged.
    GCMControllerBatteryLevel75to100
} GCMControllerBatteryLevel;

/**
 Charger status game controllers.
 */
typedef enum : NSInteger {
    //! No charger is attached to the controller.
    GCMControllerChargerDetached,
    //! Controller is now being charged.
    GCMControllerChargerCharging,
    //! Charger is attached to the controller and battery has been fully charged.
    GCMControllerChargerDone
} GCMControllerChargerStatus;

/**
 A GCMIDSet object encapsulates MFi Game Controller Module firmware ID information. Vendor ID and Product ID matches USB Vendor ID and USB Product ID configured with the GCM Configurator. Firmware ID is the GC firmware file system version number used to generate the GC firmware OTA update image.
 */
@interface GCMIDSet : NSObject
//! The Vendor ID of the controller or image. This is a 16-bit integer.
@property (readonly) NSInteger vendorId;
//! The Product ID of the controller or image. This is a 16-bit integer.
@property (readonly) NSInteger productId;
/** The Firmware ID of the controller of image. This is a 16-bit integer. The higher byte represents the major version number in hexadecimal, and the lower byte represents the minor version number in hexadecimal. For example, for R1.6.4 firmware release the Firmwware Number would be 0x0164.
 @note Firmware ID only represents the version number of the GC firmware. For the firmware version string of the end product, please refer to firmwareRevision property of the EAAccessory object.
 */
@property (readonly) NSInteger firmwareId;
@end

/**
 A GCMPowerStatus object encapsulates battery and charger information of a game controller.
 */
@interface GCMPowerStatus : NSObject
//! The battery voltage of the controller.
@property (readonly) NSInteger batteryVoltage;
//! The battery level of the controller.
@property (readonly) GCMControllerBatteryLevel batteryLevel;
//! The charger status of the controller.
@property (readonly) GCMControllerChargerStatus chargerStatus;
@end

/**
 The GCMOTAUManager class coordinates the attached game controllers by an iAP2 protocol string. You use this class to retrieve version information of the connected game controllers and the OTA update images. You also use this class to perform OTA update to selected game controllers.
 */
@interface GCMOTAUManager : NSObject

/**
 The object that acts as the delegate of the manager.
 */
@property (nonatomic, assign, nullable) id<GCMOTAUManagerDelegate> delegate;

/**
 The EAAccessory objects corresponding to the list of currently connected game controllers. (read-only)
 
 @note The manufacturer-supplied attributes of model name, manufacturer, model number, serial number, firmware revision and hardware revision can be accessed through EAAccessory properties, which generally are used to determine the game controller manufacturer specific firmware version as well as if the controller need to be updated.
 
 @see EAAccessory
 */
@property (nonatomic, readonly) NSArray<EAAccessory *> *availableControllers;

/**
 Initializes the MFi Game Controller Module iOS OTA update manager with protocol and controller Access Key.

 @param protocolString The External Accessory Session protocol string to use when communicating with game controllers. This protocol string must match the one configured with the GCM Configurator. All communications with game controllers are expected to use this protocol.
 @param accessKey The 16-Byte controller Access Key from MSB to LSB. This Access Key must match the one configured with the GCM Configurator. This parameter will be ignored if the length of the NSData object is not equal to 16. You may specify nil for this parameter if the controller is not configured with an Access Key.
 @return The initialized MFi Game Controller Module iOS OTA update manager object.
 @see EAAccessoryManager
 */
+ (instancetype)initWithProtocol:(NSString *)protocolString
                       accessKey:(nullable NSData *)accessKey;

/**
 Returns a Boolean value that indicates whether the specified file is a valid GC firmware OTA update image.

 @param path A file path.
 @param idSet On input, a pointer to a GCMIDSet object. If the specified file is a valid GC firmware OTA update image, this pointer is set to an actual GCMIDSet object containing the GC firmware ID information for the image. You may specify nil for this parameter if you do not want the GC firmware ID information.
 @return YES if the file at path is a valid GC firmware OTA update image; otherwise NO.
 @see GCMIDSet
 */
+ (BOOL)fileAtPathIsGCMOTAUImage:(NSString *)path
                        GCMIDSet:(GCMIDSet * _Nullable * _Nullable)idSet;

/**
 Reloads the list of connected game controllers.
 */
- (void)reloadAvailableControllers;

/**
 Returns the GC firmware ID information of the specified controller.
 
 @param controller The game controller EAAccessory object from which you want to read GC firmware ID information. You can get a list of available game controllers from the availableControllers object.
 @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information. The error code is one of the errors described in GCMOTAUErrorCode.
 @return GC firmware ID information for this controller, or nil if an error has occurred.
 @see GCMIDSet
 */
- (nullable GCMIDSet *)GCMIDSetForController:(EAAccessory *)controller
                                               error:(NSError * _Nullable *)error;

/** 
 Returns the power status of the specified controller.
 
 @note Optional powerStatusUpdatedForController:powerStatus: delegate method can be used to receive power status updates of connected game controllers.
 
 @param controller The game controller EAAccessory object from which you want to read power status. You can get a list of available game controllers from the availableControllers object.
 @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information. The error code is one of the errors described in GCMOTAUErrorCode.
 @return Game controller power status for this controller, or nil if an error has occurred.
 @see GCMPowerStatus
 */
- (nullable GCMPowerStatus *)GCMPowerStatusForController:(EAAccessory *)controller
                                                           error:(NSError * _Nullable *)error;

/**
 Starts updating the controller with a specified OTA update image.
 
 @note The developer should always use fileAtPathIsGCMOTAUImage:GCMIDSet: method to determine if a file is a valid GC firmware OTA update image before calling this method. Use the delegate method OTAUProgressUpdatedForController:progress: to receive OTA update progress, and method OTAUCompletedForController: to receive OTA update completed information. OTAUErrorForController:error: delegate method may be called during the OTA update process if an error has occurred.
 
 @param controller The game controller EAAccessory object to which you want to perform firmware update. You can get a list of available game controllers from the availableControllers object.
 @param imagePath The path to a GC firmware OTA update image.
 @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 @return YES if the update process started successfully, or NO if an error has occurred.
 */
- (BOOL)startUpdateGCMController:(EAAccessory *)controller
                       withOTAUImage:(NSString *)imagePath
                               error:(NSError * _Nullable *)error;
@end

/**
 The GCMOTAUManagerDelegate protocol defines methods for receiving notifications when a game controller is connected or disconnected. It also defines methods for receiving updates of power status and OTA update progress. Implementation of all methods are mandatory.
 */
@protocol GCMOTAUManagerDelegate <NSObject>

/**
 Tells the delegate that a game controller is connected and available for your application to use.
 
 @param controller EAAccessory object representing the game controller that was connected.
 */
- (void)controllerConnected:(EAAccessory *)controller;

/**
 Tells the delegate that a game controller is disconnected and no longer available for your application to use.
 
 @param controller EAAccessory object representing the game controller that was disconnected.
 */
- (void)controllerDisconnected:(EAAccessory *)controller;

/**
 Tells the delegate that the progress of the OTA update to a game controller.
 
 @param controller EAAccessory object representing the game controller.
 @param progress The progress of the OTA update process. This is a float number from 0 to 1.
 @see startUpdateGCMController:withOTAUImage:error:
 */
- (void)OTAUProgressUpdatedForController:(EAAccessory *)controller
                                progress:(float)progress;

/**
 Tells the delegate that the OTA update process to a game controller has completed successfully.
 
 @param controller EAAccessory object representing the game controller.
 @see startUpdateGCMController:withOTAUImage:error:
 */
- (void)OTAUCompletedForController:(EAAccessory *)controller;

/**
 Tells the delegate that an error has occurred during the OTA update process to a game controller.
 
 @param controller EAAccessory object representing the game controller.
 @param error An error object containing the error information. The error code is one of the errors described in GCMOTAUErrorCode.
 @see GCMOTAUErrorCode
 */
- (void)OTAUErrorForController:(EAAccessory *)controller
                         error:(NSError *)error;

@optional

/**
 Tells the delegate that the power status of a game controller has updated.
 
 @param controller EAAccessory object representing the game controller.
 @param powerStatus Game controller power status for this controller.
 @see GCMPowerStatus
 */
- (void)powerStatusUpdatedForController:(EAAccessory *)controller
                            powerStatus:(GCMPowerStatus *)powerStatus;

@end
NS_ASSUME_NONNULL_END

//
//  Main Program.m
// 
//
//  Created by BLE Sensor Tag.
//  
//

#include "Main Program.h"


-(void) configureSensorTag {
    // Configure sensortag, turning on Sensors and setting update period for sensors etc ...
    
    //Configure Accelerometer

    NSLog(@"Configured TI SensorTag Accelerometer Service profile");
    CBUUID *sUUID = [CBUUID UUIDWithString:@"(null)"];
    CBUUID *cUUID = [CBUUID UUIDWithString:@"(null)"];
    CBUUID *pUUID = [CBUUID UUIDWithString:@"(null)"];
    NSInteger period = 0;
    uint8_t periodData = (uint8_t)(period / 10);
    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:pUUID data:[NSData dataWithBytes:&periodData length:1]];
    uint8_t data = 0x01;
    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]
    cUUID = [CBUUID UUIDWithString:@"(null)"];
    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];

    //Configure Gyroscope

    NSLog(@"Configured TI SensorTag Gyroscope Service profile");
    CBUUID *sUUID = [CBUUID UUIDWithString:@"(null)"];
    CBUUID *cUUID = [CBUUID UUIDWithString:@"(null)"];
    uint8_t data = 0x07;
    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]
    cUUID = [CBUUID UUIDWithString:@"(null)"];
    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];

    
}
-(void) deconfigureSensorTag {
    //Deconfigure Accelerometer
    NSLog(@"Deconfigured TI SensorTag Accelerometer Service profile");
    CBUUID *sUUID = [CBUUID UUIDWithString:@"(null)"];
    CBUUID *cUUID = [CBUUID UUIDWithString:@"(null)"];
    uint8_t data = 0x00;
    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]
    cUUID = [CBUUID UUIDWithString:@"(null)"];
    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];

    //Deconfigure Gyroscope
    NSLog(@"Deconfigured TI SensorTag Gyroscope Service profile");
    CBUUID *sUUID = [CBUUID UUIDWithString:@"(null)"];
    CBUUID *cUUID = [CBUUID UUIDWithString:@"(null)"];
    uint8_t data = 0x00;
    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]
    cUUID = [CBUUID UUIDWithString:@"(null)"];
    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];

}
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    //Read Accelerometer
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"(null)"]]) {
        float x = [sensorKXTJ9 calcXValue:characteristic.value];
        float y = [sensorKXTJ9 calcYValue:characteristic.value];
        float z = [sensorKXTJ9 calcZValue:characteristic.value];
    }

    //Read Gyroscope
    //A gyro sensor must be added to the class to keep calibration values : @property (strong,nonatomic) sensorIMU3000 *gyroSensor;
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"(null)"]]) {
        float x = [self.gyroSensor calcXValue:characteristic.value];
        float y = [self.gyroSensor calcXValue:characteristic.value];
        float z = [self.gyroSensor calcXValue:characteristic.value];
    }

}



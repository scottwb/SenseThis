module SensorTag

  # KXTJ9 Accelerometer
  class Accelerometer

    UUID_SERVICE = CBUUID.UUIDWithString("F000AA10-0451-4000-B000-000000000000")
    UUID_DATA    = CBUUID.UUIDWithString("F000AA11-0451-4000-B000-000000000000")
    UUID_CONFIG  = CBUUID.UUIDWithString("F000AA12-0451-4000-B000-000000000000")
    UUID_PERIOD  = CBUUID.UUIDWithString("F000AA13-0451-4000-B000-000000000000")

    RANGE = 4.0

    def self.configure(period = 500)
      puts "SensorTag::Accelerometer.configure"

      # Set the sample period
      data = Pointer.new(:uchar, 1)
      data[0] = period / 10
      BLEUtility.writeCharacteristic(
        self.d.p,
        sCBUUID: UUID_SERVICE,
        cCBUUID: UUID_PERIOD,
        data:    NSData.dataWithBytes(data, length: 1)
      )

      # Turn it on
      data[0] = 0x01
      BLEUtility.writeCharacteristic(
        self.d.p,
        sCBUUID: UUID_SERVICE,
        cCBUUID: UUID_CONFIG,
        data:    NSData.dataWithBytes(data, length: 1)
      )

      # Enable data notifications
      BLEUtility.setNotificationForCharacteristic(
        self.d.p,
        sCBUUID: UUID_SERVICE,
        cCBUUID: UUID_DATA,
        enable:  true
      )
    end

    def self.deconfigure
      puts "SensorTag::Accelerometer.deconfigure"

      # Turn it off
      data = Pointer.new(:uchar, 1)
      data[0] = 0x00
      BLEUtility.writeCharacteristic(
        self.d.p,
        sCBUUID: UUID_SERVICE,
        cCBUUID: UUID_CONFIG,
        data:    NSData.dataWithBytes(data, length: 1)
      )

      # Disable data notifications
      BLEUtility.setNotificationForCharacteristic(
        self.d.p,
        sCBUUID: UUID_SERVICE,
        cCBUUID: UUID_DATA,
        enable:  false
      )
    end

    def self.read(characteristic)
      if characteristic.UUID.isEqual(UUID_DATA)
        {
          x: calcXValue(characteristic.value),
          y: calcYValue(characteristic.value),
          z: calcZValue(characteristic.value)
        }
      end
    end

    def self.calcXValue(data)
      scratchVal = Pointer.new(:uchar, data.length)
      data.getBytes(scratchVal, length: 3)
      return ((scratchVal[0] * 1.0) / (256 / RANGE))
    end

    def self.calcYValue(data)
      scratchVal = Pointer.new(:uchar, data.length)
      data.getBytes(scratchVal, length: 3)
      return ((scratchVal[1] * 1.0) / (256 / RANGE))
    end

    def self.calcZValue(data)
      scratchVal = Pointer.new(:uchar, data.length)
      data.getBytes(scratchVal, length: 3)
      return ((scratchVal[2] * 1.0) / (256 / RANGE))
    end

  end
end

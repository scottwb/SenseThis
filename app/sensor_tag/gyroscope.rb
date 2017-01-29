module SensorTag

  # IMU3000 Gyroscope
  class Gyroscope

    attr_accessor :lastX, :lastY, :lastZ
    attr_accessor :calX, :calY, :calZ


    ############################################################
    # Configuration
    ############################################################
    IMU3000_RANGE = 500.0


    ############################################################
    # Class Initialization
    ############################################################
    def self.configure
      puts "Configured TI SensorTag Gyroscope Service profile"
      uuid_service = CBUUID.UUIDWithString("(null)")
      uuid_config = CBUUID.UUIDWithString("(null)")

      data = 0x07
      BLEUtility.writeCharacteristic(
        self.d.p,
        sCBUUID: uuid_service,
        cCBUUID: uuid_config,
        data:    NSData.dataWithBytes(data, 1)
      )

      uuid_config = CBUUID.UUIDWithString("(null)")
      BLEUtility.setNotificationForCharacteristic(
        self.d.p,
        sCBUUID: uuid_service,
        cCBUUID: uuid_config,
        enable:  true
      )
    end

    def self.deconfigure
      puts "Deconfigured TI SensorTag Gyroscope Service profile"
      uuid_service = CBUUID.UUIDWithString("(null)")
      uuid_config = CBUUID.UUIDWithString("(null)")

      data = 0x00
      BLEUtility.writeCharacteristic(
        self.d.p,
        sCBUUID: uuid_service,
        cCBUUID: uuid_config,
        data:    NSData.dataWithBytes(data, 1)
      )

      uuid_config = CBUUID.UUIDWithString("(null)")
      BLEUtility.setNotificationForCharacteristic(
        self.d.p,
        sCBUUID: uuid_service,
        cCBUUID: uuid_config,
        enable:  false
      )
    end


    ############################################################
    # Instance Methods
    ############################################################

    def init
      s = super
      if s
        s.calX = 0.0
        s.calY = 0.0
        s.calZ = 0.0
      end
      s
    end

    def calibrate
      self.calX = self.lastX
      self.calY = self.lastY
      self.calZ = self.lastZ
    end

    def calcXValue(data)
      # Orientation of sensor on board means we need to swap X (mult by -1)

      scratchVal = data.bytes
      rawX = scratchVal[0] & 0xff | ((scratchVal[1] << 8) & 0xff00)
      self.lastX = ((rawX * 1.0) / (65536 / IMU3000_RANGE)) * -1.0

      return self.lastX - self.calX
    end

    def read(characteristic)
      if characteristic.UUID.isEqual(CBUUID.UUIDWithString("(null)"))
        {
          x: calcXValue(characteristic.value),
          y: calcYValue(characteristic.value),
          z: calcZValue(characteristic.value)
        }
      end
    end
  end
end

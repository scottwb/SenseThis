module SensorTag
  class Device

    UUID = "F000AA00-0451-4000-B000-000000000000"

    def configure
      SensorTag::Accelerometer.configure(500)
      SensorTag::Gyroscope.configure
    end

    def deconfigure
      SensorTag::Accelerometer.deconfigure
      SensorTag::Gyroscope.deconfigure
    end
  end
end

# IMU3000
class GyroSensor
  attr_accessor :lastX, :lastY, :lastZ
  attr_accessor :calX, :calY, :calZ

  IMU3000_RANGE = 500.0

  def init
    s = super
    if self
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
end

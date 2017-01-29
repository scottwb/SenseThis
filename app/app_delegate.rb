class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @main_controller = MainController.alloc.init
    @window.rootViewController = @main_controller
    @window.makeKeyAndVisible
    true
  end
end

def peripheral(
  peripheral,
  didUpdateValueForCharacteristic: characteristic,
  error: error
)

  # Read Accelerometer
  SensorTag.Accelerometer.read(characteristic)

  # Read Gyroscope
  #
  # A gyro sensor must be added to the class to keep calibration values:
  #
  #   attr_accessor :gyroscope
  #   gryoscope = SensorTag::Gyroscope.new
  #
  #gyroscope.read(characteristic)
end

class MainController < UIViewController
  attr_accessor :manager
  attr_accessor :peripherals

  def init
    super.tap do |s|
      s.manager     = CBCentralManager.alloc.initWithDelegate(self, queue: nil)
      s.peripherals = []
    end
    self
  end

  def viewDidLoad
    super
  end


  ############################################################
  # CBCentralManagerDelegate
  ############################################################
  def centralManagerDidUpdateState(state)
    puts "centralManagerDidUpdateState #{state}"

    state = nil

    case @manager.state
    when CBCentralManagerStateUnsupported
      state = "The platform/hardware does not support BLE"
    when CBCentralManagerStateUnauthorized
      state = "The app is not authorized to use BLE"
    when CBCentralmanagerStatePoweredOff
      state = "BLE is currently powered off"
    when CBCentralManagerStatePoweredOn
      state = "BLE is currently powered on"
    else
      state = "BLE is an unknown state: #{@manager.state}"
    end
    puts "Central manager state: #{state}"

    alert = UIAlertView.alloc.initWithTitle(
      "BLE Status",
      message: state,
      delegate: nil,
      cancelButtonTitle: "Dismiss",
      otherButtonTitles: nil
    )
    alert.show

    return false
  end

  def centralManager(
    manager,
    didDiscoverPeripheral: peripheral,
    advertisementData: data,
    RSSI: rssi
  )
    puts "centralManager:didDiscoverPeripheral #{peripheral} #{data} #{rssi}"

    unless peripherals.containsObject(peripheral)
      peripherals << peripheral
    end

    manager.connectPeripheral(peripheral, options: nil)
  end
end

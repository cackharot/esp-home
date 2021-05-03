# ESP Home Automation Utils

Collection of programs to experiment using ESP01S and other variants.

## Relay - HW-655

This relay has ST microcontroller which takes AT commands to turn on the RELAY.
ESP module is used to connect to wifi and get pass on the commands to ST micro.

A0 01 01 A2 for Relay ON
A0 01 00 A1 for Relay OFF

> IF your HW655 module is misbehaving when you turn on power (e.g. constant clicking), turn on/off constantly.
Then it might not have correct firmware. This is easy to fix.

Remove the ESP module from relay and connect the relay to system/laptop via any TTL to USB adapter.

You need only 3 wires GND, TX, RX.

Install the below tools:

```bash
brew install sdcc # Small device C complier
pip3 install stcgal # burn the hex firmware to the ST microcontroller via USB TTL
```

```bash
cd ./relay
sdcc -mmcs51 --iram-size 128 --xram-size 0 --code-size 4096 --nooverlay --noinduction --verbose --debug -V --std-sdcc89 --model-small "relay.c"

# TO upload
stcgal -p /dev/ttyUSB1 -b 1200 -D -t 11059 ./relay.ihx
# Enter this command and re-power the relay module to start uploading the code
```

Once the upload finishes we can test them out using a simple python program before jumping on to using the ESP

`python local_test.py`

## Arduino 

To use esp in arduino IDE you need to setup the additonal board.

Under the preferences add this `https://arduino.esp8266.com/stable/package_esp8266com_index.json`
Then go to Tools -> Boards -> Board Manager and search for esp and install them.

Setup under Mac OSX (BigSlur) does not upload to esp module giving the below error
```
pyserial or esptool directories not found next to this upload.py tool.
An error occurred while uploading the sketch
```

To fix that you need to edit the file under `~/Library/Arduino15/packages/esp8266/hardware/esp8266/2.7.4/tools/pyserial/serial/tools/list_ports_osx.py`

```python
#iokit = ctypes.cdll.LoadLibrary(ctypes.util.find_library('IOKit')) <------- Fix Comment these 2 lines and add the below lines
#cf = ctypes.cdll.LoadLibrary(ctypes.util.find_library('CoreFoundation'))
iokit = ctypes.cdll.LoadLibrary('/System/Library/Frameworks/IOKit.framework/IOKit')
cf = ctypes.cdll.LoadLibrary('/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation')
```

To program the esp module, connect it to the USB TTL adapter as show below (wiring diagram):

Choose 74880 baud rate in the Serial monitor.
Pre reset button and you will see this in the serial monitor of Arduino IDE:

```
 ets Jan  8 2013,rst cause:1, boot mode:(1,6)
```

This means your esp is in boot mode and ready to accept new code.

Edit the `esp-home.ino` and replace SSID and password with correct values.

Upload/flash the `esp-home.ino` code.

### Custom firmware

Build the custom firmware following the guidelines and enable/disable necessary modules and get the `0x00000.bin` and `0x100000.bin` files.

Use the `./flash_firmware.sh` to burn it.


### OSX monitor nodemcu serial port

``` bash
# use the below to get the dev file path
nodemcu-tool devices
# use screen to view the nodemcu logs
screen /dev/cu.usbserial-1420 115200
```

To quit screen press `Ctrl+a Ctrl+\` adn `y`

### Credentials file

`src/credentials.lua` is not checked into git for obvious reasons. Create that file will below contents

``` text
SSID=""
PASSWORD=""

MQTT_HOST=""
MQTT_PORT=1883
```

### References

- https://github.com/libretto/RelayMCU
- https://github.com/sololko/ESP-01-relay-HW-655
- https://www.tweaking4all.com/forum/arduino/macos-aruino-ide-how-to-fix-pyserial-or-esptool-directories-not-found-next-to-this-upload-py-tool-error-esp8266/

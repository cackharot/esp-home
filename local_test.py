import serial
import time
import sys

def turnOff(ser):
    ser.write("\xa0\x01\x00\xa1")

def turnOn(ser):
    ser.write("\xa0\x01\x01\xa2")

def setup(port):
    return serial.Serial(port=port, baudrate=9600)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: %s '/dev/tty.usbserial-1410'" % (sys.argv[0]))
        exit(-1)
    ser = setup(sys.argv[1])
    print("ON")
    turnOn(ser)
    time.sleep(3)
    print("OFF")
    turnOff(ser)
    print("BYE!")

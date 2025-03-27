/***************************************************************************
  Arduino BME680 Sensor Demo with HTTP POST requests
  - Reads sensor data from BME680 (temperature, humidity, pressure, gas)
  - Makes HTTP POST requests to register device and send sensor readings
 ***************************************************************************/

#include <Wire.h>
#include <SPI.h>
#include <WiFiNINA.h>
#include <ArduinoHttpClient.h>
#include <Adafruit_Sensor.h>
#include "Adafruit_BME680.h"
#include "arduino_secrets.h"

char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;

const char serverAddress[] = "172.18.12.37";
const int serverPort = 8080;

const String deviceName = "Nano IOT 33";
const String deviceLocation = "M241 Zimmer";

// #define BME_SCK 13
// #define BME_MISO 12
// #define BME_MOSI 11
// #define BME_CS 10
#define SEALEVELPRESSURE_HPA (1013.25)
#define BMP680_I2C_ADDRESS 0x76

Adafruit_BME680 bme(&Wire);

int status = WL_IDLE_STATUS;
WiFiClient wifiClient;
HttpClient httpClient = HttpClient(wifiClient, serverAddress, serverPort);
String macAddress = "";

bool deviceRequested = false;
bool deviceRegistered = false;
unsigned long lastSensorReadingTime = 0;
const unsigned long sensorReadingInterval = 10000;

void setup()
{
    Serial.begin(9600);
    while (!Serial)
        ;
    Serial.println(F("BME680 + HTTP POST Demo"));

    if (!bme.begin())
    {
        Serial.println("Could not find a valid BME680 sensor, check wiring!");
        while (1)
            ;
    }

    bme.setTemperatureOversampling(BME680_OS_8X);
    bme.setHumidityOversampling(BME680_OS_2X);
    bme.setPressureOversampling(BME680_OS_4X);
    bme.setIIRFilterSize(BME680_FILTER_SIZE_3);
    bme.setGasHeater(320, 150); // 320°C for 150 ms

    connectToWiFi();

    macAddress = getMACAddress();
}

void loop()
{
    if (WiFi.status() != WL_CONNECTED)
    {
        Serial.println("WiFi connection lost. Reconnecting...");
        connectToWiFi();
        return;
    }

    if (!deviceRequested)
    {
        requestDevice();
        deviceRequested = true;
        delay(3000);
        return;
    }

    if (!deviceRegistered)
    {
        registerDevice();
        deviceRegistered = true;
        delay(3000);
        return;
    }

    unsigned long currentTime = millis();
    if (currentTime - lastSensorReadingTime >= sensorReadingInterval)
    {
        sendSensorReading();
        lastSensorReadingTime = currentTime;
    }
}

void connectToWiFi()
{
    if (WiFi.status() == WL_NO_MODULE)
    {
        Serial.println("Communication with WiFi module failed!");
        while (true)
            ;
    }

    Serial.print("Connecting to WiFi network: ");
    Serial.println(ssid);

    status = WiFi.begin(ssid, pass);

    unsigned long startTime = millis();
    while (status != WL_CONNECTED && millis() - startTime < 10000)
    {
        Serial.print(".");
        delay(500);
        status = WiFi.status();
    }
    Serial.println();

    if (status == WL_CONNECTED)
    {
        Serial.println("Connected to WiFi");
        printWiFiStatus();
    }
    else
    {
        Serial.println("Failed to connect to WiFi. Retrying...");
    }
}

void printWiFiStatus()
{
    Serial.print("SSID: ");
    Serial.println(WiFi.SSID());

    IPAddress ip = WiFi.localIP();
    Serial.print("IP Address: ");
    Serial.println(ip);

    long rssi = WiFi.RSSI();
    Serial.print("Signal strength (RSSI): ");
    Serial.print(rssi);
    Serial.println(" dBm");

    Serial.print("MAC Address: ");
    Serial.println(macAddress);
}

String getMACAddress()
{
    byte mac[6];
    WiFi.macAddress(mac);

    String macStr = "";
    for (int i = 5; i >= 0; i--)
    {
        if (mac[i] < 16)
        {
            macStr += "0";
        }
        macStr += String(mac[i], HEX);
        if (i > 0)
        {
            macStr += ":";
        }
    }

    macStr.toUpperCase();
    Serial.print("MAC Address: ");
    Serial.println(macStr);

    return macStr;
}

void requestDevice()
{
    Serial.println("\nRequesting device...");

    String jsonData = "{\"macAddress\":\"" + macAddress + "\"}";

    httpClient.beginRequest();
    httpClient.post("/device/request");
    httpClient.sendHeader("Content-Type", "application/json");
    httpClient.sendHeader("Content-Length", jsonData.length());
    httpClient.beginBody();
    httpClient.print(jsonData);
    httpClient.endRequest();

    int statusCode = httpClient.responseStatusCode();
    String response = httpClient.responseBody();

    Serial.print("Status code: ");
    Serial.println(statusCode);
    Serial.print("Response: ");
    Serial.println(response);

    if (statusCode >= 200 && statusCode < 300)
    {
        Serial.println("Device request successful");
    }
    else
    {
        Serial.println("Device request failed");
    }
}

void registerDevice()
{
    Serial.println("\nRegistering device...");

    String jsonData = "{\"macAddress\":\"" + macAddress + "\",\"name\":\"" + deviceName + "\",\"localization\":\"" + deviceLocation + "\"}";

    httpClient.beginRequest();
    httpClient.post("/device");
    httpClient.sendHeader("Content-Type", "application/json");
    httpClient.sendHeader("Content-Length", jsonData.length());
    httpClient.beginBody();
    httpClient.print(jsonData);
    httpClient.endRequest();

    int statusCode = httpClient.responseStatusCode();
    String response = httpClient.responseBody();

    Serial.print("Status code: ");
    Serial.println(statusCode);
    Serial.print("Response: ");
    Serial.println(response);

    if (statusCode >= 200 && statusCode < 300)
    {
        Serial.println("Device registration successful");
    }
    else
    {
        Serial.println("Device registration failed");
    }
}

void sendSensorReading()
{
    Serial.println("\nReading sensor data...");

    if (!bme.performReading())
    {
        Serial.println("Failed to perform reading!");
        return;
    }

    printSensorReadings();

    int airQualityIndex = random(0, 500);  // Random AQI between 0-500
    int carbonDioxide = random(400, 2000); // Random CO2 between 400-2000 ppm

    String jsonData = "{\"DeviceMacAddress\":\"" + macAddress +
                      "\",\"temperature\":" + String(bme.temperature) +
                      ",\"humidity\":" + String(bme.humidity) +
                      ",\"airQualityIndex\":" + String(airQualityIndex) +
                      ",\"carbondioxide\":" + String(carbonDioxide) + "}";

    Serial.println("Sending sensor data...");
    Serial.println(jsonData);

    httpClient.beginRequest();
    httpClient.post("/sensorreading");
    httpClient.sendHeader("Content-Type", "application/json");
    httpClient.sendHeader("Content-Length", jsonData.length());
    httpClient.beginBody();
    httpClient.print(jsonData);
    httpClient.endRequest();

    int statusCode = httpClient.responseStatusCode();
    String response = httpClient.responseBody();

    Serial.print("Status code: ");
    Serial.println(statusCode);
    Serial.print("Response: ");
    Serial.println(response);

    if (statusCode >= 200 && statusCode < 300)
    {
        Serial.println("Sensor data sent successfully");
    }
    else
    {
        Serial.println("Failed to send sensor data");
    }
}

void printSensorReadings()
{
    Serial.print("Temperature = ");
    Serial.print(bme.temperature);
    Serial.println(" *C");

    Serial.print("Pressure = ");
    Serial.print(bme.pressure / 100.0);
    Serial.println(" hPa");

    Serial.print("Humidity = ");
    Serial.print(bme.humidity);
    Serial.println(" %");

    Serial.print("Gas = ");
    Serial.print(bme.gas_resistance / 1000.0);
    Serial.println(" KOhms");

    Serial.print("Approx. Altitude = ");
    Serial.print(bme.readAltitude(SEALEVELPRESSURE_HPA));
    Serial.println(" m");
}
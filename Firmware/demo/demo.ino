#include <SPI.h>
#include <WiFiNINA.h>
#include <ArduinoHttpClient.h>
#include "arduino_secrets.h"
#include "bsec.h"

char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;

const char serverAddress[] = "172.18.14.27";
const int serverPort = 8080;

Bsec iaqSensor;
String output;
String macAddress = "";

int status = WL_IDLE_STATUS;
WiFiClient wifiClient;
HttpClient httpClient = HttpClient(wifiClient, serverAddress, serverPort);

bool deviceRequested = false;
bool deviceRegistered = false;
bool deviceDeclined = false;
unsigned long lastSensorReadingTime = 0;
const unsigned long sensorReadingInterval = 10000;

void checkIaqSensorStatus(void);
void connectToWiFi();
void printWiFiStatus();
String getMACAddress();
void requestDevice();
bool isDeviceRegistered();
bool readSensorData();
void sendSensorReading();
void readI2CBUS();

void setup()
{
  Serial.begin(9600);
  while (!Serial)
    ;

  readI2CBUS();

  iaqSensor.begin(BME68X_I2C_ADDR_LOW, Wire);
  output = "\nBSEC library version " + String(iaqSensor.version.major) + "." +
           String(iaqSensor.version.minor) + "." +
           String(iaqSensor.version.major_bugfix) + "." +
           String(iaqSensor.version.minor_bugfix);
  Serial.println(output);
  checkIaqSensorStatus();

  bsec_virtual_sensor_t sensorList[13] = {
      BSEC_OUTPUT_IAQ,
      BSEC_OUTPUT_STATIC_IAQ,
      BSEC_OUTPUT_CO2_EQUIVALENT,
      BSEC_OUTPUT_BREATH_VOC_EQUIVALENT,
      BSEC_OUTPUT_RAW_TEMPERATURE,
      BSEC_OUTPUT_RAW_PRESSURE,
      BSEC_OUTPUT_RAW_HUMIDITY,
      BSEC_OUTPUT_RAW_GAS,
      BSEC_OUTPUT_STABILIZATION_STATUS,
      BSEC_OUTPUT_RUN_IN_STATUS,
      BSEC_OUTPUT_SENSOR_HEAT_COMPENSATED_TEMPERATURE,
      BSEC_OUTPUT_SENSOR_HEAT_COMPENSATED_HUMIDITY,
      BSEC_OUTPUT_GAS_PERCENTAGE};

  iaqSensor.updateSubscription(sensorList, 13, BSEC_SAMPLE_RATE_LP);
  checkIaqSensorStatus();

  output = "Timestamp [ms], IAQ, IAQ accuracy, Static IAQ, CO2 equivalent, breath VOC equivalent, "
           "raw temp[°C], pressure [hPa], raw relative humidity [%], gas [Ohm], Stab Status, run in status, "
           "comp temp[°C], comp humidity [%], gas percentage";
  Serial.println(output);

  connectToWiFi();
  macAddress = getMACAddress();
  Serial.println(macAddress);

  if (WiFi.status() == WL_CONNECTED)
  {
    deviceRegistered = isDeviceRegistered();
    if (!deviceRegistered)
    {
      requestDevice();
    }
  }
}

void loop()
{
  unsigned long currentTime = millis();

  if (deviceDeclined)
  {
    if (currentTime - lastSensorReadingTime >= sensorReadingInterval)
    {
      if (!readSensorData())
      {
        readI2CBUS();
      }
      lastSensorReadingTime = currentTime;
    }
    return;
  }

  if (WiFi.status() != WL_CONNECTED)
  {
    Serial.println("WiFi connection lost. Reconnecting...");
    connectToWiFi();
    return;
  }

  if (!deviceRequested || !deviceRegistered)
  {
    requestDevice();
    delay(3000);
    return;
  }

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

  return macStr.toUpperCase();
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
    deviceRequested = true;
  }
  else if (response.indexOf("device already registered") > -1)
  {
    deviceRegistered = true;
    deviceRequested = true;
    Serial.println("Device is already registered");
  }
  else if (response.indexOf("device was declined") > -1)
  {
    deviceDeclined = true;
    Serial.println("Device was declined");
  }
}

bool isDeviceRegistered()
{
  Serial.println("\nChecking if device registered...");

  httpClient.beginRequest();
  httpClient.get("/device/" + macAddress);
  httpClient.endRequest();

  int statusCode = httpClient.responseStatusCode();
  Serial.print("Status code: ");
  Serial.println(statusCode);

  return (statusCode >= 200 && statusCode < 300);
}

bool readSensorData()
{
  unsigned long time_trigger = millis();

  if (iaqSensor.run())
  {
    output = String(time_trigger);
    output += ", " + String(iaqSensor.iaq);
    output += ", " + String(iaqSensor.iaqAccuracy);
    output += ", " + String(iaqSensor.staticIaq);
    output += ", " + String(iaqSensor.co2Equivalent);
    output += ", " + String(iaqSensor.breathVocEquivalent);
    output += ", " + String(iaqSensor.rawTemperature);
    output += ", " + String(iaqSensor.pressure);
    output += ", " + String(iaqSensor.rawHumidity);
    output += ", " + String(iaqSensor.gasResistance);
    output += ", " + String(iaqSensor.stabStatus);
    output += ", " + String(iaqSensor.runInStatus);
    output += ", " + String(iaqSensor.temperature);
    output += ", " + String(iaqSensor.humidity);
    output += ", " + String(iaqSensor.gasPercentage);
    Serial.println(output);
    return true;
  }
  else
  {
    checkIaqSensorStatus();
    return false;
  }
}

void sendSensorReading()
{
  if (!readSensorData())
  {
    readI2CBUS();
    return;
  }

  String jsonData = "{\"DeviceMacAddress\":\"" + macAddress +
                    "\",\"temperature\":" + String(iaqSensor.temperature) +
                    ",\"humidity\":" + String(iaqSensor.humidity) +
                    ",\"airQualityIndex\":" + String(iaqSensor.iaq) +
                    ",\"carbondioxide\":" + String(iaqSensor.co2Equivalent) + "}";

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

  Serial.println(statusCode >= 200 && statusCode < 300 ? "Sensor data sent successfully" : "Failed to send sensor data");
}

void checkIaqSensorStatus(void)
{
  if (iaqSensor.bsecStatus != BSEC_OK)
  {
    output = iaqSensor.bsecStatus < BSEC_OK ? "BSEC error code : " + String(iaqSensor.bsecStatus) : "BSEC warning code : " + String(iaqSensor.bsecStatus);
    Serial.println(output);
  }

  if (iaqSensor.bme68xStatus != BME68X_OK)
  {
    output = iaqSensor.bme68xStatus < BME68X_OK ? "BME68X error code : " + String(iaqSensor.bme68xStatus) : "BME68X warning code : " + String(iaqSensor.bme68xStatus);
    Serial.println(output);
  }
}

void readI2CBUS()
{
  Serial.println("Scanning I2C bus...");
  Wire.begin();
  Wire.setClock(100000); // Lower speed for better reliability

  byte error, address;
  int deviceCount = 0;

  for (address = 1; address < 127; address++)
  {
    Wire.beginTransmission(address);
    error = Wire.endTransmission();

    if (error == 0)
    {
      Serial.print("I2C device found at address 0x");
      if (address < 16)
        Serial.print("0");
      Serial.println(address, HEX);
      deviceCount++;
    }
  }

  if (deviceCount == 0)
  {
    Serial.println("No I2C devices found");
  }
}
#include <SPI.h>
#include <WiFiNINA.h>
#include "arduino_secrets.h" 
#include <ArduinoHttpClient.h>

char ssid[] = SECRET_SSID;        // your network SSID (name)
char pass[] = SECRET_PASS;        // your network password (use for WPA, or use as key for WEP)

int status = WL_IDLE_STATUS;      // the WiFi radio's status

// Server details - separate host and port correctly
const char serverAddress[] = "192.168.19.251";  // Just the IP address without port
const int serverPort = 8080;                    // The actual port number

// Use regular WiFiClient for HTTP (port 80/8080)
WiFiClient wifiClient;  // Changed from WiFiSSLClient to regular WiFiClient
HttpClient client = HttpClient(wifiClient, serverAddress, serverPort);

void setup() {
  // Initialize serial and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  Serial.println("Arduino Nano 33 IoT HTTP POST Example");

  // Check for the WiFi module
  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed!");
    while (true);
  }

  // Attempt to connect to WiFi network:
  while (status != WL_CONNECTED) {
    Serial.print("Attempting to connect to Network named: ");
    Serial.println(ssid);                   

    // Connect to WPA/WPA2 network:
    status = WiFi.begin(ssid, pass);
    
    // Show connection status while waiting
    unsigned long startTime = millis();
    while (status != WL_CONNECTED && millis() - startTime < 10000) {
      Serial.print(".");
      delay(500);
      status = WiFi.status();
    }
    Serial.println();
    
    if (status != WL_CONNECTED) {
      Serial.println("Connection failed, retrying...");
    }
  }
  
  Serial.println("Connected to WiFi");
  printWiFiStatus();
  
  // Test connection to server directly
  if (wifiClient.connect(serverAddress, serverPort)) {
    Serial.println("Direct connection to server successful!");
    wifiClient.stop();
  } else {
    Serial.println("Direct connection to server failed!");
    Serial.println("Check if server is running and accessible.");
  }

  // Wait a bit before making the first request
  delay(1000);
  makePostRequest();
}

void loop() {
  // Wait between requests
  delay(10000);
  
  // Check WiFi connection
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi connection lost. Reconnecting...");
    reconnectToWiFi();
  } else {
    makePostRequest();
  }
}

void reconnectToWiFi() {
  status = WiFi.begin(ssid, pass);
  unsigned long startTime = millis();
  while (status != WL_CONNECTED && millis() - startTime < 10000) {
    Serial.print(".");
    delay(500);
    status = WiFi.status();
  }
  Serial.println();
  
  if (status == WL_CONNECTED) {
    Serial.println("Reconnected to WiFi");
    printWiFiStatus();
  } else {
    Serial.println("Failed to reconnect. Will try again later.");
  }
}

void printWiFiStatus() {
  // Print the SSID of the network:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // Print your board's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // Print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("Signal strength (RSSI): ");
  Serial.print(rssi);
  Serial.println(" dBm");
}

void makePostRequest() {
  Serial.println("\nMaking POST request...");
  
  // JSON data to send
  String jsonData = "{\"username\":\"test\",\"password\":\"test\"}";
  
  // Debug output
  Serial.print("Server: ");
  Serial.print(serverAddress);
  Serial.print(":");
  Serial.println(serverPort);
  Serial.print("Endpoint: ");
  Serial.println("/register");
  Serial.print("Data: ");
  Serial.println(jsonData);
  
  // Set timeout to be a bit longer
  client.setTimeout(10000);
  
  // Make the POST request properly
  client.beginRequest();
  client.post("/register");
  client.sendHeader("Content-Type", "application/json");
  client.sendHeader("Content-Length", jsonData.length());
  client.beginBody();
  client.print(jsonData);
  client.endRequest();  // End the request before getting response
  
  // Now get the response
  int postStatusCode = client.responseStatusCode();
  String postResponse = client.responseBody();
  
  Serial.print("Status code for POST request: ");
  Serial.println(postStatusCode);
  
  if (postStatusCode > 0) {
    Serial.println("Response for POST request: ");
    Serial.println(postResponse);
  } else {
    Serial.println("Error in POST request");
    if (postStatusCode == -1) Serial.println("CONNECTION_FAILED");
    if (postStatusCode == -2) Serial.println("CONNECTION_REFUSED");
    if (postStatusCode == -3) Serial.println("CONNECTION_TIMEOUT");
    if (postStatusCode == -4) Serial.println("INVALID_RESPONSE");
  }
}
#include <SPI.h>
#include <WiFiNINA.h>
#include "arduino_secrets.h" 
#include <ArduinoHttpClient.h>

char ssid[] = SECRET_SSID;        // your network SSID (name)
char pass[] = SECRET_PASS;    // your network password (use for WPA, or use as key for WEP)

int status = WL_IDLE_STATUS;      // the WiFi radio's status

// WiFi client and HttpClient objects
WiFiSSLClient wifiClient;
HttpClient client = HttpClient(wifiClient, "jsonplaceholder.typicode.com", 443);
int keyIndex = 0;   

void setup() {
  //Initialize serial and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  while (status == WL_AP_CONNECTED) {
    Serial.print("Attempting to connect to Network named: ");
    Serial.println(ssid);                   // print the network name (SSID);

    // Connect to WPA/WPA2 network:
    status = WiFi.beginAP(ssid, pass);
    delay(10000);
  }

  makeGetRequest();
}


void loop() {
}

void makeGetRequest() {
  Serial.println("\nMaking GET request...");
  
  // JSON data to send
  //String jsonData = "{\"title\":\"foo\",\"body\":\"bar\",\"userId\":1}";
  
  // Set content type
  client.beginRequest();
  int getreturn = client.get("/todos/1");
  Serial.print("getreturn: ");
  Serial.println(getreturn);
  client.endRequest();
  
  // Get the status code and response
  int statusCode = client.responseStatusCode();
  String response = client.responseBody();
  
  Serial.print("Status code: ");
  Serial.println(statusCode);
  
  Serial.println("Response:");
  Serial.println(response);
}
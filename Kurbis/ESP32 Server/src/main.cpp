#include <Arduino.h>

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>


// Valeur du piezo
int pinReading = 3;
int readValue = 0;
int howManyInARow = 0;
int readValueFiltered = 0;

int timeElaspedSinceAd = 0;
int timeElaspedSinceSendValue = 0;
int readValueToSend = 0;
int readValueCount = 0;
int actionCounter = 0;

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

BLEServer *pServer;
BLEService *pService;
BLECharacteristic *pCharacteristic;

class MyCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) override {
        std::string value = pCharacteristic->getValue();

        Serial.print("Received Value: ");
        Serial.println(value.c_str());



        // Optionally, process the value or update internal state here
        // This is where you'd react to the new value sent from the desktop app
    }
};

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(921600);

  pinMode(pinReading, INPUT);

  BLEDevice::init("bonjour_bb");
  pServer = BLEDevice::createServer();
  pService = pServer->createService(SERVICE_UUID);
  pCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );

  pCharacteristic->setValue("Hi");
  pService->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  // Your existing setup code
  pCharacteristic->setCallbacks(new MyCallbacks());
  BLEDevice::startAdvertising();
  Serial.println("Characteristic defined! Now you can read it in your phone!");
}

std::string readBLEValue() {
  std::string lValue = pCharacteristic->getValue();
  Serial.println("value received!");
  Serial.println(lValue.c_str());
  return lValue;
}

void loop() {

  int lFastRefreshMs = 5;
  delay(lFastRefreshMs);

  timeElaspedSinceAd += lFastRefreshMs;
  timeElaspedSinceSendValue += lFastRefreshMs;
  if (timeElaspedSinceAd > 2000)
  {
    BLEDevice::startAdvertising();
    timeElaspedSinceAd = 0;
  }

  if(timeElaspedSinceSendValue > 50) {
    String stringToSend = String("v") + (int)((float)readValueToSend / (float)readValueCount);
    pCharacteristic->setValue(stringToSend.c_str());
    Serial.println(stringToSend);
    readValueToSend = 0;
    readValueCount = 0;
    timeElaspedSinceSendValue = 0;
  }

  readValue = analogRead(pinReading);
  readValueToSend += readValue;
  readValueCount++;

  readValueFiltered = readValueFiltered * 0.9 + readValue * 0.1;
  if (readValueFiltered > 100)
  {
    howManyInARow++;
    // Serial.println(readValueFiltered);
  }
  else {
    if(howManyInARow > 1) {
      Serial.println(howManyInARow);
    }
    if(howManyInARow > 10 && howManyInARow < 100)
    {
      Serial.println("percussion!");
        String stringToSend = String("next") + actionCounter;

      actionCounter++;
      actionCounter = actionCounter % 10;
      pCharacteristic->setValue(stringToSend.c_str());
      Serial.println("hello from the loop");
      digitalWrite(LED_BUILTIN, HIGH);
      delay(100);
      digitalWrite(LED_BUILTIN, LOW);
    }
    howManyInARow = 0;
  }
}


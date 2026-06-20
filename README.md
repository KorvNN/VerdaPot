# VerdaPot

**A fuzzy logic-based smart plant watering system built with ESP32 and Flutter.**

VerdaPot is a fully local IoT solution that monitors plant conditions and automatically waters plants based on their actual needs. The irrigation logic runs directly on the ESP32, while a Flutter mobile app provides real-time monitoring and control.

No cloud services are required — the phone and ESP32 communicate over the same Wi-Fi network.

## Features

- Autonomous irrigation powered by fuzzy logic
- Real-time monitoring through a Flutter mobile app
- Fully local operation (no internet required)
- Persistent plant profiles stored in ESP32 NVS memory
- Non-blocking irrigation process
- Transparent irrigation decisions with explanations
- 15 predefined plant profiles + custom profile support

## Hardware

| Component | Description |
|------------|------------|
| ESP32 DevKit | Main controller |
| DHT22 | Temperature & humidity sensor |
| BH1750 | Light intensity sensor |
| Capacitive Soil Sensor | Soil moisture measurement |
| Relay + Water Pump | Irrigation control |
| Passive Buzzer | Alerts and status notifications |

## Architecture

### ESP32 Firmware
- Sensor data collection
- Fuzzy logic decision engine
- Irrigation control
- Local HTTP server

### Flutter App
- Live dashboard
- Plant profile management
- Device pairing
- Irrigation history
- Local notifications

## Plant Profiles

The system includes 15 ready-to-use plant profiles, such as:

- Cactus
- Snake Plant
- Monstera
- Peace Lily
- Begonia
- Ivy

Users can also create custom plant profiles with their own irrigation parameters.

## Communication

VerdaPot operates entirely within a local network:

- ESP32 hosts a local HTTP server
- Flutter app communicates directly with the device
- No cloud infrastructure or internet connection is required

## License

Developed as part of a university Microprocessor Systems course.

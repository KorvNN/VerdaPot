<p>
  <img src="verdapot-icon.svg" alt="VerdaPot" width="96" align="left">
</p>

# VerdaPot<br><sup><sup><em>"Local intelligence for healthier plants."</em></sup></sup>

VerdaPot is a fully local smart-watering system built with ESP32 and Flutter.
The device evaluates real plant conditions with fuzzy logic, controls irrigation
on-device, and reports live sensor data directly to the mobile app—without a cloud service.

## Highlights

- Autonomous irrigation driven by soil moisture and temperature stress
- Non-blocking pump control with transparent, human-readable decision reasons
- Live temperature, humidity, soil moisture, light, and pump status dashboard
- Fifteen built-in plant profiles plus editable custom profiles
- Persistent device configuration in ESP32 NVS storage
- Local history, charts, watering events, notifications, and CSV export
- Direct phone-to-device communication over the local Wi-Fi network
- Offline detection, health monitoring, and guarded manual watering

## Hardware

| Component | Purpose |
| --- | --- |
| ESP32 DevKit | Sensor processing, fuzzy decisions, and pump control |
| DHT22 | Air temperature and relative humidity |
| BH1750 | Ambient light intensity |
| Capacitive soil sensor | Soil-moisture measurement |
| Relay and water pump | Irrigation |
| Passive buzzer | Device feedback and alerts |

## Quick start

### 1. Configure and flash the ESP32

Install the ESP32 Arduino core together with the DHT, BH1750, and ArduinoJson
libraries. Set the local network, shared device token, app endpoint, pins, and
soil calibration values in `firmware/smart_pot/config.h`, then flash
`firmware/smart_pot/smart_pot.ino`.

Never commit real Wi-Fi credentials or production device tokens.

### 2. Run the Flutter app

```bash
cd app
flutter pub get
flutter run
```

Keep the phone and ESP32 on the same local network, then use the app's pairing
screen to connect the device and activate a plant profile.

## Architecture

| Layer | Responsibility |
| --- | --- |
| ESP32 firmware | Reads sensors, evaluates fuzzy rules, controls irrigation, and stores the active profile |
| Local protocol | Exchanges authenticated readings, events, profiles, and pump commands over HTTP |
| Flutter app | Provides pairing, monitoring, history, notifications, profiles, and settings |
| Local database | Stores sensor history, irrigation events, devices, and plant profiles on the phone |

```text
Sensors → ESP32 fuzzy engine → relay and pump
               ↕ local Wi-Fi
       Flutter app → local history and alerts
```

## Project structure

| Path | Contents |
| --- | --- |
| `firmware/smart_pot/` | ESP32 firmware, configuration, fuzzy rules, and buzzer feedback |
| `app/lib/` | Flutter application source |
| `app/lib/data/` | Drift database, repositories, and preset plant profiles |
| `app/lib/server/` | Local ingestion server, authentication, discovery, and health monitoring |

## Context

VerdaPot was developed as a university Microprocessor Systems course project.

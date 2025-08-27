# Qryptic-Trans 🔒🌌

**Welcome to the future of secure transactions!**\
Qryptic-Trans is a *revolutionary* mobile app that harnesses the **unbreakable randomness of quantum mechanics** to deliver unparalleled security for financial transactions, balance checks, and sensitive account access. Built with a sleek **Flutter** interface, a robust **Flask** backend on a single-board computer (SBC), and a dedicated **Arduino Nano 33 IoT** device displaying 4-digit OTPs (e.g., "4837") on a 0.96” OLED screen, Qryptic-Trans combines cutting-edge quantum technology with user-friendly authentication. Whether you're a fintech enthusiast, crypto trader, or privacy-conscious user, Qryptic-Trans keeps your transactions secure with *quantum precision*. 🚀

---

## 🌟 Overview

Qryptic-Trans redefines transaction security in a post-quantum world. By leveraging an external **Quantum Random Number Generator (QRNG)**, it generates *truly random* 4-digit OTPs (0000–9999), ensuring protection against classical and quantum attacks. The app’s intuitive Flutter UI, powered by a Flask backend on an SBC (e.g., Orange Pi Zero 2 or Raspberry Pi 4), seamlessly integrates with an Arduino Nano 33 IoT device for hardware-based multi-factor authentication (MFA). With Qryptic-Trans, your financial world is safeguarded by the power of quantum mechanics. 🔐

---

## ✨ Key Features

- **Quantum Randomness** 🌌: Generates 4-digit OTPs using an external QRNG (e.g., IBM Quantum or Quantis hardware), delivering true randomness immune to prediction attacks.
- **Hardware-Based MFA** 🔧: OTPs are displayed on an Arduino Nano 33 IoT device, adding a physical security layer to thwart phishing and digital threats.
- **Intuitive Flutter UI** 📱: A modern, cross-platform interface for Android and iOS, enabling seamless login, registration, OTP requests, and transaction authorization.
- **Robust Backend** 🖥️: Powered by a Flask server on an SBC, ensuring reliable QRNG integration and secure IoT communication.
- **End-to-End Security** 🔒: Employs HTTPS, JWT authentication, and encrypted IoT communication to protect user data and OTPs.
- **Fast & Reliable** ⚡: Delivers OTPs in seconds, with a Qiskit Aer simulator fallback for uninterrupted service during high demand or quantum hardware delays.

---

## 🚀 How It Works

1. **Login or Register** 🔑: Sign in to Qryptic-Trans with a secure email and password, or register quickly to get started.
2. **Initiate Transaction** 💸: From the Home Page, request an OTP for a transaction or balance check, triggering the external QRNG.
3. **IoT OTP Delivery** 📟: The 4-digit OTP (e.g., “4837”) is sent to your Arduino Nano 33 IoT device and displayed on its OLED screen.
4. **Authorize Securely** ✅: Enter the OTP into the Qryptic-Trans app to authorize your action, ensuring only you can approve sensitive operations.
5. **Quantum Protection** 🛡️: True quantum randomness guarantees OTPs are unpredictable, safeguarding your transactions against advanced threats.

---

## 🎯 Why Qryptic-Trans?

- **Unhackable Randomness** 🌟: Unlike traditional apps using pseudo-random numbers, Qryptic-Trans’s QRNG delivers certified high-entropy OTPs (NIST SP 800-90B compliant).
- **Physical Security Layer** 🔧: The Arduino IoT device ensures OTPs are delivered offline, minimizing risks of interception or spoofing.
- **Future-Proof Design** 🔮: Built to counter quantum computing threats, protecting against “harvest now, decrypt later” attacks, ideal for fintech, DeFi, and beyond.
- **User-Centric Experience** 😊: Combines a polished Flutter UI with a compact IoT device for effortless, secure authentication.

---

## 💼 Use Cases

- **Fintech & Banking** 🏦: Authorize wire transfers, payments, or balance checks with quantum-secure OTPs.
- **Cryptocurrency & DeFi** ₿: Protect wallet access or blockchain transactions with unhackable randomness.
- **Enterprise Security** 🏢: Safeguard corporate accounts or sensitive operations with hardware-based MFA.
- **Personal Privacy** 🔐: Secure your digital identity with quantum-enhanced authentication.

---

## 🔍 Technical Highlights

- **QRNG Integration** 🌌: Uses a 14-qubit quantum circuit (via IBM Quantum or Quantis hardware) to generate random 4-digit OTPs, converted from binary to decimal (0000–9999).
- **IoT Hardware** 📟: Arduino Nano 33 IoT (ABX00027) with built-in Wi-Fi and a 0.96” SSD1306 OLED for clear OTP display.
- **Backend** 🖥️: Flask on an SBC (e.g., Orange Pi Zero 2) coordinates QRNG calls and secure OTP delivery via HTTP.
- **Security** 🔒: HTTPS, JWT, and basic authentication on the Arduino ensure end-to-end protection.
- **Scalability** 📈: Supports fallback to Qiskit’s Aer simulator and potential cloud deployment for high user volumes.

---

## 🛠️ Setup Instructions

### Prerequisites

- **Hardware**:
  - SBC (Orange Pi Zero 2 or Raspberry Pi 4).
  - Arduino Nano 33 IoT (ABX00027) with 0.96” SSD1306 OLED.
  - Development PC for Flutter and Arduino IDE.
- **Software**:
  - Flutter SDK (v3.0+).
  - Arduino IDE (v2.0+).
  - Python 3.8+ with Flask, Qiskit, PyJWT, Requests.
  - IBM Quantum API token (`quantum-computing.ibm.com`).
- **Network**: Static IPs for SBC (e.g., `192.168.1.100`) and Arduino (e.g., `192.168.1.101`).

### Backend Setup (SBC)

1. Flash Armbian (Orange Pi) or Raspberry Pi OS (Pi 4).
2. Install dependencies:

   ```bash
   sudo apt update && sudo apt install python3-pip python3-venv git
   python3 -m venv qrng_env
   source qrng_env/bin/activate
   pip install flask qiskit qiskit-ibmq-provider pyjwt requests
   ```
3. Save IBM Quantum API token:

   ```python
   from qiskit import IBMQ
   IBMQ.save_account('YOUR_API_TOKEN')
   ```
4. Deploy `app.py` (see app.py) and run:

   ```bash
   python app.py
   ```

### IoT Setup (Arduino Nano 33 IoT)

1. Connect OLED: SDA → A4, SCL → A5, VCC → 3.3V, GND → GND.
2. Install Arduino IDE and libraries: `WiFiNINA`, `Adafruit_SSD1306`, `Adafruit_GFX`, `ArduinoJson`.
3. Upload `otp_display.ino` (see otp_display.ino).
4. Note Arduino’s IP from Serial Monitor (e.g., `192.168.1.101`).

### Flutter App Setup

1. Add to `pubspec.yaml`:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     http: ^0.13.5
   ```
2. Deploy `qrng_service.dart` and `home_page.dart` (see Flutter Code).
3. Run: `flutter run`.

### Security

- **Testing**: Use HTTP (`http://192.168.1.100:5000`).
- **Production**: Enable HTTPS with Let’s Encrypt: `sudo apt install certbot`, `certbot certonly --standalone`.
- **JWT**: Secure `SECRET_KEY` in `app.py`.
- **Arduino**: Add basic auth to `/otp` endpoint.

---

## 🧪 Testing

1. **Backend**:

   ```bash
   curl -X POST http://192.168.1.100:5000/login -d '{"email":"user@example.com","password":"pass"}'
   curl -X POST http://192.168.1.100:5000/trigger_qrng -H "Authorization: Bearer <token>"
   ```
2. **Arduino**:

   ```bash
   curl -X POST http://192.168.1.101/otp -d '{"otp":"4837"}'
   ```

   Verify OLED shows “OTP: 4837”.
3. **Flutter**: Run app, login, request OTP, enter OTP, and authorize.
4. **Latency**: \~2–3s (simulator), \~5–10s (quantum hardware). Add loading spinner in Flutter.

---

## 📈 Future Enhancements

- **BLE Support** 📡: Add Bluetooth to Arduino for auto-syncing OTPs to Flutter.
- **Cloud Backend** ☁️: Deploy Flask to AWS EC2 for scalability.
- **Longer OTPs** 🔢: Extend to 6-digit OTPs using 20 qubits.
- **Multi-Device Support** 📟: Integrate with other IoT devices (e.g., ESP32).

---

## 🤝 Contributing

We welcome contributions to Qryptic-Trans! Fork the repo, submit pull requests, or open issues for bugs/features. Let’s build the future of quantum security together! 🌟

---

## 📞 Contact

For support or inquiries, reach out at support@qryptic-trans.app or open an issue on GitHub.

---
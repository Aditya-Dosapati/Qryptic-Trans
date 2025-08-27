# OTP Integration Setup Guide

## 🔧 Setup Instructions

### 1. Install Flask (if not already installed)
```bash
pip install flask
```

### 2. Start the OTP Server
Navigate to the Qryptic-Trans folder and run:
```bash
python otp_server.py
```
Or use the provided batch file:
```bash
run_otp_server.bat
```

### 3. Test the Integration
1. Open the Flutter app
2. Go to "Check Balance" 
3. Select any bank
4. Check the Flask terminal for the generated OTP
5. Enter the OTP in the app
6. View your balance!

## 🔄 How It Works

### Step 1: Bank Selection
- User taps on a bank (SBI, HDFC, ICICI)
- App sends GET request to `http://localhost:5000/generate-otp`

### Step 2: OTP Generation
- Flask server generates 6-digit OTP
- OTP is displayed in the terminal window
- User sees OTP input dialog

### Step 3: OTP Verification
- User enters OTP from terminal
- App sends POST request to `http://localhost:5000/verify-otp`
- Server verifies the OTP

### Step 4: Balance Display
- If OTP is correct, user sees bank balance
- If incorrect, error message is shown

## 🌐 API Endpoints

### Generate OTP
```
GET http://localhost:5000/generate-otp
Response: {"status": "OTP generated"}
```

### Verify OTP
```
POST http://localhost:5000/verify-otp
Body: {"otp": "123456"}
Response: {"status": "success", "message": "Transaction approved"}
```

## 🎯 Features
- ✅ Real-time OTP generation
- ✅ Secure verification process
- ✅ Beautiful UI with loading states
- ✅ Error handling and timeouts
- ✅ Different balances for different banks
- ✅ Timestamp on balance display

## 🚀 Next Steps
- Replace Flask server with quantum OTP generation
- Add real bank API integration
- Implement encrypted communication
- Add transaction history

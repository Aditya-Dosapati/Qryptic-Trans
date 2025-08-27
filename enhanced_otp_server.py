# Enhanced OTP Server for Flutter Integration
from flask import Flask, request, jsonify
import random
import sys
from datetime import datetime

app = Flask(__name__)
stored_otp = None

@app.route('/generate-otp', methods=['GET'])
def generate_otp():
    global stored_otp
    stored_otp = str(random.randint(1000, 9999))  # Generate 4-digit OTP
    
    # Enhanced logging with bigger display
    timestamp = datetime.now().strftime("%H:%M:%S")
    print(f"\n{'='*60}")
    print(f"🔥 [{timestamp}] NEW 4-DIGIT OTP GENERATED")
    print(f"")
    print(f"    📱 YOUR OTP: {stored_otp}")
    print(f"")
    print(f"📱 Enter this 4-digit OTP in your Flutter app")
    print(f"{'='*60}")
    sys.stdout.flush()
    
    return jsonify({
        "status": "OTP generated",
        "message": f"Check terminal for 4-digit OTP",
        "hint": f"{stored_otp[:2]}**"
    }), 200

@app.route('/verify-otp', methods=['POST'])
def verify_otp():
    global stored_otp
    data = request.json
    user_otp = data.get("otp")
    
    timestamp = datetime.now().strftime("%H:%M:%S")
    print(f"\n🔍 [{timestamp}] OTP VERIFICATION ATTEMPT")
    print(f"User entered: {user_otp}")
    print(f"Expected OTP: {stored_otp}")
    
    if user_otp == stored_otp:
        print("✅ OTP VERIFICATION SUCCESSFUL!")
        print("💰 Showing bank balance to user...")
        stored_otp = None  # Clear OTP after use
        return jsonify({"status": "success", "message": "Transaction approved"}), 200
    else:
        print("❌ OTP VERIFICATION FAILED!")
        return jsonify({"status": "failed", "message": "Invalid OTP"}), 400

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "Flask server is running", "port": 5000}), 200

if __name__ == "__main__":
    print("🚀 OTP SERVER STARTING...")
    print("📡 Server URL: http://localhost:5001")
    print("📱 Ready for Flutter app connections!")
    print("="*60)
    sys.stdout.flush()
    app.run(host="0.0.0.0", port=5001, debug=False)

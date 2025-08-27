import requests
import json

def test_otp_server():
    # If testing from host machine, use localhost; from Android emulator use 10.0.2.2
    base_url = "http://localhost:5000"
    
    print("🧪 Testing Flask OTP Server...")
    
    try:
        # Test OTP generation
        print("\n1. Testing OTP Generation...")
        response = requests.get(f"{base_url}/generate-otp", timeout=5)
        if response.status_code == 200:
            print("✅ OTP generated successfully!")
            data = response.json()
            print(f"Response: {data}")
            if isinstance(data, dict) and "hint" in data:
                print(f"Hint from server (masked): {data['hint']}")
        else:
            print(f"❌ Failed to generate OTP: {response.status_code}")
            return
        
        # Test OTP verification with wrong OTP
        print("\n2. Testing OTP Verification (wrong OTP)...")
        wrong_otp = {"otp": "0000"}  # 4-digit wrong OTP for testing
        response = requests.post(
            f"{base_url}/verify-otp", 
            json=wrong_otp, 
            timeout=5
        )
        if response.status_code == 400:
            print("✅ Wrong OTP correctly rejected!")
            print(f"Response: {response.json()}")
        else:
            print(f"⚠️ Unexpected response: {response.status_code}")
        
        print("\n3. To test correct OTP:")
        print("- Check the terminal running enhanced_otp_server.py for the generated 4-digit OTP")
        print("- Use that OTP in the Flutter app or send it here with a POST to /verify-otp")
        print("\n🎯 Server is ready for Flutter integration!")

    except requests.exceptions.ConnectionError:
        print("❌ Cannot connect to Flask server!")
        print("Please start the server first in this project folder: python enhanced_otp_server.py")
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    test_otp_server()

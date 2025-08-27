@echo off
echo Starting OTP Server for Qryptic-Trans...
echo.
echo Make sure you have Python and Flask installed:
echo pip install flask
echo.
echo Server will run on http://localhost:5000
echo Keep this terminal open to see generated OTPs
echo.
cd /d "C:\Users\91833\Desktop\Projects\Qryptic-Trans"
python otp_server.py
pause

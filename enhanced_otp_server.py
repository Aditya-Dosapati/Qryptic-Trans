"""Enhanced OTP Server for Flutter Integration (Qiskit-based QRNG)

Replaces pseudo-random OTPs with quantum-generated digits using Qiskit Aer.
Requires:
    pip install qiskit qiskit-aer
"""

from flask import Flask, request, jsonify
import sys
from datetime import datetime

# --- Qiskit setup ---
try:
        from qiskit import QuantumCircuit, transpile
        from qiskit_aer import Aer
        QISKIT_AVAILABLE = True
except Exception as e:  # ImportError or backend issues
        QISKIT_AVAILABLE = False
        _QISKIT_IMPORT_ERROR = e

app = Flask(__name__)
stored_otp = None

# Build a simple 4-qubit circuit to generate uniform 4-bit bitstrings (0-15)
if QISKIT_AVAILABLE:
    NUM_QUBITS = 4
    _qc = QuantumCircuit(NUM_QUBITS, NUM_QUBITS)
    _qc.h(range(NUM_QUBITS))
    _qc.measure(range(NUM_QUBITS), range(NUM_QUBITS))
    _sim = Aer.get_backend('aer_simulator')


def _qrng_number_0_15():
    """Sample one 4-bit number (0-15) from the quantum circuit."""
    t_qc = transpile(_qc, _sim)
    job = _sim.run(t_qc, shots=1)
    result = job.result()
    counts = result.get_counts()
    bitstring = next(iter(counts.keys()))
    return int(bitstring, 2)


def _generate_quantum_otp_4digits():
    """Generate a 4-digit OTP using quantum randomness, digits 0-9 only."""
    digits = []
    while len(digits) < 4:
        n = _qrng_number_0_15()
        if n < 10:  # reject 10-15 to keep digits unbiased 0-9
            digits.append(str(n))
    return ''.join(digits)

@app.route('/generate-otp', methods=['GET'])
def generate_otp():
    global stored_otp
    if not QISKIT_AVAILABLE:
        msg = (
            "Qiskit not available. Install with: pip install qiskit qiskit-aer. "
            f"Import error: {_QISKIT_IMPORT_ERROR}"
        )
        print(f"\n[ERROR] {msg}")
        sys.stdout.flush()
        return jsonify({"status": "error", "message": msg}), 500

    try:
        stored_otp = _generate_quantum_otp_4digits()
    except Exception as e:
        msg = f"Failed to generate OTP using Qiskit: {e}"
        print(f"\n[ERROR] {msg}")
        sys.stdout.flush()
        return jsonify({"status": "error", "message": msg}), 500
    
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
        "message": "Check terminal for 4-digit OTP",
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
    backend = "qiskit-aer" if QISKIT_AVAILABLE else "unavailable"
    return jsonify({
        "status": "Flask server is running",
        "port": 5001,
        "qrng_backend": backend
    }), 200

if __name__ == "__main__":
    print("🚀 OTP SERVER STARTING...")
    print("📡 Server URL: http://localhost:5001")
    if QISKIT_AVAILABLE:
        print("🧪 Qiskit Aer backend loaded: quantum RNG enabled")
    else:
        print("⚠️ Qiskit not available: install 'qiskit' and 'qiskit-aer' to enable QRNG")
        print(f"    Import error: {_QISKIT_IMPORT_ERROR}")
    print("📱 Ready for Flutter app connections!")
    print("="*60)
    sys.stdout.flush()
    app.run(host="0.0.0.0", port=5001, debug=False)

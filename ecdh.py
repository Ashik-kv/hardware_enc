import curses
import serial
import hashlib
from cryptography.hazmat.primitives.asymmetric import ec

SERIAL_PORT = "/dev/tty.usbserial-210292B9CCB00"   # CHANGE THIS
BAUD_RATE   = 115200


# -------- ECDH + KDF --------
def generate_gift_key():
    private_key = ec.generate_private_key(ec.SECP256R1())
    peer_private = ec.generate_private_key(ec.SECP256R1())
    peer_public  = peer_private.public_key()

    shared_secret = private_key.exchange(ec.ECDH(), peer_public)

    digest = hashlib.sha256(shared_secret).digest()
    return digest[:16]


# -------- UART Send --------
def send_to_fpga(mode, key, plaintext):
    with serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1) as ser:
        ser.write(bytes([mode]))
        ser.write(key)
        ser.write(plaintext)


# -------- TUI --------
def main(stdscr):
    curses.curs_set(1)
    stdscr.clear()

    stdscr.addstr(0, 0, "=== GIFT UART Controller ===")
    stdscr.addstr(2, 0, "Mode (0=Decrypt, 1=Encrypt): ")
    stdscr.refresh()

    mode_input = stdscr.getstr(2, 32, 1).decode()
    if mode_input not in ['0', '1']:
        stdscr.addstr(4, 0, "Invalid mode. Press any key.")
        stdscr.getch()
        return

    mode = int(mode_input)

    stdscr.addstr(4, 0, "Enter 16 hex chars (8-byte plaintext): ")
    stdscr.refresh()

    plaintext_hex = stdscr.getstr(4, 44, 16).decode()

    if len(plaintext_hex) != 16:
        stdscr.addstr(6, 0, "Plaintext must be exactly 16 hex characters.")
        stdscr.getch()
        return

    try:
        plaintext = bytes.fromhex(plaintext_hex)
    except ValueError:
        stdscr.addstr(6, 0, "Invalid hex input.")
        stdscr.getch()
        return

    gift_key = generate_gift_key()

    stdscr.addstr(6, 0, f"Derived Key: {gift_key.hex()}")
    stdscr.addstr(8, 0, "Sending to FPGA...")
    stdscr.refresh()

    try:
        send_to_fpga(mode, gift_key, plaintext)
        stdscr.addstr(10, 0, "Data sent successfully.")
    except Exception as e:
        stdscr.addstr(10, 0, f"Serial error: {str(e)}")

    stdscr.addstr(12, 0, "Press any key to exit.")
    stdscr.getch()


if __name__ == "__main__":
    curses.wrapper(main)
#!/usr/bin/env python3
"""
Test script to verify Windows compatibility fixes
"""

import sys
import platform
import subprocess

def test_platform_detection():
    """Test platform detection"""
    print("="*60)
    print("Testing Platform Detection")
    print("="*60)
    
    IS_WINDOWS = platform.system() == 'Windows'
    IS_LINUX = platform.system() == 'Linux'
    IS_MAC = platform.system() == 'Darwin'
    
    print(f"Platform: {platform.system()}")
    print(f"IS_WINDOWS: {IS_WINDOWS}")
    print(f"IS_LINUX: {IS_LINUX}")
    print(f"IS_MAC: {IS_MAC}")
    print()

def test_wsl_detection():
    """Test WSL detection"""
    print("="*60)
    print("Testing WSL Detection")
    print("="*60)
    
    IS_WINDOWS = platform.system() == 'Windows'
    HAS_WSL = False
    
    if IS_WINDOWS:
        try:
            result = subprocess.run(['wsl', '--status'], 
                                  capture_output=True, 
                                  timeout=2)
            HAS_WSL = True
            print("WSL Status: AVAILABLE")
            print(f"Command output: {result.stdout.decode('utf-8', errors='ignore')[:200]}")
        except FileNotFoundError:
            print("WSL Status: NOT INSTALLED (command not found)")
        except subprocess.TimeoutExpired:
            print("WSL Status: TIMEOUT (WSL may not be configured)")
        except Exception as e:
            print(f"WSL Status: ERROR ({str(e)})")
    else:
        print("WSL Status: N/A (not on Windows)")
    
    print(f"HAS_WSL: {HAS_WSL}")
    print()

def test_encoding():
    """Test console encoding"""
    print("="*60)
    print("Testing Console Encoding")
    print("="*60)
    
    print(f"stdout encoding: {sys.stdout.encoding}")
    print(f"stderr encoding: {sys.stderr.encoding}")
    
    # Test UTF-8 reconfiguration
    if platform.system() == 'Windows':
        try:
            if sys.stdout.encoding != 'utf-8':
                sys.stdout.reconfigure(encoding='utf-8')
                print("✓ Reconfigured stdout to UTF-8")
            if sys.stderr.encoding != 'utf-8':
                sys.stderr.reconfigure(encoding='utf-8')
                print("✓ Reconfigured stderr to UTF-8")
            
            # Test Unicode characters
            print("\nTesting Unicode characters:")
            print("✓ Check mark (U+2713)")
            print("⚠️ Warning sign (U+26A0)")
            print("❌ Cross mark (U+274C)")
            print("✅ Check mark button (U+2705)")
            
        except Exception as e:
            print(f"[!] Encoding reconfiguration failed: {e}")
            print("Using ASCII fallbacks:")
            print("[+] Check mark")
            print("[!] Warning sign")
            print("[x] Cross mark")
    else:
        print("Encoding test: N/A (not on Windows)")
    
    print()

def test_ascii_fallbacks():
    """Test ASCII fallback characters"""
    print("="*60)
    print("Testing ASCII Fallback Characters")
    print("="*60)
    
    print("[+] Success/Check")
    print("[!] Warning")
    print("[x] Error")
    print("[*] Info/Tool")
    print("[i] Information")
    print("[-] Neutral")
    print()

def main():
    print("\n" + "="*60)
    print("GarudRecon Windows Compatibility Test")
    print("="*60)
    print()
    
    test_platform_detection()
    test_wsl_detection()
    test_encoding()
    test_ascii_fallbacks()
    
    print("="*60)
    print("Test Complete!")
    print("="*60)
    print("\nIf you see Unicode characters above, encoding fix works!")
    print("If you see ASCII fallbacks ([+], [!], etc.), that's also fine.")
    print("\nNext steps:")
    if platform.system() == 'Windows':
        print("1. Ensure WSL is installed: wsl --install")
        print("2. Install tools in WSL: wsl sudo ./install_basic_tools.sh")
        print("3. Run web backend: python3 web_backend.py")
    else:
        print("1. Install tools: sudo ./install_basic_tools.sh")
        print("2. Run web backend: python3 web_backend.py")

if __name__ == '__main__':
    main()

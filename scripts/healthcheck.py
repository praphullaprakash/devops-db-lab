import requests
import sys
import time
import socket
import argparse

def check_dns(host):
    try:
        ip = socket.gethostbyname(host)
        return True, ip
    except Exception as e:
        return False, str(e)

def check_http(url, retries=3, delay=2):
    for i in range(retries):
        try:
            r = requests.get(url, timeout=5)
            return r.status_code == 200, r.status_code, r.text[:200]
        except Exception as e:
            last_error = str(e)
            time.sleep(delay)
    return False, None, last_error

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--url", required=True)
    args = parser.parse_args()

    print(f"Checking URL: {args.url}")

    ok, code, output = check_http(args.url)
    if ok:
        print(f"SUCCESS: HTTP {code}")
        print(output)
        sys.exit(0)
    else:
        print(f"FAILED: {output}")
        sys.exit(2)

if __name__ == "__main__":
    main()


#!/usr/bin/env python3
"""
Native messaging host for Session Block Firefox extension.
Runs a local HTTP server on port 7373 to receive commands from Stay in Session.
"""

import sys
import json
import struct
import threading
from http.server import HTTPServer, BaseHTTPRequestHandler
import logging

PORT = 7373
logging.basicConfig(filename='/tmp/session_block.log', level=logging.DEBUG,
                    format='%(asctime)s %(message)s')


def send_message(action):
    try:
        msg = json.dumps({'action': action}).encode('utf-8')
        sys.stdout.buffer.write(struct.pack('<I', len(msg)))
        sys.stdout.buffer.write(msg)
        sys.stdout.buffer.flush()
        logging.info(f'sent action: {action}')
    except Exception as e:
        logging.error(f'send_message error: {e}')


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        action = self.path.lstrip('/')
        if action in ('start', 'stop', 'break'):
            send_message(action)
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b'ok')
        else:
            self.send_response(400)
            self.end_headers()

    def log_message(self, format, *args):
        logging.debug(format % args)


def read_firefox_stdin():
    """Keep reading Firefox's stdin to maintain the connection."""
    while True:
        raw_length = sys.stdin.buffer.read(4)
        if not raw_length or len(raw_length) < 4:
            break


if __name__ == '__main__':
    stdin_thread = threading.Thread(target=read_firefox_stdin, daemon=True)
    stdin_thread.start()

    server = HTTPServer(('127.0.0.1', PORT), Handler)
    logging.info(f'listening on port {PORT}')
    server.serve_forever()

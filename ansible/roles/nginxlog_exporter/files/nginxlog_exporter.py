#!/usr/bin/env python3
# Мини-экспортер-заглушка: отдаёт базовые метрики по статусам из access.log.
# Для курсовой лучше заменить на полноценный nginx log exporter (готовый проект), но это поможет "оживить" стек.

from http.server import BaseHTTPRequestHandler, HTTPServer
from collections import Counter
import re

ACCESS_LOG = "/var/log/nginx/access.log"

status_re = re.compile(r'\s(\d{3})\s')

def read_statuses():
    c = Counter()
    try:
        with open(ACCESS_LOG, "r", encoding="utf-8", errors="ignore") as f:
            for line in f.readlines()[-2000:]:
                m = status_re.search(line)
                if m:
                    c[m.group(1)] += 1
    except FileNotFoundError:
        pass
    return c

class H(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path != "/metrics":
            self.send_response(404)
            self.end_headers()
            return
        statuses = read_statuses()

        out = []
        out.append("# HELP http_response_count_total Count of responses by status (last ~2000 lines)")
        out.append("# TYPE http_response_count_total counter")
        for code, cnt in sorted(statuses.items()):
            out.append(f'http_response_count_total{{status="{code}"}} {cnt}')
        out.append("# HELP http_response_size_bytes Placeholder gauge")
        out.append("# TYPE http_response_size_bytes gauge")
        out.append("http_response_size_bytes 0")

        body = ("
".join(out) + "
").encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; version=0.0.4")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, format, *args):
        return

def main():
    addr = ("0.0.0.0", int(__import__("os").environ.get("PORT", "4040")))
    HTTPServer(addr, H).serve_forever()

if __name__ == "__main__":
    main()

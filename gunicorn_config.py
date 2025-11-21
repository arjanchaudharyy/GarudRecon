#!/usr/bin/env python3
"""
Gunicorn configuration for GarudRecon Web Interface
"""
import multiprocessing
import os

# Server Socket
bind = os.environ.get('GUNICORN_BIND', '127.0.0.1:5000')
backlog = 2048

# Worker Processes
workers = int(os.environ.get('GUNICORN_WORKERS', multiprocessing.cpu_count() * 2 + 1))
worker_class = 'sync'
worker_connections = 1000
max_requests = 1000
max_requests_jitter = 50
timeout = 600  # 10 minutes for long-running scans
keepalive = 5

# Logging
accesslog = os.environ.get('GUNICORN_ACCESS_LOG', 'logs/gunicorn_access.log')
errorlog = os.environ.get('GUNICORN_ERROR_LOG', 'logs/gunicorn_error.log')
loglevel = os.environ.get('GUNICORN_LOG_LEVEL', 'info')
access_log_format = '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s"'

# Process Naming
proc_name = 'garudrecon'

# Server Mechanics
daemon = False
pidfile = None
umask = 0
user = None
group = None
tmp_upload_dir = None

# SSL (if needed)
# keyfile = '/path/to/keyfile'
# certfile = '/path/to/certfile'

def on_starting(server):
    """Called just before the master process is initialized"""
    print("Starting GarudRecon Web Interface...")

def on_reload(server):
    """Called to recycle workers during a reload via SIGHUP"""
    print("Reloading GarudRecon Web Interface...")

def when_ready(server):
    """Called just after the server is started"""
    print("GarudRecon Web Interface is ready!")
    print(f"Workers: {workers}")
    print(f"Listening on: {bind}")

def on_exit(server):
    """Called just before exiting"""
    print("GarudRecon Web Interface is shutting down...")

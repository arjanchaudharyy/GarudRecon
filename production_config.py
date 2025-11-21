#!/usr/bin/env python3
"""
Production configuration for GarudRecon Web Interface
"""
import os

class Config:
    """Production configuration"""
    
    # Security
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'CHANGE-THIS-TO-A-RANDOM-SECRET-KEY'
    
    # Flask
    DEBUG = False
    TESTING = False
    ENV = 'production'
    
    # CORS - Update with your domain
    CORS_ORIGINS = os.environ.get('CORS_ORIGINS', '*').split(',')
    
    # Application
    HOST = os.environ.get('HOST', '127.0.0.1')
    PORT = int(os.environ.get('PORT', 5000))
    
    # Scan Configuration
    MAX_CONCURRENT_SCANS = int(os.environ.get('MAX_CONCURRENT_SCANS', 5))
    SCAN_TIMEOUT = int(os.environ.get('SCAN_TIMEOUT', 7200))  # 2 hours
    SCANS_DIR = os.environ.get('SCANS_DIR', 'scans')
    
    # Logging
    LOG_LEVEL = os.environ.get('LOG_LEVEL', 'INFO')
    LOG_FILE = os.environ.get('LOG_FILE', 'logs/garudrecon.log')
    
    @staticmethod
    def init_app(app):
        """Initialize application with this config"""
        # Create necessary directories
        os.makedirs('scans', exist_ok=True)
        os.makedirs('logs', exist_ok=True)


class DevelopmentConfig(Config):
    """Development configuration"""
    DEBUG = True
    ENV = 'development'
    HOST = '0.0.0.0'


class ProductionConfig(Config):
    """Production configuration"""
    DEBUG = False
    ENV = 'production'
    HOST = '127.0.0.1'


class DockerConfig(Config):
    """Docker configuration"""
    DEBUG = False
    ENV = 'production'
    HOST = '0.0.0.0'


# Configuration dictionary
config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'docker': DockerConfig,
    'default': DevelopmentConfig
}

#!/usr/bin/env python3
"""Redis Basics Module"""

import redis
from typing import Union
import uuid


class Cache:
    """Cache class - Imp for Redis"""

    def __init__(self):
        """Initializes class"""
        self._redis = redis.Redis()
        self._redis.flushdb()

    def store(self, data: Union[str, bytes, int, float]) -> str:
        """Stores data with a unique key and returns the key"""
        key = str(uuid.uuid4())
        self._redis.set(key, data)
        return key

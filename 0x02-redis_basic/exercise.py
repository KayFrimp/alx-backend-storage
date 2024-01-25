#!/usr/bin/env python3
"""Redis Basics Module"""

import redis
from typing import Any, Optional, Union, Callable
import uuid
from functools import wraps


def count_calls(method):
    """Decorater function count_calls"""
    @wraps(method)
    def wrapper(*args, **kwargs):
        self = args[0]
        key = method.__qualname__
        self._redis.incr(key)
        result = method(*args, **kwargs)
        return result
    return wrapper


class Cache:
    """Cache class - Imp for Redis"""

    def __init__(self):
        """Initializes class"""
        self._redis = redis.Redis()
        self._redis.flushdb()

    @count_calls
    def store(self, data: Union[str, bytes, int, float]) -> str:
        """Stores data with a unique key and returns the key"""
        key = str(uuid.uuid4())
        self._redis.set(key, data)
        return key

    def get(self, key: str, fn: Callable[[Any], Any] = None) -> Any:
        """Takes key argument and returns data in desired format"""
        value = self._redis.get(key)
        if value is None:
            return None
        if fn is not None:
            return fn(value)
        else:
            return value

    def get_str(self, key: str) -> Optional[str]:
        """parametrize Cache.get with correct conversion func"""
        return self.get(key, fn=lambda x: x.decode("utf-8"))

    def get_int(self, key: str) -> Optional[int]:
        """parametrize Cache.get with correct conversion func"""
        return self.get(key, fn=int)

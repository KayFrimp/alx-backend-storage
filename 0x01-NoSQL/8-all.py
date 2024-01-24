#!/usr/bin/env python3
"""list_all Module"""


def list_all(mongo_collection):
    """Lists all documents in a collection"""
    return list(mongo_collection.find())

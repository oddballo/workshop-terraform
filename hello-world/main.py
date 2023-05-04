import re
import sys
import os
import logging
import json

NAME = os.getenv('NAME')
LOG_LEVEL = os.getenv('LOG_LEVEL', 'INFO').upper()

logger = logging.getLogger()
logger.setLevel(LOG_LEVEL)

def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps('Hello '+NAME)
    }

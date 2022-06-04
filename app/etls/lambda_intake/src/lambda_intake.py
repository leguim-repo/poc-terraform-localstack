import json
import os


def lambda_handler(event, context):
    print(os.environ)
    return {
        "status_code": 200,
        "lambda_name": __name__,
        "event": json.dumps(event),
    }

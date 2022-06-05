import json
import os


def lambda_handler(event, context):
    print(f"event:\n{json.dumps(event)}")
    print(f"os.environ:\n{os.environ}")
    return {
        "status_code": 200,
        "lambda_name": __name__,
        "event": json.dumps(event),
    }

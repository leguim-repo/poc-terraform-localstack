import json


def lambda_handler(event, context):
    print(f"event: {json.dumps(event)}")
    return {"status_code": 200,
            "lambda_name": __name__,
            "event:": json.dumps(event)}

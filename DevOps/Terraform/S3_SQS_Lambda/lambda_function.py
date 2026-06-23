def lambda_handler(event, context):

    for record in event['Records']:
        print("Uploaded file:", record['s3']['object']['key'])

    return {
        'statusCode': 200
    }

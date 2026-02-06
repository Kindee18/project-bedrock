import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    # Log the received event
    logger.info(f"Received event: {json.dumps(event)}")
    
    # Extract file name from S3 event
    try:
        for record in event['Records']:
            bucket_name = record['s3']['bucket']['name']
            file_key = record['s3']['object']['key']
            logger.info(f"Image received: {file_key} from bucket: {bucket_name}")
            print(f"Image received: {file_key}")
            
        return {
            'statusCode': 200,
            'body': json.dumps('Successfully processed S3 event')
        }
    except Exception as e:
        logger.error(f"Error processing S3 event: {str(e)}")
        raise e

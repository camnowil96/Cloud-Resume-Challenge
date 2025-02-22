import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('cloudresume-test')

def lambda_handler(event, context):
    try:
        # Fetch item from DynamoDB
        response = table.get_item(Key={'id': '1'})
        
        # Get the view count and convert from Decimal to int if necessary
        views = response.get('Item', {}).get('views', Decimal(0))
        views = int(views)  # Convert Decimal to int
        
        # Increment the view count
        views += 1
        
        # Update the view count in DynamoDB
        table.put_item(Item={'id': '1', 'views': views})

        # Return the views count as JSON
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"views": views})
        }

    except Exception as e:
        print(f"Error: {str(e)}")  # Log the error
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e)})
        }

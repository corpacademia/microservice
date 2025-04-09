
import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2', region_name='us-east-1')
    ec2.terminate_instances(InstanceIds=['i-052d7195a25cf3371'])
    print("Instance i-052d7195a25cf3371 terminated.")

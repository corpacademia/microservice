
import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2', region_name='us-east-1')
    ec2.terminate_instances(InstanceIds=['i-03b390ba1312ae8f5'])
    print("Instance i-03b390ba1312ae8f5 terminated.")

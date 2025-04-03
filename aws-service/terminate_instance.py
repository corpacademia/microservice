
import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2', region_name='us-east-1')
    ec2.terminate_instances(InstanceIds=['i-09e286368094c1a8e'])
    print("Instance i-09e286368094c1a8e terminated.")

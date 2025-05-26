import boto3
import sys
from botocore.exceptions import ClientError

def delete_iam_user(username):
    iam = boto3.client('iam')

    try:
        # Detach managed policies
        for policy in iam.list_attached_user_policies(UserName=username)['AttachedPolicies']:
            iam.detach_user_policy(UserName=username, PolicyArn=policy['PolicyArn'])

        # Delete inline policies
        for policy_name in iam.list_user_policies(UserName=username)['PolicyNames']:
            iam.delete_user_policy(UserName=username, PolicyName=policy_name)

        # Remove from groups
        for group in iam.list_groups_for_user(UserName=username)['Groups']:
            iam.remove_user_from_group(GroupName=group['GroupName'], UserName=username)

        # Delete access keys
        for key in iam.list_access_keys(UserName=username)['AccessKeyMetadata']:
            iam.delete_access_key(UserName=username, AccessKeyId=key['AccessKeyId'])

        # Delete login profile
        try:
            iam.delete_login_profile(UserName=username)
        except ClientError as e:
            if e.response['Error']['Code'] != 'NoSuchEntity':
                raise

        # Delete MFA devices (optional)
        for mfa in iam.list_mfa_devices(UserName=username)['MFADevices']:
            iam.deactivate_mfa_device(UserName=username, SerialNumber=mfa['SerialNumber'])
            iam.delete_virtual_mfa_device(SerialNumber=mfa['SerialNumber'])

        # Finally, delete the user
        iam.delete_user(UserName=username)
        print(f"User '{username}' deleted successfully.")

    except ClientError as error:
        print(f"Error deleting user '{username}': {error}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python delete_iam_user.py <username>")
        sys.exit(1)

    delete_iam_user(sys.argv[1])
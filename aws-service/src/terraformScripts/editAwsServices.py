import boto3
import json
import sys

def get_existing_policy(iam_client, username, policy_name):
    try:
        response = iam_client.get_user_policy(
            UserName=username,
            PolicyName=policy_name
        )
        policy_doc = response['PolicyDocument']
        return policy_doc
    except Exception as e:
        print(f"Error fetching existing policy: {e}")
        sys.exit(1)

def update_policy_actions(policy_document, new_services):
    updated_actions = [f"{service}:*" for service in new_services]
    policy_document['Statement'][0]['Action'] = updated_actions
    return policy_document

def update_user_policy(iam_client, username, policy_name, updated_policy_document):
    try:
        iam_client.put_user_policy(
            UserName=username,
            PolicyName=policy_name,
            PolicyDocument=json.dumps(updated_policy_document)
        )
        print(f"Policy '{policy_name}' successfully updated for user '{username}'.")
    except Exception as e:
        print(f"Error updating policy: {e}")
        sys.exit(1)

def main():
    if len(sys.argv) != 3:
        print("Usage: python update_iam_policy.py <username> <service1,service2,...>")
        sys.exit(1)

    username = sys.argv[1]
    new_services = sys.argv[2].split(",")
    policy_name = "UserLimitedAccessPolicy"

    iam_client = boto3.client('iam')

    print(f"Fetching existing policy for user '{username}'...")
    existing_policy = get_existing_policy(iam_client, username, policy_name)

    print("Updating policy actions...")
    updated_policy = update_policy_actions(existing_policy, new_services)

    print("Attaching updated policy...")
    update_user_policy(iam_client, username, policy_name, updated_policy)

    print("Policy update completed.")

if __name__ == "__main__":
    main()
import boto3
import json
import sys


def build_policy(services):
    services = [s.strip() for s in services if s.strip()]
    if not services:
        print("Error: No valid services provided.")
        sys.exit(1)

    allowed_actions = [f"{service}:*" for service in services]

    policy_document = {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AllowFullServiceAccessForUserOwnedResources",
                "Effect": "Allow",
                "Action": allowed_actions,
                "Resource": "*",
            }
        ]
    }
    return policy_document


def attach_inline_policy(iam_client, username, policy_document, policy_name="UserLimitedAccessPolicy"):
    try:
        iam_client.put_user_policy(
            UserName=username,
            PolicyName=policy_name,
            PolicyDocument=json.dumps(policy_document)
        )
        print(f"Inline policy '{policy_name}' attached to user '{username}' successfully.")
    except Exception as e:
        print(f"Error attaching inline policy: {e}")
        sys.exit(1)


def main():
    if len(sys.argv) != 3:
        print("Usage: python attach_policy_to_existing_user.py <username> <service1,service2,...>")
        sys.exit(1)

    username = sys.argv[1]
    services = sys.argv[2].split(",")

    iam_client = boto3.client("iam")

    # Check if user exists
    try:
        iam_client.get_user(UserName=username)
    except iam_client.exceptions.NoSuchEntityException:
        print(f"User '{username}' does not exist.")
        sys.exit(1)

    # Build and attach policy
    policy = build_policy(services)
    attach_inline_policy(iam_client, username, policy)


if __name__ == "__main__":
    main()
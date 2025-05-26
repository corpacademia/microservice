import boto3
import sys

def delete_inline_policy(iam_client, username, policy_name="UserLimitedAccessPolicy"):
    try:
        iam_client.delete_user_policy(
            UserName=username,
            PolicyName=policy_name
        )
        print(f"Inline policy '{policy_name}' deleted from user '{username}' successfully.")
    except iam_client.exceptions.NoSuchEntityException:
        print(f"Policy '{policy_name}' not found for user '{username}'. Nothing to delete.")
    except Exception as e:
        print(f"Error deleting inline policy: {e}")
        sys.exit(1)

def main():
    if len(sys.argv) != 2:
        print("Usage: python delete_policy.py <username>")
        sys.exit(1)

    username = sys.argv[1]
    iam_client = boto3.client('iam')
    delete_inline_policy(iam_client, username)

if __name__ == "__main__":
    main()
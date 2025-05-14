import boto3
import json
import sys
import secrets
import string
import psycopg2


def build_policy(username, services):
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


def create_iam_user(iam_client, username):
    try:
        response = iam_client.create_user(UserName=username)
        print(f"IAM user '{username}' created successfully.")
        return response
    except iam_client.exceptions.EntityAlreadyExistsException:
        print(f"User '{username}' already exists.")
        sys.exit(1)
    except Exception as e:
        print(f"Error creating user: {e}")
        sys.exit(1)


def attach_inline_policy(iam_client, username, policy_document):
    policy_name = "UserLimitedAccessPolicy"
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


def generate_random_password(length=16):
    alphabet = string.ascii_letters + string.digits + string.punctuation
    password = ''.join(secrets.choice(alphabet) for _ in range(length))
    return password


def create_login_profile(iam_client, username, password):
    try:
        iam_client.create_login_profile(
            UserName=username,
            Password=password,
            PasswordResetRequired=False
        )
        print("Login profile created successfully.")
    except Exception as e:
        print(f"Error creating login profile: {e}")
        sys.exit(1)


def get_console_login_link(iam_client):
    try:
        response = iam_client.list_account_aliases()
        aliases = response.get('AccountAliases', [])
        if aliases:
            alias = aliases[0]
            console_url = f"https://{alias}.signin.aws.amazon.com/console"
        else:
            sts_client = boto3.client('sts')
            account_id = sts_client.get_caller_identity().get('Account')
            console_url = f"https://{account_id}.signin.aws.amazon.com/console"
    except Exception as e:
        print(f"Error retrieving console login link: {e}")
        console_url = "Console login URL could not be generated."
    return console_url


def insert_into_db(username, password, console_url, role):
    try:
        conn = psycopg2.connect(
            host="localhost",
            port=5432,
            user="postgres",
            password="Corp@123",
            dbname="golab"
        )
        cur = conn.cursor()

        if role == "superadmin":
            table = "cloudslicelab"
        elif role == "orgadmin":
            table = 'cloudsliceorgassignment'
        elif role == "user":
            table = "cloudsliceuserassignment"
        else:
            print("Invalid role provided. No DB insertion.")
            return

        insert_query = f"""
            INSERT INTO {table} (username, password, console_url)
            VALUES (%s, %s, %s);
        """
        cur.execute(insert_query, (username, password, console_url))
        conn.commit()
        cur.close()
        conn.close()
        print(f"Credentials inserted into '{table}' table successfully.")
    except Exception as e:
        print(f"Database insertion error: {e}")
        sys.exit(1)


def main():
    if len(sys.argv) != 4:
        print("Usage: python iam_user.py <username> <service1,service2,...> <role>")
        sys.exit(1)

    username = sys.argv[1]
    services = sys.argv[2].split(",")
    role = sys.argv[3]

    iam_client = boto3.client('iam')

    create_iam_user(iam_client, username)

    policy_document = build_policy(username, services)
    print("Created policy document:")
    print(json.dumps(policy_document, indent=4))
    attach_inline_policy(iam_client, username, policy_document)

    password = generate_random_password()
    create_login_profile(iam_client, username, password)

    console_url = get_console_login_link(iam_client)

    # Output the IAM user's credentials
    print("\nIAM User Credentials:")
    print(f"Username: {username}")
    print(f"Password: {password}")
    print(f"Console Login URL: {console_url}")

    # Save credentials to PostgreSQL
    insert_into_db(username, password, console_url, role)


if __name__ == "__main__":
    main()
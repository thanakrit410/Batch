#!/bin/bash

# Configuration
S3_BUCKET_NAME="sap-landing-bucket"
DEST_FOLDER="PRD/VRM"
MOUNT_DIR="/mnt/s3"
AWS_ACCESS_KEY_ID="xxxxxxxx"
AWS_SECRET_ACCESS_KEY="xxxxxxxx"

# echo "Installing s3fs..."
# if ! command -v s3fs &> /dev/null; then
#     sudo zypper refresh
#     sudo zypper install -y s3fs
#     if ! command -v s3fs &> /dev/null; then
#         echo "Failed to install s3fs. Please check your system and try again."
#         exit 1
#     fi
#     echo "s3fs installed successfully."
# else
#     echo "s3fs is already installed."
# fi


CREDENTIALS_FILE=~/.passwd-s3fs
echo "Setting up AWS credentials..."
if [ ! -f "$CREDENTIALS_FILE" ]; then
    echo "$AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY" > "$CREDENTIALS_FILE"
    chmod 600 "$CREDENTIALS_FILE"
    echo "AWS credentials file created at $CREDENTIALS_FILE."
else
    echo "AWS credentials file already exists at $CREDENTIALS_FILE."
fi


if [ ! -d "$MOUNT_DIR" ]; then
    echo "Creating mount directory at $MOUNT_DIR..."
    sudo mkdir -p "$MOUNT_DIR"
    echo "Directory created."
else
    echo "Mount directory already exists at $MOUNT_DIR."
fi


echo "Mounting S3 bucket $S3_BUCKET_NAME to $MOUNT_DIR..."
if mountpoint -q "$MOUNT_DIR"; then
    echo "S3 bucket is already mounted at $MOUNT_DIR."
else
    s3fs "$S3_BUCKET_NAME" "$MOUNT_DIR" -o passwd_file="$CREDENTIALS_FILE" -o use_path_request_style -o url="https://s3.ap-southeast-1.amazonaws.com"
    if mountpoint -q "$MOUNT_DIR"; then
        echo "S3 bucket mounted successfully at $MOUNT_DIR."
    else
        echo "Failed to mount S3 bucket. Please check the configuration."
        exit 1
    fi
fi


LOCAL_SUBDIR="$MOUNT_DIR/$DEST_FOLDER"
if [ ! -d "$LOCAL_SUBDIR" ]; then
    echo "Creating subdirectory $LOCAL_SUBDIR..."
    mkdir -p "$LOCAL_SUBDIR"
    echo "Subdirectory created."
else
    echo "Subdirectory $LOCAL_SUBDIR already exists."
fi

echo "Setup complete. S3 bucket $S3_BUCKET_NAME is mounted at $MOUNT_DIR, and subdirectory $DEST_FOLDER is ready at $LOCAL_SUBDIR."

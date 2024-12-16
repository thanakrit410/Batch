#!/bin/bash

# ข้อมูล SFTP Server (SFTP Gateway)
SFTP_HOST="your-sftp-gateway-host"  
SFTP_USER="your-sftp-username"      
SFTP_PASSWORD="your-sftp-password"  
SFTP_PORT=22                        

# ไดเรกทอรีที่เก็บไฟล์ที่ต้องการอัปโหลด
LOCAL_DIR="/path/to/local/files"
S3_BUCKET_DIR="s3folder/your-directory" 

# เชื่อมต่อกับ SFTP Gateway และอัปโหลดไฟล์
echo "Connecting to SFTP Gateway..."
sftp -P $SFTP_PORT $SFTP_USER@$SFTP_HOST <<EOF
cd $S3_BUCKET_DIR  # เปลี่ยนไปยัง directory ที่ต้องการใน S3
mput $LOCAL_DIR/*  # อัปโหลดไฟล์ทั้งหมดใน LOCAL_DIR ไปยัง S3
exit  # ออกจาก SFTP session
EOF

# ตรวจสอบสถานะการอัปโหลด
if [ $? -eq 0 ]; then
    echo "Files uploaded successfully to S3!"
else
    echo "Failed to upload files to S3."
fi

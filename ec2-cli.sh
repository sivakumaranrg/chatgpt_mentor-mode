#!/bin/bash
set -e

### GET DEFAULT VPC
echo "[+] Fetching default VPC..."
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" --query "Vpcs[0].VpcId" --output text)
echo "    Default VPC: $VPC_ID"


### CREATE SECURITY GROUP
echo "[+] Creating security group siva-sg..."
SG_ID=$(aws ec2 create-security-group \
  --group-name siva-sg \
  --description "Allow all IPv4" \
  --vpc-id "$VPC_ID" \
  --query "GroupId" --output text)

aws ec2 authorize-security-group-ingress \
  --group-id "$SG_ID" \
  --ip-permissions '[{"IpProtocol":"-1","IpRanges":[{"CidrIp":"0.0.0.0/0"}]}]'

echo "    Security Group ID: $SG_ID"


### IMPORT KEYPAIR
echo "[+] Importing keypair siva-key..."

aws ec2 import-key-pair \
  --key-name siva-key \
  --public-key-material "c3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFCQVFEWk1wQkUxQisvSFozYWdINGNoOURPN01QRVNoTWRKN3lQYUVybHRIVmVaTHQ4NXpSeDVLSmRXWkVwVTlXTEFvcEZramZzUTNPbzRVK0xCTDI4WFhCbkVzV0w3aytDVkp3NmdESzBuQW1GNzFBNWxsRlhSQkZHSXdLc0M1OHJEMlplQ3BXWmNwb1NYWmhTSUJNL2lQTVJXN0VMdk5PMHRldWJyaFBvSjBQZGVONGFLVXlISkdtM2lRdGV3bXd2WG9Eb0NVR01URGtsN0lwR1JpNlBLTE1ZVkZlNm9OMVZlbm9RLzlyR05Cc3hwWHJJYkFBbTVQejQxdytwa1BBVlE4enpjWFdyaXVpeDNyNlBhV0dlWTZJbFV6d0JOeUJjZi9MVDNtY3BmaXo2SThGQXpLUVlWM0lVdFhvTjBXSG0ybStXWXNuRUZJUWFYejdzdGFVU3k5d3o="

echo "    Keypair imported."


### GET SUBNET
echo "[+] Fetching subnet..."
SUBNET_ID=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "Subnets[0].SubnetId" --output text)

echo "    Subnet: $SUBNET_ID"


### LAUNCH EC2 INSTANCE
echo "[+] Launching EC2 instance..."

INSTANCE_ID=$(aws ec2 run-instances \
  --image-id ami-0fa3fe0fa7920f68e \
  --instance-type t3.medium \
  --key-name siva-key \
  --user-data '#!/bin/bash
curl -s https://raw.githubusercontent.com/sivakumaranrg/chatgpt_mentor-mode/master/ec2.sh | bash' \
  --network-interfaces "[{\"AssociatePublicIpAddress\":true,\"DeviceIndex\":0,\"SubnetId\":\"$SUBNET_ID\",\"Groups\":[\"$SG_ID\"]}]" \
  --block-device-mappings "[{\"DeviceName\":\"/dev/xvda\",\"Ebs\":{\"VolumeSize\":30,\"VolumeType\":\"gp3\",\"Iops\":3000,\"Throughput\":125,\"DeleteOnTermination\":true}}]" \
  --credit-specification '{"CpuCredits":"unlimited"}' \
  --tag-specifications "[{\"ResourceType\":\"instance\",\"Tags\":[{\"Key\":\"Name\",\"Value\":\"minikube\"}]}]" \
  --query "Instances[0].InstanceId" \
  --output text)

echo "    EC2 Instance Created: $INSTANCE_ID"


### GET PUBLIC IP
echo "[+] Waiting for Public IP..."
sleep 5

PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

echo ""
echo "============================================"
echo "   EC2 INSTANCE LAUNCHED SUCCESSFULLY"
echo "============================================"
echo "Instance ID : $INSTANCE_ID"
echo "Public IP   : $PUBLIC_IP"
echo "SSH Key     : siva-key"
echo "SG          : $SG_ID"
echo "Subnet      : $SUBNET_ID"
echo "============================================"
echo "SSH Command:"
echo "ssh -i ~/.ssh/id_ed25519 ec2-user@$PUBLIC_IP"
echo "============================================"


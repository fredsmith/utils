#! /bin/bash

cat ~/.ssh/header.cfg > ~/.ssh/config
echo '' > ~/.aws/credentials
echo '' > ~/.aws/config
echo '' > ~/.boto

cd ~/workspace/configuration/util/vpc-tools
for FILE in ~/workspace/aws-creds/*.txt; do
  BOUNCEHOST='none'
  . $FILE
  if [[ ! -z "$AWS_VPC_STACK" ]]; then
    export STACK="stack-name $AWS_VPC_STACK"
  fi
  if [[ ! -z "$AWS_SSH_KEY" ]]; then
    export SSHKEY="identity-file $AWS_SSH_KEY"
  fi
  if [[ ! -z "$AWS_SSH_USERNAME" ]]; then
    export SSHUSER="user $AWS_SSH_USERNAME"
  fi
  if [[ -z "$SKIP_SSHCONFIG" ]]; then
    echo "#############################################" >> ~/.ssh/config
    echo "############### $AWS_VPC_STACK ###############" >> ~/.ssh/config
    echo "#############################################" >> ~/.ssh/config
    echo $AWS_VPC_STACK
    if [[ ! -z "$AWS_NETMASK" ]]; then
      echo "Host $AWS_NETMASK.*" >> ~/.ssh/config
      echo "    ProxyCommand ssh -W %h:%p $AWS_VPC_STACK-bastion" >> ~/.ssh/config
      echo "    User $AWS_SSH_USERNAME" >> ~/.ssh/config
      echo "" >> ~/.ssh/config
    fi
    python vpc-tools.py ssh-config $STACK $SSHKEY $SSHUSER strict-host-check no jump-box $BOUNCEHOST >> ~/.ssh/config
  fi
  if [[ ! -z "$DO_AWSCONFIG" ]]; then
    echo "[$AWS_DEFAULT_PROFILE]" >> ~/.aws/credentials
    echo "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
    echo "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
    echo "" >> ~/.aws/credentials
    echo "[profile $AWS_DEFAULT_PROFILE]" >> ~/.aws/config
    echo "region=$AWS_DEFAULT_REGION" >> ~/.aws/config
    echo "" >> ~/.aws/config
  fi
  if [[ ! -z "$DO_BOTOCONFIG" ]]; then
    echo "[profile $AWS_DEFAULT_PROFILE]" >> ~/.boto
    echo "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> ~/.boto
    echo "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> ~/.boto
    echo "" >> ~/.boto
  fi

  unset AWS_VPC_STACK
  unset SKIP_SSHCONFIG
  unset STACK
  unset AWS_SSH_KEY
  unset SSHKEY
  unset AWS_SSH_USERNAME
  unset SSHUSER
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_NETMASK
  unset BOUNCEHOST
  unset DO_BOTOCONFIG
  unset DO_AWSCONFIG
  unset AWS_DEFAULT_PROFILE
done

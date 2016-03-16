#! /usr/bin/env bash

cat ~/.ssh/header.cfg > ~/.ssh/config
echo '' > ~/.aws/credentials
echo '' > ~/.aws/config
echo '' > ~/.boto

for FILE in ~/workspace/aws-creds/*.txt; do
  BOUNCEHOST='none'
  . $FILE
  echo -n " - `basename $FILE` "
  if [[ ! -z "$DO_AWSCONFIG" ]]; then
    echo -n "[AWS]"
    if [[ ! -z "$AWS_ACCESS_KEY_ID" ]]; then
      echo "[$AWS_DEFAULT_PROFILE]" >> ~/.aws/credentials
      echo "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
      echo "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
      echo "" >> ~/.aws/credentials
    fi
    echo "[profile $AWS_DEFAULT_PROFILE]" >> ~/.aws/config
    echo "region=$AWS_DEFAULT_REGION" >> ~/.aws/config
    if [[ ! -z "$AWS_ROLE_ARN" ]]; then
      echo "role_arn=$AWS_ROLE_ARN" >> ~/.aws/config
      echo "source_profile=$AWS_SOURCE_PROFILE" >> ~/.aws/config
    fi
    if [[ ! -z "$AWS_MFA_SERIAL" ]]; then
      echo "mfa_serial=$AWS_MFA_SERIAL" >> ~/.aws/config
    fi
    echo "" >> ~/.aws/config
  fi
  if [[ ! -z "$DO_BOTOCONFIG" ]]; then
    echo -n "[boto]"
    echo "[profile $AWS_DEFAULT_PROFILE]" >> ~/.boto
    if [[ ! -z "$AWS_ACCESS_KEY_ID" ]]; then
      echo "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> ~/.boto
      echo "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> ~/.boto
    fi
    if [[ ! -z "$AWS_ROLE_ARN" ]]; then
      echo "role_arn=$AWS_ROLE_ARN" >> ~/.boto
      echo "source_profile=$AWS_SOURCE_PROFILE" >> ~/.boto
    fi

    echo "" >> ~/.boto
  fi
  if [[ -z "$SKIP_SSHCONFIG" ]]; then
    echo -n "[ssh]"
    echo "#############################################" >> ~/.ssh/config
    echo "############### $AWS_DEFAULT_PROFILE ###############" >> ~/.ssh/config
    echo "#############################################" >> ~/.ssh/config
    if [[ ! -z "$AWS_NETMASK" ]]; then
      echo "Host $AWS_NETMASK.*" >> ~/.ssh/config
      echo "    ProxyCommand ssh -W %h:%p $AWS_VPC_STACK-bastion" >> ~/.ssh/config
      echo "    User $AWS_SSH_USERNAME" >> ~/.ssh/config
      echo "" >> ~/.ssh/config
    fi
      if [[ ! -z "$SSH_HOST_PREFIX" ]]; then
            export PREFIX="--prefix $SSH_HOST_PREFIX"
      fi
    aws-ssh-config --tags Name --private --profile=$AWS_DEFAULT_PROFILE --user=$AWS_SSH_USERNAME $PREFIX >> ~/.ssh/config
  fi
  echo "" 

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
  unset SSH_HOST_PREFIX
  unset AWS_ROLE_ARN
  unset AWS_SOURCE_PROFILE
  unset AWS_MFA_SERIAL
done

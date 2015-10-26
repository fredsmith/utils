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
    echo "[$AWS_DEFAULT_PROFILE]" >> ~/.aws/credentials
    echo "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
    echo "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
    echo "" >> ~/.aws/credentials
    echo "[profile $AWS_DEFAULT_PROFILE]" >> ~/.aws/config
    echo "region=$AWS_DEFAULT_REGION" >> ~/.aws/config
    echo "" >> ~/.aws/config
  fi
  if [[ ! -z "$DO_BOTOCONFIG" ]]; then
    echo -n "[boto]"
    echo "[profile $AWS_DEFAULT_PROFILE]" >> ~/.boto
    echo "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> ~/.boto
    echo "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> ~/.boto
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
done

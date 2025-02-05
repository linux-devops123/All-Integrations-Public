ARG version=lts
FROM jenkins/jenkins:${version}
USER root
ARG AWS_ACCESS_keys
RUN echo $AWS_ACCESS_keys
ARG AWS_SECRET_KEYS
RUN echo $AWS_SECRET_KEYS
ARG AWS_DEFAULT_REGION
RUN echo $AWS_DEFAULT_REGION
ENV AWS_DEFAULT_REGION=ap-south-1
RUN  echo $AWS_DEFAULT_REGION
COPY . /var/lib/jenkins/files

RUN apt-get update 

RUN apt install python3 -y && \
apt install pip -y && \
apt install jq -y && \
apt install curl -y && \
apt install unzip -y && \
apt install wget -y && \
apt install awscli -y 

#install winrm
RUN pip install "pywinrm>=0.3.0"
#install boto3
RUN pip install boto3

RUN apt install -y docker.io
RUN apt install -y ansible 
RUN apt-get install software-properties-common -y

#install packer
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \ 
apt-get update && apt-get install packer

#install terrafom latest version
RUN wget https://releases.hashicorp.com/terraform/1.3.8/terraform_1.3.8_linux_amd64.zip && \
unzip terraform_1.3.8_linux_amd64.zip -d /usr/local/bin/

#install terragrunt version 0.43.1 with terraform 1.3
RUN wget "https://github.com/gruntwork-io/terragrunt/releases/download/v0.43.1/terragrunt_linux_amd64"
RUN chmod u+x terragrunt_linux_amd64
RUN mv terragrunt_linux_amd64 /usr/local/bin/terragrunt

#install ansible vault
RUN apt install vault -y



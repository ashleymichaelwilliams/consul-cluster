FROM centos:centos7
MAINTAINER Ashley Williams <ashleymichaelwilliams@gmail.com>


# Set Env Variables
ENV HASHICORP_RELEASES=https://releases.hashicorp.com
ENV CONSUL_VERSION=1.6.2
ENV VAULT_VERSION=1.2.3
ENV CONSUL_TEMPLATE_VERSION=0.22.0


# Download/Install Dependencies
RUN yum install -y sudo epel-release
RUN yum install -y unzip jq wget which


# Creat Container Process User
RUN groupadd -g 1000 consul && useradd -u 1000 -g 1000 -c 'Consul Agent' -m -d '/home/consul' -s '/bin/bash' consul
RUN gpasswd --add consul wheel
RUN echo "consul ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/consul && \
    chmod 0440 /etc/sudoers.d/consul


# Switch to Non-Root 'consul' User
USER consul




### Consul Installation

RUN sudo mkdir -p /consul/{consul-data,consul-config,consul-policies}/ && \
    sudo chown -R consul:consul /consul

RUN wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -q -nv -P /home/consul
RUN sudo unzip /home/consul/consul_${CONSUL_VERSION}_linux_amd64.zip -d /usr/local/bin/

VOLUME /consul/consul-data/
VOLUME /consul/consul-config/
VOLUME /consul/consul-policies/
VOLUME /consul/script-checks/

COPY --chown=consul consul/config-templates/ /consul/config-templates/
COPY --chown=consul consul/consul-policies/ /consul/consul-policies/
COPY --chown=consul consul/script-checks/ /consul/script-checks/

RUN sudo chown -R consul:consul /consul/




### Vault Installation

RUN sudo mkdir -p /vault/{vault-config,vault-policies} && \
    sudo chown -R consul:consul /vault

RUN wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -q -nv -P /home/consul
RUN sudo unzip /home/consul/vault_${VAULT_VERSION}_linux_amd64.zip -d /usr/local/bin/

RUN vault -autocomplete-install
RUN exec $SHELL

VOLUME /vault/vault-config/
VOLUME /vault/vault-policies/

COPY --chown=consul vault/config.json /vault/vault-config/config.json
COPY --chown=consul vault/vault-policies/ /vault/vault-policies/

RUN sudo chown -R consul:consul /vault/

ENV VAULT_ADDR=http://127.0.0.1:8200




### Consul-Template

RUN sudo mkdir -p /consul-template && \
    sudo chown -R consul:consul /consul-template

RUN wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -q -nv -P /home/consul
RUN sudo unzip /home/consul/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -d /usr/local/bin/

VOLUME /consul-template/

COPY --chown=consul consul-template/ /consul-template/

RUN sudo chown -R consul:consul /consul-template/



### Prepare Container Runtime
COPY --chown=consul docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY --chown=consul scripts/ /home/consul/scripts/

RUN sudo chmod 777 /usr/local/bin/docker-entrypoint.sh
RUN sudo ln -s /usr/local/bin/docker-entrypoint.sh
RUN sudo chown -R consul:consul /home/consul/


# Start Container
WORKDIR /home/consul

ENTRYPOINT ["docker-entrypoint.sh"]

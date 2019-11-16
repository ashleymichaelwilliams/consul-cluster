from centos:centos7

MAINTAINER Ashley Williams <ashleymichaelwilliams@gmail.com>


# Set Env Variables
ENV HASHICORP_RELEASES=https://releases.hashicorp.com
ENV CONSUL_VERSION=1.6.2
ENV VAULT_VERSION=1.2.3
ENV CONSUL_TEMPLATE_VERSION=0.22.0


# Creat Container Process User
RUN groupadd -g 1000 consul && useradd -u 1000 -g 1000 -c 'Consul Agent' -m -d '/home/consul' -s '/bin/bash' consul




### Consul Installation

RUN mkdir -p /consul/{consul-data,consul-config,consul-policies}/ && \
    chown -R consul:consul /consul

RUN yum install -y epel-release
RUN yum install -y unzip jq wget which

RUN wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -q -nv -P /home/consul
RUN unzip /home/consul/consul_${CONSUL_VERSION}_linux_amd64.zip -d /usr/local/bin/
RUN chown consul:consul /usr/local/bin/consul

VOLUME /consul/consul-data/
VOLUME /consul/consul-config/
VOLUME /consul/consul-policies/

COPY consul-config.json /consul/consul-config/config.json
COPY consul-policies/ /consul/consul-policies/




### Vault Installation

RUN mkdir -p /vault/{vault-config,vault-policies} && \
    chown -R consul:consul /vault

RUN wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -q -nv -P /home/consul
RUN unzip /home/consul/vault_${VAULT_VERSION}_linux_amd64.zip -d /usr/local/bin/
RUN chown consul:consul /usr/local/bin/vault

RUN vault -autocomplete-install
RUN exec $SHELL

VOLUME /vault/vault-config/
VOLUME /vault/vault-policies/

COPY vault-config.json /vault/vault-config/config.json
COPY vault-policies/ /vault/vault-policies/

ENV VAULT_ADDR=http://127.0.0.1:8200




### Consul-Template

RUN mkdir -p /consul-template && \
    chown -R consul:consul /consul-template

RUN wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -q -nv -P /home/consul
RUN unzip /home/consul/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -d /usr/local/bin/
RUN chown consul:consul /usr/local/bin/consul-template

VOLUME /consul-template/

COPY consul-template/ /consul-template/




### Prepare Process Runtime


COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh && ln -s /usr/local/bin/docker-entrypoint.sh

USER consul
WORKDIR /home/consul
ENTRYPOINT ["/docker-entrypoint.sh"]


# By default you'll get an insecure single-node development server that stores
# everything in RAM, exposes a web UI and HTTP endpoints, and bootstraps itself.
# Don't use this configuration for production.
#CMD ["agent", "-config-dir=/consul/consul-config/"]
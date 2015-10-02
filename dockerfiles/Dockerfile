FROM centos:6
MAINTAINER 'Timothy Dice <timothy.dice30@gmail.com>'

RUN curl -s https://packagecloud.io/install/repositories/chef/stable/script.rpm.sh | bash
RUN yum install -y openssh-server
RUN yum install -y chef-server-core opscode-manage
RUN yum install -y vixie-cron crontabs && yum clean all
RUN ln -sf /bin/true /sbin/initctl

RUN echo "root:mypass" | chpasswd

ADD ./run.sh /run.sh
RUN chmod 700 /run.sh
CMD ["/run.sh"]

EXPOSE 443
EXPOSE 22

ENTRYPOINT [ "-d", "--name=chef-server", -h "chef-server" ]

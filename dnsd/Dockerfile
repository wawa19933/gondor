FROM ubuntu

RUN apt -qqy update && apt -qqy upgrade
RUN apt -qqy install vim git supervisor curl rsync libbotan-1.10-1 libssl1.0.0 libmysqlclient20 libldap-2.4-2 libgeoip1 libsqlite3-0 libyaml-cpp0.5v5 
RUN apt -qqy autoremove && apt -qqy autoclean

RUN mkdir /etc/pdns
VOLUME [ "/etc/pdns" ]

ADD powerdns.tar.gz /opt/powerdns
RUN ln -rsf /opt/powerdns/bin/* /usr/bin/
RUN ln -rsf /opt/powerdns/sbin/* /usr/sbin/

EXPOSE 53 8080

ENTRYPOINT ["/opt/powerdns/sbin/pdns_server"]
CMD ["--daemon=no", "--config", "--config-dir=/etc/pdns"]
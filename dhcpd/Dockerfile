FROM ubuntu

RUN apt -qqy update && apt -qqy upgrade
RUN apt -qqy install vim git supervisor curl rsync libbotan-1.10-1 liblog4cplus-1.1-9 libssl1.0.0 libmariadb2  
RUN apt -qqy autoremove && apt -qqy autoclean

VOLUME [ "/etc/kea" ]

ADD kea.tar.gz /
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
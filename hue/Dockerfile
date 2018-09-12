FROM earthquakesan/hue-build-env:branch-3.11

RUN mkdir -p /opt/hue
WORKDIR /opt/hue

#RUN git clone https://github.com/cloudera/hue.git ./
#RUN git checkout branch-3.11
RUN git clone -b branch-4.2 --depth 1 --single-branch https://github.com/cloudera/hue.git ./

RUN pip install logilab-astng
RUN make apps

#ADD entrypoint.sh /entrypoint.sh
#RUN chmod a+x /entrypoint.sh

COPY common_header.mako /opt/hue/desktop/core/src/desktop/templates/common_header.mako
COPY  pseudo-distributed.custom.ini /opt/hue/desktop/conf/pseudo-distributed.custom.ini

ENV HUE_HOME "/opt/hue/"

EXPOSE 8000

#ENTRYPOINT ["/entrypoint.sh"]
CMD ["build/env/bin/hue", "runserver_plus", "0.0.0.0:8000"]
#CMD ["build/env/bin/hue", "runserver_plus", "0.0.0.0:8088"]

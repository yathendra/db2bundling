FROM ibmcom/db2:11.5.0.0a
USER root

RUN mkdir -p /var/custom
COPY custom/* /var/custom/
RUN chmod a+x /var/custom/*.sh

#COPY db2std_vpc.lic /tmp
#RUN chmod a+x /tmp/db2std_vpc.lic

#COPY db2_common_functions /var/db2_setup/include/db2_common_functions
#COPY --chown=1001:0 db2std_vpc.lic /home
#ENTRYPOINT [ "/bin/sh", "-c" ]
#CMD [ "/opt/ibm/db2/V11.5/adm/db2licm -a /home/db2std_vpc.lic" ]

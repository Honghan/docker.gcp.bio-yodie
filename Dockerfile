# start from a base ubuntu image
FROM ubuntu
MAINTAINER Honghan Wu <honghan.wu@gmail.com>

########
# Pre-reqs
########
RUN apt-get update \ 
&& apt-get -y install software-properties-common \
&& add-apt-repository ppa:openjdk-r/ppa

RUN apt-get update \
	&& apt-get install -y \
	ant \
	curl \
	openjdk-8-jdk \
	subversion \
	unzip \
	vim


ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64/


#######
# GCP
#######

# Create a user and roup with a specified U/GID.
# You should also create this group on the host and add any users who will be using this container.
RUN groupadd -g67890 gcp
RUN useradd -u67890 -g gcp -ms /bin/bash gcp

# Create a mountpoint for the host volume
RUN mkdir /gcpdata
RUN chown gcp:gcp /gcpdata
VOLUME /gcpdata
RUN chmod g+ws /gcpdata
RUN setfacl -Rdm g:gcp:rwx /gcpdata


# Install GCP&GATE to /opt/gcp
RUN mkdir /opt/gcp
WORKDIR '/opt/gcp'

ENV JAVA_TOOL_OPTIONS '-Dfile.encoding=UTF8'

RUN cd /opt/gcp
#at this moment, bio-yodie requires this particular subversion of GCP
RUN svn co http://svn.code.sf.net/p/gate/code/gcp/trunk@18658 gcp-2.5-18658
RUN cd /opt/gcp/gcp-2.5-18658 && ant
ENV GCP_HOME '/opt/gcp/gcp-2.5-18658'

#copy sql handler libs
ADD sqlhandler/* /opt/gcp/gcp-2.5-18658/lib/

#RUN curl -L 'http://netix.dl.sourceforge.net/project/gate/gate/8.1/gate-8.1-build5169-ALL.zip' > gate-8.1-build5169-ALL.zip && unzip gate-8.1-build5169-ALL.zip && mv gate-8.1-build5169-ALL gate && rm gate-8.1-build5169-ALL.zip

ADD gate-8.1-build5169-ALL.zip /opt/gcp/
RUN unzip gate-8.1-build5169-ALL.zip && mv gate-8.1-build5169-ALL gate && rm gate-8.1-build5169-ALL.zip

ENV GATE_HOME '/opt/gcp/gate'
#UKB is required
ENV UKB_HOME '/gcpdata/ukb'

ENV PATH "$PATH:$GCP_HOME:$GATE_HOME/bin:$UKB_HOME/bin"

# Set the user so we don't run as root
USER gcp
ENV HOME /home/gcp
WORKDIR /home/gcp

ENTRYPOINT ["gcp-direct.sh"]

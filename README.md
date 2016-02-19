# docker.gcp.bio-yodie
Docker image for running BIO-YODIE with GCP

###preparation
need to put the jar(s) of the cutomised GCP InputHandler and/or DocumentEnumerator into ./sqlhandler/ folder, for example, the streaming implementation of https://github.com/Honghan/cris.feeder. Neccessary libraries should also be put there. These jars will be copied to GCP lib folder.

###building
docker build -t hwu/gcp .

###running
Interactive running: docker run -it -v /gcpruntime:/gcpdata --entrypoint=/bin/bash hwu/gcp
Note: the host folder to be mounted as /gcpdata (/gcpruntime in above example) should contain the following.

1. UKB: resides in the /gcpruntime/ukb
2. bio-yodie pipeline
3. GCP batch file (refer: https://github.com/Honghan/cris.feeder/blob/master/cris_feeder_gcp/conf/gcp-batch.xml)

##Acknowledgement
This docker image is based on Cass(Johnston, Caroline)'s work.

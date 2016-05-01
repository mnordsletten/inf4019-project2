# Version: 0.0.1
FROM ubuntu:14.04
MAINTAINER Martin Nordsletten "mnordsletten@gmail.com"
ENV REFRESHED_AT 2016-03-29
RUN apt-get update && apt-get install -y git
RUN git clone https://git.cs.hioa.no/s238051/docker_distribute.git
ADD commands_test1 /commands_test1
ADD commands_test2 /commands_test2

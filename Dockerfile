FROM adoptopenjdk/openjdk15

LABEL maintainer "Lumunix <lumunix@icloud.com>"

ARG IDEA_VERSION=2021.1
ARG IDEA_SOURCE=https://download.jetbrains.com/idea/ideaIC-${IDEA_VERSION}.tar.gz
ARG IDEA_LOCAL_DIR=.IdeaIC${IDEA_VERSION}
ENV USERNAME developer
WORKDIR /opt/idea
ENV HOME /home/$USERNAME

RUN  \
  apt-get update && apt-get install --no-install-recommends -y \
  gcc git openssh-client less \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 \
  && rm -rf /var/lib/apt/lists/*



RUN curl -fsSL $IDEA_SOURCE -o /opt/idea/installer.tgz \
  && tar --strip-components=1 -xzf installer.tgz \
  && rm installer.tgz


RUN adduser --disabled-password --gecos '' $USERNAME && \
  echo $USERNAME:$USERNAME: | chpasswd && \
  echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  adduser $USERNAME sudo

RUN mkdir /home/$USERNAME/IdeaProjects && \
    chown $USERNAME:$USERNAME /home/$USERNAME/IdeaProjects
RUN mkdir /home/$USERNAME/$IDEA_LOCAL_DIR && \
    chown $USERNAME:$USERNAME /home/$USERNAME/$IDEA_LOCAL_DIR

CMD [ "/opt/idea/bin/idea.sh" ]

###################################################################################################################
# Adapted from https://github.com/microsoft/vscode-dev-containers/blob/master/containers/r/.devcontainer/Dockerfile
# licence: MIT
###################################################################################################################

FROM rocker/r-ver:4.2.0

# Options for setup script
ARG USERNAME
ARG INSTALL_ZSH="false"
ARG USER_UID="1000"
ARG USER_GID="1000"
ARG UPGRADE_PACKAGES="false"
ARG INSTALL_OHMYZSH="false"
ARG INSTALL_NONFREE="false"
ARG QUARTO_VERSION=latest

# key dependencies for certain R packages
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends software-properties-common curl wget libssl-dev libxml2-dev libsodium-dev imagemagick libmagick++-dev libgit2-dev libssh2-1-dev zlib1g-dev librsvg2-dev libudunits2-dev libcurl4-openssl-dev python3-pip pandoc libzip-dev libfreetype6-dev libfontconfig1-dev tk libpq5 libxt6 openssh-client openssh-server libglpk40 \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

COPY library-scripts/common-debian.sh /tmp/library-scripts/
RUN apt-get update && bash /tmp/library-scripts/common-debian.sh ${INSTALL_ZSH} ${USERNAME} ${USER_UID} ${USER_GID} ${UPGRADE_PACKAGES} ${INSTALL_OHMYZSH} ${INSTALL_NONFREE}

# install R packages needed for VSCode interaction and package management
RUN install2.r --error --skipinstalled --ncpus -4 languageserver renv remotes httpgd

# install radian via python and pip3
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends python3-setuptools

RUN pip3 install radian

# install dot net core runtime for the R Tools plugin
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb \
    && dpkg -i /tmp/packages-microsoft-prod.deb

RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-transport-https \
    && apt-get -y install --no-install-recommends dotnet-sdk-3.1

# ensure that the renv package cache env var is accessible in default R installation
RUN echo "RENV_PATHS_CACHE=/renv/cache" >> /usr/local/lib/R/etc/Renviron

# copy the modified .Rprofile template to the renv cache
#COPY library-scripts/.Rprofile-vscode /renv/.Rprofile-vscode

# [Optional] Uncomment this section to add Quarto to the container
RUN /rocker_scripts/install_quarto.sh

# [Optional] Uncomment this section to add Hugo to the container
# Customize version number as appropriate
#RUN curl -L https://github.com/gohugoio/hugo/releases/download/v0.92.0/hugo_extended_0.92.0_Linux-64bit.deb -o /tmp/hugo.deb
#RUN apt-get -y install ./tmp/hugo.deb

# [Optional] Uncomment this section to add shinycannon to the container
RUN curl -L https://github.com/rstudio/shinycannon/releases/download/v1.1.3/shinycannon_1.1.3-dd43f6b_amd64.deb -o /tmp/shinycannon.deb
RUN apt-get update \
  && apt-get -y install --no-install-recommends default-jre-headless \
  && apt-get -y install ./tmp/shinycannon.deb

# [Optional] install additional dependencies for image processing
RUN pip3 install google-cloud-vision
RUN pip3 install google-cloud-storage
RUN pip3 install aiohttp aiofiles tldextract
RUN pip3 install tqdm

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME

FROM        ubuntu:16.10

ENV         DEBIAN_FRONTEND noninteractive

RUN         apt-get update && apt-get upgrade -y && \
            apt-get install wget software-properties-common zip pciutils x11-utils libpython2.7 python cmake ninja-build make gcc-6-arm-linux-gnueabi g++-6-arm-linux-gnueabi -y

#INSTALL JAVA

RUN         add-apt-repository -y ppa:webupd8team/java && apt-get update
RUN         echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections # <-automatically accept the Oracle license.
RUN         apt-get install oracle-java8-installer -y
RUN         update-java-alternatives -s java-8-oracle


#DOWNLOAD AND INSTALL TIZEN-SDK

ENV         TIZEN_USER tizen
ENV         TIZEN_SDK_DIR /home/${TIZEN_USER}/TizenSDK/
ENV         TIZEN_SDK_DOWNLOAD_URL https://download.tizen.org/sdk/Installer/tizen-studio_1.1
ENV         TIZEN_SDK_INSTALLER_FILE web-cli_Tizen_Studio_1.1_ubuntu-64.bin

RUN         useradd -ms /bin/bash ${TIZEN_USER} # tizen sdk doesn't allow to be installed by root
USER        ${TIZEN_USER}
WORKDIR     /home/${TIZEN_USER}

RUN         wget ${TIZEN_SDK_DOWNLOAD_URL}/${TIZEN_SDK_INSTALLER_FILE} && chmod +x ./${TIZEN_SDK_INSTALLER_FILE}

RUN         export DISPLAY=:0.0 && ./${TIZEN_SDK_INSTALLER_FILE} --accept-license ${TIZEN_SDK_DIR} && \
            ${TIZEN_SDK_DIR}/package-manager/package-manager-cli.bin install MOBILE-2.4-NativeAppDevelopment-CLI MOBILE-2.3-NativeAppDevelopment-CLI

ENV         PATH="${PATH}:${TIZEN_SDK_DIR}/tools:${TIZEN_SDK_DIR}/tools/ide/bin"
ENV         TIZEN_KEYSTORE_DIR /home/${TIZEN_USER}/keystore
COPY        keystore ${TIZEN_KEYSTORE_DIR}

ENV         TIZEN_CERT_PROFILE certdev
ENV         TIZEN_CERT_AUTHOR_PASS 1234
ENV         TIZEN_CERT_DIST_PASS pass
RUN         tizen security-profiles add -n ${TIZEN_CERT_PROFILE} -a ${TIZEN_KEYSTORE_DIR}/author.p12 -d ${TIZEN_KEYSTORE_DIR}/distributor.p12 -p ${TIZEN_CERT_AUTHOR_PASS}  -dp ${TIZEN_CERT_DIST_PASS}

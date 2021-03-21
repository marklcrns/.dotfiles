#!/bin/bash

# Language packages

APT_PACKAGES_LANGUAGE=(
  # Python
  "python3-dev"
  "libffi-dev"
  "libssl-dev"
  "python3-pip"
  "python3-venv"
  # Java
  "default-jre"
  "default-jdk"
  "openjdk-8-jdk"
  "openjdk-8-jre"
  "openjdk-11-jdk"
  "openjdk-11-jre"
  "openjdk-13-jdk"
  "openjdk-13-jre"
  "maven"
  # R
  "r-base"
)

PIP3_PACKAGES_LANGUAGES=(
  "wheel"
  "pipenv"
  "virtualenv"
  "Send2Trash"
  "trash-cli"
)

echolog
echolog "${UL_NC}Installing Language Packages${NC}"
echolog

# Python2 (Needs to go before python3 installation)
if apt_install "python" && apt_install "python-dev"; then
  curl_install "https://bootstrap.pypa.io/pip/2.7/get-pip.py" "${DOWNLOADS_DIR}/get-pip.py"
  sudo python2 ${DOWNLOADS_DIR}/get-pip.py
fi

apt_bulk_install "${APT_PACKAGES_LANGUAGE[@]}"
pip_bulk_install 3 "${PIP3_PACKAGES_LANGUAGES[@]}"

# Oracle JDK 11.0.7
cd $SCRIPTDIR/install/
sudo cp "${SCRIPTDIR}../resources/jdk-11.0.7_linux-x64_bin.tar.gz" "/var/cache/oracle-jdk11-installer-local" && \
  echo "deb http://ppa.launchpad.net/linuxuprising/java/ubuntu focal main" | \
  sudo tee /etc/apt/sources.list.d/linuxuprising-java.list && \
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 73C3DB2A && \
  sudo apt update && \
  sudo apt install oracle-java11-installer-local -y && \
  sudo apt install oracle-java11-set-default-local -y

# Set java and javac 11 as default
export JDK_HOME=/usr/lib/jvm/java-11-openjdk-amd64
sudo update-alternatives --set java ${JDK_HOME}/bin/java
sudo update-alternatives --set javac ${JDK_HOME}/bin/javac
# Copy the Java path excluding the 'bin/java' to environment if not exist
if grep -q 'JAVA_HOME=' /etc/environment; then
  if ! sudo sed -i "s,^JAVA_HOME=.*,JAVA_HOME=${JDK_HOME}/jre/," /etc/environment; then
    echo "JAVA_HOME=${JDK_HOME}/jre/" | sudo tee -a /etc/environment
  fi
  source /etc/environment
fi


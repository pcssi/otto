# java_install_prepare installs the things necessary for any Java installs
java_install_prepare() {
  # Obvious: we're running non-interactive mode
  export DEBIAN_FRONTEND=noninteractive

  # Update apt once
  apt_update_once

  # Our PPAs have unicode characters, so we need to set the proper lang.
  otto_init_locale

  # Install stuff we need
  oe sudo apt-get install -y python-software-properties software-properties-common apt-transport-https curl wget
}

# java_install_8 installs Java 8
java_install_8() {
  oe sudo add-apt-repository ppa:webupd8team/java -y
  apt_update

  # Accept the Oracle license agreement
  echo debconf shared/accepted-oracle-license-v1-1 select true | oe sudo debconf-set-selections

  # Install Java
  apt_install oracle-java8-installer oracle-java8-set-default
}

# java_gradle_install installs the specified Gradle version.
java_gradle_install() {
  local version="$1"

  oe sudo add-apt-repository ppa:cwchien/gradle -y
  apt_update
  apt_install "gradle-${version}"
}

# java_maven_install installs the specified Maven version.
java_maven_install() {
  local version="$1"
  oe sudo curl "http://mirrors.koehn.com/apache/maven/maven-3/${version}/binaries/apache-maven-${version}-bin.tar.gz" --create-dirs -o "/opt/apache-maven-${version}-bin.tar.gz"
  oe sudo tar -zxvf "/opt/apache-maven-${version}-bin.tar.gz" -C /opt
  oe sudo rm "/opt/apache-maven-${version}-bin.tar.gz"
  oe export "PATH=/opt/apache-maven-${version}/bin:$PATH"
}

# java_lein_install installs the specified Leiningen version.
java_lein_install() {
  local version="$1"
  oe sudo curl "https://raw.githubusercontent.com/technomancy/leiningen/${version}/bin/lein" --create-dirs -o ~/bin/lein
  oe sudo chmod a+x ~/bin/lein
}

# java_scala_install installs the specified Scala version.
java_scala_install() {
  local version="$1"
  oe sudo apt-get update
  oe sudo apt-get remove scala-library scala
  oe sudo wget "http://scala-lang.org/files/archive/scala-${version}.deb"
  oe sudo apt-get -f install
  oe sudo dpkg -i "scala-${version}.deb"
  oe sudo apt-get update
  oe rm "scala-${version}.deb"
}

# java_sbt_install installs the specified sbt version.
java_sbt_install() {
  local version="$1"
  oe wget "http://dl.bintray.com/sbt/debian/sbt-${version}.deb"
  oe sudo apt-get update
  oe sudo dpkg -i "sbt-${version}.deb"
  oe rm "sbt-${version}.deb"
}

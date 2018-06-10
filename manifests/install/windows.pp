# filebeat::install::windows
#
# Download and install filebeat on Windows
#
# @summary A private class that installs filebeat on Windows
#
class filebeat::install::windows {
  package {'filebeat':
    ensure   => $filebeat::package_ensure,
    provider => 'chocolatey',
  }
}

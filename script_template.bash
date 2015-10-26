#! /usr/bin/env bash
DEBUG="false"
function usage {
   echo "$0 - $VERSION (2012 - fred.smith@fredsmith.org)";
   echo "description of the program";
   echo "Usage: $0 [options]";
   echo "options:";
   echo "    -d   Debug mode";
   echo "    -h   Usage (this screen)";
   
}

while getopts "dh" optionName; do
      case "$optionName" in
         d)
            DEBUG="true"
            ;;
         h)
            usage;
            exit;
            ;;
         [?])
            usage;
            exit;
            ;;
      esac
done


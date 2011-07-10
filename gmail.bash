#!/usr/bin/env bash

# Gmail inbox feed parser
#
#   EXAMPLE: ./gmail.bash GMAIL_USER
#
# GMAIL_USER can include username and optionally a password

set -o errtrace
set -o errexit
set -o nounset

parent=$(dirname -- "$BASH_SOURCE")
source "$parent/bash-xml.bash"
source "$parent/bash-stack.bash"

gmail_parse_feed () {
    bash_xml_sax_parse gmail_parse_feed_element_start gmail_parse_feed_element_end gmail_parse_feed_characters
}
gmail_parse_feed_element_start () {
    [ "$2" != "entry" ] || (gmail_entry_name="" && gmail_entry_title="" && gmail_entry_date="")
    stack_push "$2"
}
gmail_parse_feed_element_end () {
    [ "$2" != "entry" ] || printf "%20s | %-25s | %s\n" "$gmail_entry_date" "$gmail_entry_name" "$gmail_entry_title"
    stack_pop
}
gmail_parse_feed_characters () {
    case "$(stack_list)" in
        "feed entry title")       gmail_entry_title="$1" ;;
        "feed entry issued")      gmail_entry_date="$1"  ;;
        "feed entry author name") gmail_entry_name="$1"  ;;
    esac
}

gmail_fetch_feed () {
    curl -u "$1" --silent 'https://mail.google.com/mail/feed/atom'
}

gmail_inbox () {
    if [ $# -gt 0 ]; then
        GMAIL_USER="$1"
    fi
    gmail_fetch_feed "$GMAIL_USER" | gmail_parse_feed
}

if [ "$0" == "$BASH_SOURCE" ]; then
    gmail_inbox "$@"
fi

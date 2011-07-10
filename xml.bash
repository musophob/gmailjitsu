#!/usr/bin/env bash

set -o errtrace 
set -o errexit
set -o nounset


# BASH STACK:

declare -a stack
stack_push () {
    [ $# -eq 1 ] || stack_err "stack_push takes one argument" || return 1
    stack[${#stack[@]}]="$1"
}
stack_pop () {
    index=$(stack_index) || stack_err "index out of range" || return 1
    unset stack[$index]
}
stack_item () {
    [ $# -ge 1 ] && item="$1" || item="0"
    index=$(stack_index $item) || stack_err "index out of range" || return 1
    echo ${stack[$index]}
}
stack_index () {
    [ $# -ge 1 ] && index="$1" || index="0" || true
    [ "$index" -ge 0 ] && [ "$index" -lt ${#stack[@]} ] || return 1
    expr ${#stack[@]} - "$index" - 1 || true
}
stack_count () {
    echo ${#stack[@]}
}
stack_list () {
    echo ${stack[@]}
}
stack_err () {
    echo "Stack error: $@" 1>&2
    return 1
}


# BASH XML PARSER:

bash_sax_parse () {
    handle_element_start="$1"
    handle_element_end="$2"
    handle_characters="$3"
    # assumes each line contains one element
    cat "/dev/stdin" | bash_xml_split | while read line; do
        case "$line" in
            "<?"*)      ;;
            "</"*)      [ -z "$handle_element_end" ]    || "$handle_element_end"    "$line" "$(expr "$line" : '</*\([^ />]*\)')" ;;
            "<"*"/>")   [ -z "$handle_element_start" ]  || "$handle_element_start"  "$line" "$(expr "$line" : '</*\([^ />]*\)')"
                        [ -z "$handle_element_end" ]    || "$handle_element_end"    "$line" "$(expr "$line" : '</*\([^ />]*\)')" ;;
            "<"*)       [ -z "$handle_element_start" ]  || "$handle_element_start"  "$line" "$(expr "$line" : '</*\([^ />]*\)')" ;;
            *)          [ -z "$handle_characters" ]     || "$handle_characters"     "$line" ;;
        esac
    done
}

# splits an XML document into a stream of lines containing one element each and removes blanks
# TODO: make this more robust
bash_xml_split () {
    sed -e 's/</\
</g' -e 's/>/>\
/g' | sed -e '/^ *$/d'
}


# EXAMPLE: XML prettifier

xml_prettify () {
    bash_sax_parse xml_prettify_start xml_prettify_end xml_prettify_characters
}
xml_prettify_indent="2"
xml_prettify_print () {
    printf "%*s%s\n" $(expr $(stack_count) \* $xml_prettify_indent) "" "$1"
}
xml_prettify_start () {
    case "$1" in
        *"/>") ;; # HACK: skip self terminating tags
        *) xml_prettify_print "$1" ;;
    esac
    stack_push "$2"
}
xml_prettify_end () {
    stack_pop
    xml_prettify_print "$1"
}
xml_prettify_characters () {
    xml_prettify_print "$1"
    return 0
}


# EXAMPLE: Gmail feed parser

gmail_parse_feed () {
    bash_sax_parse gmail_parse_feed_element_start gmail_parse_feed_element_end gmail_parse_feed_characters
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

gmail_user='USERNAME'
gmail_fetch_feed () {
    curl -u "$gmail_user" --silent 'https://mail.google.com/mail/feed/atom'
}

gmail_fetch_feed | gmail_parse_feed

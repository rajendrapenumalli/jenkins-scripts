#!/usr/bin/env bash

: ' Script that collects disk space from Linux and pushes a message to Slack with
    the results, if it is an alert it will also mention @channel.
    '

# check if debug flag is set
if [ "${DEBUG}" = true ]; then

  set -x # enable print commands and their arguments as they are executed.
  export # show all declared variables (includes system variables)
  whoami # print current user

else

  # unset if flag is not set
  unset DEBUG

fi

# bash default parameters
set -o errexit  # make your script exit when a command fails
set -o pipefail # exit status of the last command that threw a non-zero exit code is returned
set -o nounset  # exit when your script tries to use undeclared variables

# check binaries
__AWK=$(which awk)
__CURL=$(which curl)
__DF=$(which df)
__GREP=$(which grep)

# parameters
readonly __disk="${1:-"/dev/sda1"}"
readonly __disk_size_alert_trigger_in_GB="${2:-"5"}"
readonly __msg_from="${3:-"robot-monitor"}"
readonly __msg_icon="${4:-":robot_face:"}"
readonly __slack_webhook_url="${5:-"https://hooks.slack.com/services/T124DF485/AE45U48H1/jdui132599asdasdHrasdad7asadM"}"
readonly __slack_channel_or_person="${6:-"#monitor"}"

# college disk usage
readonly __disk_free_in_KB=$(${__DF} \
                              | ${__GREP} "${__disk}" \
                              | ${__AWK} '{print $4'} \
                            )

# conversions
readonly __disk_size_alert_trigger_in_KB=$(((${__disk_size_alert_trigger_in_GB}*1024)*1024))
readonly __disk_free_in_GB=$(((${__disk_free_in_KB}/1024)/1024))

# variables / message and icons definitions
readonly __server=$(hostname)
readonly __msg_alert_icon=":x:"
readonly __msg_alert_text="${__msg_alert_icon} ${__server^^} disk *${__disk}* is running out of space. *${__disk_free_in_GB} GB* free, @channel please check."
readonly __msg_ok_icon=":white_check_mark:"
readonly __msg_ok_text="${__msg_ok_icon} ${__server^^} disk *${__disk}* is working under normal parameters. *${__disk_free_in_GB} GB* free."

# push message to slack function
function push_to_slack {

  # parameters
  local __from="${1:-}"
  local __channel_or_person="${2:-}"
  local __text="${3:-}"

  # push to slack via webhook
  ${__CURL} --request POST \
            --data-urlencode \
              "payload={\"username\": \"${__from}\",
                        \"icon_emoji\": \"${__msg_icon}\",
                        \"channel\": \"${__channel_or_person}\",
                        \"text\": \"${__text}\",
                        \"as_user\": \"false\",
                        \"link_names\": \"true\"
                       }" \
            "${__slack_webhook_url}"

} # end of push_to_slack

# check trigger
if [ "${__disk_free_in_KB}" -lt "${__disk_size_alert_trigger_in_KB}" ]; then

  push_to_slack "${__msg_from}" "${__slack_channel_or_person}" "${__msg_alert_text}"

else

  push_to_slack "${__msg_from}" "${__slack_channel_or_person}" "${__msg_ok_text}"

fi

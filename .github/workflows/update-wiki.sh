conversion() {

  readarray -t categories < <(cat $GITHUB_WORKSPACE/etc/categories | sed 's/$/|/g' | awk -F'|' '{print $2}' | sort - | uniq)
  readarray -t script_name < <(cat $GITHUB_WORKSPACE/etc/categories | sed 's/$/|/g' | awk -F'|' '{print $1}')
  readarray -t script_category < <(cat $GITHUB_WORKSPACE/etc/categories | sed 's/$/|/g' | awk -F'|' '{print $2}')

  for category in "${categories[@]}"; do
    if [[ "$category" == "hidden" ]]; then
      continue
    fi
    echo "# $category"
    iter=0
    for script in "${script_name[@]}"; do
      if [[ "${script_category[$iter]}" == "$category" ]] && [[ -e "$GITHUB_WORKSPACE/apps/$script" ]]; then

        # determine if app is arm64, arm32, or both
        if [[ -e "$GITHUB_WORKSPACE/apps/$script/install" ]]; then
          arch="ARM32/ARM64"
        elif [[ -e "$GITHUB_WORKSPACE/apps/$script/install-32" ]]; then
          if [[ -e "$GITHUB_WORKSPACE/apps/$script/install-64" ]]; then
            arch="ARM32/ARM64"
          else
            arch="ARM32 ONLY"
          fi
        elif [[ -e "$GITHUB_WORKSPACE/apps/$script/install-64" ]]; then
          arch="ARM64 ONLY"
        else
          arch="Package app"
        fi
        num_users="$(echo "$clicklist" | grep "[0-9] $script"'$' | awk '{print $1}' | head -n1)"
        if [ ! -z "$num_users" ] && [ "$num_users" -gt 20 ];then
          #list the number of users, using this printf command to add commas (,) for every thousand number
          arch_users="$arch - $(printf "%'d" "$num_users") Users"
          if [ "$num_users" -ge 10000 ];then
            #if this app has over 10,000 users, add two exclamation points!!
            arch_users+="!!"
          elif [ "$num_users" -ge 1500 ];then
            #if this app has over 1500 users, add an exclamation point!
            arch_users+="!"
          fi
        else
          arch_users="$arch"
        fi
        script_website=$(cat "$GITHUB_WORKSPACE/apps/$script/website" 2>/dev/null)
        script_credits=$(cat "$GITHUB_WORKSPACE/apps/$script/credits" 2>/dev/null)
        echo ""
        script_url=$(echo $script | sed -e 's/ /%20/g')
        echo "### <img src=\"https://github.com/Botspot/pi-apps/blob/master/apps/$script_url/icon-64.png\" height=32> ***[$script](https://github.com/Botspot/pi-apps/tree/master/apps/$script_url)***"
        [[ ! -z "$script_website" ]] && [[ ! -z "$script_credits" ]] && echo "$script_website - $script_credits<br />"
        [[ ! -z "$script_website" ]] && [[ -z "$script_credits" ]] && echo "$script_website<br />"
        [[ -z "$script_website" ]] && [[ ! -z "$script_credits" ]] && echo "$script_credits<br />"
        sed -i '$a\' "$GITHUB_WORKSPACE/apps/$script/description"
        echo "$arch_users"
        echo '```'
        cat "$GITHUB_WORKSPACE/apps/$script/description"
        echo '```'
      fi
      iter=$(($iter + 1))
    done
  done

}

# download current clicklist to /tmp and store its contents in a variable
wget 'https://raw.githubusercontent.com/Botspot/pi-apps-analytics/main/clicklist' -qO "/tmp/clicklist" >/dev/null
clicklist="$(cat "/tmp/clicklist")"

conversion >Apps-List.md

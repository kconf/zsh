#!/usr/bin/env zsh

cht() { curl cht.sh/$* }

qr() { curl qrenco.de/$* }

clone() { gh repo clone $1 $HOME/Dev/github.com/$1 }

proxy() {
	local default_proxy="http://localhost:7890"
	
	case "$1" in
		"on")
			local proxy_url="${2:-$default_proxy}"
			export no_proxy="localhost,127.0.0.1,::1,192.168.0.0/16,localaddress,.localdomain.com"
			export http_proxy="$proxy_url" \
				https_proxy="$proxy_url" \
				ftp_proxy="$proxy_url" \
				rsync_proxy="$proxy_url" \
				HTTP_PROXY="$proxy_url" \
				HTTPS_PROXY="$proxy_url" \
				FTP_PROXY="$proxy_url" \
				RSYNC_PROXY="$proxy_url"
			echo "Proxy enabled: $proxy_url"
			;;
		"off")
			unset http_proxy https_proxy ftp_proxy rsync_proxy \
				HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY no_proxy
			echo "Proxy disabled."
			;;
		"toggle")
			if [[ -n "$http_proxy" ]]; then
				proxy off
			else
				proxy on
			fi
			;;
		*)
			echo "Usage: proxy {on [url]|off|toggle}"
			echo "  proxy on [url]  - Enable proxy (default: $default_proxy)"
			echo "  proxy off       - Disable proxy"
			echo "  proxy toggle    - Toggle proxy state"
			;;
	esac
}

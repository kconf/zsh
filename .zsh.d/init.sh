#!/usr/bin/env zsh

cht() { curl cht.sh/$* }

qr() { curl qrenco.de/$* }

clone() { gh repo clone $1 $HOME/Dev/github.com/$1 }


proxy_on() {
	export no_proxy="localhost,127.0.0.1,::1,192.168.0.0/16,localaddress,.localdomain.com"

	local proxy=$1
	export http_proxy="$proxy" \
		https_proxy=$proxy \
		ftp_proxy=$proxy \
		rsync_proxy=$proxy \
		HTTP_PROXY=$proxy \
		HTTPS_PROXY=$proxy \
		FTP_PROXY=$proxy \
		RSYNC_PROXY=$proxy
}

proxy_off() {
	unset http_proxy https_proxy ftp_proxy rsync_proxy \
		HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY
	echo -e "Proxy environment variable removed."
}

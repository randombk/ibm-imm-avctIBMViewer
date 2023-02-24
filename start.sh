#!/bin/bash
set -e

read -p "Server (default 192.168.1.137): " SERVER
read -p "Proto (default http): " SERVER_PROTO
read -p "User (default RandomBK): " IMM_USER
read -sp "Pass: " IMM_PASS

SERVER=${SERVER:-192.168.1.137}
SERVER_PROTO=${SERVER_PROTO:-http}
IMM_USER=${name:-RandomBK}

echo Logging in...
login_response=$(curl "$SERVER_PROTO://$SERVER/session/create" -d "USERNAME=$IMM_USER,PASSWORD=$IMM_PASS" 2>/dev/null) 
echo Login Response: $login_response

echo Starting Session...
kvm_user=$(curl "$SERVER_PROTO://$SERVER/kvm/kvm/jnlp" -H "Cookie: session_id=${login_response:3}" 2>/dev/null | grep "user=" | sed 's/.*user=\(0x.*\)<.*/\1/g')
echo Parsed KVM User $kvm_user. Starting Java client

cd avctIBMViewer
java -Djava.library.path="$(pwd)" com.avocent.ibmc.kvm.Main \
	ip=$SERVER \
	helpurl=$SERVER_PROTO://$SERVER/aessrp/help/contents.html \
	user=$kvm_user \
	passwd= \
	apcp=1 \
	version=2 \
	kmport=3900 \
	vport=3900 \
	title=$SERVER-Video Viewer \
	vm=1 \
	power=1 \
	statusbar=led \
	immversion=1 

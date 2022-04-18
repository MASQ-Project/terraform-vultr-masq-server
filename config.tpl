#!/bin/sh
echo "Starting" >> /home/ubuntu/debug.txt

echo "ratePack: \"${ratePack}\"" >> /home/ubuntu/debug.txt
echo "scanIntervals: \"${scanIntervals}\"" >> /home/ubuntu/debug.txt
echo "paymentThresholds: \"${paymentThresholds}\"" >> /home/ubuntu/debug.txt


ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
### Applyed this to Fix a very strange issue where a VM would sometimes boot up with its system DNS being blocked by Vultrs Firewall
if [ -z "$ip" ]
then
    echo "+-- DNS FIX Applyed --+" >> /home/ubuntu/debug.txt
    echo "nameserver 1.1.1.1" > /etc/resolv.conf
    sleep 5s
    ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
fi

 

apt update -y
apt install -y jq python zip curl tmux
sudo ufw allow "${clandestine_port}"


if [ "${centralLogging}" = true ]
then
    curl https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -O
    sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
    echo "${agent_config}" | base64 -d >> /home/ubuntu/amazon-cloudwatch-agent.json
fi

curl -so /home/ubuntu/masqBin.zip ${downloadurl}
unzip /home/ubuntu/masqBin.zip -d /home/ubuntu/
cp /home/ubuntu/generated/bin/MASQNode /usr/local/bin/MASQNode
cp /home/ubuntu/generated/bin/masq /usr/local/bin/masq
sudo chmod 755 /usr/local/bin/MASQNode
sudo chmod 755 /usr/local/bin/masq
mkdir /home/ubuntu/masq
chmod 755 /home/ubuntu/masq
rm -rf /home/ubuntu/generated/
rm /home/ubuntu/masqBin.zip
rm /home/ubuntu/generated.tar.gz

    
echo "1" >> /home/ubuntu/debug.txt
if [ "${centralNighbors}" = true ]
then
    # arr=$(curl -s https://dev.api.masq.ai/nodes/polygon-mumbai | jq -r '.[].descriptor')
    arr=$(curl -s https://dev.api.masq.ai/nodes/${chain} | jq -r '.[].descriptor')
    echo "#!/bin/bash"  >> /home/ubuntu/test.sh
    echo "tr '\\n' , <<< \"$${arr}\""  >> /home/ubuntu/test.sh
    chmod +x /home/ubuntu/test.sh
    joined=$("/home/ubuntu/test.sh")
    rm /home/ubuntu/test.sh
fi

echo "2" >> /home/ubuntu/debug.txt
echo "chain=\"${chain}\"" >> /home/ubuntu/masq/config.toml
echo "blockchain-service-url=\"${bcsurl}\"" >> /home/ubuntu/masq/config.toml
echo "clandestine-port=\"${clandestine_port}\"" >> /home/ubuntu/masq/config.toml
echo "db-password=\"${dbpass}\"" >> /home/ubuntu/masq/config.toml
echo "dns-servers=\"${dnsservers}\"" >> /home/ubuntu/masq/config.toml
echo "gas-price=\"${gasprice}\"" >> /home/ubuntu/masq/config.toml
echo "ip=\"$${ip}\"" >> /home/ubuntu/masq/config.toml
echo "log-level=\"trace\"" >> /home/ubuntu/masq/config.toml
echo "neighborhood-mode=\"standard\"" >> /home/ubuntu/masq/config.toml
echo "real-user=\"1000:1000:/home/ubuntu\"" >> /home/ubuntu/masq/config.toml
if [ "${paymentThresholds}" != "" ]; then echo "payment-thresholds=\"${paymentThresholds}\"" >> /home/ubuntu/masq/config.toml ; fi
if [ "${scanIntervals}" != "" ]; then echo "scan-intervals=\"${scanIntervals}\"" >> /home/ubuntu/masq/config.toml ; fi
if [ "${ratePack}" != "" ]; then echo "rate-pack=\"${ratePack}\"" >> /home/ubuntu/masq/config.toml ; fi


echo "3" >> /home/ubuntu/debug.txt


if [ "${masterNode}" = true ]
then
    echo "#neighbors=\"\"" >> /home/ubuntu/masq/config.toml 
else
    if [ -z "$${arr}" ]
    then
        echo "starting bootstrapped."
    else
        echo "neighbors=\"$${joined%,}\"" >> /home/ubuntu/masq/config.toml
    fi
    if [ "${centralNighbors}" = false ]
    then
        if [ "${customnNighbors}" != "" ]
        then
            echo "neighbors=\"${customnNighbors}\"" >> /home/ubuntu/masq/config.toml
        else
            echo "#neighbors=\"${customnNighbors}\"" >> /home/ubuntu/masq/config.toml
        fi
    fi
fi

echo "4" >> /home/ubuntu/debug.txt

chown ubuntu:ubuntu /home/ubuntu/masq/config.toml
chmod 755 /home/ubuntu/masq/config.toml
echo "[Unit]" >> /etc/systemd/system/MASQNode.service
echo "Description=MASQNode serve" >> /etc/systemd/system/MASQNode.service
echo "After=network.target" >> /etc/systemd/system/MASQNode.service
echo "StartLimitIntervalSec=0" >> /etc/systemd/system/MASQNode.service
echo "" >> /etc/systemd/system/MASQNode.service
echo "[Service]" >> /etc/systemd/system/MASQNode.service
echo "Type=forking" >> /etc/systemd/system/MASQNode.service
echo "Restart=always" >> /etc/systemd/system/MASQNode.service
echo "RestartSec=10" >> /etc/systemd/system/MASQNode.service
echo "User=ubuntu" >> /etc/systemd/system/MASQNode.service
echo "ExecStart=/usr/bin/tmux new-session -d -s masq '/usr/bin/sudo /usr/local/bin/MASQNode --data-directory /home/ubuntu/masq'" >> /etc/systemd/system/MASQNode.service
echo "ExecStop=/usr/bin/tmux kill-session -t masq" >> /etc/systemd/system/MASQNode.service
echo "" >> /etc/systemd/system/MASQNode.service
echo "[Install]" >> /etc/systemd/system/MASQNode.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/MASQNode.service

# >> Sleep timer on Random from 1 - 31 secconds
# timer=$(( $RANDOM % 30 + 1 ))
echo "Sleep..." >> /home/ubuntu/debug.txt
timer=$(shuf -i 0-30 -n1)
echo "Timer: $${timer}" >> /home/ubuntu/debug.txt
sleep $${timer}




systemctl enable MASQNode.service
systemctl start MASQNode.service
sleep 5
/usr/local/bin/masq set-password "${dbpass}"




echo "cycleDerivation: ${cycleDerivation}" >> /home/ubuntu/debug.txt
echo "derivationIndex: ${derivationIndex}" >> /home/ubuntu/debug.txt
echo "masterNode: ${masterNode}" >> /home/ubuntu/debug.txt
echo "index: ${index}" >> /home/ubuntu/debug.txt

#walletIndex=$(${derivationIndex} + ${index})



if [ "${cycleDerivation}" = true ]
then
    walletIndex=$((${derivationIndex}+${index}))
    echo "walletIndex: $${walletIndex}" >> /home/ubuntu/debug.txt
    echo "m/44'/60'/0'/0/$${walletIndex}" >> /home/ubuntu/debug.txt

    /usr/local/bin/masq recover-wallets --consuming-path "m/44'/60'/0'/0/$${walletIndex}" --db-password "${dbpass}" --mnemonic-phrase "${mnemonicAddress}" --earning-path "m/44'/60'/0'/0/$${walletIndex}" #
else
    if [ "${earnwalletAddressindex}" -eq "0" ]
    then
    /usr/local/bin/masq recover-wallets --consuming-path "m/44'/60'/0'/0/0" --db-password "${dbpass}" --mnemonic-phrase "${mnemonicAddress}" --earning-path "m/44'/60'/0'/0/0" #
    else
    /usr/local/bin/masq recover-wallets --consuming-path "m/44'/60'/0'/0/1" --db-password "${dbpass}" --mnemonic-phrase "${mnemonicAddress}" --earning-address "${earnwalletAddress}"
    fi
fi




/usr/local/bin/masq shutdown
sleep 2
systemctl stop MASQNode.service
sleep 5
systemctl start MASQNode.service
#amazon-cloudwatch-agent-ctl -a fetch-config -s -m ec2 -c file:/home/ubuntu/amazon-cloudwatch-agent.json
echo "Finished" >> /home/ubuntu/debug.txt                              #DEBUG


sleep 15
su ubuntu
descr=$(masq descriptor | grep -oE '[a-zA-Z0-9_.-]*@[0-9].*')
hostname >> /home/ubuntu/info.txt
echo "$${ip}" >> /home/ubuntu/info.txt
echo "$${descr}" | grep -oE '[a-zA-Z0-9_.-]*@[0-9].*' >> /home/ubuntu/info.txt
echo "$${descr}" | grep -oE '[a-zA-Z0-9_.-]*@[0-9].*' >> /home/ubuntu/descriptor.txt
echo "curl --request POST 'https://dev.api.masq.ai/nodes' --header 'Content-Type: application/json' --data-raw '{\"chain\":\"polygon-mumbai\",\"descriptor\":\"$${descr}\"}'" >> /home/ubuntu/saveDescriptor.txt
echo "10" >> /home/ubuntu/debug.txt

if [ "${pushDescriptor}" = true ]
then
    echo "11" >> /home/ubuntu/debug.txt
    chmod +x /home/ubuntu/saveDescriptor.txt
    ./home/ubuntu/saveDescriptor.txt
    echo "Saved Descriptor" >> /home/ubuntu/debug.txt                              #DEBUG
else
    echo "12" >> /home/ubuntu/debug.txt
    echo "Descriptor NOT Saved" >> /home/ubuntu/debug.txt                              #DEBUG
fi
echo "FIN" >> /home/ubuntu/debug.txt

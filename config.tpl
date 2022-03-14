#!/bin/sh
echo "Starting" >> /home/ubuntu/debug.txt

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

if [ "${centralNighbors}" = true ]
then
    arr="( $(curl -s https://dev.api.masq.ai/nodes/${chain} | jq -r '.[].descriptor') )"
    printf -v joined '%s,' "$${arr[@]}"
fi

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

if [ -z "$${arr}" ]
then
    echo "starting bootstrapped."
else
    echo "#neighbors=\"$${joined%,}\"" >> /home/ubuntu/masq/config.toml
fi
if [ "${centralNighbors}" = false ]
then
    echo "neighbors=\"${customnNighbors}\"" >> /home/ubuntu/masq/config.toml
fi

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
systemctl enable MASQNode.service
systemctl start MASQNode.service
sleep 5s
/usr/local/bin/masq set-password "${dbpass}"

if [ "${earnwalletAddressindex}" -eq "0" ]
then
   /usr/local/bin/masq recover-wallets --consuming-path "m/44'/60'/0'/0/0" --db-password "${dbpass}" --mnemonic-phrase "${mnemonicAddress}" --earning-path "m/44'/60'/0'/0/0"
else
   /usr/local/bin/masq recover-wallets --consuming-path "m/44'/60'/0'/0/0" --db-password "${dbpass}" --mnemonic-phrase "${mnemonicAddress}" --earning-address "${earnwalletAddress}"
fi

/usr/local/bin/masq shutdown
sleep 2s
systemctl stop MASQNode.service
sleep 5s
systemctl start MASQNode.service
#amazon-cloudwatch-agent-ctl -a fetch-config -s -m ec2 -c file:/home/ubuntu/amazon-cloudwatch-agent.json

echo "Finished" >> /home/ubuntu/debug.txt                              #DEBUG
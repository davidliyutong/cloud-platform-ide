trap "echo exitting" 15
if [ ! -f "/root/.config/code-server/CONFIGURED" ]; then
    echo "Init config with default"
    echo "Password: speit"
    tar -xf /opt/home.tar.gz -C /root
fi
code-server --config /root/.config/code-server/config.yaml
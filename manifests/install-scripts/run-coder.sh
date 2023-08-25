trap "echo exitting" 15
if [ ! -f "/root/.config/code-server/CONFIGURED" ]; then
    echo "Init config with default"
    echo "Password: none"
    tar -xf /opt/home.tar.xz -C /root --no-same-owner
fi
code-server --bind-addr 0.0.0.0:3000 --auth none --cert false
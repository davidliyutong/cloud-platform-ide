DEPLOY_HOME=/home/ubuntu
trap "echo exitting" 15
if [ ! -f "$DEPLOY_HOME/.config/code-server/CONFIGURED" ]; then
    echo "Init config with default"
    echo "Password: none"
    sudo tar -xf /opt/home.tar.xz -C $DEPLOY_HOME --no-same-owner
    sudo rsync -a /root/ $DEPLOY_HOME/
fi

echo "---------------------------"
sudo -E /startup.sh
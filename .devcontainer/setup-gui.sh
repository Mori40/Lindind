#!/bin/bash
set -e

echo "Updating system..."
sudo apt update

echo "Installing XFCE + VNC..."
sudo apt install -y \
  xfce4 xfce4-goodies \
  x11vnc xvfb \
  novnc websockify

echo "Setting VNC password..."
mkdir -p ~/.vnc
x11vnc -storepasswd 1234 ~/.vnc/passwd

echo "Creating start script..."
cat <<'EOF' > ~/start-vnc.sh
#!/bin/bash

Xvfb :1 -screen 0 1280x800x16 &
export DISPLAY=:1

startxfce4 &

x11vnc -display :1 -forever -usepw -shared &

websockify --web=/usr/share/novnc/ 6080 localhost:5901
EOF

chmod +x ~/start-vnc.sh

echo "DONE. Run: bash ~/start-vnc.sh"

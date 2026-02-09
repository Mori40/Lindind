#!/bin/bash
set -e

echo "🔹 Updating system..."
apt update && apt upgrade -y

echo "🔹 Installing Desktop Environment and GUI tools..."
apt install -y xfce4 xfce4-goodies x11vnc xvfb novnc websockify

echo "🔹 Setting up VNC password..."
mkdir -p ~/.vnc
x11vnc -storepasswd 1234 ~/.vnc/passwd

echo "🔹 Creating start script for GUI..."
cat <<'EOF' > ~/start-vnc.sh
#!/bin/bash
echo "🔹 Starting X virtual framebuffer..."
Xvfb :1 -screen 0 1024x768x16 &

export DISPLAY=:1
echo "🔹 Starting XFCE Desktop..."
startxfce4 &

echo "🔹 Starting VNC server on :1..."
x11vnc -display :1 -forever -usepw -shared &

echo "🔹 Starting noVNC on port 6080..."
websockify --web=/usr/share/novnc/ 6080 localhost:5901
EOF

chmod +x ~/start-vnc.sh

echo "✅ Setup complete! Run 'bash ~/start-vnc.sh' to start your Linux GUI."

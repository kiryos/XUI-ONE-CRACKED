#!/bin/bash
echo -e "\nChecking that minimal requirements are ok"

# اختيار نوع السيرفر
echo "========================================"
echo "        XUI ONE Installer 22.04        "
echo "========================================"
echo
echo "اختر نوع السيرفر الذي تريد تثبيته:"
echo "1) Main Server"
echo "2) Update Server"
echo "3) Load Balancer (LB)"
read -p "اختر الرقم [1-3]: " choice

case $choice in
  1) TYPE="main";;
  2) TYPE="update";;
  3) TYPE="lb";;
  *) echo "خيار غير صالح"; exit 1;;
esac

echo "تم اختيار نوع السيرفر: $TYPE"
echo "$TYPE" > /root/xui_server_type.txt

# كشف نظام التشغيل والإصدار
if [ -f /etc/lsb-release ]; then
    OS="$(grep DISTRIB_ID /etc/lsb-release | sed 's/^.*=//')"
    VER="$(grep DISTRIB_RELEASE /etc/lsb-release | sed 's/^.*=//')"
elif [ -f /etc/os-release ]; then
    OS="$(grep -w ID /etc/os-release | sed 's/^.*=//')"
    VER="$(grep -w VERSION_ID /etc/os-release | sed 's/^.*=//')"
 else
    OS="$(uname -s)"
    VER="$(uname -r)"
fi
ARCH=$(uname -m)
echo "Detected : $OS  $VER  $ARCH"

# تثبيت المتطلبات الأساسية
wget https://github.com/amidevous/xui.one/raw/refs/heads/master/install-dep.sh -qO /tmp/install-dep.sh >/dev/null 2>&1
bash /tmp/install-dep.sh

cd /root
wget https://github.com/amidevous/xui.one/releases/download/test/XUI_1.5.13.zip -qO XUI_1.5.13.zip >/dev/null 2>&1
unzip XUI_1.5.13.zip >/dev/null 2>&1

wget https://raw.githubusercontent.com/amidevous/xui.one/master/install.python3 -qO /root/install.python3 >/dev/null 2>&1
chmod +x /root/install.python3

# تشغيل تثبيت Python مع قراءة نوع السيرفر
python3 /root/install.python3

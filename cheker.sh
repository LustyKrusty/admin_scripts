#!/bin/bash
# Занітсалювати lynx, nmap, whois, curl, nikto 
# Отримати IP-адреси для домену та записати їх у масив
ip_list=($(dig +short $domain))
for ip in "${ip_list[@]}"; do
  echo -e "\e[32m1) Відкриті порти:\e[0m" >> "$domain-$ip.txt"
  # Запуск nmap для IP
  nmap -Pn $ip >> "$domain-$ip.txt"
  # Виконати whois для IP та отримати OrgName
  org_name=$(whois $ip | grep OrgName | awk -F': ' '{print $2}')
  # Перевірка CloudFlare
  echo -e "\e[32m2)Чи підключений CloudFlare:\e[0m" >> "$domain-$ip.txt"
  if [[ "$org_name" == *"Cloudflare, Inc."* ]]; then
    echo " active" >> "$domain-$ip.txt"
  else
    echo " not active" >> "$domain-$ip.txt"
  fi
  echo -e "\e[32m3)Вивід типових проблем:\e[0m"  >> "$domain-$ip.txt"
  # Отримати код відповіді HTTP
  http_code=$(curl -Is https://"$domain"/pub/static/ | awk '{print $1, $2}' | grep HTTP | grep -o '[0-9]\{3\}')
    echo "Доступ до /pub/static/: $http_code" >> "$domain-$ip.txt"
  http_code=$(curl -Is https://"$domain"/admin | awk '{print $1, $2}' | grep HTTP | grep -o '[0-9]\{3\}')
    echo "Доступ до /admin: $http_code" >> "$domain-$ip.txt"
  http_code=$(lynx -dump https://"$domain"/magento_version)
    echo "Версія: $http_code" >> "$domain-$ip.txt"
  read -p "Просканувати на вразливості? (yes/no): " scan_vulnerabilities
  if [[ $scan_vulnerabilities == "yes" ]]; then
    # Запуск nikto
    echo -e "\e[32m4) Можливі вразливості і версії софту \e[0m" >> "$domain-$ip.txt"
    nikto -host $domain >> "$domain-$ip.txt"
  else
    echo "Сканування на вразливості не запущено."
  fi
done

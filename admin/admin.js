const $ = (id) => document.getElementById(id);
const state = { generated:false, active:"docker", outputs:{} };
const safe = (value) => String(value ?? "").replace(/[&<>"']/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
const slugOk = v => /^[a-zA-Z0-9_-]{3,32}$/.test(v);
const vmInfo = {vm1:{name:"Docker VM 1",ip:"192.168.200.177"},vm2:{name:"Docker VM 2",ip:""},vm3:{name:"Docker VM 3",ip:""}};
function data(){const username=$("username").value.trim();const domain=$("domain").value.trim().toLowerCase();return {username,ros:$("ros").value,vm:$("dockerVm").value,vpnIp:$("vpnIp").value.trim(),dockerPort:$("dockerPort").value,domain,publicApi:$("publicApi").value,targetApi:$("targetApi").value,publicWinbox:$("publicWinbox").value,targetWinbox:$("targetWinbox").value,enableOlt:$("enableOlt").checked,publicOlt:$("publicOlt").value,targetOlt:$("targetOlt").value,mikhmonUser:$("mikhmonUser").value.trim(),mikhmonPass:$("mikhmonPass").value,vpnUser:$("vpnUser").value.trim(),vpnPass:$("vpnPass").value};}
function validate(d){if(!slugOk(d.username))return "Username hanya boleh huruf, angka, _ atau - (3–32 karakter).";if(!/^(?:[a-z0-9-]+)$/.test(d.domain))return "Subdomain tidak valid.";if(!/^\\d{1,3}(?:\\.\\d{1,3}){3}$/.test(d.vpnIp))return "Format IP VPN tidak valid.";for(const [k,v] of Object.entries({dockerPort:d.dockerPort,publicApi:d.publicApi,targetApi:d.targetApi,publicWinbox:d.publicWinbox,targetWinbox:d.targetWinbox,...(d.enableOlt?{publicOlt:d.publicOlt,targetOlt:d.targetOlt}:{})})){if(!Number.isInteger(Number(v))||Number(v)<1||Number(v)>65535)return "Port "+k+" harus antara 1–65535.";}if(d.publicApi===d.publicWinbox)return "Public API dan Winbox tidak boleh menggunakan port yang sama.";return "";}
function compose(d){if(d.ros==="7")return `version: "3.9"
services:
  mikhmon:
    image: stbbaru2024/mikhmonros7
    container_name: mikhmon-${d.username}
    ports:
      - "${d.dockerPort}:80"
    volumes:
      - ./mikhmon-data-${d.username}:/var/www/html
    restart: unless-stopped
`;return `version: '3.8'
services:
  mikhmon-${d.username}:
    image: animegasan/mikhmon:v3-latest
    container_name: mikhmon-${d.username}
    ports:
      - "${d.dockerPort}:80"
    volumes:
      - ./mikhmon-data/${d.username}:/opt/mikhmon/data
    restart: unless-stopped
`;}
function dockerScript(d){const base=d.ros==="7"?"/home/alam/mikhmon/":"/home/alam/mikhmon-alamhost/";const template=d.ros==="7"?"ros7":"ros6";let lines=[`cd ${base}`,`# Pastikan folder tujuan belum ada; jangan hapus data pelanggan yang sudah ada.`,`test ! -e "${d.username}" || { echo "Folder ${d.username} sudah ada; batalkan agar data tidak tertimpa."; exit 1; }`,`cp -a ${template} ${d.username}`];if(d.ros==="7")lines.push(`mv ${d.username}/mikhmon-data ${d.username}/mikhmon-data-${d.username}`);else lines.push(`mkdir -p ${d.username}/mikhmon-data/${d.username}`);lines.push(`cd ${d.username}`,`# Simpan docker-compose.yml hasil generator pada folder ini.`,`docker compose up -d`,`docker ps --filter "name=mikhmon-${d.username}"`);return lines.join("\n");}
function apache(d){const host=vmInfo[d.vm].ip||"DOCKER_VM_IP_FROM_BACKEND";return `<VirtualHost *:80>
    ServerName ${d.domain}.alamhost.com
    ProxyPreserveHost Off
    RequestHeader set Host "${host}:${d.dockerPort}"
    ProxyPass / http://${host}:${d.dockerPort}/
    ProxyPassReverse / http://${host}:${d.dockerPort}/
    ErrorLog ${"$"}{APACHE_LOG_DIR}/${d.username}_error.log
    CustomLog ${"$"}{APACHE_LOG_DIR}/${d.username}_access.log combined
    RewriteEngine on
    RewriteCond ${"$"}{SERVER_NAME} =${d.domain}.alamhost.com
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>

# Tahap enable site dan SSL dilakukan backend setelah validasi:
# a2ensite ${d.username}.conf
# apache2ctl configtest
# systemctl reload apache2
# certbot --apache -d ${d.domain}.alamhost.com
`;}
function nat(d){const lines=[`/ip firewall nat add chain=dstnat dst-address=103.112.162.253 protocol=tcp dst-port=${d.publicApi} action=dst-nat to-addresses=${d.vpnIp} to-ports=${d.targetApi} comment="${d.username}| API"`,`/ip firewall nat add chain=dstnat dst-address=103.112.162.253 protocol=tcp dst-port=${d.publicWinbox} action=dst-nat to-addresses=${d.vpnIp} to-ports=${d.targetWinbox} comment="${d.username}| Winbox"`];if(d.enableOlt)lines.push(`/ip firewall nat add chain=dstnat dst-address=103.112.162.253 protocol=tcp dst-port=${d.publicOlt} action=dst-nat to-addresses=${d.vpnIp} to-ports=${d.targetOlt} comment="${d.username}| OLT"`);return lines.join("\n");}
function client(d){return `INFO AKSES PELANGGAN
Username: ${d.username}
Domain: ${d.domain}.alamhost.com
Mikhmon: ${d.domain}.alamhost.com
User: ${d.mikhmonUser}
Password: ${d.mikhmonPass?"(diisi dari secret backend)":"(belum diatur)"}

API: ${d.domain}.alamhost.com:${d.publicApi}
Winbox: ${d.domain}.alamhost.com:${d.publicWinbox}

SCRIPT OPENVPN CLIENT (template dari config-mikhmon.src)
interface ovpn-client add name=${d.username}@alamhost.com connect-to=${d.domain}.alamhost.com user=${d.vpnUser} password=<PASSWORD_DARI_BACKEND> disabled=no

Catatan: password tidak dimasukkan ke frontend atau file publik. Backend akan mengambil secret dari konfigurasi server saat integrasi aktif.`;}
function generate(){const d=data();const err=validate(d);if(err){toast(err);return;}state.outputs={docker:compose(d)+"\n\n# Provisioning steps\n"+dockerScript(d),apache:apache(d),nat:nat(d),client:client(d)};state.generated=true;$("outputState").textContent="Konfigurasi dibuat";$("outputState").style.color="var(--green)";render();$("outputs").scrollIntoView({behavior:"smooth",block:"start"});toast("Konfigurasi berhasil dibuat.");}
function render(){const d=data();$("targetName").textContent=vmInfo[d.vm].name;$("targetIp").textContent=vmInfo[d.vm].ip||"IP dikelola backend";$("runtimeName").textContent="ROS "+d.ros+" · Docker";$("containerName").textContent="mikhmon-"+d.username;$("summaryPort").textContent=d.dockerPort+" → 80";$("summaryDomain").textContent=d.domain+".alamhost.com";if(state.generated){$("outputCode").textContent=state.outputs[state.active];$("outputTitle").textContent=({docker:"docker-compose.yml + provisioning",apache:"Apache VirtualHost",nat:"MikroTik NAT rules",client:"Informasi akses pelanggan"})[state.active];}}
function toast(msg){const el=$("toast");el.textContent=msg;el.classList.add("show");clearTimeout(toast.timer);toast.timer=setTimeout(()=>el.classList.remove("show"),2800);}
$("generateBtn").addEventListener("click",generate);
$("dockerVm").addEventListener("change",render);$("ros").addEventListener("change",render);["username","dockerPort","domain"].forEach(id=>$(id).addEventListener("input",render));
$("enableOlt").addEventListener("change",e=>$("oltFields").classList.toggle("hidden",!e.target.checked));
document.querySelectorAll(".tab").forEach(btn=>btn.addEventListener("click",()=>{document.querySelectorAll(".tab").forEach(b=>b.classList.remove("active"));btn.classList.add("active");state.active=btn.dataset.tab;render();}));
$("copyBtn").addEventListener("click",async()=>{if(!state.generated){toast("Generate konfigurasi terlebih dahulu.");return;}try{await navigator.clipboard.writeText(state.outputs[state.active]);toast("Konfigurasi disalin.");}catch{toast("Clipboard tidak tersedia di browser ini.");}});
document.querySelectorAll("[data-deploy]").forEach(btn=>btn.addEventListener("click",()=>toast("Backend deployment belum terhubung. Belum ada perintah server yang dijalankan.")));
$("customerForm").addEventListener("reset",()=>setTimeout(()=>{state.generated=false;state.outputs={};$("outputCode").textContent="Isi data pelanggan lalu klik “Generate konfigurasi”.";$("outputState").textContent="Belum dibuat";$("oltFields").classList.add("hidden");render();},0));
render();
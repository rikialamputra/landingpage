const $ = (id) => document.getElementById(id);
const state = { generated:false, active:"docker", outputs:{} };
const safe = (value) => String(value ?? "").replace(/[&<>"']/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
const slugOk = v => /^[a-zA-Z0-9_-]{3,32}$/.test(v);
const vmInfo = {vm1:{name:"Docker VM 1",ip:"192.168.200.177"},vm2:{name:"Docker VM 2",ip:"192.168.200.152"},vm3:{name:"Docker VM 3",ip:"192.168.200.182"}};
function data(){const username=$("username").value.trim();const domain=$("domain").value.trim().toLowerCase();return {username,ros:$("ros").value,vm:$("dockerVm").value,vpnIp:$("vpnIp").value.trim(),dockerPort:$("dockerPort").value,domain,publicApi:$("publicApi").value,targetApi:$("targetApi").value,publicWinbox:$("publicWinbox").value,targetWinbox:$("targetWinbox").value,enableOlt:$("enableOlt").checked,publicOlt:$("publicOlt").value,targetOlt:$("targetOlt").value,mikhmonUser:"mikhmon",mikhmonPass:"1234",vpnUser:username,vpnPass:"11223344",forwards:[...document.querySelectorAll(".forward-row")].map(row=>({publicPort:row.querySelector(".forward-public").value,targetPort:row.querySelector(".forward-target").value,protocol:row.querySelector(".forward-protocol").value,comment:row.querySelector(".forward-comment").value.trim()}))};}
function validate(d){if(!slugOk(d.username))return "Username hanya boleh huruf, angka, _ atau - (3–32 karakter).";if(!/^(?:[a-z0-9-]+)$/.test(d.domain))return "Subdomain tidak valid.";if(!/^\d{1,3}(?:\.\d{1,3}){3}$/.test(d.vpnIp))return "Format IP VPN tidak valid.";for(const [k,v] of Object.entries({dockerPort:d.dockerPort,publicApi:d.publicApi,targetApi:d.targetApi,publicWinbox:d.publicWinbox,targetWinbox:d.targetWinbox,...(d.enableOlt?{publicOlt:d.publicOlt,targetOlt:d.targetOlt}:{})})){if(!Number.isInteger(Number(v))||Number(v)<1||Number(v)>65535)return "Port "+k+" harus antara 1–65535.";}if(d.publicApi===d.publicWinbox)return "Public API dan Winbox tidak boleh menggunakan port yang sama.";const used=[Number(d.publicApi),Number(d.publicWinbox),...(d.enableOlt?[Number(d.publicOlt)]:[])];for(const [i,p] of d.forwards.entries()){for(const [k,v] of Object.entries({publicPort:p.publicPort,targetPort:p.targetPort})){if(!Number.isInteger(Number(v))||Number(v)<1||Number(v)>65535)return "Port forwarding tambahan #"+(i+1)+" tidak valid.";}if(used.includes(Number(p.publicPort)))return "Public port forwarding tambahan bentrok dengan port lain.";used.push(Number(p.publicPort));}return "";}
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
function dockerScript(d){
 const base=d.ros==="7"?"/home/alam/mikhmon":"/home/alam/mikhmon-alamhost";
 const template=d.ros==="7"?"ros7":"ros6";
 const folder=d.username,container="mikhmon-"+d.username;
 const image=d.ros==="7"?"stbbaru2024/mikhmonros7":"animegasan/mikhmon:v3-latest";
 const volume=d.ros==="7"?"./mikhmon-data-"+folder+":/var/www/html":"./mikhmon-data/"+folder+":/opt/mikhmon/data";
 const service=d.ros==="7"?"mikhmon":container;
 const compose="version: '"+(d.ros==="7"?"3.9":"3.8")+"'\nservices:\n  "+service+":\n    image: "+image+"\n    container_name: "+container+"\n    ports:\n      - '"+d.dockerPort+":80'\n    volumes:\n      - "+volume+"\n    restart: unless-stopped\n";
 const path=base+"/"+folder,cron=path+"/auto_restart.sh",log=path+"/restart_log.txt";
 const q=v=>"'"+String(v).replace(/'/g,"'\\''")+"'";
 const lines=["#!/usr/bin/env bash","set -Eeuo pipefail","BASE_DIR="+q(base),"TEMPLATE_DIR="+q(template),"CUSTOMER_DIR="+q(folder),"CONTAINER_NAME="+q(container),
 "cd \"$BASE_DIR\"","if [[ -e \"$CUSTOMER_DIR\" ]]; then echo 'Folder pelanggan sudah ada; dibatalkan agar data tidak tertimpa.' >&2; exit 1; fi",
 "if [[ ! -d \"$TEMPLATE_DIR\" ]]; then echo 'Folder template tidak ditemukan.' >&2; exit 1; fi",
 "command -v docker-compose >/dev/null 2>&1 || { echo 'docker-compose belum tersedia.' >&2; exit 1; }",
 "cp -a \"$TEMPLATE_DIR\" \"$CUSTOMER_DIR\"","cd \"$CUSTOMER_DIR\"",
 d.ros==="7"?"mv mikhmon-data "+q("mikhmon-data-"+folder):"mkdir -p "+q("mikhmon-data/"+folder),
 "cat > docker-compose.yml <<'COMPOSE_EOF'",...compose.trimEnd().split("\n"),"COMPOSE_EOF","docker-compose up -d",
 "cat > auto_restart.sh <<'RESTART_EOF'","#!/usr/bin/env bash","CONTAINER_NAME="+q(container),"URL="+q("http://localhost:"+d.dockerPort),"TIMEOUT=10","LOG_FILE="+q(log),
 "if ! docker inspect \"$CONTAINER_NAME\" >/dev/null 2>&1; then exit 0; fi","STARTED_AT=$(docker inspect -f '{{.State.StartedAt}}' \"$CONTAINER_NAME\")",
 "STARTED_SEC=$(date -d \"$STARTED_AT\" +%s 2>/dev/null || echo 0)","NOW_SEC=$(date +%s)","UPTIME_SEC=$((NOW_SEC - STARTED_SEC))",
 "if [[ \"$STARTED_SEC\" -eq 0 || \"$UPTIME_SEC\" -lt 120 ]]; then exit 0; fi",
 "HTTP_CODE=$(curl -s -o /dev/null -w '%{http_code}' --max-time \"$TIMEOUT\" \"$URL\" || true)",
 "if [[ \"$HTTP_CODE\" != 200 && \"$HTTP_CODE\" != 302 ]]; then"," echo \"$(date): Web hang (HTTP $HTTP_CODE). Restart container.\" >> \"$LOG_FILE\""," docker restart \"$CONTAINER_NAME\" >/dev/null","fi","RESTART_EOF","chmod +x auto_restart.sh",
 "CRON_LINE="+q("* * * * * "+cron+" >/dev/null 2>&1"),"(crontab -l 2>/dev/null | grep -Fv "+q(cron)+" || true; echo \"$CRON_LINE\") | crontab -",
 "docker ps --filter \"name=$CONTAINER_NAME\""];
 return lines.join("\n");
}
function apache(d){
 const vmIp=vmInfo[d.vm].ip;
 const domain=d.domain+".alamhost.com";
 const site=d.username+".conf";
 const sslSite=d.username+"-le-ssl.conf";
 const vhost=[
  "<VirtualHost *:80>",
  "    ServerName "+domain,
  "",
  "    ProxyPreserveHost Off",
  "    RequestHeader set Host \""+vmIp+":"+d.dockerPort+"\"",
  "",
  "    ProxyPass / http://"+vmIp+":"+d.dockerPort+"/",
  "    ProxyPassReverse / http://"+vmIp+":"+d.dockerPort+"/",
  "",
  "    ErrorLog \${APACHE_LOG_DIR}/"+d.username+"_error.log",
  "    CustomLog \${APACHE_LOG_DIR}/"+d.username+"_access.log combined",
  "",
  "    RewriteEngine on",
  "    RewriteCond %{SERVER_NAME} ="+domain,
  "    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]",
  "</VirtualHost>"
 ].join("\n");
 return [
  "a2dissite "+site,
  "a2dissite "+sslSite,
  "rm /etc/apache2/sites-available/"+site,
  "rm /etc/apache2/sites-available/"+sslSite,
  "",
  "sudo tee /etc/apache2/sites-available/"+site+" > /dev/null <<'EOF'",
  ...vhost.split("\n"),
  "EOF",
  "",
  "a2ensite "+site,
  "service apache2 restart",
  "certbot --apache -d "+domain
 ].join("\n");
}
function nat(d){const lines=[`/ip firewall nat add chain=dstnat dst-address=103.112.162.253 protocol=tcp dst-port=${d.publicApi} action=dst-nat to-addresses=${d.vpnIp} to-ports=${d.targetApi} comment="${d.username}| API"`,`/ip firewall nat add chain=dstnat dst-address=103.112.162.253 protocol=tcp dst-port=${d.publicWinbox} action=dst-nat to-addresses=${d.vpnIp} to-ports=${d.targetWinbox} comment="${d.username}| Winbox"`];if(d.enableOlt)lines.push(`/ip firewall nat add chain=dstnat dst-address=103.112.162.253 protocol=tcp dst-port=${d.publicOlt} action=dst-nat to-addresses=${d.vpnIp} to-ports=${d.targetOlt} comment="${d.username}| OLT"`);for(const p of d.forwards){if(p.publicPort&&p.targetPort){const note=(p.comment||"Custom forwarding").replace(/[^a-zA-Z0-9 _.-]/g,"").slice(0,32);lines.push(`/ip firewall nat add chain=dstnat dst-address=103.112.162.253 protocol=${p.protocol} dst-port=${p.publicPort} action=dst-nat to-addresses=${d.vpnIp} to-ports=${p.targetPort} comment="${d.username}| ${note}"`);}}return lines.join("\n");}
function client(d){
 const domain=d.domain+".alamhost.com";
 return [
  "INFO AKSES PELANGGAN",
  "Username: "+d.username,
  "Domain: "+domain,
  "Mikhmon: "+domain,
  "User: "+d.mikhmonUser,
  "Password: "+d.mikhmonPass,
  "",
  "API: "+domain+":"+d.publicApi,
  "Winbox: "+domain+":"+d.publicWinbox,
  "",
  "SCRIPT OPENVPN CLIENT",
  "interface ovpn-client add name="+d.username+"@alamhost.com connect-to="+domain+" user="+d.vpnUser+" password="+d.vpnPass+" disabled=no"
 ].join("\n");
}
function generate(){const d=data();const err=validate(d);if(err){toast(err);return;}state.outputs={docker:dockerScript(d),apache:apache(d),nat:nat(d),client:client(d)};state.generated=true;$("outputState").textContent="Konfigurasi dibuat";$("outputState").style.color="var(--green)";render();$("outputs").scrollIntoView({behavior:"smooth",block:"start"});toast("Konfigurasi berhasil dibuat.");}
function render(){const d=data();$("targetName").textContent=vmInfo[d.vm].name;$("targetIp").textContent=vmInfo[d.vm].ip||"IP dikelola backend";$("runtimeName").textContent="ROS "+d.ros+" · Docker";$("containerName").textContent="mikhmon-"+d.username;$("summaryPort").textContent=d.dockerPort+" → 80";$("summaryDomain").textContent=d.domain+".alamhost.com";if(state.generated){$("outputCode").textContent=state.outputs[state.active];$("outputTitle").textContent=({docker:"Docker provisioning script (copy & paste)",apache:"Apache VirtualHost",nat:"MikroTik NAT rules",client:"Informasi akses pelanggan"})[state.active];}}
function toast(msg){const el=$("toast");el.textContent=msg;el.classList.add("show");clearTimeout(toast.timer);toast.timer=setTimeout(()=>el.classList.remove("show"),2800);}
$("generateBtn").addEventListener("click",generate);
$("dockerVm").addEventListener("change",render);$("ros").addEventListener("change",render);["username","dockerPort","domain"].forEach(id=>$(id).addEventListener("input",render));
$("enableOlt").addEventListener("change",e=>$("oltFields").classList.toggle("hidden",!e.target.checked));
document.querySelectorAll(".tab").forEach(btn=>btn.addEventListener("click",()=>{document.querySelectorAll(".tab").forEach(b=>b.classList.remove("active"));btn.classList.add("active");state.active=btn.dataset.tab;render();}));
$("copyBtn").addEventListener("click",async()=>{if(!state.generated){toast("Generate konfigurasi terlebih dahulu.");return;}try{await navigator.clipboard.writeText(state.outputs[state.active]);toast("Konfigurasi disalin.");}catch{toast("Clipboard tidak tersedia di browser ini.");}});
document.querySelectorAll("[data-deploy]").forEach(btn=>btn.addEventListener("click",()=>toast("Backend deployment belum terhubung. Belum ada perintah server yang dijalankan.")));
$("customerForm").addEventListener("reset",()=>setTimeout(()=>{state.generated=false;state.outputs={};$("outputCode").textContent="Isi data pelanggan lalu klik “Generate konfigurasi”.";$("outputState").textContent="Belum dibuat";$("oltFields").classList.add("hidden");render();},0));

function addForwardRow(){const row=document.createElement("div");row.className="forward-row";row.innerHTML='<label class="field"><span>Public port</span><input class="forward-public" type="number" min="1" max="65535" placeholder="Contoh 63210"></label><label class="field"><span>Target port</span><input class="forward-target" type="number" min="1" max="65535" placeholder="Contoh 8729"></label><label class="field"><span>Protocol</span><select class="forward-protocol"><option value="tcp">TCP</option><option value="udp">UDP</option></select></label><label class="field"><span>Keterangan</span><input class="forward-comment" maxlength="32" placeholder="Contoh SSH / OLT"></label><button type="button" class="remove-forward" aria-label="Hapus port forwarding">×</button>'; $("forwardList").appendChild(row);}
$("addForward").addEventListener("click",addForwardRow);
$("forwardList").addEventListener("click",e=>{if(e.target.classList.contains("remove-forward"))e.target.closest(".forward-row").remove();});
$("forwardList").addEventListener("input",()=>{if(state.generated)generate();});
$("forwardList").addEventListener("change",()=>{if(state.generated)generate();});
function applyTheme(theme){document.body.dataset.theme=theme;const light=theme==="light";$("themeIcon").textContent=light?"☾":"☀";$("themeLabel").textContent=light?"Dark mode":"Light mode";}
const savedTheme=localStorage.getItem("alamhost-admin-theme")||"dark";applyTheme(savedTheme);
$("themeToggle").addEventListener("click",()=>{const next=document.body.dataset.theme==="light"?"dark":"light";applyTheme(next);localStorage.setItem("alamhost-admin-theme",next);});

render();

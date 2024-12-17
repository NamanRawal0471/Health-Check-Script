### **Project Title: Automated Server Health Check & Alert System** 🚦📧  

---

### **Overview**  
This project implements an **automated health check system** for multiple servers categorized under different server types. It performs regular health checks for each server by hitting their health endpoints and **notifies administrators** via email if any server is unresponsive or encounters issues.

---

### **Key Features**  

1. **Health Check Automation**:  
   - The script iterates through servers of six predefined types (`ServerType1` to `ServerType6`), checking their respective health URLs using `curl`.  
   - It evaluates HTTP response codes like **200 (OK)** and **503 (Service Unavailable)** to determine server health.  
   - Servers returning any other response codes are flagged as **down**.

2. **Dynamic Configuration**:  
   - Servers are grouped into associative arrays (`declare -A`), where each server has a **name** and corresponding **IP address**.  
   - Health check URLs are dynamically built for each server based on its IP and endpoint structure.

3. **Centralized Alert System**:  
   - If servers are detected as **unresponsive**, an alert message is constructed containing details such as:  
     - Server Name  
     - Server IP  
     - Health Check URL  
   - The notification is sent to a designated email address (`TO` variable) using the `mail` command.

4. **Custom Health Endpoints**:  
   - Each server type has a slightly different health check URL structure (e.g., `/v1/healthcheck`, `/health`, or `/healthcheck?pretty=true`).  
   - The script handles these variations seamlessly.

---

### **Tech Stack**  
- **Bash Script**: Used for automating the process and looping through server types.  
- **curl**: To perform HTTP requests and capture server responses.  
- **mail**: For sending automated email alerts.  
- **Linux Utilities**: File handling, loops, and temporary storage (`/tmp`).

---

### **Workflow**  
1. **Initialize Server Data**: Define servers and IPs for six server types.  
2. **Perform Health Check**: The `perform_health_check` function evaluates server responses by querying their health endpoints.  
3. **Capture Alerts**: If a server response is not 200/503, its details are appended to the `SERVER_DOWN_ALERTS` list.  
4. **Send Notifications**: If any server fails the health check, an email alert is generated and sent to the administrator.

---

### **Use Case**  
This project ensures **proactive monitoring** of critical servers in **QA/Staging environments**. It enables IT teams to detect issues early, minimize downtime, and quickly address server failures without manual intervention.

---

### **Benefits**  
✅ **Automation**: Reduces manual effort in server health monitoring.  
✅ **Scalability**: Easily extendable to include more server types and endpoints.  
✅ **Timely Notifications**: Immediate alerts help teams act on server issues quickly.  
✅ **Customization**: Flexible URL structures and configurations for different server types.  

---

**Output**: An automated **email notification** listing all servers that are down, ensuring real-time visibility into infrastructure health. 🚨

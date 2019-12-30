#Dockerfile for the AppDynamics Standalone Machine Agent and Cisco UCS extension.
# The extension supports PowershellCore wich can run on Linux. The base image is Ubuntu OS

FROM mcr.microsoft.com/powershell

# Install required packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y unzip && \
    apt-get clean

# Install AppDynamics Machine Agent
ENV MACHINE_AGENT_HOME /opt/appdynamics/machine-agent/
COPY machineagent*.zip /tmp/ 
RUN mkdir -p ${MACHINE_AGENT_HOME} && \
    unzip -oq /tmp/machineagent*.zip -d ${MACHINE_AGENT_HOME} && \
    rm /tmp/machineagent*.zip


# Include AppDynamics UCS Extension 
COPY ucs-monitoring-extension* ${MACHINE_AGENT_HOME}/monitors/ucs-monitoring-extension
RUN chmod 744 ${MACHINE_AGENT_HOME}/monitors/ucs-monitoring-extension/run.sh

# Include start script to configure and start MA at runtime
ADD start-appdynamics ${MACHINE_AGENT_HOME}
RUN chmod 744 ${MACHINE_AGENT_HOME}/start-appdynamics

# Configure and Run AppDynamics Machine Agent
CMD "${MACHINE_AGENT_HOME}/start-appdynamics"

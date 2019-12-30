## Containarising Cisco UCS AppDynamics Monitoring Extension 

This project contains docker artefacts and instructions on how to configure and run the Cisco UCS Monitoring Extension in docker container. All AppDynamics extensions uses the Standalone Machine Agent, this instruction also contains how to enable Docker Visibility -  if required. 
 
To build and run this script, you should be running Docker API version 1.27 or higher (to find out your version, run: `docker version`). The configuration uses the Microsoft Powershell Core docker image which uses Ubuntu as a base image and packages the standalone Machine Agent (with bundled JRE). In addition, it uses a simple Bash shell script that starts the Machine Agent with the correct system properties to connect to your Controller - you would need to supply these values as environment variables via the docker-compose.yml file.

To build and run the project:

1. Clone this repo and `cd ucs-monitoring-extension-docker`

2. Edit the docker-compose.yml file with the host, port, account name, access key and SSL connection details for your Controller. Please see the [product documentation](https://docs.appdynamics.com/display/latest/Standalone+Machine+Agent+Configuration+Properties)  for details of how to configure these properties, which allow the Machine Agent to connect to your Controller instance.

3. Download the Machine Agent ZIP bundle with JRE (64-bit Linux) from the [AppDynamics Download Site](https://download.appdynamics.com), copy it to your project directory as is. 

4. Download the Cisco UCS Extension from the [AppDynamics Extensions site](https://www.appdynamics.com/community/exchange/cisco-ucs-monitoring-extension/) then edit the `config.json` file and run the `Setup.ps1`  as described in the documentation. The purpose of running the `Setup.ps1` script are to generate UCS encrypted credentials, create analytics schemas and to generate ServiceNow credentials (if in use).  Doing this will require Powershell to be installed on the build machine, alternatively, sping up the container, run the Setup in the container, copy all files in the extension folder to the build machine then rebuild the image. 

5.  Docker Container monitoring requires a Server Visibility license and version 4.3.3 or higher of both the Controller and the Standalone Machine Agent. If you are only interested in running the Cisco UCS extension without the additional benefits of Server/Docker Visibility, you will be required to set the following flags to false in the `start-appdynamics` bash script as shown below: 

>     MA_PROPERTIES+=" -Dappdynamics.sim.enabled=false"
>     MA_PROPERTIES+=" -Dappdynamics.docker.enabled=false"

Setting the above properties to false saves you one Server Visibility license, it will, howeever, use one basic machine agent license. 

6. Run `docker-compose up`

The first time you run this command, you will see a lot of console output as the Docker image is built, followed by output similar to this:

```
ucs-monitoring-extension-docker $ docker-compose up
Creating docker-cisco-ucs-extension ... done
Attaching to docker-cisco-ucs-extension
docker-cisco-ucs-extension | Using Java Version [1.8.0_231] for Agent
docker-cisco-ucs-extension | Using Agent Version [Machine Agent v4.5.16.2357 GA compatible with 4.4.1.0 Build Date 2019-11-06 21:59:42]
docker-cisco-ucs-extension | [INFO] Agent logging directory set to: [/opt/appdynamics/machine-agent]
docker-cisco-ucs-extension | ERROR StatusLogger No Log4j 2 configuration file found. Using default configuration (logging only errors to the console), or user programmatically provided configurations. Set system property 'log4j2.debug' to show Log4j 2 internal initialization logging. See https://logging.apache.org/log4j/2.x/manual/configuration.html for instructions on how to configure Log4j 2
docker-cisco-ucs-extension | Machine Agent Install Directory :/opt/appdynamics/machine-agent
docker-cisco-ucs-extension | Machine Agent Temp Directory :/opt/appdynamics/machine-agent/tmp
docker-cisco-ucs-extension | Tasks Root Directory :/opt/appdynamics/machine-agent/controlchannel
docker-cisco-ucs-extension | [INFO] Agent logging directory set to: [/opt/appdynamics/machine-agent]
docker-cisco-ucs-extension | Redirecting all logging statements to the configured logger
docker-cisco-ucs-extension | Started AppDynamics Machine Agent Successfully.
```
### Troubleshooting Commands

- View the Machine Agent log: `docker exec -it docker-cisco-ucs-extension bash -c "tail -f /opt/appdynamics/machine-agent/logs/machine-agent.log"`

- Stop the container: `docker-compose stop`

- Rebuild the container: `docker-compose up --build`
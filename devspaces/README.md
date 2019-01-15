# DevFactory DevSpaces Development Environment

**DevFactory DevSpaces Development Environment** (DE) allows developers to run the Snipe-IT Application inside a Docker Container.

For that, we need to do some preliminary Local Setup and then actually run the Container with Development Servers inside of it.

## But What Servers Will Be Running in DE

The Docker Container will be running the following Development Servers:

|Server|Exposing Ports|Description|
|------|--------------|-----------|
|Apache 2.4|80 [HTTP]|Snipe-IT Application|
|MySQL 5.6|3306|Database Listener [user=root pass=snipeit]|

## Local Setup

### Minimum Requirements

* Docker.

To make use of the DE, a preliminary Local Setup is required. Please proceed with the following instructions:

[dfds-ui]: https://www.devspaces.io
[dfds-faq]: https://devspaces.io/devspaces/help
[app-repo]: https://github.com/trilogy-group/snipe-it
[sync-ui]: http://localhost:49152/
[docker-hub]: https://cloud.docker.com
[snipeit-docs]: https://snipe-it.readme.io/docs
[dfds-support-slack]: https://devfactorydev.slack.com/messages/CA3FB78BS

1. Login in [DevSpaces UI][dfds-ui] with your GitHub Account. The first time you will have to authorize some permissions to DevFactory in order to work properly.

2. Once logged in, install the DevSpaces CLI tools by clicking the link inside the warning message:

    >*The DevSpaces Client is not running. Please...*

3. Clone the Repository [Snipe-IT App][app-repo], now the `APP_REPO`.

4. Inside the `APP_REPO/devspaces/docker/assets/setup` folder, update the `mail-params.sh` with your SMTP client info.

## Create the Docker Container Configuration

With Local Setup in place, now it's possible to create the Docker Container Configuration in your DevSpaces. Please proceed with the following commands:

    cd APP_REPO/devspaces/docker
    devspaces create

As a output you will see the following:

    / Starting DevSpace creation ...

    - DevSpace trilogy-snipe-it was created. The build/validation process is now in progress

After that, a popup window `'trilogy-snipe-it Build Status'` gets up and displays logs for the building process.

You must wait for the build/validation process to finish before continuing on to the next Section and it may take some time. At the end of the building process, a success message will appear like:

>*`Phase complete: POST_BUILD Success: true`*

This popup window could stop listen for build events and seems stuck. In that case and at any time you can:

1. Resume the listening by clicking the Link `'Resume Tailing Log'` located in the lower left corner.
2. Close and reopen it with the command:

        devspaces info trilogy-snipe-it --buildstatus

On the other hand, the validation process also happens asynchronously, so you should wait for a successful validation message in your email inbox or in the Taskbar Notification Area.

### What Does The 'create' Command Do?

1. Create a new Docker Container Configuration called `trilogy-snipe-it` in your DevSpaces with information coming from the file `devspaces.yml` and the `Dockerfile` itself.

2. Trigger the aforementioned build/validation process.

At the end of this process you can see the Configuration in the [DevSpaces User Interface][dfds-ui] with status `Stopped`, but in the middle with status `Building`, `Creating` and `Validating`.

## Start the Docker Container

With the Docker Container Configuration in place and validated, now it's possible to start the Docker Container with the Development Servers running on it. Please proceed with the following command:

    devspaces start trilogy-snipe-it

As a output you will see something like:

    - DevSpace trilogy-snipe-it instance is starting and will synchronized with your local folder: C:\Users\Jaime Bravo\AppData\Roaming\DevSpaces\devfactory\DevSpaces\trilogy-snipe-it-04 after this DevSpace is ready

### What Does The 'start' Command Do?

1. Create and Start a new Docker Container.
2. Start MySQL Server.
3. Bind a Local Tempory Folder (created on the fly) to the Remote Folder `/data`. We change this in the next Section.
4. Create a Public DNS Name, so you can hit your Development Servers.

At the end of its execution you can see the `trilogy-snipe-it` Configuration in the [DevSpaces User Interface][dfds-ui] with status `Running`.

## Bind to the Docker Container

With the Docker Container running, now it's possible to bind the Local Repository `APP_REPO`. Please proceed with the following commands:

    cd APP_REPO
    devspaces bind trilogy-snipe-it

As a output you will see something like:

    / Syncing DevSpace trilogy-snipe-it...

    - The directory 'APP_REPO' will now be synchronized with DevSpace trilogy-snipe-it

### What Does The 'bind' Command Do?

Bind (rsync) your Local Repository Folder to the Container's Folder `/data`, the Remote Repository Path.

NOTES:

1. You can see the status and progress of synchronization through this [Local Web UI][sync-ui].
2. Sometimes this command could take time because the rsync (which can be optimized).

## Query Docker Container Info

To see the Docker Container Information (Public DNS Name and Port Mapping mostly), just:

    devspaces info trilogy-snipe-it

An output example of this after starting the Docker Container is as follows:

    DevSpace     : trilogy-snipe-it
    Folder       : F:\trabajo\git\trilogy\snipe-it
    Status       : Active
    Created Date : 2019-01-14
    Start Date   : 2019-01-14
    Uptime       : 00:06 Hours
    Docker Image : Docker image built for this DevSpace 39 minutes ago by jaime-bravo

    URLs

            tcp://trilogy-snipe-it.jaime-bravo.devspaces.io:54386 (to 3306)
            http://trilogy-snipe-it.jaime-bravo.devspaces.io:12710 (to 80)

    Ports
            3306            tcp
            80              http

    Environment Variables
    You don't have any environment variables added yet

## Connect to the Docker Container

Now with the Container running and the Local Repository binded, it's possible to get inside of it, where more commands needs to be execute in order to get all the thing up and running properly. For that, just execute the following command:

    devspaces exec trilogy-snipe-it

### What Does The 'exec' Command Do?

1. Open a popup window `'DevSpaces exec -- Bash ******...'`.
2. Start a new shell as `root` user inside the Docker Container.

When you finish working with the Docker Container, type `exit`.

## Inside the Container

Now inside the Container, it's possible start the Snipe-IT Application with the following command:

    /snipe-it-start.sh <host> <http_port>

The `host`and `http_port` parameters should be taken from `'Query Docker Container Info'` Section.

## Stop Docker Container

To stop the Docker Container, just:

    devspaces stop trilogy-snipe-it

As a output you will see something like:

    / Stopping DevSpace trilogy-snipe-it...

    - DevSpace trilogy-snipe-it is stopping

After a while you can see the `trilogy-snipe-it` Configuration in the [DevSpaces User Interface][dfds-ui] with status `Stopped` again.

## Rebinding Folders

If you suspect about synchronization stop working fine, you can rebind by just following the instruccions from `'Bind to the Docker Container'` Section again.

## Optimizing File Synchronization

When you bind your Local Repository Folder `APP_REPO` to the Container's Folder `/data`, all the files will be synchronized by default. If you think there is no point in synchronizing some specific folders or files, such as those temporarily generated by an IDE or any other Tool, then here you have a room for optimization.

So to exclude such files, just include paths or glob patterns inside the `sync-ignore` directive from `APP_REPO/devspaces/docker/devspaces.yml` file.

## About the DevSpaces User Interface

The [DevSpaces User Interface][dfds-ui] allows you to see the Docker Container Configurations authored by you and the status of the Docker Containers launched from those configurations inside your DevSpaces. In the case of Snipe-IT Application, you can observe the following when you are logged in:

The Main Section `My DevSpaces` showing your Docker Container Configuration for the Application called `trilogy-snipe-it`. Its row contains a button where you can manage the Docker Container, see and modify the Configuration details.

## Running Snipe-IT Application via Docker-Compose File

### Additional Requirements

* Docker Compose Tool.
* Bash Shell.

### Docker Container Management

Before issue any command, move to the right place:

    cd APP_REPO/devspaces

The following commands handle the life cycle of a Docker Container Service called `trilogy-snipe-it` and are quite similar to those already explained:

|Command|Action|
|-------|------|
|`./docker-cli.sh deploy`|Deploy & Start a New Docker Container Service|
|`./docker-cli.sh exec`|Connect to the Docker Container|
|`./docker-cli.sh stop`|Stop the Docker Container Service|
|`./docker-cli.sh start`|Start the Docker Container Service (should be used only after `stop` command)|
|`./docker-cli.sh undeploy`|Stop & Undeploy the Docker Container Service|

## Troubleshooting

### DevSpaces Creation ends with a Build Failed Status

An unexpected status of `Build Failed` could be observed even though the Build Logs shows a Successful Build. In such case it's necessary retry the whole process, doing the following:

    cd APP_REPO/devspaces/docker
    devspaces update

### Unauthorized on DevSpaces Exec Command

The following unexpected result could be output by execution of the command `devspaces exec trilogy-snipe-it`:

    error: You must be logged in to the server (Unauthorized)

    x Something is wrong with your DevSpace, try to execute the command again, or try to restart the DevSpace!

To overcome this problem, follow the steps below:

1. Exit from the DevSpaces CLI Tool from the Taskbar.
2. Log out from the [DevSpaces User Interface][dfds-ui].
3. Log in again with your Github Account.
4. Try twice the same command `devspaces exec trilogy-snipe-it`.
    * The first time, it launches the CLI Tool but doesn't execute the command itself.
    * The second time is actual command execution.

### Other Issues

In case of any other problem, doubt or just by curiosity:

* Visit the [DevSpaces Documentation][dfds-faq].
* Request online assistance through the [DevSpaces Support][dfds-support-slack] Slack Channel.
* Take a look at the [Snipe-IT Documentation][snipeit-docs].

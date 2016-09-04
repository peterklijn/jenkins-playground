# Jenkins playground

Run the container with the following command:

```
docker run -p 8080:8080 -v ~/path/to/a/dir/on/your/system:/var/jenkins_home/jobs/seed/workspace xebia/jenkins-playground:2.7.3-0
```

This will start Jenkins at port 8080 at your local machine with a volume mount from your local machine which will be your Jenkins playground.

Now two things can happen:

* The folder you mounted contains files, in which case Jenkins will assume you want to continue where you left off last time, and will rebuild your playground infrastructure how you left it.
* The folder you mounted is empty, in which case Jenkins will assume this is the first time you ran this container, and will add some example code to get you going.

Everytime a filechange will happen in that folder, the seedjob will automatically trigger, happy coding :)

## Conventions

Please keep to the following conventions:

* Jobs or scripts generating multiple jobs should be placed in the root of this directory.
* Commonly used functions/closures/parts of your job definition should be placed in the helpers folder.

## Pre-installed plugins

* ansicolor
* greenballs
* groovy-postbuild
* rebuild
* postbuildscript
* job-dsl
* workflow-aggregator
* ws-cleanup

package helpers

static addColorAndTimestampWrappers() {
  { -> colorizeOutput(); timestamps() }
}

static listViewColumnConfiguration() {
  { ->
    status()
    weather()
    name()
    lastSuccess()
    lastFailure()
    lastDuration()
    buildButton()
  }
}

static addBuildScript(script) {
  { -> shell(script) }
}

static addPostBuildScript(script) {
  { project ->
    project / publishers << 'org.jenkinsci.plugins.postbuildscript.PostBuildScript' {
      buildSteps {
        'hudson.tasks.Shell' { command(script) }
      }
      scriptOnlyIfSuccess(false)
      scriptOnlyIfFailure(false)
      markBuildUnstable(true)
    }
    (project / 'quietPeriod').setValue(0)
  }
}

static addEnvironmentInjectFilePath(filePath) {
  { project ->
    project / publishers << 'org.jenkinsci.plugins.postbuildscript.PostBuildScript' {
      buildSteps {
        EnvInjectBuilder {
          info {
            propertiesFilePath(filePath)
          }
        }
      }
    }
  }
}

static addProjectConfiguration() {
  { project ->
    (project / 'quietPeriod').setValue(0)
    (project / 'disabled').setValue(false)
    (project / 'concurrentBuild').setValue(false)
    (project / 'blockBuildWhenDownstreamBuilding').setValue(false)
    (project / 'blockBuildWhenUpstreamBuilding').setValue(false)
  }
}

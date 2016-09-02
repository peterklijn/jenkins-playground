import static helpers.common.*

canary_script = """#!/bin/bash
  |echo "Hello world!"
  |""".stripMargin()

job('canary') {
  description 'canary description'
  steps addBuildScript(canary_script)
}

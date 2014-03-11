exec = require("child_process").exec

module.exports =
  configDefaults: {
    args: ''
  },
  activate: ->
    atom.workspaceView.command "ti-build-atom:build", (event) =>
      @build()

  build: ->
    projectpath = atom.project?.getPath()
    if projectpath
      exec "titanium build --platform iphone --target simulator --log-level debug -q --project-dir #{projectpath}", (error, stdout, stderr) ->
        console.log "---------stdout: ---------\n" + stdout  if stdout isnt ""
        console.log "---------stderr: ---------\n" + stderr  if stderr isnt ""
        console.log "---------exec error: ---------\n[" + error + "]"  if error isnt null
        return

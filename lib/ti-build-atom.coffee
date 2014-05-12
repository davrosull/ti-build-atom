{$, $$, SelectListView, BufferedProcess} = require 'atom'
exec = require("child_process").exec

module.exports =
class TiBuildView extends SelectListView
  @activate: ->
    new TiBuildView

  keyBindings: null

  initialize: ->
    super
    @addClass('ti-build-atom overlay from-top')

    # @setItems([{ "id":"1", "name":"iOS Device", "key":"⌘⌥D" },
    # { "id":"2", "name":"iOS Simulator - iPhone (3.5 inch)", "key":"" },
    # { "id":"3", "name":"iOS Simulator - iPhone (4 inch)", "key":"⌘⌥1" },
    # { "id":"4", "name":"iOS Simulator - iPad", "key":"" },
    # { "id":"5", "name":"iOS Simulator - iPad Retina", "key":"⌘⌥2" },
    # { "id":"6", "name":"Android Device", "key":"⌘⌥A" },
    # { "id":"0", "name":"Clean", "key":"⌘⌥C"}])

    @setItems([{ "id":"2", "name":"iOS Simulator - iPhone (3.5 inch)", "key":"" },
    { "id":"3", "name":"iOS Simulator - iPhone (4 inch)", "key":"⌘⌥1" },
    { "id":"4", "name":"iOS Simulator - iPad", "key":"" },
    { "id":"5", "name":"iOS Simulator - iPad Retina", "key":"⌘⌥2" },
    { "id":"6", "name":"Android - Device", "key":"⌘⌥3" },
    { "id":"0", "name":"Clean", "key":"⌘⌥C"}])

    atom.workspaceView.command 'ti-build-atom:toggle', =>
      @toggle()

    atom.workspaceView.command "ti-build-atom:clean", (event) =>
      @clean()

    atom.workspaceView.command "ti-build-atom:iphoneSimulator", (event) =>
      @iphoneSimulator()

    atom.workspaceView.command "ti-build-atom:ipadSimulator", (event) =>
      @ipadSimulator()

    atom.workspaceView.command "ti-build-atom:androidDevice", (event) =>
      @androidDevice()

  getFilterKey: ->
    'name'

  toggle: ->
    if @hasParent()
      @cancel()
    else
      @attach()

  attach: ->
    atom.workspaceView.append(this)
    @focusFilterEditor()

  viewForItem: (item) ->
    $("<li class='event'>#{item.name} <div class='pull-right'><kbd class='key-binding'>#{item.key}</kbd></div></li>")

  confirmed: (item) ->
    @cancel()
    console.log("Building for: #{item.name}")
    id = item.id
    switch id
      when '1'
        @build('iphone', 'all', 'device')
      when '2'
        @build('iphone', 'iPhone Retina (3.5 inch)', 'simulator')
      when '3'
        @build('iphone', 'iPhone Retina (4 inch)', 'simulator')
      when '4'
        @build('iphone', 'iPad', 'simulator')
      when '5'
        @build('iphone', 'iPad Retina', 'simulator')
      when '6'
        @build('android', 'all', 'device')
      when '0'
        @clean()

  clean: ->
    console.log("Cleaning the Build Directory")
    projectpath = atom.project?.getPath()
    if projectpath
      command = "titanium"
      args = ["clean" , "-d" , projectpath ]
      stdout = (output) -> console.log(output)
      process = new BufferedProcess({command, args, stdout})


  build: (platform, device, target) ->
    console.log("Running on device/simulator")
    projectpath = atom.project?.getPath()
    if projectpath
      command = "titanium"
      args = ["build" ,"--platform" ,platform,"-C",device, "-T",target, "-d" , projectpath ]
      stdout = (output) -> console.log(output)
      process = new BufferedProcess({command, args, stdout})

        #return

  iosDevice: ->
    @build('iphone', 'all', 'device')

  iphoneSimulator: ->
    @build('iphone', 'iPhone Retina (4 inch)', 'simulator')

  ipadSimulator: ->
    @build('iphone', 'iPad Retina', 'simulator')

  androidDevice: ->
    @build('android', 'all', 'device')

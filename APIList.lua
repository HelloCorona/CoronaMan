local Class = {}

-- 코로나 API 리스트
Class.list = {
    "audio.dispose()",
    "audio.fade()",
    "audio.fadeOut()",
    "audio.findFreeChannel()",
    "audio.freeChannels",
    "audio.getDuration()",
    "audio.getMaxVolume()",
    "audio.getMinVolume()",
    "audio.getVolume()",
    "audio.isChannelActive()",
    "audio.isChannelPaused()",
    "audio.isChannelPlaying()",
    "audio.loadSound()",
    "audio.loadStream()",
    "audio.pause()",
    "audio.play()",
    "audio.reserveChannels()",
    "audio.reservedChannels",
    "audio.resume()",
    "audio.rewind()",
    "audio.seek()",
    "audio.setMaxVolume()",
    "audio.setMinVolume()",
    "audio.setVolume()",
    "audio.stop()",
    "audio.stopWithDelay()",
    "audio.totalChannels",
    "audio.unreservedFreeChannels",
    "audio.unreservedUsedChannels",
    "audio.usedChannels",
    "composer.getScene()",
    "composer.getSceneName()",
    "composer.getVariable()",
    "composer.gotoScene()",
    "composer.hideOverlay()",
    "composer.isDebug",
    "composer.loadScene()",
    "composer.newScene()",
    "composer.recycleAutomatically",
    "composer.recycleOnLowMemory",
    "composer.recycleOnSceneChange",
    "composer.removeHidden()",
    "composer.removeScene()",
    "composer.setVariable()",
    "composer.showOverlay()",
    "composer.stage",
    "crypto.digest()",
    "crypto.hmac()",
    "crypto.md4",
    "crypto.md5",
    "crypto.sha1",
    "crypto.sha224",
    "crypto.sha256",
    "crypto.sha384",
    "crypto.sha512",
    "display.actualContentHeight",
    "display.actualContentWidth",
    "display.capture()",
    "display.captureBounds()",
    "display.captureScreen()",
    "display.colorSample()",
    "display.contentCenterX",
    "display.contentCenterY",
    "display.contentHeight",
    "display.contentScaleX",
    "display.contentScaleY",
    "display.contentWidth",
    "display.currentStage",
    "display.fps",
    "display.getCurrentStage()",
    "display.getDefault()",
    "display.imageSuffix",
    "display.loadRemoteImage()",
    "display.newCircle()",
    "display.newContainer()",
    "display.newEmbossedText()",
    "display.newEmitter()",
    "display.newGroup()",
    "display.newImage()",
    "display.newImageRect()",
    "display.newLine()",
    "display.newPolygon()",
    "display.newRect()",
    "display.newRoundedRect()",
    "display.newSnapshot()",
    "display.newSprite()",
    "display.newText()",
    "display.pixelHeight",
    "display.pixelWidth",
    "display.remove()",
    "display.save()",
    "display.screenOriginX",
    "display.screenOriginY",
    "display.setDefault()",
    "display.setDrawMode()",
    "display.setStatusBar()",
    "display.statusBarHeight",
    "display.topStatusBarContentHeight",
    "display.viewableContentHeight",
    "display.viewableContentWidth",
    "assert()",
    "collectgarbage()",
    "error()",
    "getfenv()",
    "getmetatable()",
    "ipairs()",
    "next()",
    "pairs()",
    "pcall()",
    "print()",
    "rawequal()",
    "rawget()",
    "rawset()",
    "select()",
    "setfenv()",
    "setmetatable()",
    "tonumber()",
    "tostring()",
    "type()",
    "unpack()",
    "graphics.defineEffect()",
    "graphics.newImageSheet()",
    "graphics.newMask()",
    "graphics.newOutline()",
    "graphics.newTexture()",
    "graphics.releaseTextures()",
    "io.close()",
    "io.flush()",
    "io.input()",
    "io.lines()",
    "io.open()",
    "io.output()",
    "io.read()",
    "io.tmpfile()",
    "io.type()",
    "io.write()",
    "json.decode()",
    "json.encode()",
    "json.prettify()",
    "licensing.init()",
    "licensing.verify()",
    "math.abs()",
    "math.acos()",
    "math.asin()",
    "math.atan()",
    "math.atan2()",
    "math.ceil()",
    "math.cos()",
    "math.cosh()",
    "math.deg()",
    "math.exp()",
    "math.floor()",
    "math.fmod()",
    "math.frexp()",
    "math.huge",
    "math.inf",
    "math.ldexp()",
    "math.log()",
    "math.log10()",
    "math.max()",
    "math.min()",
    "math.modf()",
    "math.pi",
    "math.pow()",
    "math.rad()",
    "math.random()",
    "math.randomseed()",
    "math.round()",
    "math.sin()",
    "math.sinh()",
    "math.sqrt()",
    "math.tan()",
    "math.tanh()",
    "media.RemoteSource",
    "media.capturePhoto()",
    "media.captureVideo()",
    "media.getSoundVolume()",
    "media.hasSource()",
    "media.newEventSound()",
    "media.newRecording()",
    "media.pauseSound()",
    "media.playEventSound()",
    "media.playSound()",
    "media.playVideo()",
    "media.save()",
    "media.selectPhoto()",
    "media.selectVideo()",
    "media.setSoundVolume()",
    "media.show()",
    "media.stopSound()",
    "native.canShowPopup()",
    "native.cancelAlert()",
    "native.cancelWebPopup()",
    "native.getFontNames()",
    "native.getProperty()",
    "native.getSync()",
    "native.newFont()",
    "native.newMapView()",
    "native.newTextBox()",
    "native.newTextField()",
    "native.newVideo()",
    "native.newWebView()",
    "native.requestExit()",
    "native.setActivityIndicator()",
    "native.setKeyboardFocus()",
    "native.setProperty()",
    "native.setSync()",
    "native.showAlert()",
    "native.showPopup()",
    "native.showWebPopup()",
    "native.systemFont",
    "native.systemFontBold",
    "network.canDetectNetworkStatusChanges",
    "network.cancel()",
    "network.download()",
    "network.request()",
    "network.setStatusListener()",
    "network.upload()",
    "os.clock()",
    "os.date()",
    "os.difftime()",
    "os.execute()",
    "os.exit()",
    "os.remove()",
    "os.rename()",
    "os.time()",
    "package.loaded",
    "package.loaders",
    "module()",
    "require()",
    "package.seeall",
    "physics.addBody()",
    "physics.engineVersion",
    "physics.fromMKS()",
    "physics.getAverageCollisionPositions()",
    "physics.getDebugErrorsEnabled()",
    "physics.getGravity()",
    "physics.getMKS()",
    "physics.getReportCollisionsInContentCoordinates()",
    "physics.newJoint()",
    "physics.newParticleSystem()",
    "physics.pause()",
    "physics.queryRegion()",
    "physics.rayCast()",
    "physics.reflectRay()",
    "physics.removeBody()",
    "physics.setAverageCollisionPositions()",
    "physics.setContinuous()",
    "physics.setDebugErrorsEnabled()",
    "physics.setDrawMode()",
    "physics.setGravity()",
    "physics.setMKS()",
    "physics.setPositionIterations()",
    "physics.setReportCollisionsInContentCoordinates()",
    "physics.setScale()",
    "physics.setTimeStep()",
    "physics.setVelocityIterations()",
    "physics.start()",
    "physics.stop()",
    "physics.toMKS()",
    "store.availableStores",
    "store.canLoadProducts",
    "store.canMakePurchases",
    "store.finishTransaction()",
    "store.init()",
    "store.isActive",
    "store.loadProducts()",
    "store.purchase()",
    "store.restore()",
    "store.target",
    "string.byte()",
    "string.char()",
    "string.find()",
    "string.format()",
    "string.gmatch()",
    "string.gsub()",
    "string.len()",
    "string.lower()",
    "string.match()",
    "string.rep()",
    "string.reverse()",
    "string.sub()",
    "string.upper()",
    "system.CachesDirectory",
    "system.DocumentsDirectory",
    "system.ResourceDirectory",
    "system.TemporaryDirectory",
    "system.activate()",
    "system.cancelNotification()",
    "system.deactivate()",
    "system.getIdleTimer()",
    "system.getInfo()",
    "system.getInputDevices()",
    "system.getPreference()",
    "system.getTimer()",
    "system.hasEventSource()",
    "system.openURL()",
    "system.orientation",
    "system.pathForFile()",
    "system.scheduleNotification()",
    "system.setAccelerometerInterval()",
    "system.setGyroscopeInterval()",
    "system.setIdleTimer()",
    "system.setLocationAccuracy()",
    "system.setLocationThreshold()",
    "system.setTapDelay()",
    "system.vibrate()",
    "table.concat()",
    "table.copy()",
    "table.indexOf()",
    "table.insert()",
    "table.maxn()",
    "table.remove()",
    "table.sort()",
    "timer.cancel()",
    "timer.pause()",
    "timer.performWithDelay()",
    "timer.resume()",
    "transition.blink()",
    "transition.cancel()",
    "transition.dissolve()",
    "transition.fadeIn()",
    "transition.fadeOut()",
    "transition.from()",
    "transition.moveBy()",
    "transition.moveTo()",
    "transition.pause()",
    "transition.resume()",
    "transition.scaleBy()",
    "transition.scaleTo()",
    "transition.to()",
    "widget.newButton()",
    "widget.newPickerWheel()",
    "widget.newProgressView()",
    "widget.newScrollView()",
    "widget.newSegmentedControl()",
    "widget.newSlider()",
    "widget.newSpinner()",
    "widget.newStepper()",
    "widget.newSwitch()",
    "widget.newTabBar()",
    "widget.newTableView()",
    "widget.setTheme()"
}

return Class
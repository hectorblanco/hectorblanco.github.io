$ ->
  w = $(window)
  Modernizr.addTest 'highresdisplay', ->
    return unless window.matchMedia
    mq = window.matchMedia("only screen and (-moz-min-device-pixel-ratio: 1.3), only screen and (-o-min-device-pixel-ratio: 2.6/2), only screen and (-webkit-min-device-pixel-ratio: 1.3), only screen  and (min-device-pixel-ratio: 1.3), only screen and (min-resolution: 1.3dppx)")
    return true if mq and mq.matches

  homeSection = $("#home")
  aboutSection = $("#about")
  gallerySection = $("#gallery")
  skillsSection = $("#skills")
  contactSection = $("#contact")

  menuHeightOffset = $("#navbar-menu").outerHeight() * -1

  # ENABLE ANIMATION ONCE LOADED
  
  $("body").removeClass("preload");

  # IMAGES LAZY LOADING

  lazySource = if Modernizr.highresdisplay then "original-rd" else "original"
  placeholder = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"

  $(".img-lazy").each ->
    self = $(this)
    if self.parent().is(":visible")
      self.attr("src", placeholder) if self.is("img")
      imgSource = self.data(lazySource) ? self.data("original")
      self.one "appear", -> $("<img />").bind("load", -> loadImage(self, imgSource)).attr("src", imgSource)

  loadImage = (self, imgSource) ->
    self.hide()
    if self.is("img")
      self.attr("src", imgSource)
    else
      self.css("background-image", "url('#{imgSource}')")
    self.fadeIn("slow")
    self.removeClass("img-lazy").removeAttr("data-original").removeAttr("data-original-rd")

  homeSection.find(".img-lazy").trigger("appear")
  setTimeout (-> aboutSection.find(".img-lazy").trigger("appear")), 200
  setTimeout (-> gallerySection.find(".img-lazy").trigger("appear")), 400
  setTimeout (-> skillsSection.find(".img-lazy").trigger("appear")), 600
  setTimeout (-> contactSection.find(".img-lazy").trigger("appear")), 800

  # GALLERY

  # Gallery with Isotope
  gallery = $("#gallery .gallery").isotope
    layoutMode: 'masonry'
    itemSelector: '.gallery-item'
    masonry: 
      isFitWidth: true

  # Filter images according to topic
  $("#navbar-gallery .gallery-filter a").click ->
    # Scroll to gallery while filtering
    scrollToTarget gallerySection
    # Filter gallery items
    filter = $(this).data("filter")
    gallery.isotope
      filter: ".#{filter}"            
    # Recalculate scenes
    updateScenes()
    # Force pictures loading
    gallerySection.find(".img-lazy").trigger("appear")
    # Enable gallery section
    $("#navbar-gallery .gallery-filter .navbar-item").removeClass("active")
    $(this).parent(".navbar-item").addClass("active")
    closeNavigations()
    return false

  activityIndicatorOn = ->
    $("#lightbox-loading").show()
  activityIndicatorOff = ->
    $("#lightbox-loading").hide()

  overlayOn = -> 
    $("#lightbox-overlay").show()
    $("body").addClass("noscroll")
  overlayOff = ->
    $("body").removeClass("noscroll")
    $("#lightbox-overlay").fadeOut("fast")

  captionOn = ->
    selectedImage = $("#imagelightbox").attr("src")
    image = $("a[href='#{selectedImage}'] img")
    title = image.attr("alt")
    body = image.data("caption")
    if title.length > 0 or body.length > 0
      caption = $("#lightbox-caption")
      caption.find(".title").text(title)
      caption.find(".body").text(body)
      caption.show()
  captionOff = ->
    $("#lightbox-caption").fadeOut("fast")

  # Show large picture on hovering images  
  $("#gallery .gallery-item a").imageLightbox
    onStart:      -> overlayOn()
    onEnd:        ->
      captionOff()
      overlayOff()
      activityIndicatorOff()
    onLoadStart:  ->
      captionOff()
      activityIndicatorOn()
    onLoadEnd:    ->
      captionOn()
      activityIndicatorOff()

  # NAV COLLAPSE

  closeNavigations = ->
    $(".navbar-collapse.in").slideUp "fast", -> $(this).removeClass("in") 

  $(".navbar .navbar-item").click ->
    closeNavigations() 

  $(".navbar .navbar-toggle").click ->
    collapsedNavId = $(this).data("target")    
    $(collapsedNavId).slideToggle("fast", ->
      $(this).toggleClass("in") 
    )

  # SCROLL MAGIC

  scrollController = new ScrollMagic()
  sceneHeights = {}
 
  getHomeHeight = -> return sceneHeights.home  
  updateHomeHeight = -> sceneHeights.home = homeSection.outerHeight()

  getAboutHeight = -> return sceneHeights.about  
  updateAboutHeight = -> sceneHeights.about = aboutSection.outerHeight()

  getGalleryHeight = -> return sceneHeights.gallery  
  updateGalleryHeight = -> sceneHeights.gallery = gallerySection.outerHeight()

  getSkillsHeight = -> return sceneHeights.skills  
  updateSkillsHeight = -> sceneHeights.skills = skillsSection.outerHeight()

  getContactHeight = -> return sceneHeights.contact  
  updateContactHeight = -> sceneHeights.contact = contactSection.outerHeight()

  updateScenes = ->
    updateHomeHeight()
    updateAboutHeight()
    updateGalleryHeight()
    updateSkillsHeight()
    updateContactHeight()

  updateScenes()
  w.on "resize", updateScenes  

  # SKILL BARS

  enableSkillBar = (bar) ->
    bar.find(".graph .bar").addClass("loaded")

  enableDesignerSkills = -> enableSkillBar skillsSection.find("#designer-skills")
  enableSoftwareSkills = -> enableSkillBar skillsSection.find("#software-skills")
  enableWebSkills = -> enableSkillBar skillsSection.find("#web-skills")
  enableLanguageSkills = -> enableSkillBar skillsSection.find("#language-skills")

  if Modernizr.touch
    skillsSection.find(".skill-bars").each -> enableSkillBar $(this)
  else
    loadDesignerSkillsScene = new ScrollScene  
      triggerElement: "#designer-skills"
      triggerHook: 0.5
    loadDesignerSkillsScene.on("enter", enableDesignerSkills).addTo(scrollController)

    loadSoftwareSkillsScene = new ScrollScene  
      triggerElement: "#software-skills"
      triggerHook: 0.5
    loadSoftwareSkillsScene.on("enter", enableSoftwareSkills).addTo(scrollController)

    loadWebSkillsScene = new ScrollScene  
      triggerElement: "#web-skills"
      triggerHook: 0.5
    loadWebSkillsScene.on("enter", enableWebSkills).addTo(scrollController)

    loadLanguageSkillsScene = new ScrollScene  
      triggerElement: "#language-skills"
      triggerHook: 0.5
    loadLanguageSkillsScene.on("enter", enableLanguageSkills).addTo(scrollController)

  # HEADER IMAGE

  $(".scroll-layers").addClass("fluid") if Modernizr.touch

  if not $(".scroll-layers").hasClass("fluid")
    parallaxTween = new TimelineMax()
    parallaxTween.add [
      TweenMax.to("#home .scroll-layers .layer1, #home .scroll-layers .layer2", 2,
        backgroundPosition: "center -200px"
        ease: Linear.easeNone
      )
      TweenMax.to("#home .scroll-layers .layer3", 2,
        backgroundPosition: "center -300px"
        ease: Linear.easeNone
      )
      TweenMax.to("#home .scroll-layers .layer4", 2,
        backgroundPosition: "center -450px"
        ease: Linear.easeNone
      )
    ]

    parallaxScene = new ScrollScene
      triggerElement: "#home"
      triggerHook: 0
      offset: 0
      duration: $("#home").height()
    parallaxScene.setTween(parallaxTween).addTo(scrollController)

  # TOP NAVIGATION MENU

  topMenuScene = new ScrollScene
    triggerElement: "#navbar-menu"
    triggerHook: 0
    offset: 0    
  topMenuScene.setPin("#navbar-menu", {pinnedClass: "navbar-stuck"}).addTo(scrollController)

  # GALLERY NAVIGATION MENU

  galleryMenuScene = new ScrollScene
    triggerElement: "#navbar-gallery"
    triggerHook: 0
    offset: menuHeightOffset
    duration: getGalleryHeight
  galleryMenuScene.setPin("#navbar-gallery", {pinnedClass: "navbar-stuck", pushFollowers: false}).addTo(scrollController)

  # HIGHLIGHT MENU

  highlightSection = (sectionId) ->
    menuSections = $("#navbar-menu li.navbar-item")
    menuSections.removeClass("active")
    menuSections.has("a[href~='#{sectionId}']").addClass("active")      

  enableHomeSection = -> highlightSection homeSection.attr("id")
  enableAboutSection = -> highlightSection aboutSection.attr("id")
  enableGallerySection = -> highlightSection gallerySection.attr("id")    
  enableSkillsSection = -> highlightSection skillsSection.attr("id")
  enableContactSection = -> highlightSection contactSection.attr("id")

  homeSectionScene = new ScrollScene
    triggerElement: "##{homeSection.attr("id")}"
    triggerHook: 0
    offset: menuHeightOffset
    duration: getHomeHeight
  homeSectionScene.on("enter", enableHomeSection).addTo(scrollController)

  aboutSectionScene = new ScrollScene
    triggerElement: "##{aboutSection.attr("id")}"
    triggerHook: 0
    offset: menuHeightOffset
    duration: getAboutHeight
  aboutSectionScene.on("enter", enableAboutSection).addTo(scrollController)

  gallerySectionScene = new ScrollScene
    triggerElement: "##{gallerySection.attr("id")}"
    triggerHook: 0
    offset: menuHeightOffset
    duration: getGalleryHeight
  gallerySectionScene.on("enter", enableGallerySection).addTo(scrollController)

  skillsSectionScene = new ScrollScene
    triggerElement: "##{skillsSection.attr("id")}"
    triggerHook: 0
    offset: menuHeightOffset
    duration: getSkillsHeight
  skillsSectionScene.on("enter", enableSkillsSection).addTo(scrollController)

  contactSectionScene = new ScrollScene
    triggerElement: "##{contactSection.attr("id")}"
    triggerHook: 0
    offset: menuHeightOffset
    duration: getContactHeight
  contactSectionScene.on("enter", enableContactSection).addTo(scrollController)

  # SCROLL TO SECTION

  goToUrl = (url, e) ->
    return unless url?
    target = $("##{url}")
    if target.length > 0
      e.preventDefault() unless e?
      scrollToTarget(target)
      return false

  scrollToTarget = (target, offset = 0) ->
    return unless target and target.length > 0
    targetOffset = target.offset().top + menuHeightOffset + offset
    targetId = target.attr("id")
    if targetOffset isnt w.scrollTop()
      $("html,body").animate scrollTop : targetOffset,
        duration: 500
        complete: ->
          #updateUrl targetId
          highlightSection target.attr("id")

  # updateUrl = (targetId) ->
  #   if window.history and window.history.pushState
  #     history.pushState "", document.title, targetId
  #   else
  #     location.hash = "##{targetId}"

  $(document).on "click", "*[data-navigate=true]", (e) -> goToUrl($(this).attr("href"), e)
  #goToUrl window.location.pathname

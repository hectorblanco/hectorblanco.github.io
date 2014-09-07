$ ->
  isIe = $("meta[name=isie]").size() > 0

  homeSection = $("#home")
  aboutSection = $("#about")
  gallerySection = $("#gallery")
  skillsSection = $("#skills")
  contactSection = $("#contact")

  menuHeightOffset = $("#navbar-menu").outerHeight() * -1

  # ENABLE ANIMATION ONCE LOADED
  
  $("body").removeClass("preload");

  # IMAGES LAZY LOADING

  $("img.lazy").show().lazyload
    effect : "fadeIn"
    event: "showImages"
  
  setTimeout ->
    $("img.lazy").trigger("showImages")
  , 500

  # GALLERY

  # Gallery with Isotope
  gallery = $("#gallery .gallery").isotope
    layoutMode: 'masonry'
    itemSelector: '.gallery-item'
    masonry: 
      isFitWidth: true

  # Filter images according to topic
  $("#navbar-gallery .gallery-filter a").click ->
    # Scroll to gallery before filtering
    scrollToTarget gallerySection
    $("html,body").promise().done =>
      # Filter gallery items
      filter = $(this).data("filter")
      gallery.isotope
        filter: ".#{filter}"
    # Enable gallery section
    $("#navbar-gallery .gallery-filter .navbar-item").removeClass("active")
    $(this).parent(".navbar-item").addClass("active")
    return false

  activityIndicatorOn = ->
    $("#lightbox-loading").show("slow")
  activityIndicatorOff = ->
    $("#lightbox-loading").hide("fast")

  overlayOn = -> 
    $("#lightbox-overlay").fadeIn()
    $("body").addClass("noscroll");
  overlayOff = ->
    $("body").removeClass("noscroll");
    $("#lightbox-overlay").fadeOut("slow")

  # Show large picture on hovering images  
  $("#gallery .gallery-item a").imageLightbox
    onStart:      -> overlayOn()
    onEnd:        ->
      overlayOff()
      activityIndicatorOff()
    onLoadStart:  -> activityIndicatorOn()
    onLoadEnd:    -> activityIndicatorOff()

  # NAV COLLAPSE

  $(".navbar .navbar-toggle").click ->
    collapsedNavId = $(this).data("target")    
    $(collapsedNavId).slideToggle("fast", ->
      $(this).toggleClass("in") 
      #highlightSection()   
    )

  # SCROLL MAGIC

  scrollController = new ScrollMagic()

  # SKILL BARS

  enableSkillBar = (bar) ->
    bar.find(".graph .bar").addClass("loaded")

  enableDesignerSkills = ->
    enableSkillBar skillsSection.find("#designer-skills")

  enableSoftwareSkills = ->
    enableSkillBar skillsSection.find("#software-skills")

  enableWebSkills = ->
    enableSkillBar skillsSection.find("#web-skills")

  enableLanguageSkills = ->
    enableSkillBar skillsSection.find("#language-skills")

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

  if Modernizr.touch
    backgroundImage.addClass("fluid")
  else
    parallaxTween = new TimelineMax()
    parallaxTween.add [
      TweenMax.to("#home .scroll-layer .layer1", 2,
        backgroundPosition: "center -200px"
        ease: Linear.easeNone
      )
      TweenMax.to("#home .scroll-layer .layer2", 2,
        backgroundPosition: "center -200px"
        ease: Linear.easeNone
      )
      TweenMax.to("#home .scroll-layer .layer3", 2,
        backgroundPosition: "center -300px"
        ease: Linear.easeNone
      )
      TweenMax.to("#home .scroll-layer .layer4", 2,
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
    duration: $("#gallery .gallery").height()
  galleryMenuScene.setPin("#navbar-gallery", {pinnedClass: "navbar-stuck", pushFollowers: false}).addTo(scrollController)

  # HIGHLIGHT MENU

  highlightSection = (sectionId) ->
    menuSections = $("#navbar-menu li.navbar-item")
    menuSections.removeClass("active")
    menuSections.has("a[href~='#{sectionId}']").addClass("active")      

  enableHomeSection = (e) ->
    highlightSection homeSection.attr("id")
  
  enableAboutSection = (e) ->
    highlightSection aboutSection.attr("id")

  enableGallerySection = (e) ->
    highlightSection gallerySection.attr("id")

  enableSkillsSection = (e) ->
    highlightSection skillsSection.attr("id")

  enableContactSection = (e) ->
    highlightSection contactSection.attr("id")

  homeSectionScene = new ScrollScene
    triggerElement: "##{homeSection.attr("id")}"
    triggerHook: 0
    offset: menuHeightOffset
    duration: homeSection.outerHeight()
  homeSectionScene.on("enter", enableHomeSection).addTo(scrollController)

  aboutSectionScene = new ScrollScene
    triggerElement: "##{aboutSection.attr("id")}"
    triggerHook: 0
    offset: menuHeightOffset
    duration: aboutSection.outerHeight()
  aboutSectionScene.on("enter", enableAboutSection).addTo(scrollController)

  gallerySectionScene = new ScrollScene
    triggerElement: "##{gallerySection.attr("id")}"
    triggerHook: 0
    offset: menuHeightOffset
    duration: gallerySection.outerHeight()
  gallerySectionScene.on("enter", enableGallerySection).addTo(scrollController)

  skillsSectionScene = new ScrollScene
    triggerElement: "##{skillsSection.attr("id")}"
    triggerHook: 0
    offset: menuHeightOffset
    duration: skillsSection.outerHeight()
  skillsSectionScene.on("enter", enableSkillsSection).addTo(scrollController)

  contactSectionScene = new ScrollScene
    triggerElement: "##{contactSection.attr("id")}"
    triggerHook: 0
    offset: menuHeightOffset
    duration: contactSection.outerHeight()
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
    if targetOffset isnt $(window).scrollTop()
      $("html,body").animate scrollTop : targetOffset,
        duration: 500
        complete: ->
          updateUrl targetId
          highlightSection target.attr("id")

  updateUrl = (targetId) ->
    if window.history and window.history.pushState
      history.pushState "", document.title, targetId
    else
      location.hash = "##{targetId}"

  $(document).on "click", "*[data-navigate=true]", (e) -> goToUrl($(this).attr("href"), e)
  #goToUrl window.location.pathname

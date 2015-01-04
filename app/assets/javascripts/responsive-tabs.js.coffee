#Courtesy http://openam.github.io/bootstrap-responsive-tabs/
#switched over to coffeescript and updated with additional dom elements for styleing

class CourseTabs
  constructor: ($tabGroup) ->
    @$tabGroup = $tabGroup
    @hidden = " hidden-xs"
    @visible = " visible-xs"

    @$collapseDiv = $("<div></div>",
      class: "panel-group responsive" + @visible
      id: "collapse-" + @$tabGroup.attr("id")
    )

    klass = this
    tabs = @$tabGroup.find("li a")
    $.each tabs, ->
      panel = klass._convertTabToPanel($(this))
      klass.$collapseDiv.append(panel)

    @$tabGroup.after @$collapseDiv
    @$tabGroup.addClass @hidden

    $(".tab-content.responsive").addClass @hidden

  replacePanel: ($tab) =>
    id = @_panelContentId($tab)
    $("##{id}").replaceWith @_buildPanelContent($tab)

  _convertTabToPanel: ($tab) =>
    $panelHeading = @_buildPanelHeading($tab)
    $panelContent = @_buildPanelContent($tab)

    $panel = $("<div>").attr("class", "panel panel-default")
    $panel.html($panelHeading).append($panelContent)

  _buildPanelHeading: ($tab) =>
    # build panel heading
    expanded = '' # ' expanded' if $tab.parent().hasClass("active")
    $panelHeading = $("<div>").attr("class", "panel-heading")
    $panelTitle =   $("<h4>").attr("class", "panel-title " + expanded)
    $iconChevron =  $('<span>').attr('class','icon-chevron-down')
    $titleAnchor =  $("<a>",
      class: "accordion-toggle collapsed"
      "data-toggle": "collapse"
      "data-parent": "#collapse-" + @$tabGroup.attr("id")
      href: "#collapse-" + $tab.attr("href").replace(/#/g, "")
      html: $tab.html()
    )
    $panelHeading.html(
      $panelTitle.html($titleAnchor).append($iconChevron)
    )

  _buildPanelContent: ($tab) =>
    pcontent = $("#" + $tab.attr("href").replace(/#/g, "")).html()

    # handle nested accordion in responsive layout
    if $(pcontent).find('.lesson-accordion').length > 0
      pcontent = pcontent.replace(/lesson-accordion/g,'lesson-accordion-responsive')
      pcontent = pcontent.replace(/href="#/g,'href="#responsive-')
      pcontent = pcontent.replace(/class="panel-collapse collapse" id="/g,'class="panel-collapse collapse" id="responsive-')

    # We don't want to default to open on mobile
    active = '' # if $tab.parent().hasClass("active") then " in" else ""
    $panelContent = $("<div>",
      id: @_panelContentId($tab)
      class: "panel-collapse collapse" + active
    )
    $panelBody = $("<div>").attr("class", "panel-body").html(pcontent)
    $panelContent.html($panelBody)

  _panelContentId: ($tab) ->
    "collapse-" + $tab.attr("href").replace(/#/g, "")

MC.courseTabs =
  ready: ->
    new CourseTabs($(".nav.nav-tabs.responsive"))

    $(".lesson-accordion,#collapse-marketing-accordion,#collapse-enrolled-accordion").on "shown.bs.collapse", (e) ->
      $(e.target).closest('.panel-group').find('.expanded').removeClass('expanded')
      $(e.target).prev('.panel-heading').find('.panel-title').toggleClass('expanded')

    $(".lesson-accordion,#collapse-marketing-accordion,#collapse-enrolled-accordion").on "hidden.bs.collapse", (e) ->
      $(e.target).closest('.panel-group').find('.expanded').removeClass('expanded')


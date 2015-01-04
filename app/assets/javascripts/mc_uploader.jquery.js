;(function ($) {
  var defaults = {
    strings: {
      title: 'Masterclass Profile Image',
      dropText: 'Drag profile image here',
      altText: 'Or select using the button',
      buttons: {
        choose: "Choose file",
        upload: "Upload file",
      },
      tableHeadings: [
        "Type", "Name", "Size", "Remove all x"
      ]
    },
    acceptableFileTypes: [
      "image/png", "image/jpg", "image/jpeg"
    ],
    modalBox: '#profile-image-modal',
    imageTarget: '#profile-picture img',
  };

  function Up(el, opts) {
    this.config         = $.extend(true, {}, defaults, opts);
    this.el             = el;
    this.$el            = $(el);
    this.$modalBox      = $(this.config.modalBox);
    this.$imageTarget   = $(this.config.imageTarget);
    this.fileList       = [];
    this.allXHR         = [];
    this.currentUserId  = this.el.data('current-user-id');
  }

  Up.prototype.init = function() {
    var widget = this,
        strings         = widget.config.strings,
        container       = $("<article/>", { "class": "up" } ),
        heading         = $("<header/>").appendTo(container),
        title           = $("<h1/>", {text: strings.title} ).appendTo(heading),
        drop            = $("<div/>", { 
                                        "class": "up-drop-target",
                                        html: $("<h2/>", { 
                                                           text: strings.dropText 
                                        }) 
                          }).appendTo(container),
        alt             = $("<h3/>", { text: strings.altText }).appendTo(container),
        //upload          = $("<input/>", { type: "file" }).prop("multiple", true).appendTo(container),
        //upload          = $("<input/>", { type: "file" }).appendTo(container),
        select          = $("<a/>", { href: "#", "class": "button up-choose",text: strings.buttons.choose }).appendTo(container),
        selected        = $("<div/>", { "class": "up-selected" }).appendTo(container),
        upload          = $("<a/>", { href: "#", "class": "button up-upload", text: strings.buttons.upload }).appendTo(container);

    widget.el.append(container);

    widget.el.on("click", "a.up-choose", function(e){
      widget.el.find("input[type='file']").click();
    });

    widget.el.on('change', "#file-upload", function(e){
      if (widget.validateFiles(e.currentTarget.files) == true ) {
        widget.files = [e.currentTarget.files[0]];
      } else {
        var message = 'You may only use files of filetypes: ' +  widget.config.acceptableFileTypes.join(' ') 
        alert(message);
        return;
      }
      widget.handleFiles();
    })



    widget.el.on("drop change dragover", "article.up", function(e){
      if ( e.type === "dragover" ) {
        e.preventDefault();
        e.stopPropagation();
        return false;
      } else if ( e.type === "drop" ) {
        e.preventDefault();
        e.stopPropagation();

        if (widget.validateFiles(e.originalEvent.dataTransfer.files) == true ) {
          widget.files = [e.originalEvent.dataTransfer.files[0]];
        } else {
          var message = 'You may only use files of filetypes: ' +  widget.config.acceptableFileTypes.join(' ') 
          alert(message);
          return;
        }
      } else {
        widget.files = widget.el
        .find("input[type='file']")[0]
        .files;
      }
      widget.handleFiles();
    });

    widget.el.on("click", "a.up-upload", function(e) {
      e.preventDefault();
      widget.uploadFiles();
    });

    widget.el.on("click", "td a", function(e) {
      e.preventDefault();
      e.stopPropagation();
      var removeAll = function() {
        widget.el.find("table").remove();
        widget.el.find("input[type='file']").val("");
        widget.fileList = []
      }

      if ( e.originalEvent.target.className == "up-remove-all" ) {
        removeAll();
      } else {
        var link = $(this),
            removed,
            filename = link.closest("tr").children().eq(1).text();
        link.closest("tr").remove();

        $.each( widget.fileList, function(i, item) {
          if ( item.name === filename ) {
            removed = i;
          } 
        });

        widget.fileList.splice(removed, 1);

        if ( widget.el.find("tr").length === 1) {
          removeAll();
        }
      }
    });

  };

  Up.prototype.removeAll = function() {
    var widget = this;
    widget.el.find('table').remove();
    widget.el.find("input[type='file']").val("");
    widget.fileList = [];
  }

  Up.prototype.validateFiles = function(files) {
    var widget          = this,
        sExtension;

    if ( files.length > 0 ) {
      return ($.inArray(files[0].type, widget.config.acceptableFileTypes) >= 0) ? true : false;
    } else {
      return false;
    }
  }

  Up.prototype.handleFiles = function() {
    var widget    = this,
        container = widget.el.find("div.up-selected"),
        row       = $("<tr/>"),
        cell      = $("<td/>"),
        remove    = $("<a/>", { href: "#" }),
        table;
    widget.removeAll();

    if ( !container.find("table").length ) {
      table = $("<table/>");
      var header = row.clone().appendTo(table),
          strings = widget.config.strings.tableHeadings;

      $.each(strings, function(i, string) {
        var cs      = string.toLowerCase().replace(/\s/g, "_"),
            newCell = cell.clone().addClass("up-table-head " + cs).appendTo(header);
        if ( i === strings.length - 1 ) {
          var clear = remove.clone().text(string).addClass("up-remove-all");
          newCell.html(clear)//#.attr("colspan", 2);
        } else {
          newCell.text(string);
        }
      });
    } else {
      table = container.find("table");
    }

    $.each(widget.files, function(i, file) {
      var fileRow   = row.clone(),
          filename  = file.name.split("."),
          ext       = filename[filename.length - 1],
          del       = remove.clone().text("x").addClass("up-remove");

      cell.clone().addClass("icon " + ext).appendTo(fileRow);
      cell.clone().text(file.name).appendTo(fileRow);
      cell.clone().text((Math.round(file.size / 1024)) + " kb").appendTo(fileRow);
      cell.clone().html(del).appendTo(fileRow);
      progHtml = "<div class='progress'><div class='progress-bar' role='progressbar' aria-valuenow='10' aria-valuemin='0' aria-valuemax='90' style='width: 0%'></div></div>"
      //cell.clone().html("<div class='up-progress' />").appendTo(fileRow);
      cell.clone().html(progHtml).appendTo(fileRow);

      fileRow.appendTo(table);
      widget.fileList.push(file);
    });

    if ( !container.find("table").length ) {
      table.appendTo(container);
    }
    //widget.initProgress();
  }

  Up.prototype.initProgress = function() {
    this.el.find("div.up-progress").each(function() {
      var el = $(this); 

      if ( !el.hasClass("ui-progressbar")) {
        el.progressbar();
      }
    });
  }

  Up.prototype.handleProgress = function(e, progress) {
    var complete = Math.round((e.loaded / e.total ) * 100);
    //progress.progressbar("value", complete);
    $('.progress-bar').css('width', complete)
  }

  $.fn.up = function(options) {
    new Up (this, options).init();
    return this;
  };

  Up.prototype.uploadFiles = function() {
    var widget  = this,
        a       = widget.el.find("a.up-upload");

    if ( !a.hasClass("disabled")) {
      a.addClass("disabled");

      $.each(widget.fileList, function(i, file){
        var fd    = new FormData(),
            prog  = widget.el.find("div.up-progress").eq(i),
            uid   = widget.currentUserId;
        fd.append("image", file);

        widget.allXHR.push($.ajax({
          type: "POST",
          url: "/account/add_image",
          data: fd,
          contentType: false,
          processData: false,
          xhr: function() {
            var xhr = jQuery.ajaxSettings.xhr();

            if (xhr.upload) {
              xhr.upload.onprogress = function(e) {
                widget.handleProgress(e, prog)
              }
              return xhr
            }
          }
        })
        .done(function(data, textResponse, jqXHR){
          var parent = prog.parent(),
              prev = parent.prev();

          prev.add(parent).empty();
          prev.text("File uploaded!");
          widget.$modalBox.modal('hide');
          $(widget.config.imageTarget).attr('src', data.url)
        })
        );
      });

      $.when.apply($, widget.allXHR).done(function() {
        widget.el.find("table").remove();
        widget.el.find("a.up-upload").removeClass("disabled");
      });
    }
  }
}(jQuery));

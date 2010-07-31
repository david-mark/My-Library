/*
 My Library Page Transition add-on
 Requires DOM and Style modules
 NOTE: At the moment the Transform add-on is also required as
       the findProprietaryStyle function is created by it.
       This function will be moved to the core in the near future.
*/

var API, global = this;

(function() {
  var doc = global.document;

  if (API && API.findProprietaryStyle && API.findProprietaryStyle('animation') && API.isHostMethod(doc, 'write') &&
      API.isHostObjectProperty(doc, 'documentElement') && typeof doc.documentElement.style.visibility == 'string' && API.areFeatures && API.areFeatures('getEBI', 'getElementDocument', 'attachDocumentReadyListener')) {

    // Global options and flag indicating first call of createPageTransition

    var firstCall, deferTransition, contentContainerId, animationClassName;

    // Writes transition-specific style sheet
    // Most applications will call this once
    // "Themed" applications call multiple times to write alternates
    // Must be called from a script in the head of the document

    API.createPageTransition = function(href, options, doc) {
      if (!doc) {
        doc = global.document;
      }
      if (!options) {
        options = {};
      }

      // Only initial call can set global options
      // Alternates can only specify name and max width

      if (!firstCall) {
        deferTransition = options.defer;
        contentContainerId = options.contentContainerId;
        animationClassName = options.className;
        firstCall = true;
      }

      var link = '<link rel="stylesheet' + (options.alternate ? ' alternate' : '') + '" type="text/css" href="' + href.replace('&', '&amp;') + '" media="screen and (' + 'max-' + (options.deviceWidth ? 'device-' : '') + 'width' + ': ' + (options.maxWidth || '480px') + ')"';

      if (options.name) {
        link += ' title="' + options.name + '"';
      }

      link += '">';

      doc.write(link);
    };

    API.attachDocumentReadyListener(function() {

    // Converts micro-format relationships to animation class names

    var linkTransitions = {
      home: 'up',
      previous: 'forward',
      next: 'back',
      up: 'up',
      down: 'down'
    };

    API.addPageTransitionClassName = function(rel, className) {
      linkTransitions[rel] = className;
    };

    var getElementDocument = API.getElementDocument, getEBI = API.getEBI;
    var testHash = /\#.*$/;
    var testFullyQualified = /^[^:]*:\/{1,3}[^\/]*(\/.*)$/;
    var testMail = /^mailto:/;
    var testNews = /^news:/;

    API.transitionPage = function(contentContainer, className) {
      var body, dir, doc, find, head, href, i, link, links, matches, referrer;

      // If no class name specified, set to previously provided

      if (!className) {
        className = animationClassName;
      }

      // If no previously provided class name, try to determine direction
      // from links in head and content container

      if (!className) {

        // Determine content container and document

        if (contentContainer) {
          doc = getElementDocument(contentContainer);
        } else {
          if (contentContainerId) {
            contentContainer = getEBI(contentContainerId);
            if (contentContainer) {
              doc = getElementDocument(contentContainer);
            }
          }
          if (!contentContainer) {
            doc = contentContainer = global.document;
          }
        }

        body = API.getBodyElement(doc);
        referrer = doc.referrer;

        // Loops through links looking for referrer match

        find = function(referrer, defaultDir) {
          var done;

          for (i = links.length; i-- && !done;) {
            href = links[i].href;
            if (href && !testFullyQualified.test(href) && !testMail.test(href) && !testNews.test(href)) {
              done = true;
              matches = referrer.match(testFullyQualified);
              if (matches) {
                referrer = matches[1];
              }
            }
          }

          for (i = links.length; i-- && !dir;) {
            link = links[i];
            href = link.href.replace(testHash, '');
            if (href == referrer && (defaultDir || linkTransitions[link.rel])) {
              dir = link.rel || defaultDir;
            }
          }
        };

        // No referrer results in no transition

        if (referrer) {

          // Strip fragment identifier

          referrer = referrer.replace(testHash, '');

          // Check links in head first

          head = doc.getElementsByTagName('head')[0];
          links = head.getElementsByTagName('link');
          find(referrer);

          // If no match found, search content container

          if (!dir) {
            links = contentContainer.getElementsByTagName('a');

            // Default direction is up for links in content container
            // as most will be lacking rel attribute and can be assumed to
            // be down the path

            find(referrer, 'up');
          }

          // Set the animation class name if direction determined

          if (dir) {
            className = linkTransitions[dir];          
          }        
        }
      }

      if (className) {
        var bodyClassName = body.className;
        body.className = bodyClassName ? bodyClassName + ' ' + className : className;

        // Put body class back after a second so that the transition
        // will not repeat itself on resizes that cross the width threshold

        global.setTimeout(function() {
          body.className = bodyClassName; 
        }, 1000);
      }

      body.style.visibility = 'visible';
    };

    if (!deferTransition) {
      API.transitionPage();
    }
    });
  }
})();
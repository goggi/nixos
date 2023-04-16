''
    /*
    ┌─┐┬┌┬┐┌─┐┬  ┌─┐
    └─┐││││├─┘│  ├┤
    └─┘┴┴ ┴┴  ┴─┘└─┘
    ┌─┐┌─┐─┐ ┬
    ├┤ │ │┌┴┬┘
    └  └─┘┴ └─
    */

    :root {
      --srf-primary: #1e1e2e;
      --srf-secondary: #181825;
      --srf-text: #cdd6f4;
      --srf-accent: #cba6f7;
      --srf-light: #ffffff;

    }


  toolbar toolbarspring{
    -moz-box-flex: 2 !important;
    min-width: 0px !important;
    max-width: 100px !important;
  }

    /*
     * My changes
    */
    #urlbar-input-container {

      background-color: var(--srf-secondary) !important;
      border: 1px solid var(--srf-secondary) !important;
      border-radius: 0px !important;
      padding: 1 !important;
      paddig-left: 10px !important;
      height: 100% !important;
    }
    .tabbrowser-tab .tab-label { color: var(--srf-text) !important; }

    /* Kill bookmark icons in the Personal Toolbar */
    toolbarbutton.bookmark-item > .toolbarbutton-icon {
      padding-right: 5px !important;
      display: none !important;
    }
    #PersonalToolbar {
      color: var(--srf-text) !important;
    }


    /*
     * Default
    */

    window,
    #main-window,
    #toolbar-menubar,
    #TabsToolbar,
    #PersonalToolbar,
    #navigator-toolbox,
    #sidebar-box {
      background-color: var(--srf-primary) !important;
      -moz-appearance: none !important;
      background-image: none !important;
      border: none !important;
      box-shadow: none !important;
    }

    #TabsToolbar {
      visibility: collapse;

    }

    #navigator-toolbox * { font-size: 14px !important; }

    #urlbar {
      color: #ffffff !important;
      border-radius: 0px !important;
    }
    urlbar, #searchbar {
      font-size: 12px !important;
      font-weight: bold !important;
    }

    ::selection {
      background-color: var(--srf-accent);
      color: var(--srf-primary);
    }

    :root {
      --tabs-border: transparent !important;
    }

    .tab-background {
      border: none !important;
      border-radius: 0!important;
      margin: 0!important;
      margin-left: -1.6px!important;
      padding: 0!important;
    }

    .tab-background[selected='true'] {
      -moz-appearance: none !important;
      background-image: none !important;
      background-color: var(--srf-secondary)!important;
    }


    .tabbrowser-tab {
      border-radius: 15px 15px 0px 0px / 15px 15px 0px 0px !important;
    }

    .tabbrowser-tabs {
      border: none !important;
      opacity: 0 !important;
    }

    .tabbrowser-tab::before, .tabbrowser-tab::after{
      opacity: 0 !important;
      border-left: none !important;
    }

    .titlebar-placeholder {
      border: none !important;
    }

    .tab-line {
      display: none !important;
    }

    #back-button,
    #forward-button,
    #whats-new-menu-button,
    #star-button,
    #pocket-button,
    #save-to-pocket-button
    #pageActionSeparator,
    #pageActionButton,
    #reader-mode-button,
    #urlbar-zoom-button,
    #identity-box,
    #PanelUI-button,
    #tracking-protection-icon-container {
      display: none !important;
    }

    #context-navigation,
    #context-savepage,
    #context-pocket,
    #context-sendpagetodevice,
    #context-selectall,
    #context-viewsource,
    #context-inspect-a11y,
    #context-sendlinktodevice,
    #context-openlinkinusercontext-menu,
    #context-bookmarklink,
    #context-savelink,
    #context-savelinktopocket,
    #context-sendlinktodevice,
    #context-searchselect,
    #context-sendimage,
    #context-print-selection,
    #context_bookmarkTab,
    #context_moveTabOptions,
    #context_sendTabToDevice,
    #context_reopenInContainer,
    #context_selectAllTabs,
    #context_closeTabOptions {
      display: none !important;
    }

    #save-to-pocket-button {
      visibility: hidden !important;
    }

    .titlebar-spgza {
      display: none !important;
    }

    .tabbrowser-tab:not([pinned]) .tab-close-button {
      display: none !important;
    }

    .tabbrowser-tab:not([pinned]) .tab-icon-image {
      display: none !important;
    }

    #navigator-toolbox::after {
      border-bottom: 0px !important;
      border-top: 0px !important;
    }

    #nav-bar {
      background: var(--srf-secondary) !important;
      border: none !important;
      box-shadow: none !important;
      margin-top: 0px !important;
      border-top-width: 0px !important;
      margin-bottom: 0px !important;
      border-bottom-width: 0px !important;
    }

    #history-panel,
    #sidebar-search-container,
    #bookmarksPanel {
      background: var(--srf-primary) !important;
    }

    #search-box {
      -moz-appearance: none !important;
      background: var(--srf-primary) !important;
      border-radius: 6px !important;
    }



    .urlbarView-favicon {
        # display: none !important;
    }
    .urlbarView {
      font-size: 12px !important;
      font-weight: bold !important;
      padding-block: 0px !important;
      background-color: var(--srf-primary) !important;
      border: 1px solid var(--srf-primary) !important;
    }

    #urlbar[breakout][breakout-extend] > #urlbar-input-container {
      height: 34px;
    }

    *|*.urlbarView-row-inner {padding-block: 0px !important;}

    #urlbar[focused='true'] > #urlbar-background {
      box-shadow: none !important;
    }

    .urlbarView-url {
      color: var(--srf-text) !important;
    }

    /* this gets rid of that border on address bar focus */
    #urlbar[focused="true"]:not([suppress-focus-border]) > #urlbar-background, #searchbar:focus-within {
        outline: none !important;
        outline-offset: unset !important;
        outline-color: transparent !important;
    }
    #alltabs-button { display: none !important; }

    #urlbar[focused="true"] > #urlbar-background, #searchbar:focus-within {
        box-shadow: none !important;
    }

    .urlbarView .urlbarView-body-outer .urlbarView-row[label] {
        margin-block-start: 0 !important;
        position: inherit !important;
    }

    .urlbarView-row, .urlbarView-row > .urlbarView-row-inner, .urlbarView-row-inner[selected] {
        border-radius: 0px !important;
    }

    /* based on https://old.reddit.com/comments/fwhlva//fmolndz */
    #urlbar[breakout][breakout-extend]:not([open]) {
      top: calc((var(--urlbar-toolbar-height) - var(--urlbar-height)) / 2) !important;
      left: 0 !important;
      width: 100% !important;
    }
    #urlbar[breakout][breakout-extend]:not([open]) > #urlbar-input-container {
      height: var(--urlbar-height) !important;
      padding-block: 2px !important;
      padding-inline: 0px !important;
    }
    #urlbar[breakout][breakout-extend][breakout-extend-animate] > #urlbar-background {
      animation-name: none !important;
    }
    #urlbar[breakout][breakout-extend]:not([open]) > #urlbar-background {
      box-shadow: none !important;
    }

    #urlbar-results, .urlbarView-results {
        padding-block: 0px !important;
        padding: 2px !important;
    }


    #urlbar[breakout]{
      margin-inline-start: 0px !important;
      width: 100% !important;
      left: 0 !important;
      top: calc((var(--urlbar-toolbar-height) - var(--urlbar-height)) / 2) !important;
    }
    #urlbar[breakout]:not([open]){ bottom: calc((var(--urlbar-toolbar-height) - var(--urlbar-height)) / 2) !important; }
    .urlbarView{ margin-inline: 0 !important; width: auto !important; }
    #urlbar-background{ animation: none !important; }

    #nav-bar {
        padding-left: 10px;
    }

''

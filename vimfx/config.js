// vimfx.set('hints.chars', 'abcdefghijklmnopqrstuvw xyz')

const options = {};
let {commands} = vimfx.modes.normal;


[
    [{
        name: 'search_bookmarks',
        description: 'Search Bookmark',
        category: 'tabs',
        order: commands.focus_location_bar.order + 1,
    },
     (args) => {
         let {vim} = args
         let {gURLBar} = vim.window
         gURLBar.value = ''
         commands.focus_location_bar.run(args)
         gURLBar.value = '* '
         gURLBar.onInput(new vim.window.KeyboardEvent('input'))
     },
     ['b','custom.mode.normal'],
    ],
    [{
        name: 'open_hatena_bookmark_entry',
        description: 'Open Hatena Bookmark Entry',
        category: 'tabs',
    },
     ({vim}) => {
         const location = new vim.window.URL(vim.browser.currentURI.spec)
         const tmp=
             (location.protocol === "https:" ? "s/" : "") +
             location.href.replace(location.protocol+"//","")
         vim.window.gBrowser.loadURI(`http://b.hatena.ne.jp/entry/${tmp}`)
     },
     ['gb','custom.mode.normal'],
    ],
    [{
        name: 'translate_en_to_jp',
        description: 'Translate English to Japanese',
        category: 'tabs',
    },
     ({vim}) => {
     //TranslateEnglishToJapan(){
         const location = new vim.window.URL(vim.browser.currentURI.spec)
         const url=encodeURIComponent(location)
         vim.window.gBrowser.loadURI(`http://translate.google.com/translate?sl=en&tl=ja&u=${url}`)
     },
     ['gt','custom.mode.normal'],
    ],
    [{
        name: 'bookmark_page',
        description: 'Bookmark page',
    },
     ({vim}) => {
         let {window} = vim
         window.PlacesCommandHook.bookmarkCurrentPage(true, window.PlacesUtils.bookmarksMenuFolderId)
     },
     ['gv','custom.mode.normal'],
    ],

    [{
        name: 'pocket_click_toolbar_button',
        description: 'Pocket click',
    },
     ({vim}) => {
         let f = vim.window.document.getElementById("pocket-button")
         f.click()
     },
     ["ga",'custom.mode.normal'],
    ],

].forEach(([opt, fn, key]) => {
    vimfx.addCommand(opt,fn)
    let [shortcuts, mode] = Array.isArray(key)
        ? key
        : [key, 'mode.normal']
    if(key)
        vimfx.set(`${mode}.${opt.name}`, shortcuts)
})

Object.entries(options).forEach(([option, value]) => vimfx.set(option, value));

const MAPPINGS = {
    "scroll_half_page_down": "<c-v>",
    "scroll_half_page_up" :"<a-v>",
    'tab_select_previous': 'K h',
    'tab_select_next': 'J l',
    'scroll_right': '<c-f>',
    'scroll_left': '<c-b>',
    'scroll_down': 'j <c-n>',
    'scroll_up': 'k <c-p>',
    'history_back': 'B H',
    'history_forward': 'F L',
    'find': '/ <C-s>',
    'scroll_to_top': 'gg <',
    'scroll_to_bottom': 'G >',
    'follow': 'f e',
    'follow_in_tab': '',
    'follow_in_focused_tab': 'E',
    'follow_in_window': '',
    'follow_in_private_window': '',
    'esc': '<force><escape> <c-[>',
    'mode.caret.exit': '<escape> <c-[>',
    'tab_move_backward': 'gK <a-l>',
    'tab_move_forward': 'gJ <a-h>',
}

Object.entries(MAPPINGS).forEach(([cmd, value]) => {
    if (!cmd.includes('.')) {
        cmd = `mode.normal.${cmd}`;
    }
    vimfx.set(cmd, value)
})

// vimfx.set('hints.chars', 'abcdefghijklmnopqrstuvw xyz')

const options = {
    "hints.chars": "asdfghjkl"
};
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
         let location = new vim.window.URL(vim.browser.currentURI.spec)
         let tmp=
             (location.protocol === "https:" ? "s/" : "") +
             location.href.replace(location.protocol+"//","")
         vim.window.gBrowser.loadURI(`http://b.hatena.ne.jp/entry/${tmp}`)
     },
     ['gc','custom.mode.normal'],
    ],
    [{
        name: 'bookmark_page',
        description: 'Bookmark page',
    },
     ({vim}) => {
         let {window} = vim
         window.PlacesCommandHook.bookmarkCurrentPage(true, window.PlacesUtils.bookmarksMenuFolderId)
     },
     ['gb','custom.mode.normal'],
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
    // 'search_bookmarks': ['b','custom.mode.normal'],
    "scroll_half_page_down": "<c-v>",
    "scroll_half_page_up" :"<a-v>",
    'tab_select_previous': 'K gT h',
    'tab_select_next': 'J gt l',
    'scroll_right': '<c-f>',
    'scroll_left': '<c-b>',
    'scroll_down': 'j <c-n>',
    'scroll_up': 'k <c-p>',
    'history_back': 'B H',
    'history_forward': 'F L',
    'find': '/ <C-s>',
    'scroll_to_top': 'gg <',
    'scroll_to_bottom': 'G >',
    'follow': 'f',
    'follow_in_tab': 'E',
    'follow_in_focused_tab': 'e',
    'follow_in_window': '',
    'follow_in_private_window': '',
    // 'custom.mode.normal.click_toolbar_pocket': 'P',
}

Object.entries(MAPPINGS).forEach(([cmd, value]) => {
    if (!cmd.includes('.')) {
        cmd = `mode.normal.${cmd}`;
    }
    vimfx.set(cmd, value)
})

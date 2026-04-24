local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local add_snippets = require("beaver.snips").add_snippets

add_snippets("yaml", {
  -- Ansible
  ["debug"] = fmt(
    [[
    - name: debug
      debug:
        msg: {}
  ]],
    { i(1) }
  ),

  ["fail"] = fmt(
    [[
    - name: fail here
      fail:
        msg: {}
  ]],
    { i(1) }
  ),

  ["ir"] = fmt(
    [[
    - name: {}
      include_role:
        name: {}
  ]],
    { i(1), i(2) }
  ),

  ["create_tmp_dir"] = fmt(
    [[
    - name: Create a temp dir
      tempfile:
         state: directory
         suffix: {}
      register: raw_{}

    - name: Assign the temp dir path
      set_fact:
        {}: "{{{{ raw_{}.path }}}}"
]],
    { i(1), i(2), rep(2), rep(2) }
  ),

  ["read_file"] = fmt(
    [[
      - name: Read thie file content
        slurp:
          path: "{}"
        register: raw_{}

      - name: Assign the file content
        set_fact:
          {}: "{{{{ raw_{}.content | b64decode }}}}"
    ]],
    { i(1), i(2), rep(2), rep(2) }
  ),
})

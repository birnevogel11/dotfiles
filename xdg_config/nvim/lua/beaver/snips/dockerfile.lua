local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local add_snippets = require("beaver.snips").add_snippets

add_snippets("dockerfile", {
  ["debnoninteractive"] = t("ENV DEBIAN_FRONTEND=noninteractive"),
  ["apt-mirror"] = t("sed -i 's/archive.ubuntu.com/de.archive.ubuntu.com/g' /etc/apt/sources.list"),
  ["apt-update"] = fmt(
    [[
      RUN set -ex \
          && sed -i 's/archive.ubuntu.com/de.archive.ubuntu.com/g' /etc/apt/sources.list \
          && apt update \
          && apt upgrade -y \
          && DEBIAN_FRONTEND=noninteractive {} \
          && apt-get clean all \
          && rm -rf \
               /var/cache/debconf/* \
               /var/lib/apt/lists/* \
               /var/log/* \
               /tmp/* \
               /var/tmp/*
    ]],
    { i(1) }
  ),
  runm = fmt(
    [[
      RUN set -ex \
          && {1}
    ]],
    { i(1) }
  ),
  ["apt-clean"] = fmt(
    [[
          && apt-get clean all \
          && rm -rf \
               /var/cache/debconf/* \
               /var/lib/apt/lists/* \
               /var/log/* \
               /tmp/* \
               /var/tmp/*
          {}
    ]],
    { i(1) }
  ),
  ["build-dep"] = fmt(
    [[
      RUN set -ex \
          && apk add --no-cache --virtual .build-deps {} \
          && {} \
          && apk del .build-deps
    ]],
    { i(1, "build-base"), i(2) }
  ),
})
